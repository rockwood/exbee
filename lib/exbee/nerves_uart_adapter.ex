defmodule Exbee.NervesUARTAdapter do
  alias Nerves.UART

  defdelegate enumerate, to: UART
  defdelegate start_link, to: UART
  defdelegate write(pid, message), to: UART
  defdelegate read(pid), to: UART

  def setup!(adapter, serial_port, opts) do
    :ok = UART.open(adapter, serial_port, opts)
    :ok = UART.configure(adapter, framing: {Nerves.UART.Framing.Line, separator: <<0x7E>>})
    adapter
  end
end
