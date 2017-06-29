defmodule Mix.Tasks.Exbee.At do
  @moduledoc false

  defmodule Query do
    @switches [
      serial_port: :string,
      speed: :integer,
      data_bits: :integer,
      stop_bits: :integer,
      parity: :integer,
      flow_control: :atom
    ]

    @shortdoc "Query AT configuration values."
    @moduledoc """
    #{@shortdoc}

    Depending on the installed firmware, some parameters will respond with `invalid_command`.

    Device options can either be passed via switches (ex: `--serial-port`) or they'll be read from
    `:exbee` config values

    Switch options include:

    #{
      @switches
      |> Keyword.keys()
      |> Enum.map(&("\n * --" <> (&1 |> to_string() |> String.replace("_", "-"))))
    }

    Examples:

    Return a list of all AT parameter values:

        > mix exbee.at.query --serial-port COM1 --speed 115200
        SL: <<0x40, 0xB1, 0x90, 0x74>>
        SM: invalid_command
        VR: <<0x21, 0xA7>>
        SN: <<0x0, 0x1>>

    Return a single AT parameter value:

        > mix exbee.at.query NJ
        NJ: <<0xFF>>
    """

    use Mix.Task

    alias Exbee.{ATCommands, ATCommandFrame, Request}

    def run(args) do
      {device_args, commands, _} = OptionParser.parse(args, switches: @switches)

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

    defp parse_request_frames([]), do: ATCommands.all() |> Map.keys() |> parse_request_frames()
    defp parse_request_frames(commands) do
      for command <- commands do
        %ATCommandFrame{command: command}
      end
    end
  end

  defmodule Set do
    @switches [
      serial_port: :string,
      speed: :integer,
      data_bits: :integer,
      stop_bits: :integer,
      parity: :integer,
      flow_control: :atom
    ]

    @shortdoc "Set AT configuration values."
    @moduledoc """
    #{@shortdoc}

    Device options can either be passed via switches (ex: `--serial-port`) or they'll be read from
    `:exbee` config values

    Switch options include:

    #{
      @switches
      |> Keyword.keys()
      |> Enum.map(&("\n * --" <> (&1 |> to_string() |> String.replace("_", "-"))))
    }

    Examples:

    Set a single AT parameter values:

        > mix exbee.at.query NJ=1 --serial-port COM1 --speed 115200
        NJ: ok

    Set multiple AT parameter values

        > mix exbee.at.query NJ=255 DL='<<0x0, 0x0, 0xFF, 0xFF>>'
        NJ: ok
        DL: ok
    """

    use Mix.Task

    alias Exbee.{ATCommandFrame, Request}

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
    @shortdoc "List available AT configuration options."
    @moduledoc """
    #{@shortdoc}

    Example:

        > mix exbee.at.options
        SL: Serial Number Low
        SM: Sleep Mode
        VR: Firmware Version
    """

    use Mix.Task

    alias Exbee.{ATCommands}

    def run(_args) do
      for {command, description} <- ATCommands.all() do
        IO.puts("#{command}: #{description}")
      end
    end
  end
end
