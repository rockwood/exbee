defmodule Mix.Tasks.Exbee.SerialPorts do
  @moduledoc """
  List available serial ports
  """

  use Mix.Task

  def run(_) do
    for {name, config} <- Exbee.Device.enumerate() do
      IO.puts("#{name} => #{inspect config}")
    end
  end
end
