defmodule Frankt.Mixfile do
  use Mix.Project

  def project do
    [
      app: :frankt,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
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
    ]
  end

  defp package do
    [licenses: ["MIT"],
     files: ~w(lib priv) ++
    ~w(LICENSE mix.exs package.json README.md)]
  end
end
