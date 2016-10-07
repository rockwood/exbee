defmodule Exbee.Configuration do
  alias Exbee.Device

  @params %{
    pan_id: "ATID",
    my_id: "ATMY",
    node_id: "ATNI",
    scan_channels: "ATSC",
    scan_duration: "ATSD",
    stack_profile: "ATZS",
    node_join_time: "ATNJ",
    network_timeout: "ATNW",
    channel: "ATCH",
    serial_high: "ATSH",
    serial_low: "ATSL",
    destination_high: "ATDH",
    destination_low: "ATDL",
    power_level: "ATPL",
    power_mode: "ATPM",
    encryption_enabled: "ATEE",
    encryption_options: "ATEO",
    encryption_key: "ATKY",
    baud_rate: "ATBD",
    parity: "ATNB",
    stop_bits: "ATSB",
    packetization_timeout: "ATRO",
    sleep_mode: "ATSM",
    sleep_cycles: "ATSN",
    sleep_options: "ATSO",
    sleep_period: "ATSP",
    sleep_delay: "ATST",
    poll_rate: "ATPO",
    io_d0: "ATD0",
    io_d1: "ATD1",
    io_d2: "ATD2",
    io_d3: "ATD3",
    io_d4: "ATD4",
    io_d5: "ATD5",
    io_pwm0: "ATP0",
    io_d11: "ATP1",
    io_d12: "ATP2",
    io_pull_up_resistor: "ATPR",
    io_led_blink_time: "ATLT",
    io_pwm_timer: "ATRP",
    io_device_options: "ATDO",
    io_sampling_rate: "ATIR",
    io_change_detection: "ATIC",
    io_voltage_threshold: "ATV+",
    firmware_version: "ATVR",
    hardware_version: "ATHV",
    association_indication: "ATAI",
    supply_voltage: "AT%V"
  }

  def get(pid) do
    Device.enter_command_mode(pid)
    config = @params
    |> Map.keys
    |> Enum.reduce(%{}, fn(key, acc) ->
      case get(pid, key) do
        {:ok, value} -> Map.put(acc, key, value)
        {:error, _} -> acc
      end
    end)

    {:ok, config}
  end
  def get(pid, key) do
    Device.write(pid, "#{@params[key]}\r")
  end
end
