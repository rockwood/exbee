defmodule Exbee.Device do
  use GenServer
  require Logger
  alias Exbee.{Command}

  @adapter Application.get_env(:exbee, :adapter)

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
    @adapter.enumerate()
  end

  def start_link(serial_port, opts \\ []) do
    GenServer.start_link(__MODULE__, [self, serial_port, opts])
  end

  def write(pid, data) do
    GenServer.call(pid, {:write, data})
  end

  def read(pid) do
    GenServer.call(pid, {:read})
  end

  def enter_command_mode(pid) do
    :ok = write(pid, "+++")

    case read(pid) do
      {:ok, "OK"} -> :ok
      {:ok, ""} -> :error
    end
  end

  # Server

  defmodule State do
    defstruct [:controller, :adapter]
  end

  def init([controller, serial_port, opts]) do
    {:ok, adapter} = @adapter.start_link()
    {:ok, %State{controller: controller, adapter: @adapter.setup!(adapter, serial_port, opts)}}
  end

  def handle_call({:write, data}, _from, %{adapter: adapter} = state) do
    {:reply, @adapter.write(adapter, data), state}
  end

  def handle_call({:read}, _from, %{adapter: adapter} = state) do
    {:reply, @adapter.read(adapter), state}
  end

  def handle_info({:nerves_uart, _serial_port, message}, %{controller: controller} = state) do
    case Command.parse_message(message) do
      {:ok, command} -> send(controller, {:exbee_command, command})
      {:error, reason} -> Logger.debug(reason)
    end

    {:noreply, state}
  end
end
