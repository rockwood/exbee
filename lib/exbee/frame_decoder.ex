defprotocol Exbee.FrameDecoder do
  def decode(frame, encoded_frame)
end
