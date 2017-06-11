defmodule Exbee.ATCommandFrame do
  defstruct [id: 0x01, command: "", value: nil]

  defimpl Exbee.FrameEncoder do
    def encode(%{id: id, command: command, value: nil}) do
      <<0x08, id, command::bitstring-size(16)>>
    end
    def encode(%{id: id, command: command, value: value}) do
      <<0x08, id, command::bitstring-size(16), value::binary>>
    end
  end
end
