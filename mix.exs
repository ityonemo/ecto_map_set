defmodule EctoMapSet.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_map_set,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      preferred_cli_env: [
        "ecto.create": :test,
        "ecto.migrate": :test,
        "ecto.drop": :test,
        "ecto.gen.migration": :test
      ],
      source_url: "https://github.com/ityonemo/ecto_map_set",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.6"},
      {:plug_crypto, ">= 0.0.0", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:ecto_sql, "~> 3.6", only: :test},
      {:postgrex, ">= 0.0.0", only: :test},
      {:elixir_uuid, ">= 0.0.0", only: :test},
      {:jason, ">= 0.0.0", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package, do: [
    name: "ecto_map_set",
    licenses: ["MIT"],
    links: %{"GitHub" => "https://github.com/ityonemo/ecto_map_set"},
    description: "MapSet support for ecto"
  ]

  def docs, do: [
      main: "EctoMapSet",
      source_url: "https://github.com/ityonemo/ecto_map_set"
    ]

end
