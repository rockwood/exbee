defmodule Exbee.TxResultFrame do
  @moduledoc """
  Received upon completion of a `Exbee.TxFrame` or `Exbee.ExplicitTxFrame`. The
  `:deliver_status` indicates whether the transmission was successful.

  Possible status values include:

    * :ok (`0x00`)
    * :mac_ack_failure (`0x01`)
    * :cca_failure (`0x02`)
    * :invalid_endpoint (`0x15`)
    * :network_ack_failure (`0x21`)
    * :network_not_joined (`0x22`)
    * :self_addressed (`0x23`)
    * :address_not_found (`0x24`)
    * :route_not_found (`0x25`)
    * :relay_failure (`0x26`)
    * :invalid_binding_table_index (`0x2B`)
    * :resource_error (`0x2C`)
    * :aps_transmission (`0x2D`)
    * :aps_unicast_transmission (`0x2E`)
    * :resource_error (`0x32`)
    * :oversized_payload (`0x74`)
    * :indirect_message_failure (`0x75`)
  """

  @type t :: %__MODULE__{id: integer, network_addr: integer, retry_count: integer, status: integer,
                         discovery: integer}
  defstruct [id: 0x01, network_addr: nil, retry_count: 0, status: nil,
             discovery: nil]

  defimpl Exbee.DecodableFrame do
    @statuses %{
      0x00 => :ok,
      0x01 => :mac_ack_failure,
      0x02 => :cca_failure,
      0x15 => :invalid_endpoint,
      0x21 => :network_ack_failure,
      0x22 => :network_not_joined,
      0x23 => :self_addressed,
      0x24 => :address_not_found,
      0x25 => :route_not_found,
      0x26 => :relay_failure,
      0x2B => :invalid_binding_table_index,
      0x2C => :resource_error,
      0x2D => :aps_transmission,
      0x2E => :aps_unicast_transmission,
      0x32 => :resource_error,
      0x74 => :oversized_payload,
      0x75 => :indirect_message_failure,
    }

    @discoveries %{
      0x00 => :no_overhead,
      0x01 => :address,
      0x02 => :route,
      0x03 => :address_and_route,
      0x40 => :extended_timeout,
    }

    def decode(frame, <<0x8B, id::8, network_addr::16, retry_count::8, status::8, discovery::8>>) do
      {:ok, %{frame | id: id, network_addr: network_addr, retry_count: retry_count,
               status: @statuses[status], discovery: @discoveries[discovery]}}
    end
  end
end
