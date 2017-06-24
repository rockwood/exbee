defmodule Exbee.Request do
  @default_frame_timeout 2_000

  alias Exbee.Device
  require Logger

  def run(request_frames, device_args \\ [], frame_timeout \\ @default_frame_timeout) do
    total_timeout = length(request_frames) * frame_timeout
    task = Task.async(fn -> do_run(request_frames, device_args, frame_timeout) end)

    case Task.await(task, total_timeout + frame_timeout) do
      {:ok, results} -> {:ok, results}
      _ -> {:error, "Failed to receive all frames within #{total_timeout}ms"}
    end
  end

  defp do_run(request_frames, device_args, frame_timeout) do
    {:ok, device} = Device.start_link(device_args)

    results = Enum.flat_map request_frames, fn(request_frame) ->
      Device.send_frame(device, request_frame)

      case receive_frame(frame_timeout) do
        {:ok, response_frame} ->
          [response_frame]
        {:error, reason} ->
          Logger.warn("#{reason} (#{inspect request_frame})")
          []
      end
    end

    :ok = Device.stop(device)

    {:ok, results}
  end

  defp receive_frame(timeout) do
    receive do
      {:exbee, response_frame} -> {:ok, response_frame}
      _ -> receive_frame(timeout)
    after
      timeout ->
        {:error, "Failed to receive response frame within #{timeout}ms"}
    end
  end
end
