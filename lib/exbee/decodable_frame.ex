defprotocol Exbee.DecodableFrame do
  @moduledoc "Protocol used to decode a binary message into a frame."

  @spec decode(Exbee.DecodableFrame.t, binary) :: Exbee.DecodableFrame.t
  def decode(frame, encoded_frame)
end
