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
