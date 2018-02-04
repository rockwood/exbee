defmodule Mix.Tasks.Exbee.SerialPorts do
  @shortdoc "List available serial ports"
  @moduledoc """
  #{@shortdoc}
  """

  use Mix.Task

  def run(_) do
    for {name, config} <- Exbee.serial_ports() do
      IO.puts("#{name} => #{inspect(config)}")
    end
  end
end
