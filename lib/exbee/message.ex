defmodule Exbee.Message do
  @moduledoc """
  Converts between binary messages and frames.
  """

  alias Exbee.{EncodableFrame, DecodableFrame}

  require Logger

  @separator <<0x7E>>

  @decodable_frames %{
    0x88 => Exbee.ATCommandResultFrame,
    0x8A => Exbee.DeviceStatusFrame,
    0x8B => Exbee.TxResultFrame,
    0x90 => Exbee.RxFrame,
    0x91 => Exbee.ExplicitRxFrame,
    0x92 => Exbee.RxSampleReadFrame,
    0x94 => Exbee.RxSensorReadFrame,
    0x97 => Exbee.RemoteATCommandResultFrame
  }

  @doc """
  Decodes a binary message into frames using the `Exbee.DecodableFrame` protocol.

  Messages can arrive incomplete, so this returns a buffer of any partial messages. The caller
  should return this buffer prepended to the next message.

  Frames with invalid checksums will be dropped.
  """
  @spec parse(binary) :: {binary, [DecodableFrame.t()]}
  def parse(data) do
    do_parse(data, <<>>, [])
  end

  @doc """
  Encodes a frame into a binary message using the `Exbee.EncodableFrame` protocol.

  It applies the separator, length, and checksum bytes.
  """
  @spec build(EncodableFrame.t()) :: binary
  def build(frame) do
    encoded_frame = EncodableFrame.encode(frame)

    <<@separator, byte_size(encoded_frame)::16, encoded_frame::binary,
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
    frame_struct = Map.get(@decodable_frames, frame_type, Exbee.GenericFrame) |> struct()

    with {:ok, _} <- validate_checksum(encoded_frame, checksum),
         {:ok, decoded_frame} <- DecodableFrame.decode(frame_struct, encoded_frame) do
      [decoded_frame | frames]
    else
      {:error, reason} ->
        Logger.warn(reason)
        frames
    end
  end

  defp validate_checksum(encoded_frame, checksum) do
    calculated = calculate_checksum(encoded_frame)

    if calculated == checksum do
      {:ok, calculated}
    else
      details = "Should equal #{inspect(calculated)}, but got #{inspect(checksum)}"
      {:error, "Invalid checksum for frame #{inspect(encoded_frame)}. (#{details})"}
    end
  end

  defp calculate_checksum(encoded_frame) do
    0xFF - (encoded_frame |> sum_bytes() |> rem(256))
  end

  defp sum_bytes(encoded, sum \\ 0)
  defp sum_bytes(<<>>, sum), do: sum
  defp sum_bytes(<<h::8, t::binary>>, sum), do: sum_bytes(t, sum + h)
end
