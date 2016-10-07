defmodule Exbee.Adapter do
  alias Nerves.UART

  defdelegate enumerate, to: UART
  defdelegate start_link, to: UART
  defdelegate open(pid, serial_port, opts \\ []), to: UART
  defdelegate write(pid, command), to: UART
  defdelegate read(pid), to: UART
end
