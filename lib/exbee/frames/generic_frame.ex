defmodule Exbee.GenericFrame do
  defstruct [:type, :payload]

  def decode(<<type::8, payload::binary>>) do
    {:ok, %__MODULE__{type: type, payload: payload}}
  end
end
