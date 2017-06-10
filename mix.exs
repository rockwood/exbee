defmodule Exbee.Mixfile do
  use Mix.Project

  def project do
    [app: :exbee,
     version: "0.1.0",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :nerves_uart]]
  end

  defp deps do
    [
      {:nerves_uart, "~> 0.1.2"},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]
end
