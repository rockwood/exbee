defmodule Exbee.ATCommandFrame do
  @moduledoc """
  Query or set AT parameters on a local device.

  To query parameter values, send with `value: nil`.

  An `Exbee.ATCommandResultFrame` will be returned indicating the status of the command.
  """

  @type t :: %__MODULE__{id: integer, command: String.t, value: binary}
  defstruct [id: 0x01, command: "", value: nil]

  defimpl Exbee.EncodableFrame do
    alias Exbee.Util

    def encode(%{id: id, command: command, value: nil}) do
      <<0x08, id, command::bitstring-size(16)>>
    end
    def encode(%{id: id, command: command, value: value}) do
      binary_value = Util.to_binary(value)
      <<0x08, id, command::bitstring-size(16), binary_value::binary>>
    end
  end
end
