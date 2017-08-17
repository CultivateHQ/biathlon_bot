defmodule GameStateTest do
  use ExUnit.Case, async: false

  setup do
    GameState.reset
    :ok
  end

  describe "game states" do
    test "start goes to started" do
      GameState.start
      assert GameState.state == :started
      assert GameState.start_secs > 0
      refute GameState.finish_secs
    end

    test "reset goes to unstarted" do
      GameState.start
      assert GameState.state == :started
      GameState.reset
      assert GameState.state == :unstarted

      refute GameState.start_secs
      refute GameState.finish_secs
    end

    test "unstarted game ignores light sensor events" do
      Events.broadcast("light_level_triggers", :triggered)
      assert GameState.state == :unstarted
    end

    test "started game finishes when light sensor triggers" do
      GameState.start
      Events.broadcast("light_level_triggers", :triggered)
      assert GameState.start_secs > 0
      assert GameState.finish_secs >= GameState.start_secs
    end
  end
end
