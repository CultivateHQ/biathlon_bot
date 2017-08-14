defmodule SensorTriggerReactions.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(SensorTriggerReactions.Buzzer, [buzzer_pin()]),
    ]

    opts = [strategy: :one_for_one, name: SensorTriggerReactions.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp buzzer_pin() do
    Application.fetch_env!(:sensor_trigger_reactions, :buzzer_pin)
  end
end
