defmodule LightSensor.Mixfile do
  use Mix.Project

  def project do
    [
      app: :light_sensor,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {LightSensor.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dummy_nerves, git: "https://github.com/CultivateHQ/dummy_nerves.git", only: [:dev, :test]},
      {:elixir_ale, "~> 1.0", only: :prod},
      {:events, in_umbrella: true},
    ]
  end
end
