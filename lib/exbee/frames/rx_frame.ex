defmodule Exbee.RxFrame do
  @moduledoc """
  Received when a device reads a transmission from a remote node.

  A device configured with the standard API Rx Indicator (`AO = 0`) will return this frame when it
  receives an RF packet.
  """

  @type t :: %__MODULE__{mac_addr: binary, network_addr: binary, type: binary, payload: binary}
  defstruct [:mac_addr, :network_addr, :type, :payload]

  defimpl Exbee.DecodableFrame do
    def decode(frame, <<0x90, mac_addr::64, network_addr::16, type::8, payload::binary>>) do
      {:ok, %{frame | mac_addr: mac_addr, network_addr: network_addr, type: type, payload: payload}}
    end
  end
end
