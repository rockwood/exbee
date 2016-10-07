defmodule Exbee.Adapter do
  alias Nerves.UART
  alias Exbee.Commands

  @timeout 2_000

  defdelegate enumerate, to: UART
  defdelegate start_link, to: UART
  defdelegate open(pid, device, opts \\ []), to: UART

  def write(pid, command) do
    :ok = UART.write(pid, "#{command}")
    {:ok, response} = UART.read(pid, @timeout)
    {:ok, String.replace(response, "\r", "")}
  end
end
