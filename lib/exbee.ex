defmodule Exbee do
  @current_adapter Application.get_env(:exbee, :adapter)

  @moduledoc """
  Interface with [Xbee](en.wikipedia.org/wiki/XBee) wireless radios in [Elixir](elixir-lang.org).
  """

  @doc """
  Return a map of available serial devices with information about each.

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

  Depending on the device and the operating system, not all fields may be returned.

  fields are:

  * `:vendor_id` - The 16-bit USB vendor ID of the device providing the port. Vendor ID to name lists are managed through usb.org
  * `:product_id` - The 16-bit vendor supplied product ID
  * `:manufacturer` - The manufacturer of the port
  * `:description` - A description or product name
  * `:serial_number` - The device's serial number if it has one
  """
  defdelegate enumerate, to: @current_adapter
  defdelegate start_link, to: @current_adapter
  defdelegate open(pid, device, opts), to: @current_adapter
end
