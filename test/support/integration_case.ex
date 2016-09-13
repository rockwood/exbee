defmodule Exbee.IntegrationCase do
  use ExUnit.CaseTemplate
  alias Exbee.Device

  setup_all do
    {serial_port, _} = Device.enumerate |> Enum.find(&filter_test_device/1)
    {:ok, device} = Device.start_link(serial_port, speed: 9600, active: false)
    {:ok, device: device, serial_port: serial_port}
  end

  defp filter_test_device({_, device}) do
    Map.get(device, :manufacturer) == "FTDI"
  end
end
