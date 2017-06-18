defmodule Exbee.RequestTest do
  use Exbee.IntegrationCase
  alias Exbee.Request

  test "run" do
    {:ok, [frame]} = Request([%Exbee.ATCommandFrame{command: "NJ"}])
    assert frame
  end
end
