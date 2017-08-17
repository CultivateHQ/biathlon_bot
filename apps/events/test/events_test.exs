defmodule EventsTest do
  use ExUnit.Case
  doctest Events

  test "subscribing and receiving events" do
    Events.subscribe("laser_hits")

    Events.broadcast("laser_hits", "pweep pweep")
    Events.broadcast("phaser_hits", "phchow pchow")

    assert_receive {:event, "laser_hits", "pweep pweep"}
    refute_receive {:event, "phaser_hits", _}
  end
end
