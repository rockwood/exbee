defmodule Exbee.RxGenericCommand do
  defstruct [:id, :payload]

  def parse(<<id::8, payload::binary>>) do
    {:ok, %__MODULE__{id: id, payload: payload}}
  end
end
