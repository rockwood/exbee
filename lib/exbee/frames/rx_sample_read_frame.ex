defmodule Exbee.RxSampleReadFrame do
  @moduledoc """
  Received when a device reads a remote I/O sample.
  """

  @type t :: %__MODULE__{mac_addr: binary, network_addr: binary, options: atom, samples: binary,
                         digital_ch: binary, analog_ch: binary, value: binary}
  defstruct [:mac_addr, :network_addr, :options, :samples, :digital_ch, :analog_ch, :value]

  defimpl Exbee.FrameDecoder do
    @options %{
      0x01 => :acknowledged,
      0x02 => :broadcast
    }

    def decode(frame, <<0x92, mac_addr::64, network_addr::16, options::8, samples::8,
                        digital_ch::16, analog_ch::8, value::16>>) do
      {:ok, %{frame | mac_addr: mac_addr, network_addr: network_addr, options: @options[options],
                      samples: samples, digital_ch: digital_ch, analog_ch: analog_ch, value: value}}
    end
  end
end
