defmodule Exbee.RealAdapter do
  defdelegate enumerate_devices, to: Nerves.UART, as: :enumerate
end
