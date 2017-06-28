defmodule Exbee.Adapter do
  @moduledoc """
  Interface to a serial connection.
  """

  @type adapter_option ::
    {:speed, non_neg_integer} |
    {:data_bits, 5..8} |
    {:stop_bits, 1..2} |
    {:parity, :none | :even | :odd | :space | :mark} |
    {:flow_control, :none | :hardware | :software}

  @callback enumerate() :: map
  @callback start_link() :: {:ok, pid} | {:error, term}
  @callback open(pid, binary, [adapter_option]) :: :ok | {:error, term}
  @callback write(pid, binary | [byte]) :: :ok | {:error, term}
  @callback stop(pid) :: :ok | {:error, term}
end
