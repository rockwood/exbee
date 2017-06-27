defmodule Exbee.ReceiveSensorReadFrame do
  @moduledoc """
  Sent when a device receives a remote sensor.
  """

  @type t :: %__MODULE__{mac_addr: binary, network_addr: binary, options: atom, type: binary,
                         ad_value: binary, temperature_value: binary}
  defstruct [:mac_addr, :network_addr, :options, :type, :ad_value, :temperature_value]

  defimpl Exbee.FrameDecoder do
    @options %{
      0x01 => :acknowledged,
      0x02 => :broadcast
    }

    @types %{
      0x01 => :ad_read,
      0x02 => :temperature_read,
      0x60 => :water_present,
    }

    def decode(frame, <<0x94, mac_addr::64, network_addr::16, options::8, type::8, ad_value::64,
          temperature_value::16>>) do
      {:ok, %{frame | mac_addr: mac_addr, network_addr: network_addr, options: @options[options],
              type: @types[type], ad_value: ad_value, temperature_value: temperature_value}}
    end
  end
end
