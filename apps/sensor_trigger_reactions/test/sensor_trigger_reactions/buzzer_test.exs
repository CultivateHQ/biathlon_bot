defmodule SensorTriggerReactions.BuzzerTest do
  use ExUnit.Case, async: false


  alias SensorTriggerReactions.Buzzer
  alias ElixirALE.GPIO

  test "sets pin to low when triggered" do
    GPIO.write(pin(), 1)
    send(Buzzer, {:event, "light_level_triggers", :triggered})
    :sys.get_state(Buzzer)
    assert 0 == GPIO.read(pin())
  end

  test "sets pin back to high" do
    GPIO.write(pin(), 0)
    send(Buzzer, :stop_buzzing)
    :sys.get_state(Buzzer)
    assert 1 == GPIO.read(pin())
  end

  defp pin do
    pin_number = Application.fetch_env!(:sensor_trigger_reactions, :buzzer_pin)
    :"gpio_#{pin_number}"
  end
end
