defmodule Wifi.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(WiFi.Initialiser, [wifi_opts()]),
      worker(WiFi.Ntp, [ntp_servers()]),
    ]

    opts = [strategy: :one_for_one, name: Wifi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp wifi_opts() do
    Application.fetch_env!(:wifi, :settings)
  end

  defp ntp_servers do
    Application.fetch_env!(:wifi, :ntp_servers)
  end

end
