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
    @known <<0, 18, 146, 0, 19, 162, 0, 64, 175, 220, 167, 208, 92, 1, 1, 0, 2, 0, 0, 2, 20>>
    @unknown <<0, 18, 1, 0, 19, 162, 0, 64, 175, 220, 167, 208, 92, 1, 1, 0, 2, 0, 0, 2, 20>>
    @invalid <<0, 0, 146, 0, 19, 162, 0, 64, 175, 220, 167, 208, 92, 1, 1, 0, 2, 0, 0, 2, 20>>

    test "with a known message, returns the correct frame" do
      assert {:ok, %Exbee.RxSampleFrame{value: 2}} = Message.parse(@known)
    end

    test "with an unknown command, returns the generic command" do
      {:ok, %Exbee.GenericFrame{type: 1, payload: payload}} = Message.parse(@unknown)
      assert <<0, 19, 162, _rest::binary>> = payload
    end

    test "with an invalid message, returns an invaid error" do
      {:error, reason} = Message.parse(@invalid)
      assert reason =~ "Invalid"
    end
  end

  describe "build/1" do
    setup do
      {:ok, frame: %Exbee.GenericFrame{type: 0x01, payload: <<0x02, 0x03>>}}
    end

    test "correctly encodes the length and checksum", %{frame: frame} do
      message = Message.build(frame)
      assert message == <<0x00, 0x03, 0x01, 0x02, 0x03, 0xF9>>
    end
  end
end
