defmodule LocalEventsTest do
  use ExUnit.Case
  doctest LocalEvents

  test "subscribing and receiving events" do
    LocalEvents.subscribe(:laser_hits)

    LocalEvents.broadcast(:laser_hits, "pweep pweep")
    LocalEvents.broadcast(:phaser_hits, "phchow pchow")

    assert_receive {:local_event, :laser_hits, "pweep pweep"}
    refute_receive {:local_event, :phaser_hits, _}
  end
end
