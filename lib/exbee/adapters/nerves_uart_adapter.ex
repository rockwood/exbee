defmodule Exbee.NervesUARTAdapter do
  alias Nerves.UART

  @behaviour Exbee.Adapter

  defdelegate enumerate, to: UART
  defdelegate start_link, to: UART
  defdelegate write(pid, message), to: UART
  defdelegate stop(pid), to: UART
  defdelegate open(pid, serial_port, opts), to: UART
end
