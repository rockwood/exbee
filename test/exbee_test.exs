defmodule ExbeeTest do
  use Exbee.TestCase, async: true

  describe "enumerate_devices/0" do
    test "delegates to Nerves.UART.enumerate" do
      assert is_map(Exbee.enumerate_devices)
    end
  end
end
