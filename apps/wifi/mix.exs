defmodule Wifi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wifi,
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
      mod: {Wifi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves_network, "~> 0.3", only: :prod},
      {:dummy_nerves, path: "../../../dummy_nerves", only: [:dev, :test]}, # replace with git / hex link
    ]
  end
end
