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
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env())
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
      {:phoenix, "~> 1.3"},
      {:gettext, "~> 0.13", optional: true},
      {:ex_doc, "~> 0.18.1", only: :dev, runtime: false},
      {:credo, "~> 0.9.2", only: :dev}
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
      logo: "logo.png",
      extras: [
        "README.md": [filename: "README.md", title: "Introduction"],
        "guides/Concepts.md": [],
        "guides/Client.md": [filename: "Client.md", title: "Client side"],
        "guides/Examples.md": []
      ],
      groups_for_modules: [Testing: [Frankt.ActionTest]],
      main: "README.md"
    ]
  end

  # Specifies paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]
end
