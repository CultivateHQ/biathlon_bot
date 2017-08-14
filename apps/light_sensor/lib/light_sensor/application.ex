defmodule LightSensor.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(ElixirALE.SPI, ["spidev0.0", [], [name: ElixirALE.SPI]]),
      worker(LightSensor.LightLevelMonitor, [trigger_threshold(), spi_address()])
    ]

    opts = [strategy: :one_for_one, name: LightSensor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp trigger_threshold do
    Application.fetch_env!(:light_sensor, :trigger_threshold)
  end

  defp spi_address do
    Application.fetch_env!(:light_sensor, :spi_address)
  end
end
