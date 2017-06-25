defmodule Exbee.ReceiveExplicitFrame do
  defstruct [:mac_addr, :network_addr, :source, :destination, :cluster_id, :profile_id, :type,
             :payload]

  defimpl Exbee.FrameDecoder do
    def decode(frame, <<0x91, mac_addr::64, network_addr::16, source::8, destination::8,
          cluster_id::8, profile_id::8, type::8, payload::binary>>) do
      {:ok, %{frame | mac_addr: mac_addr, network_addr: network_addr, source: source,
               destination: destination, cluster_id: cluster_id, profile_id: profile_id, type: type,
               payload: payload}}
    end
  end
end
