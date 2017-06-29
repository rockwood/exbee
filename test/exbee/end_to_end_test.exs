defmodule Exbee.EndToEndTest do
  use Exbee.IntegrationCase
  alias Exbee.{ATCommandFrame, ATCommandResultFrame}

  @moduletag :integration

  describe "serial_ports/0" do
    test "returns each connected serial port" do
      assert Exbee.serial_ports() |> is_map()
    end
  end

  describe "send_frame/2" do
    test "sends the frame and receives a response", %{device: device} do
      assert :ok = Exbee.send_frame(device, %ATCommandFrame{command: "NJ"})
      assert_receive {:exbee,  %ATCommandResultFrame{command: "NJ", status: :ok}}
    end
  end
end
