# IO Data Sample RX Indicator (API 1)

# 7E 00 12 92 00 13 A2 00 40 AF DC A7 D0 5C 01 01 00 02 00 00 02 14

# Start delimiter: 7E
# Length: 00 12 (18)
# Frame type: 92 (IO Data Sample RX Indicator)
# 64-bit source address: 00 13 A2 00 40 AF DC A7
# 16-bit source address: D0 5C
# Receive options: 01
# Number of samples: 01
# Digital channel mask: 00 02
# Analog channel mask: 00
# DIO1/AD1 digital value: High
# Checksum: 14

defmodule Exbee.MessageTest do
  use Exbee.TestCase
  alias Exbee.{Message}

  describe "parse/1" do
    test "parses basic frames" do
      {buffer, frames} = Message.parse(<<0x7E, 0x00, 0x03, 0x01, 0x02, 0x03, 0xF9>>)
      assert [%Exbee.GenericFrame{payload: <<0x02, 0x03>>}] = frames
      assert buffer == <<>>
    end

    test "parses multipe frames in one message" do
      {buffer, frames} = Message.parse(
        <<0x7E, 0x00, 0x03, 0x01, 0x02, 0x03, 0xF9, 0x01, 0x7E, 0x00, 0x03, 0x01, 0x02, 0x03, 0xF9>>
      )
      assert length(frames) == 2
      assert buffer == <<>>
    end

    test "buffers extra end bits" do
      {buffer, frames} = Message.parse(<<0x7E, 0x00, 0x03, 0x01, 0x02, 0x03, 0xF9, 0x7E, 0x00>>)
      assert [%Exbee.GenericFrame{payload: <<0x02, 0x03>>}] = frames
      assert buffer == <<0x7E, 0x00>>
    end

    test "drops extra start bits" do
      {buffer, frames} = Message.parse(<<0x00, 0x01, 0x7E, 0x00, 0x03, 0x01, 0x02, 0x03, 0xF9>>)
      assert [%Exbee.GenericFrame{payload: <<0x02, 0x03>>}] = frames
      assert buffer == <<>>
    end
  end

  describe "build/1" do
    setup do
      {:ok, frame: %Exbee.GenericFrame{type: 0x01, payload: <<0x02, 0x03>>}}
    end

    test "correctly encodes the length and checksum", %{frame: frame} do
      message = Message.build(frame)
      assert message == <<0x7E, 0x00, 0x03, 0x01, 0x02, 0x03, 0xF9>>
    end
  end
end
