defmodule Exbee.RequestTest do
  use Exbee.TestCase
  alias Exbee.{Request, FakeAdapter}

  setup do
    FakeAdapter.MessageQueue.start_link()
    :ok
  end

  describe "run/1" do
    setup do
      FakeAdapter.MessageQueue.enqueue([<<0x7E, 0x00, 0x03, 0x01, 0x02, 0x03, 0xF9>>])
      request_frames = [%Exbee.GenericFrame{type: 1, payload: <<0x00>>}]
      {:ok, results} = Request.run(request_frames, adapter: FakeAdapter)
      {:ok, results: results}
    end

    test "returns one result for each request frame", %{results: results} do
      assert [%Exbee.GenericFrame{type: 0x01, payload: <<0x02, 0x03>>}] = results
    end
  end
end
