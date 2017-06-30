defmodule Exbee.GenericFrame do
  @type t :: %__MODULE__{type: integer, payload: binary}
  defstruct [:type, :payload]

  defimpl Exbee.DecodableFrame do
    def decode(frame, <<type::8, payload::binary>>) do
      {:ok, %{frame | type: type, payload: payload}}
    end
  end

  defimpl Exbee.EncodableFrame do
    alias Exbee.Util

    def encode(%{type: type, payload: payload}) do
      <<type, Util.to_binary(payload)::binary>>
    end
  end
end
