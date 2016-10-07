defmodule Exbee.Device do
  use GenServer
  alias Exbee.{Command}

  @adapter Application.get_env(:exbee, :adapter)

  defmodule State do
    defstruct [:controller, :adapter]
  end

  def enumerate do
    @adapter.enumerate
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

  def init([controller, serial_port, opts]) do
    {:ok, adapter} = @adapter.start_link
    @adapter.open(adapter, serial_port, opts)
    state = %State{controller: controller, adapter: adapter}
    {:ok, state}
  end

  def handle_call({:write, data}, _from, %{adapter: adapter} = state) do
    {:reply, @adapter.write(adapter, data), state}
  end

  def handle_call({:read}, _from, %{adapter: adapter} = state) do
    {:reply, @adapter.read(adapter), state}
  end

  def handle_info({:nerves_uart, _serial_port, message}, %{controller: controller} = state) do
    send(controller, {:exbee_command, Command.parse(message)})
    {:noreply, state}
  end
end
