defmodule WiFi.Initialiser do
  use GenServer

  @name __MODULE__

  def start_link(wifi_opts) do
    GenServer.start_link(__MODULE__, wifi_opts, name: @name)
  end

  def init(wifi_opts) do
    kernel_init()
    {:ok, _} = Nerves.Network.setup("wlan0", wifi_opts)
    {:ok, {}}
  end

  # Is this the kind of thing Bootloader is for?
  if Mix.env == :prod do
    defp kernel_init do
      {_, 0} = System.cmd("modprobe", ["brcmfmac"])
      :ok
    end
  else
    defp kernel_init, do: :ok
  end
end
