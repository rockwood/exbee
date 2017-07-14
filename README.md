# Exbee

Communicate with [XBee](http://en.wikipedia.org/wiki/XBee) wireless radios in Elixir.

## Installation

Add `exbee` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:exbee, "~> 0.1.0"}]
end
```

## Usage


Exbee assumes that XBee modules are set to API mode. In API mode, XBee modules send and receive
commands via encoded frames.

### Discover attached serial ports

```elixir
iex> Exbee.serial_ports()
%{
  "COM1" => %{description: "USB Serial", manufacturer: "FTDI", product_id: 1, vendor_id: 2},
  "COM2" => %{...},
  "COM3" => %{...}
}
```

### Start an Exbee process

Frames are sent via the `Exbee.send_frame/2` function. Frames received on the serial port are
reported as messages to the current process. The messages have the form: `{:exbee, frame}`

This example starts an Exbee process and sends an `Exbee.ATCommandFrame` to change the value of
the `NJ` parameter. Upon receiving the command, the XBee module will return an
`Exbee.ATCommandResultFrame` indicating the status of the request.

```elixir
iex> {:ok, pid} = Exbee.start_link(serial_port: "COM1", speed: 9600)
iex> Exbee.send_frame(pid, %Exbee.ATCommandFrame{command: "NJ", value: 1})
:ok

iex> flush()
{:exbee, %Exbee.ATCommandResultFrame{command: "NJ", status: :ok, value: ...}}
```

### Configuration

Exbee options can either be passed directly to `Exbee.start_link/1`, or they'll be read from
`:exbee` config values. For example, to default to a specific serial port, add this to the
project's `config.exs` file.

```elixir
config :exbee,
  serial_port: "COM1"
```

The following options are available:

  * `:serial_port` - The serial interface connected to the Xbee device.
  * `:speed` - (number) set the initial baudrate (e.g., 115200)
  * `:data_bits` - (5, 6, 7, 8) set the number of data bits (usually 8)
  * `:stop_bits` - (1, 2) set the number of stop bits (usually 1)
  * `:parity` - (`:none`, `:even`, `:odd`, `:space`, or `:mark`) set the parity. Usually this is
    `:none`. Other values:
    * `:space` means that the parity bit is always 0
    * `:mark` means that the parity bit is always 1
  * `:flow_control` - (`:none`, `:hardware`, or `:software`) set the flow control strategy.

## Mix Tasks

  * `mix exbee.serial_ports` - List available serial ports
  * `mix exbee.at.options` - List available configuration options
  * `mix exbee.at.query` - Query configuration values. Options: [command --serial-port]
  * `mix exbee.at.set` - Set a configuration value. Options: [command=value --serial-port]

## License

This software is licensed under the [Apache 2 License](LICENSE).
