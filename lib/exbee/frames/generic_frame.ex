defmodule Exbee.GenericFrame do
  @type t :: %__MODULE__{type: binary, payload: binary}
  defstruct [:type, :payload]

  defimpl Exbee.DecodableFrame do
    def decode(frame, <<type::8, payload::binary>>) do
      {:ok, %{frame | type: type, payload: payload}}
    end
  end

  defimpl Exbee.EncodableFrame do
    def encode(%{type: type, payload: payload}) do
      <<type, payload::binary>>
    end
  end
end
