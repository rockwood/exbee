defmodule Exbee.Message do
  @frame_types %{
    0x92 => Exbee.RxSampleFrame,
  }

  def parse(<<length::16, frame_data::binary-size(length), _checksum::8>>) do
    decode_frame(frame_data)
  end
  def parse(invalid_message), do: {:error, "Invalid message: #{inspect invalid_message}"}

  defp decode_frame(<<frame_type::8, _rest::binary>> = frame_data) do
    Map.get(@frame_types, frame_type, Exbee.GenericFrame).decode(frame_data)
  end
end
