defmodule Exbee.ModemStatusFrame do
  defstruct [:status]

  defimpl Exbee.FrameDecoder do
    def decode(frame, <<0x8A, status::8>>) do
      {:ok, %{frame | status: status}}
    end
  end
end
