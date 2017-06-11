# Exbee

Interface with [Xbee](http://en.wikipedia.org/wiki/XBee) wireless radios in [Elixir](elixir-lang.org).

## Installation

  1. Add `exbee` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:exbee, "~> 0.1.0"}]
    end
    ```

  2. Ensure `exbee` is started before your application:

    ```elixir
    def application do
      [applications: [:exbee]]
    end
    ```

## Usage

Discover attached devices:

    iex> Exbee.Device.enumerate()

    %{
      "COM1" => %{
        description: "USB Serial Port",
        manufacturer: "FTDI",
        product_id: 123,
        vendor_id: 456
      },
      "COM2" => %{...},
      "COM3" => %{...}
    }

Connect to a device:

    iex> Exbee.Device.start_link("COM1")

    {:ok, device_pid}

Receiving:

All Xbee compliant frames are sent to the controlling process (in these examples, the current iex
session).

    iex> flush()

    {:exbee_command, %Exbee.RxSampleFrame{mac_addr: 0000, network_addr: 00000, analog_ch: 0, ...}}

Sending:

    iex> Exbee.send(%Exbee.ATCommandFrame{})

TODO:

  * Rename Command -> Frame
