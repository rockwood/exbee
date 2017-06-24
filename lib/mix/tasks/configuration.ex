defmodule Mix.Tasks.Exbee.Configuration do
  defmodule Query do
    use Mix.Task

    alias Exbee.{Configuration, ATCommandFrame, Request}

    @shortdoc "Query all configuration values. Options: [command --serial-port]"

    def run(args) do
      {device_args, commands, _} = OptionParser.parse(args, switches: [serial_port: :string])

      {:ok, response_frames} = commands |> parse_request_frames() |> Request.run(device_args)

      for frame <- response_frames do
        case frame do
          %{command: command, value: value, status: :ok} ->
            IO.puts("#{command}: #{inspect(value, base: :hex)}")
          %{command: command, status: error_status} ->
            IO.puts("#{command}: #{error_status}")
          _ ->
            nil
        end
      end
    end

    defp parse_request_frames([]), do: Configuration.options() |> Map.keys() |> parse_request_frames()
    defp parse_request_frames(commands) do
      for command <- commands do
        %ATCommandFrame{command: command}
      end
    end
  end

  defmodule Set do
    use Mix.Task

    alias Exbee.{Configuration, ATCommandFrame, Request}

    @shortdoc "Set a configuration value. Options: [command=value --serial-port]"

    @available_args [:serial_port]

    def run(args) do
      {device_args, command_pairs, _} = OptionParser.parse(args, switches: [serial_port: :string])

      {:ok, response_frames} = command_pairs |> parse_request_frames() |> Request.run(device_args)

      for frame <- response_frames do
        case frame do
          %{command: command, status: status} -> IO.puts("#{command}: #{status}")
          other_frame -> IO.puts("#{inspect other_frame}")
        end
      end
    end

    def parse_request_frames(command_pairs) do
      for command_pair <- command_pairs do
        case String.split(command_pair, "=") do
          [raw_command, raw_value] ->
            {value, _} = Code.eval_string(raw_value)
            %ATCommandFrame{command: String.upcase(raw_command), value: value}
          _ ->
            raise ArgumentError, message: "Unable to parse #{command_pair}."
        end
      end
    end
  end

  defmodule Options do
    use Mix.Task

    alias Exbee.{Configuration}

    @shortdoc "List available configuration options"

    def run(_args) do
      for {command, description} <- Configuration.options() do
        IO.puts("#{command}: #{description}")
      end
    end
  end
end
