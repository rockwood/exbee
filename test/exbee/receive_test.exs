defmodule Exbee.ReceiveTest do
  use Exbee.TestCase
  alias Exbee.{Device, FakeAdapter, Command.RxSample}

  describe "receiving a message" do
    setup do
      {:ok, device} = Device.start_link("Fake", speed: 9600, active: true)
      {:ok, device: device}
    end

    test "", %{device: device} do
      FakeAdapter.test_receive(<<126, 0, 18, 146, 0, 19, 162, 0, 64, 175, 220, 167, 208, 92, 1, 1, 0, 2, 0, 0, 2, 20>>)
      assert_received {:exbee_command, %RxSample{value: 2}}
    end
  end
end
