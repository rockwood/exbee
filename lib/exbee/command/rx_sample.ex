defmodule Exbee.Command.RxSample do
  defstruct [:addr_hi, :addr_lo, :options, :samples, :digital_ch, :analog_ch, :value, type: 92]

  def new(opts \\ []) do
    struct(__MODULE__, opts)
  end
end
