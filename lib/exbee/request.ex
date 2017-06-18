defmodule Exbee.Request do
  @frame_timeout 2_000

  alias Exbee.Device
  require Logger

  def run(request_frames, device_args \\ []) do
    total_timeout = length(request_frames) * @frame_timeout
    task = Task.async(fn -> do_run(request_frames, device_args) end)

    case Task.await(task, total_timeout + @frame_timeout) do
      {:ok, results} -> {:ok, results}
      _ -> {:error, "Failed to receive all frames within #{total_timeout}ms"}
    end
  end

  defp do_run(request_frames, device_args) do
    {:ok, device} = Device.start_link(device_args)

    results = Enum.map request_frames, fn(frame) ->
      {frame, send_frame(device, frame)}
    end

    :ok = Device.stop(device)

    {:ok, results}
  end

  defp send_frame(device, {frame, response_count}), do: send_frame(device, frame, response_count)
  defp send_frame(device, frame, response_count \\ 1) do
    :ok = Device.send_frame(device, frame)
    receive_frames([], response_count)
  end

  defp receive_frames(results, count) when count <= 0, do: results
  defp receive_frames(results, count) do
    receive do
      {:exbee, frame} -> receive_frames([frame | results], count - 1)
      _ -> receive_frames(results, count)
    after
      @frame_timeout ->
        Logger.warn("Failed to receive response frame within #{@frame_timeout}ms")
        results
    end
  end
end
