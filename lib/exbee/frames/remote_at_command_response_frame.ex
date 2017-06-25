defmodule Exbee.RemoteATCommandResponseFrame do
  defstruct [:id, :mac_addr, :network_addr, :command, :status, :value]

  defimpl Exbee.FrameDecoder do
    @statuses %{
      0x00 => :ok,
      0x01 => :error,
      0x02 => :invalid_command,
      0x03 => :invalid_parameter,
      0x04 => :transmition_failure,
    }

    def decode(frame, <<0x97, id::8, mac_addr::64, network_addr::16, command::bitstring-size(16),
          status::8, value::binary>>) do
      {:ok, %{frame | id: id, mac_addr: mac_addr, network_addr: network_addr, command: command,
              status: @statuses[status], value: value}}
    end
  end
end
