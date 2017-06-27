defprotocol Exbee.FrameEncoder do
  @moduledoc "Protocol used to encode a frame into a binary message."


  @spec encode(Exbee.FrameEncoder.t) :: binary
  def encode(frame)
end
