defmodule Exbee.Device do
  use GenServer
  alias Exbee.{Message}

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

  * `:vendor_id` - The 16-bit USB vendor ID of the device providing the port. Vendor ID to name lists are managed through usb.org
  * `:product_id` - The 16-bit vendor supplied product ID
  * `:manufacturer` - The manufacturer of the port
  * `:description` - A description or product name
  * `:serial_number` - The device's serial number if it has one
  """
  def enumerate do
    Application.get_env(:exbee, :adapter).enumerate()
  end

  def start_link(args \\ []) do
    adapter = Keyword.get(args, :adapter, Application.get_env(:exbee, :adapter))
    serial_port = Keyword.get(args, :serial_port, Application.get_env(:exbee, :serial_port))

    GenServer.start_link(__MODULE__, [self(), adapter, serial_port, args])
  end

  def send_frame(pid, frame) do
    GenServer.call(pid, {:send_frame, frame})
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  # Server

  defmodule State do
    defstruct [:caller_pid, :adapter_pid, :adapter, buffer: <<>>]
  end

  def init([caller_pid, adapter, serial_port, args]) do
    {:ok, adapter_pid} = adapter.start_link()

    :ok = adapter.setup(adapter_pid, serial_port, args)

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
