defmodule Exbee.TransmitExplicitFrame do
  defstruct [id: 0x01, mac_addr: 0x000000000000FFFF, network_addr: 0xFFFE, source: nil,
             destination: nil, cluster_id: nil, profile_id: nil, radius: 0x00,
             options: 0x00, payload: nil]

  defimpl Exbee.FrameEncoder do
    def encode(%{id: id, mac_addr: mac_addr, network_addr: network_addr, source: source,
                 destination: destination, cluster_id: cluster_id, profile_id: profile_id,
                 radius: radius, options: options, payload: payload}) do
      <<0x11, id::8, mac_addr::64, network_addr::16, source::8, destination::8, cluster_id::16,
        profile_id::16, radius::8, options::8, payload::binary>>
    end
  end
end
