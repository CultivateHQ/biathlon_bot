use Mix.Config

config :wifi, :ntp_servers, []
import_config "config.secret.exs"
import_config "#{Mix.env}.exs"
