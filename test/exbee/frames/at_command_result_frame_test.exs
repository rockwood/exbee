defmodule Exbee.ATCommandResultFrameTest do
  use Exbee.TestCase

  alias Exbee.{DecodableFrame, ATCommandResultFrame}

  test "decode" do
    message = <<0x88, 0x1, 0x4E, 0x4A, 0x0, 0xFF>>
    {:ok, frame} = DecodableFrame.decode(%ATCommandResultFrame{}, message)
    assert frame == %ATCommandResultFrame{command: "NJ", id: 1, status: :ok, value: <<0xFF>>}
  end
end
