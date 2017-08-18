defmodule Wifi.NetworkWrapper do
  @moduledoc """
  Responsible for setting up WiFi with `Nerves.Network`.

  Uses `WiFi.Settings` to access the WiFi config in such a way that the SSID and secret can be overwritten
  without having to replace the firmware image.

  By setting up the WiFi in a process we can take the connection down and create a new one when the SSSID
  and secret are changed with `Wifi.set/2`.

  """

  use GenServer
  require Logger

  alias Wifi.Settings

  @name __MODULE__

  @doc """
  The settings file is the one used to store any changed SSID and secret settings.
  """
  def start_link(settings_file) do
    GenServer.start_link(__MODULE__, settings_file, name: @name)
  end

  def init(settings_file) do
    kernel_init()

    wifi_opts = Settings.read_settings(settings_file)

    {:ok, _} = Nerves.Network.setup("wlan0", wifi_opts)
    {:ok, {}}
  end

  # Is this the kind of thing Bootloader is for?
  if Mix.env == :prod do
    defp kernel_init do
      {_, 0} = System.cmd("modprobe", ["brcmfmac"])
      {_, 0} = System.cmd("epmd", ["-daemon"])
      :ok
    end
  else
    defp kernel_init, do: :ok
  end
end
