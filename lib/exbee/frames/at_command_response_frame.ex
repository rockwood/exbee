defmodule Exbee.ATCommandResponseFrame do
  defstruct [id: 0x01, command: nil, value: nil]

  defimpl Exbee.FrameDecoder do
    def decode(frame, <<0x88, id::8, command::bitstring-size(16), value::binary>>) do
      {:ok, %{frame | id: id, command: command, value: value}}
    end
  end
end
