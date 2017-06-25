defmodule Exbee.ModemStatusFrame do
  defstruct [:status]

  defimpl Exbee.FrameDecoder do
    @statuses %{
      0x00 => :hardware_reset,
      0x01 => :watchdog_timer_reset,
      0x03 => :disassociated,
      0x06 => :coordinator_started,
      0x07 => :security_key_updated,
      0x0D => :voltage_supply_limit_exceeded,
      0x11 => :modem_configuration_change,
    }

    def decode(frame, <<0x8A, status::8>>) do
      {:ok, %{frame | status: Map.get(@statuses, status, status)}}
    end
  end
end
