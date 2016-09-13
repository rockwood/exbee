defmodule Exbee.RealAdapter do
  alias Nerves.UART
  alias Exbee.Commands

  @timeout 2_000

  defdelegate enumerate_devices, to: UART, as: :enumerate
  defdelegate start_link, to: UART
  defdelegate open(pid, device, opts), to: UART

  def ping(pid) do
    enter_command_mode(pid)
  end

  def get_config(pid) do
    :ok = enter_command_mode(pid)

    config = Enum.reduce(Commands.all, %{}, fn({key, command}, acc) ->
      {:ok, value} = write(pid, "#{command}\r")
      Map.put(acc, key, value)
    end)

    {:ok, config}
  end

  defp write(pid, command) do
    :ok = UART.write(pid, "#{command}")
    {:ok, response} = UART.read(pid, @timeout)
    {:ok, String.replace(response, "\r", "")}
  end

  defp enter_command_mode(pid) do
    case write(pid, "+++") do
      {:ok, "OK"} -> :ok
      {:ok, ""} -> :error
    end
  end
end
