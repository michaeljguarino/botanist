defmodule Botanist.MixProject do
  use Mix.Project

  def project do
    [
      app: :botanist,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "",
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [
      applications: applications(Mix.env())
    ]
  end

  defp package() do
    [
      name: "botanist",
      licenses: [],
      maintainers: [],
      links: %{}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_all), do: ["lib"]

  defp applications(:test), do: [:ecto, :postgrex]
  defp applications(_all), do: []

  defp deps do
    [
      {:ecto, "~> 2.2.10"},
      {:ex_doc, "~> 0.18.3"},
      {:postgrex, "~> 0.11", only: [:test]},
      {:junit_formatter, "~> 2.2", only: [:test]},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end
