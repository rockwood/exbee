defmodule Exbee.TxResultFrameTest do
  use Exbee.TestCase

  alias Exbee.{DecodableFrame, TxResultFrame}

  test "decode" do
    message = <<0x8B, 0x1, 0xEF, 0x2F, 0x0, 0x0, 0x0>>

    {:ok, frame} = DecodableFrame.decode(%TxResultFrame{}, message)

    assert frame == %TxResultFrame{
             id: 1,
             retry_count: 0,
             status: :ok,
             discovery: :no_overhead,
             network_addr: 0xEF2F
           }
  end
end
