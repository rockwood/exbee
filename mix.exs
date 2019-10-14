defmodule Exbee.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exbee,
      description: "Communicate with XBee wireless radios in Elixir",
      version: "0.0.5",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/rockwood/exbee",
      deps: deps(),
      package: package(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      dialyzer: [
        ignore_warnings: ".dialyzer-ignore-warnings",
        plt_add_apps: [:mix]
      ]
    ]
  end

  def application do
    [applications: [:logger, :nerves_uart]]
  end

  defp deps do
    [
      {:nerves_uart, "~> 1.1.0"},
      {:ex_doc, "~> 0.14", only: :dev},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      name: :exbee,
      maintainers: ["Kevin Rockwood"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/rockwood/exbee"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
