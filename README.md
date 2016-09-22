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

    iex> Exbee.enumerate_devices

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

