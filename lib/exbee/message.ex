defmodule Exbee.Message do
  alias Exbee.{FrameEncoder, FrameDecoder}

  require Logger

  @separator <<0x7E>>

  @frame_types %{
    0x08 => Exbee.ATCommandFrame,
    0x88 => Exbee.ATCommandResponseFrame,
    0x92 => Exbee.RxSampleFrame,
    0x8A => Exbee.ModemStatusFrame,
  }

  def parse(data) do
    do_parse(data, <<>>, [])
  end

  def build(frame) do
    encoded_frame = FrameEncoder.encode(frame)

    <<@separator,
      byte_size(encoded_frame)::16,
      encoded_frame::binary,
      calculate_checksum(encoded_frame)>>
  end

  defp do_parse(data, buffer, frames) when byte_size(data) < 1, do: {buffer, frames}
  defp do_parse(<<@separator, rest::binary>>, _, frames), do: do_parse(rest, <<@separator>>, frames)
  defp do_parse(<<next_char::binary-size(1), rest::binary>>, buffer, frames) do
    case buffer <> next_char do
      <<@separator, length::16, encoded_frame::binary-size(length), checksum::8>> ->
        do_parse(rest, <<>>, apply_frame(frames, encoded_frame, checksum))
      new_buffer ->
        do_parse(rest, new_buffer, frames)
    end
  end

  defp apply_frame(frames, <<frame_type::8, _rest::binary>> = encoded_frame, checksum) do
    frame_struct = Map.get(@frame_types, frame_type, Exbee.GenericFrame) |> struct()

    with {:ok, _} <- validate_checksum(encoded_frame, checksum),
         {:ok, decoded_frame} <- FrameDecoder.decode(frame_struct, encoded_frame)
    do
      [decoded_frame | frames]
    else
      {:error, reason} ->
        Logger.debug(reason)
        frames
    end
  end

  defp validate_checksum(encoded_frame, checksum) do
    calculated = calculate_checksum(encoded_frame)

    if calculated == checksum do
      {:ok, calculated}
    else
      details = "Should equal #{inspect calculated}, but got #{inspect checksum}"
      {:error, "Invalid checksum for frame #{inspect encoded_frame}. (#{details})"}
    end
  end

  defp calculate_checksum(encoded_frame) do
    0xFF - (encoded_frame |> sum_bytes() |> rem(256))
  end

  defp sum_bytes(encoded, sum \\ 0)
  defp sum_bytes(<<>>, sum), do: sum
  defp sum_bytes(<<h::8, t::binary>>, sum), do: sum_bytes(t, sum + h)
end
