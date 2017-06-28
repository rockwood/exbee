defmodule Exbee.IntegrationCase do
  use ExUnit.CaseTemplate

  setup do
    {serial_port, _} = Exbee.serial_ports() |> Enum.find(&filter_test_device/1)
    {:ok, device} = Exbee.start_link(serial_port: serial_port)
    {:ok, device: device, serial_port: serial_port}
  end

  defp filter_test_device({_, device}) do
    Map.get(device, :manufacturer) == "FTDI"
  end
end
