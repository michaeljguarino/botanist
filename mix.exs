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
      description: "A run-once database seeder using Ecto",
      elixirc_paths: elixirc_paths(Mix.env()),
      docs: docs()
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
      maintainers: ["Hutch Interiors Inc."],
      links: %{
        "GitHub" => "https://github.com/homee-engineering/botanist"
      }
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_all), do: ["lib"]

  defp applications(:test), do: [:ecto, :postgrex]
  defp applications(_all), do: []

  defp deps do
    [
      {:ecto, "~> 2.2.10"},

      # Test
      {:postgrex, "~> 0.11", only: [:test]},
      {:junit_formatter, "~> 2.2", only: [:test]},
      {:mock, "~> 0.3.0", only: :test},

      # Docs
      {:ex_doc, "~> 0.18.3"}
    ]
  end

  defp docs do
    [
      main: "Botanist",
      source_url: "https://github.com/elixir-ecto/ecto",
    ]
  end
end
