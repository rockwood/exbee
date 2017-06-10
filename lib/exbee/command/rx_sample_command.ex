defmodule Exbee.RxSampleCommand do
  defstruct [:addr_hi, :addr_lo, :options, :samples, :digital_ch, :analog_ch, :value, id: 0x92]

  def parse(<<0x92, addr_hi::64, addr_lo::16, options::8, samples::8, digital_ch::16, analog_ch::8, value::16>>) do
    {:ok, %__MODULE__{addr_hi: addr_hi, addr_lo: addr_lo, options: options, samples: samples,
                      digital_ch: digital_ch, analog_ch: analog_ch, value: value}}
  end
  def parse(_), do: {:error, "Invalid RxSample frame"}
end
