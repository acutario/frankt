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
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Frankt.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix, "~> 1.3.3"},
      {:phoenix_html, "~> 2.10"},
      {:gettext, "~> 0.11", optional: true},
      {:cowboy, "~> 1.0", only: [:dev, :test]},
      {:credo, "~> 0.9.2", only: :dev},
      {:ex_doc, "~> 0.18.1", only: :dev, runtime: false},
      {:phoenix_ecto, "~> 3.3", only: [:dev, :test]},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_active_link, "~> 0.1.1", only: [:dev, :test]}
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
      main: "overview",
      extras: [
        "guides/introduction/overview.md",
        "guides/docs/Concepts.md": [],
        "guides/docs/Client.md": [filename: "Client.md", title: "Client side"],
        "guides/docs/Examples.md": []
      ],
      groups_for_modules: [Testing: [Frankt.ActionTest]],
      groups_for_extras: [
        Introduction: ~r/guides\/introduction\/[^\/]+\.md/,
        Guides: ~r/guides\/docs\/[^\/]+\.md/
      ]
    ]
  end

  # Specifies paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]
end
