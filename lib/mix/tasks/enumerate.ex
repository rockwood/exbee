defmodule Mix.Tasks.Exbee.Enumerate do
  use Mix.Task

  def run(_) do
    IO.inspect(Exbee.Device.enumerate())
  end
end
