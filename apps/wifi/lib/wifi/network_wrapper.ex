defmodule Wifi.NetworkWrapper do
  use GenServer
  require Logger

  alias Wifi.Settings

  @name __MODULE__

  def start_link(settings_file) do
    GenServer.start_link(__MODULE__, settings_file, name: @name)
  end

  def init(settings_file) do
    kernel_init()

    wifi_opts = Settings.read_settings(settings_file)

    Logger.debug "Starting WiFi with #{inspect(wifi_opts)}"


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
