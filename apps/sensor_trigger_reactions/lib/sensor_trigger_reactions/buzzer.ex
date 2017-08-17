defmodule SensorTriggerReactions.Buzzer do
  use GenServer

  @name __MODULE__

  alias ElixirALE.GPIO

  @buzz_for 750

  def start_link(buzzer_pin) do
    GenServer.start_link(__MODULE__, buzzer_pin, name: @name)
  end

  def init(buzzer_pin) do
    {:ok, pid} = GPIO.start_link(buzzer_pin, :output)

    GPIO.write(pid, 1)

    Events.subscribe(:light_level_triggers)
    {:ok, pid}
  end

  def handle_info({:event, :light_level_triggers, :triggered}, pin_pid) do
    GPIO.write(pin_pid, 0)
    Process.send_after(self(), :stop_buzzing, @buzz_for)
    {:noreply, pin_pid}
  end
  def handle_info({:event, :light_level_triggers, _}, pin_pid), do: {:noreply, pin_pid}

  def handle_info(:stop_buzzing, pin_pid) do
    GPIO.write(pin_pid, 1)
    {:noreply, pin_pid}
  end
end
