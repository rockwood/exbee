defmodule Exbee.RemoteATCommandResultFrame do
  @moduledoc """
  Received in response to an `Exbee.RemoteATCommandFrame`.

  Some commands end back multiple frames; for example, the `ND` command.
  """

  @type t :: %__MODULE__{id: integer, mac_addr: integer, network_addr: integer, command: String.t,
                         status: atom, value: binary}
  defstruct [:id, :mac_addr, :network_addr, :command, :status, :value]

  defimpl Exbee.DecodableFrame do
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
