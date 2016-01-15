defmodule Polyglot.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [app: :polyglot,
     version: @version,
     elixir: "~> 1.2",
     deps: deps,
     package: package,
     description: description,
     docs: docs
    ]
  end

  def application do
    []
  end

  defp deps do
    [{:ex_doc, "~> 0.11", only: :dev}]
  end

  defp package do
    [licenses: ["MIT", "UNICODE License"],
     maintainers: ["Patrick Oscity"],
     links: %{github: "https://github.com/padde/polyglot"]
  end

  defp docs do
    [main: "Polyglot",
     source_ref: "v#{@version}",
     source_url: "https://github.com/padde/polyglot"]
  end

  defp description do
    """
    Polyglot is a localization library for Elixir that provides reusable
    formatting rules and translations for a large number of languages.
    """
  end
end
