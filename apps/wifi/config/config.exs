use Mix.Config

config :wifi, :ntp_servers, []

config :wifi, :settings_file, "/root/wifi.txt"

import_config "config.secret.exs"
import_config "#{Mix.env}.exs"
