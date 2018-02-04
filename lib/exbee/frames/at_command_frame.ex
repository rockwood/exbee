defmodule Exbee.ATCommandFrame do
  @moduledoc """
  Query or set AT parameters on a local device.

  To query parameter values, send with `value: nil`.

  An `Exbee.ATCommandResultFrame` will be returned indicating the status of the command.
  """

  @type t :: %__MODULE__{id: integer, command: String.t(), value: binary}
  defstruct id: 0x01, command: "", value: nil

  defimpl Exbee.EncodableFrame do
    alias Exbee.Util

    def encode(frame = %{id: id, command: command}) do
      case frame do
        %{value: nil} ->
          <<0x08, id, command::bitstring-size(16)>>

        %{value: value} ->
          <<0x08, id, command::bitstring-size(16), Util.to_binary(value)::binary>>
      end
    end
  end
end
