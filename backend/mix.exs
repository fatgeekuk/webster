defmodule WebsterUmbrella.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: Coverex.Task, output: "/tmp/coverage/backend"]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:coverex, "~> 1.4.10", only: :test},
      {:ssl_verify_fun, "~> 1.1"}
    ]
  end
end
