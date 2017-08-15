use Mix.Config

# import_config "#{Mix.Project.config[:target]}.exs"

# main_app = Applica

if Mix.env == :prod do
  config :bootloader,
    init: [:nerves_runtime],
    app: Mix.Project.config()[:app]
end
