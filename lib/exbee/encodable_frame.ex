defprotocol Exbee.EncodableFrame do
  @moduledoc "Protocol used to encode a frame into a binary message."


  @spec encode(Exbee.EncodableFrame.t) :: binary
  def encode(frame)
end
