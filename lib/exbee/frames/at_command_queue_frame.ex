defmodule Exbee.ATCommandQueueFrame do
  @moduledoc """
  Query or set AT parameters on a local device.

  In contrast to the `Exbee.ATCommandFrame`, this frame queues new parameter values and does not
  apply them until issuing either an `Exbee.ATCommandFrame`, or an `Exbee.ATCommandQueueFrame` with
  `command: "AC"`

  When querying parameter values, this frame behaves identically to the `Exbee.ATCommandFrame`
  frame. The device returns register queries immediately and does not queue them.

  An `Exbee.ATCommandResultFrame` will be returned indicating the status of the command.
  """

  @type t :: %__MODULE__{id: binary, command: String.t, value: binary}
  defstruct [id: 0x01, command: "", value: nil]

  defimpl Exbee.EncodableFrame do
    def encode(%{id: id, command: command, value: nil}) do
      <<0x09, id, command::bitstring-size(16)>>
    end
    def encode(%{id: id, command: command, value: value}) when is_integer(value) do
      <<0x09, id, command::bitstring-size(16), value>>
    end
    def encode(%{id: id, command: command, value: value}) when is_binary(value) do
      <<0x09, id, command::bitstring-size(16), value::binary>>
    end
  end
end
