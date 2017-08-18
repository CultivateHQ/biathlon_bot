defmodule BiathlonBot.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:credo, "~> 0.8.6", only: [:dev, :test]},
      {:dialyxir, "~> 0.5.1", only: [:dev, :test]},
    ]
  end
end
