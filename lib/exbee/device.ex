defmodule Exbee.Device do
  use GenServer
  alias Exbee.Adapter

  @timeout 2_000

  defmodule State do
    defstruct [
      adapter: nil
    ]
  end

  def enumerate do
    Adapter.enumerate
  end

  def start_link(serial_port, opts \\ []) do
    GenServer.start_link(__MODULE__, [serial_port, opts])
  end

  def write(pid, data) do
    GenServer.call(pid, {:write, data})
  end

  def enter_command_mode(pid) do
    case write(pid, "+++") do
      {:ok, "OK"} -> :ok
      {:ok, ""} -> :error
    end
  end

  # Server

  def init([serial_port, opts]) do
    {:ok, adapter} = Adapter.start_link
    Adapter.open(adapter, serial_port, opts)
    state = %State{adapter: adapter}
    {:ok, state}
  end

  def handle_call({:write, data}, _from, %{adapter: adapter} = state) do
    {:reply, Adapter.write(adapter, data), state}
  end
end
