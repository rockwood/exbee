defmodule Exbee.NervesUARTAdapter do
  alias Nerves.UART

  defdelegate enumerate, to: UART
  defdelegate start_link, to: UART
  defdelegate write(pid, message), to: UART
  defdelegate stop(pid), to: UART

  def setup(pid, serial_port, opts) do
    UART.open(pid, serial_port, opts)
  end
end
