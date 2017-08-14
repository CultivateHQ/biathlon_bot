defmodule WiFi.Initialiser do
  use GenServer

  @name __MODULE__

  def start_link(wifi_opts) do
    GenServer.start_link(__MODULE__, wifi_opts, name: @name)
  end

  def init(wifi_opts) do
    {_, 0} = System.cmd("modprobe", ["brcmfmac"])
    {:ok, _} = Nerves.Network.setup("wlan0", wifi_opts)
    {:ok, {}}
  end

end
