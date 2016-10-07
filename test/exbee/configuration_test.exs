defmodule Exbee.ConfigurationTest do
  use Exbee.IntegrationCase
  alias Exbee.Configuration

  describe "get" do
    test "returns the entire config", %{device: device} do
      {:ok, config} = Configuration.get(device)
      assert config.pan_id == "0"
    end

    test "returns a single config value", %{device: device} do
      {:ok, pan_id} = Configuration.get(device, :pan_id)
      assert pan_id == "0"
    end
  end
end
