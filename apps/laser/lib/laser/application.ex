defmodule Laser.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Laser.LaserControl, [laser_pin(), laser_fire_duration()]),
    ]

    opts = [strategy: :one_for_one, name: Laser.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp laser_pin() do
    Application.fetch_env!(:laser, :laser_pin)
  end

  defp laser_fire_duration() do
    Application.fetch_env!(:laser, :laser_fire_duration)
  end
end
