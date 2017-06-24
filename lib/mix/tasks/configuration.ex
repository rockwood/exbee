defmodule Mix.Tasks.Exbee.Configuration do
  defmodule Query do
    use Mix.Task

    alias Exbee.{Configuration, ATCommandFrame, Request}

    @shortdoc "Query all configuration values. Options: [--serial-port]"

    def run(args) do
      {device_args, _, _} = OptionParser.parse(args, switches: [serial_port: :string])

      request_frames = Enum.map Configuration.options(), fn({command, _}) ->
        %ATCommandFrame{command: command}
      end

      {:ok, results} = Request.run(request_frames, device_args)

      Enum.each results, fn({request_frame, response_frames}) ->
        response = Enum.map_join(response_frames, ", ", &inspect(&1, base: :hex))
        IO.puts("#{request_frame.command}: #{response}")
      end
    end
  end

  defmodule Set do
    use Mix.Task

    alias Exbee.{Configuration, ATCommandFrame, Request}

    @shortdoc "Set a configuration value. Options: [command=value --serial-port]"

    @available_args [:serial_port]

    def run(args) do
      {options, command_pairs, _} = OptionParser.parse(args, switches: [serial_port: :string])

      request_frames = Enum.map(command_pairs, &parse_command_pair/1)

      {:ok, results} = Request.run(request_frames, options)

      Enum.each results, fn({request_frame, response_frames}) ->
        response = Enum.map_join(response_frames, ", ", &inspect(&1, base: :hex))
        IO.puts("#{request_frame.command}: #{response}")
      end
    end

    def parse_command_pair(command_pair) do
      case String.split(command_pair, "=") do
        [raw_command, raw_value] ->
          {value, _} = Code.eval_string(raw_value)
          %ATCommandFrame{command: String.upcase(raw_command), value: value}
        _ ->
          raise ArgumentError, message: "Unable to parse #{command_pair}."
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
