defprotocol Exbee.FrameDecoder do
  @moduledoc "Protocol used to decode a binary message into a frame."

  @spec decode(Exbee.FrameDecoder.t, binary) :: Exbee.FrameDecoder.t
  def decode(frame, encoded_frame)
end
