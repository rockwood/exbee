defmodule Exbee.TxFrame do
  @moduledoc """
  Transmits a payload to a remote node.

    * For broadcast transmissions, set `:mac_addr` to `0x000000000000FFFF`.
    * Address the coordinator by either setting the `mac_addr` to `0x00` and `:network_addr` to
      `0xFFFE`, or by setting `:mac_addr` to the coordinator's mac address and `:network_addr` to
      `0x0000`.
    * For all other transmissions, setting `:network_addr` to the correct 16-bit address helps
      improve performance when transmitting to multiple endpoints. If you do not know a the
      endpoint's network address, set it to `0xFFFE` (unknown).

  The `:radius` attribute sets the maximum number of hops a broadcast transmission can occur. It can
  be set from `0` to `0xFF`. If set to 0, the value of the Maximum Unicast Hops(NH) command
  specifies the broadcast radius (recommended). This parameter is only used for broadcast
  transmissions.

  Possible `:option` values:

    * `0x01` - Disable retries
    * `0x20` - Enable APS encryption (if EE=1)
    * `0x40` - Use the extended transmission timeout for this destination

  An `Exbee.TxResultFrame` will be returned indicating the status of the transmission.
  """

  @type t :: %__MODULE__{id: binary, mac_addr: binary, network_addr: binary, radius: binary,
                         options: binary, payload: binary}
  defstruct [id: 0x01, mac_addr: 0x000000000000FFFF, network_addr: 0xFFFE, radius: 0x00,
             options: 0x00, payload: nil]

  defimpl Exbee.EncodableFrame do
    alias Exbee.Util

    def encode(%{id: id, mac_addr: mac_addr, network_addr: network_addr, radius: radius,
                 options: options, payload: payload}) do
      binary_payload = Util.to_binary(payload)
      <<0x10, id::8, mac_addr::64, network_addr::16, radius::8, options::8, binary_payload::binary>>
    end
  end
end
