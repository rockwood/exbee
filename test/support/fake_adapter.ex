defmodule Exbee.FakeAdapter do
  use GenServer

  defmodule State do
    defstruct [:controlling_pid, writes: []]
  end

  def enumerate do
    %{
      "/dev/fake_serial" => %{manufacturer: "Fake", product_id: 0, serial_number: "1", vendor_id: 2}
    }
  end

  def start_link do
    GenServer.start_link(__MODULE__, struct(State), [name: __MODULE__])
  end

  def open(_pid, _serial_port, _opts \\ []) do
    GenServer.call(__MODULE__, {:open})
  end

  def write(_pid, data) do
    GenServer.call(__MODULE__, {:write, data})
  end

  def test_receive(message) do
    GenServer.call(__MODULE__, {:test_receive, message})
  end

  def handle_call({:open}, {controlling_pid, _}, state) do
    {:reply, :ok, %{state | controlling_pid: controlling_pid}}
  end

  def handle_call({:write, command}, _from, %{writes: writes} = state) do
    {:reply, :ok, %{state | writes: [command | writes]}}
  end

  def handle_call({:test_receive, message}, _from, %{controlling_pid: controlling_pid} = state) do
    send(controlling_pid, {:nerves_uart, "test", message})
    {:reply, :ok, state}
  end
end
