defmodule Exbee.Command do
  @command_mapping %{
    146 => Exbee.RxSampleCommand
  }

  def parse_message(<<length::16, frame::binary-size(length), _checksum::8>>), do: command(frame)
  def parse_message(message), do: {:error, "Invalid message: #{inspect message}"}

  defp command(<<command_id::8, _rest::binary>> = frame) do
    Map.get(@command_mapping, command_id, Exbee.RxGenericCommand).parse(frame)
  end
end
