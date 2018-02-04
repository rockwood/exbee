defmodule Exbee.GenericFrame do
  @type t :: %__MODULE__{type: integer, payload: binary}
  defstruct [:type, :payload]

  defimpl Exbee.DecodableFrame do
    def decode(frame, encoded_binary) do
      case encoded_binary do
        <<type::8, payload::binary>> -> {:ok, %{frame | type: type, payload: payload}}
        _ -> {:error, :invalid_binary}
      end
    end
  end

  defimpl Exbee.EncodableFrame do
    alias Exbee.Util

    def encode(%{type: type, payload: payload}) do
      <<type, Util.to_binary(payload)::binary>>
    end
  end
end
