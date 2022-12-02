defmodule Botanist.MixProject do
  use Mix.Project

  @version "0.1.4"

  def project do
    [
      app: :botanist,
      version: @version,
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
      applications: applications(Mix.env()),
      extra_applications: [:logger, :eex]
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
      {:ecto, "~> 3.9.2"},
      {:ecto_sql, "~> 3.9.1"},

      # Test
      {:postgrex, ">= 0.0.0", only: [:test]},
      {:junit_formatter, "~> 2.2", only: [:test]},
      {:mock, "~> 0.3.7", only: :test},

      # Docs
      {:ex_doc, "~> 0.29.1", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "Botanist",
      source_url: "https://github.com/homee-engineering/botanist",
      canonical: "http://hexdocs.pm/botanist"
    ]
  end
end
