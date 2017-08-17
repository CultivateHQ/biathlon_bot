defmodule SensorTriggerReactions.Mixfile do
  use Mix.Project

  def project do
    [
      app: :sensor_trigger_reactions,
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
      mod: {SensorTriggerReactions.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:events, in_umbrella: true},
      {:dummy_nerves, path: "../../../dummy_nerves", only: [:dev, :test]}, # replace with git / hex link
    ]
  end
end
