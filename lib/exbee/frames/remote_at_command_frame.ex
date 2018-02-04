defmodule Exbee.RemoteATCommandFrame do
  @moduledoc """
  Transmits AT parameters to a remote device.

  To query parameter values, send with `value: nil`.

  For parameter changes on the remote device to take effect, send either the apply changes option
  (`option: 0x01`), or send an `AC` command to the remote node.
  """

  @type t :: %__MODULE__{
          id: integer,
          mac_addr: integer,
          network_addr: integer,
          options: integer,
          command: String.t(),
          value: binary
        }
  defstruct id: 0x01, mac_addr: 0x00, network_addr: 0xFFFE, options: 0x00, command: "", value: nil

  defimpl Exbee.EncodableFrame do
    alias Exbee.Util

    def encode(
          frame = %{
            id: id,
            mac_addr: mac_addr,
            network_addr: network_addr,
            options: options,
            command: command
          }
        ) do
      case frame do
        %{value: nil} ->
          <<0x17, id::8, mac_addr::64, network_addr::16, options::8, command::bitstring-size(16)>>

        %{value: value} ->
          <<0x17, id::8, mac_addr::64, network_addr::16, options::8, command::bitstring-size(16),
            Util.to_binary(value)::binary>>
      end
    end
  end
end
