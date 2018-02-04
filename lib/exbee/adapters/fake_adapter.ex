defmodule Exbee.FakeAdapter do
  @moduledoc false

  use GenServer

  alias __MODULE__.MessageQueue

  @behaviour Exbee.Adapter

  defmodule State do
    @moduledoc false

    defstruct [:controlling_pid]
  end

  def enumerate do
    %{"/dev/fake_serial" => %{manufacturer: "Fake", product_id: 0, serial_number: "1"}}
  end

  def start_link do
    GenServer.start_link(__MODULE__, %State{controlling_pid: self()})
  end

  def init(state) do
    {:ok, state}
  end

  def open(_pid, _serial_port, _opts), do: :ok

  def stop(_pid), do: :ok

  def write(pid, message) do
    GenServer.call(pid, {:write, message})
  end

  def handle_call({:write, _message}, _, %{controlling_pid: controlling_pid} = state) do
    send controlling_pid, {:nerves_uart, 0, MessageQueue.dequeue()}
    {:reply, :ok, state}
  end

  defmodule MessageQueue do
    @moduledoc false

    use GenServer

    def start_link do
      GenServer.start_link(__MODULE__, [], [name: __MODULE__])
    end

    def init(queue) do
      {:ok, queue}
    end

    def enqueue(messages) do
      GenServer.call(__MODULE__, {:enqueue, messages})
    end

    def dequeue() do
      GenServer.call(__MODULE__, :dequeue)
    end

    def handle_call({:enqueue, message}, _from, queue) do
      {:reply, :ok, message ++ queue}
    end
    def handle_call(:dequeue, _from, [message | rest]) do
      {:reply, message, rest}
    end
  end
end
