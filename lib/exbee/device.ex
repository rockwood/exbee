defmodule Exbee.Device do
  @moduledoc """
  Represents a connected Xbee module, communicating via a serial port.

  Frames are sent via the `send_frame/1` function. Frames received on the serial port are reported
  as messages to the current process. The messages have the following form:

      {:exbee, frame}

  This example starts a device and sends an `Exbee.ATCommandFrame` to change the value of the `NJ`
  parameter. Upon receiving the command, the device will return an `Exbee.ATCommandResponseFrame`
  indicating the status of the request.

      iex> {:ok, pid} = Exbee.Device.start_link(serial_port: "COM1")
      iex> Device.send_frame(pid, %Exbee.ATCommandFrame{command: "NJ", value: 1})
      :ok

      iex> flush()
      {:exbee, %Exbee.ATCommandResponseFrame{command: "NJ", status: :ok, value: ...}}
  """

  use GenServer
  alias Exbee.{Message}

  @config Application.get_all_env(:exbee)
  @adapter_options [:speed, :data_bits, :stop_bits, :parity, :flow_control]

  @doc """
  Return a map of available serial devices with information about each.

      iex> Exbee.Device.enumerate()
      %{
        "COM1" => %{
          description: "USB Serial Port",
          manufacturer: "FTDI",
          product_id: 123,
          vendor_id: 456
        },
        "COM2" => %{...},
        "COM3" => %{...}
      }

  Depending on the device and the operating system, not all fields may be returned.

  fields are:

    * `:vendor_id` - The 16-bit USB vendor ID of the device providing the port. Vendor ID to name
      lists are managed through usb.org
    * `:product_id` - The 16-bit vendor supplied product ID
    * `:manufacturer` - The manufacturer of the port
    * `:description` - A description or product name
    * `:serial_number` - The device's serial number if it has one
  """

  @type device_option ::
    {:serial_port, String.t} |
    {:speed, non_neg_integer} |
    {:data_bits, 5..8} |
    {:stop_bits, 1..2} |
    {:parity, :none | :even | :odd | :space | :mark} |
    {:flow_control, :none | :hardware | :software}

  def enumerate do
    @config[:adapter].enumerate()
  end

  @doc """
  Start a new Exbee device process.

      iex> {:ok, pid} = Exbee.Device.start_link(serial_port: "COM1", speed: 9600)

  Options can either be passed directly, or they'll be read from `:exbee` config values. The
  following options are available:

    * `:serial_port` - The serial interface connected to the Xbee device.
    * `:speed` - (number) set the initial baudrate (e.g., 115200)
    * `:data_bits` - (5, 6, 7, 8) set the number of data bits (usually 8)
    * `:stop_bits` - (1, 2) set the number of stop bits (usually 1)
    * `:parity` - (`:none`, `:even`, `:odd`, `:space`, or `:mark`) set the parity. Usually this is
      `:none`. Other values:
      * `:space` means that the parity bit is always 0
      * `:mark` means that the parity bit is always 1
    * `:flow_control` - (`:none`, `:hardware`, or `:software`) set the flow control strategy.

  The following are some reasons for which the device may fail to start:

    * `:enoent`  - the specified port couldn't be found
    * `:eagain`  - the port is already open
    * `:eacces`  - permission was denied when opening the port
  """
  @spec start_link([device_option]) :: {:ok, pid} | {:error, term}
  def start_link(options \\ []) do
    serial_port = Keyword.get(options, :serial_port, @config[:serial_port])
    adapter = Keyword.get(options, :adapter, @config[:adapter])
    adapter_options = Keyword.merge(@config, options) |> Keyword.take(@adapter_options)

    GenServer.start_link(__MODULE__, [self(), serial_port, adapter, adapter_options])
  end

  @doc """
  Send a frame to a given device.

  A frame must implement the `Exbee.FrameEncoder` protocol, making it possible to define custom
  frames.
  """
  @spec send_frame(pid, Exbee.FrameEncoder.t) :: :ok | {:error, term}
  def send_frame(pid, frame) do
    GenServer.call(pid, {:send_frame, frame})
  end

  @doc """
  Shuts down the device process.
  """
  @spec stop(pid) :: :ok
  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  defmodule State do
    @moduledoc false

    defstruct [:caller_pid, :adapter_pid, :adapter, buffer: <<>>]
  end

  def init([caller_pid, serial_port, adapter, adapter_options]) do
    {:ok, adapter_pid} = adapter.start_link()

    :ok = adapter.open(adapter_pid, serial_port, adapter_options)

    {:ok, %State{caller_pid: caller_pid, adapter_pid: adapter_pid, adapter: adapter}}
  end

  def handle_call({:send_frame, frame}, _, %{adapter: adapter, adapter_pid: adapter_pid} = state) do
    {:reply, adapter.write(adapter_pid, Message.build(frame)), state}
  end
  def handle_call(:stop, _, %{adapter: adapter, adapter_pid: adapter_pid} = state) do
    {:reply, adapter.stop(adapter_pid), state}
  end

  def handle_info({:nerves_uart, _port, data}, %{caller_pid: caller_pid, buffer: buffer} = state) do
    {new_buffer, frames} = Message.parse(buffer <> data)

    for frame <- frames do
      send(caller_pid, {:exbee, frame})
    end

    {:noreply, %{state | buffer: new_buffer}}
  end
end
