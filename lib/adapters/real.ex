defmodule Exbee.RealAdapter do
  alias Nerves.UART

  @timeout 10_000

  defdelegate enumerate_devices, to: UART, as: :enumerate
  defdelegate start_link, to: UART
  defdelegate open(pid, device, opts), to: UART

  def ping(pid) do
    enter_command_mode(pid)
  end

  def get_pan_id(pid) do
    :ok = enter_command_mode(pid)
    write_command(pid, "ATID")
    read_response(pid)
  end

  defp read_response(pid) do
    {:ok, response} = UART.read(pid, @timeout)
    {:ok, String.replace(response, "\r", "")}
  end

  defp write_command(pid, command) do
    UART.write(pid, "#{command}\r")
  end

  defp enter_command_mode(pid) do
    :ok = UART.write(pid, "+++")
    case read_response(pid) do
      {:ok, "OK"} -> :ok
      {:ok, ""} -> :error
    end
  end
end
