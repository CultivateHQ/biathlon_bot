defmodule LightSensor.LightLevelMonitorTest do
  use ExUnit.Case, async: false

  alias LightSensor.LightLevelMonitor
  alias ElixirALE.SPI


  setup do
    SPI.set_transfer_answer(SPI, << 0::size(16)>>)
    send(LightLevelMonitor, :read)
    :sys.get_state(LightLevelMonitor)
    Events.subscribe(:light_level_triggers)
    :ok
  end

  describe "triggering" do

    test "sends triggered event" do
      SPI.set_transfer_answer(SPI, << 0::size(6), trigger_threshold()::size(10)>>)
      send(LightLevelMonitor, :read)
      assert_receive {:event, :light_level_triggers, :triggered}
    end

    test "sends only one triggered event" do
      SPI.set_transfer_answer(SPI, << 0::size(6), trigger_threshold()::size(10)>>)
      send(LightLevelMonitor, :read)
      send(LightLevelMonitor, :read)
      assert_receive {:event, :light_level_triggers, :triggered}
      refute_receive {:event, :light_level_triggers, :triggered}
    end
  end

  describe "retriggering" do
    test "untriggers and triggers again" do
      SPI.set_transfer_answer(SPI, << 0::size(6), trigger_threshold()::size(10)>>)
      send(LightLevelMonitor, :read)
      assert_receive {:event, :light_level_triggers, :triggered}

      SPI.set_transfer_answer(SPI, << 0::size(6), (trigger_threshold() - 1)::size(10)>>)
      send(LightLevelMonitor, :read)
      assert_receive {:event, :light_level_triggers, :untriggered}

      SPI.set_transfer_answer(SPI, << 0::size(6), trigger_threshold()::size(10)>>)
      send(LightLevelMonitor, :read)
      assert_receive {:event, :light_level_triggers, :triggered}
    end
  end

  defp trigger_threshold do
    Application.fetch_env!(:light_sensor, :trigger_threshold)
  end

end
