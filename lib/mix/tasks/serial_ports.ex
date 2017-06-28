defmodule Mix.Tasks.Exbee.SerialPorts do
  @shortdoc "List available serial ports"
  @moduledoc """
  List available serial ports
  """


  use Mix.Task

  def run(_) do
    for {name, config} <- Exbee.enumerate() do
      IO.puts("#{name} => #{inspect config}")
    end
  end
end
