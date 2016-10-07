defmodule ExbeeTest do
  use Exbee.TestCase, async: true

  describe "enumerate_devices/0" do
    test "returns a list" do
      assert is_map(Exbee.enumerate_devices)
    end
  end

  describe "start_link/0" do
    test "returns a pid" do
      {:ok, pid} = Exbee.start_link
      assert is_pid(pid)
    end
  end

  describe "open/1" do
    setup :start

    test "returns :ok", %{pid: pid, device: device} do
      assert :ok = Exbee.open(pid, device, speed: 9600, active: false)
    end
  end

  describe "ping/0" do
    setup [:start, :open]

    test "returns :ok", %{pid: pid} do
      assert :ok = Exbee.ping(pid)
    end
  end

  describe "get_config/0" do
    setup [:start, :open]

    test "returns the config", %{pid: pid} do
      {:ok, config} = Exbee.get_config(pid)
      assert config.pan_id == "0"
    end
  end

  def start(_) do
    {:ok, pid} = Exbee.start_link
    {device, _} = Exbee.enumerate_devices |> Enum.find(&filter_test_device/1)

    {:ok, pid: pid, device: device}
  end

  def open(%{pid: pid, device: device}) do
    Exbee.open(pid, device, speed: 9600, active: false)
  end

  defp filter_test_device({_, device}) do
    Map.get(device, :manufacturer) == "FTDI"
  end
end
