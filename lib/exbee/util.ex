defmodule Exbee.Util do
  def to_binary(value) when is_binary(value), do: value
  def to_binary(value) when is_integer(value), do: <<value>>
end
