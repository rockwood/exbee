defmodule Exbee.Command do
  @command_mapping %{
    146 => Exbee.RxSampleCommand
  }

  def parse_message(<<length::16, frame::binary-size(length), _checksum::8>>), do: parse_command(frame)
  def parse_message(message), do: {:error, "Invalid message: #{inspect message}"}

  defp parse_command(<<command_id::8, _rest::binary>> = frame) do
    Map.get(@command_mapping, command_id).parse(frame)
  end
end
