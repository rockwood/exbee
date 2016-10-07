defmodule Exbee.Command do
  def parse(<<0x7E, length :: size(16), frame_and_checksum :: binary >>) do
    <<frame :: binary-size(length), _checksum :: binary-size(1)>> = frame_and_checksum
    parse_frame(frame)
  end

  defp parse_frame(<<0x92, addr_hi :: size(64), addr_lo :: size(16), options :: size(8),
    samples :: size(8), digital_ch :: size(16), analog_ch :: size(8), value :: size(16)>>) do
    Exbee.Command.RxSample.new(
      addr_hi: addr_hi,
      addr_lo: addr_lo,
      options: options,
      samples: samples,
      digital_ch: digital_ch,
      analog_ch: analog_ch,
      value: value,
    )
  end
end
