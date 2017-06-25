defmodule Exbee.TransmitFrame do
  defstruct [id: 0x01, mac_addr: 0x000000000000FFFF, network_addr: 0xFFFE, radius: 0x00,
             options: 0x00, payload: nil]

  defimpl Exbee.FrameEncoder do
    def encode(%{id: id, mac_addr: mac_addr, network_addr: network_addr, radius: radius,
                 options: options, payload: payload}) do
      <<0x10, id::8, mac_addr::64, network_addr::16, radius::8, options::8, payload::binary>>
    end
  end
end
