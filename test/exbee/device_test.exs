defmodule Exbee.DeviceTest do
  use Exbee.IntegrationCase, async: true
  alias Exbee.Device

  describe "enumerate/0" do
    test "returns each connected serial port" do
      assert is_map(Device.enumerate)
    end
  end

  describe "start_link/1" do
    test "returns a device pid", %{serial_port: serial_port} do
      {:ok, pid} = Device.start_link(serial_port)
      assert is_pid(pid)
    end
  end

  describe "write/2" do
    test "writing to the device", %{device: device} do
      {:ok, response} = Device.write(device, "+++")
      assert response == "OK"
    end
  end
end
