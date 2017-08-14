use Mix.Config

config :light_sensor, :trigger_threshold, 275
config :light_sensor, :spi_address, <<0x78, 0x00>>

#
#   import_config "#{Mix.env}.exs"
