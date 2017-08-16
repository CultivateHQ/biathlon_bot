defmodule Wifi do
  @moduledoc """
  Documentation for Wifi.
  """

  alias Wifi.{Settings, NetworkWrapperSupervisor, NetworkWrapper}

  def set(ssid, secret) do
    Settings.set(settings_file(), {ssid, secret})
    Supervisor.terminate_child(NetworkWrapperSupervisor, NetworkWrapper)
    {:ok, _pid} =  Supervisor.restart_child(NetworkWrapperSupervisor, NetworkWrapper)
  end

  def settings_file() do
    Application.fetch_env!(:wifi, :settings_file)
  end
end
