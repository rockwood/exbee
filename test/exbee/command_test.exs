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

defmodule Exbee.CommandTest do
  use Exbee.TestCase
  alias Exbee.Command

  describe "parse/1" do
    setup do
      bin = <<126, 0, 18, 146, 0, 19, 162, 0, 64, 175, 220, 167, 208, 92, 1, 1, 0, 2, 0, 0, 2, 20>>
      {:ok, command: Command.parse(bin)}
    end

    test "type", %{command: command} do
      assert command.type == 92
    end

    test "value", %{command: command} do
      assert command.value == 2
    end
  end
end
