defmodule Exbee.RemoteATCommandFrame do
  @moduledoc """
  Set AT parameters on a remote device.

  For parameter changes on the remote device to take effect, send either the apply changes option
  (`option: 0x01`), or send an `AC` command to the remote.
  """

  @type t :: %__MODULE__{id: binary, mac_addr: binary, network_addr: binary, options: binary,
                         command: String.t, value: binary}
  defstruct [id: 0x01, mac_addr: 0x00, network_addr: 0xFFFE, options: 0x00, command: "", value: nil]

  defimpl Exbee.FrameEncoder do
    def encode(%{id: id, mac_addr: mac_addr, network_addr: network_addr, options: options,
                 command: command, value: nil}) do
      <<0x17, id::8, mac_addr::64, network_addr::16, options::8, command::bitstring-size(16)>>
    end
    def encode(%{id: id, mac_addr: mac_addr, network_addr: network_addr, options: options,
                 command: command, value: value}) when is_integer(value) do
      <<0x17, id::8, mac_addr::64, network_addr::16, options::8, command::bitstring-size(16),
        value>>
    end
    def encode(%{id: id, mac_addr: mac_addr, network_addr: network_addr, options: options,
                 command: command, value: value}) when is_binary(value) do
      <<0x17, id::8, mac_addr::64, network_addr::16, options::8, command::bitstring-size(16),
        value::binary>>
    end
  end
end
