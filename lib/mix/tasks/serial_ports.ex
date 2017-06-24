defmodule Mix.Tasks.Exbee.SerialPorts do
  use Mix.Task

  @shortdoc "List available serial ports"

  def run(_) do
    for {name, config} <- Exbee.Device.enumerate() do
      IO.puts("#{name} => #{inspect config}")
    end
  end
end
