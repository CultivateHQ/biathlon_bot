defmodule LightSensor.LightLevelMonitor do
  use GenServer

  alias ElixirALE.SPI

  @name __MODULE__

  @read_interval 120

  @enforce_keys [:trigger_threshold, :spi_address]
  defstruct trigger_threshold: nil, spi_address: nil, triggered: false

  def start_link(trigger_threshold, spi_address) do
    GenServer.start_link(__MODULE__, {trigger_threshold, spi_address}, name: @name)
  end

  def init({trigger_threshold, spi_address}) do
    send(self(), :read)
    {:ok, %__MODULE__{trigger_threshold: trigger_threshold, spi_address: spi_address}}
  end

  def handle_info(:read, s = %{spi_address: spi_address,
                               trigger_threshold: trigger_threshold,
                               triggered: already_triggered}) do

    triggered = read(spi_address) >= trigger_threshold
    alert_if_needed(already_triggered, triggered)
    Process.send_after(self(), :read, @read_interval)
    {:noreply, %{s | triggered: triggered}}
  end

  defp alert_if_needed(false, true), do: LocalEvents.broadcast(:light_level_triggers, :triggered)
  defp alert_if_needed(true, false), do: LocalEvents.broadcast(:light_level_triggers, :untriggered)
  defp alert_if_needed(_, _), do: nil


  defp read(spi_address) do
    SPI
    |> SPI.transfer(spi_address)
    |> lower_10_bits()
  end

  defp lower_10_bits(<<_::size(6), counts::size(10)>>), do: counts
end
