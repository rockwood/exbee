defmodule Exbee.ReceiveFrame do
  defstruct [:mac_addr, :network_addr, :type, :payload]

  defimpl Exbee.FrameDecoder do
    def decode(frame, <<0x90, mac_addr::64, network_addr::16, type::8, payload::binary>>) do
      {:ok, %{frame | mac_addr: mac_addr, network_addr: network_addr, type: type, payload: payload}}
    end
  end
end
