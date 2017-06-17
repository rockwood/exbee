defmodule Exbee.NervesUARTAdapter do
  alias Nerves.UART

  defdelegate enumerate, to: UART
  defdelegate start_link, to: UART
  defdelegate write(pid, message), to: UART

  def setup!(adapter, serial_port, opts) do
    :ok = UART.open(adapter, serial_port, opts)
    adapter
  end
end
