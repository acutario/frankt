defmodule Frankt.Mixfile do
  use Mix.Project

  def project do
    [
      app: :frankt,
      name: "Frankt",
      version: "0.1.0",
      elixir: "~> 1.5",
      source_url: "https://github.com/acutario/frankt",
      homepage_url: "https://github.com/acutario/frankt",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
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
      {:gettext, "~> 0.13", optional: true},
      {:ex_doc, "~> 0.18.1", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      files: ~w(lib priv LICENSE mix.exs package.json README.md)
    ]
  end

  # Run "mix help docs" to learn about documentation.
  defp docs do
    [
      extras: [
        "README.md": [filename: "README.md", title: "Introduction"],
        "guides/Concepts.md": [],
        "guides/Examples.md": []
      ],
      main: "README.md"
    ]
  end
end
