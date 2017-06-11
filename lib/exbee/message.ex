defmodule Exbee.Message do
  alias Exbee.{FrameEncoder, FrameDecoder}

  @frame_types %{
    0x08 => Exbee.ATCommandFrame,
    0x88 => Exbee.ATCommandResponseFrame,
    0x92 => Exbee.RxSampleFrame,
  }

  def parse(message) do
    case message do
      <<length::16, encoded_frame::binary-size(length), _checksum::8>> ->
        encoded_frame |> get_frame_module() |> struct() |> FrameDecoder.decode(encoded_frame)
      invalid_message ->
        {:error, "Invalid message: #{inspect invalid_message}"}
    end
  end

  def build(frame) do
    encoded_frame = FrameEncoder.encode(frame)
    <<byte_size(encoded_frame)::16, encoded_frame::binary, calculate_checksum(encoded_frame)>>
  end

  defp get_frame_module(<<frame_type::8, _rest::binary>>) do
    Map.get(@frame_types, frame_type, Exbee.GenericFrame)
  end

  defp calculate_checksum(encoded_frame) do
    0xFF - (encoded_frame |> sum_bytes() |> rem(256))
  end

  defp sum_bytes(encoded, sum \\ 0)
  defp sum_bytes(<<>>, sum), do: sum
  defp sum_bytes(<<h::8, t::binary>>, sum), do: sum_bytes(t, sum + h)
end
