defmodule PlugTimeout.MixProject do
  use Mix.Project
  @version "0.1.0"

  def project do
    [
      app: :plug_timeout,
      version: @version,
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      description: description(),
      source_url: github_url()
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:plug, ">= 0.0.0"}
    ]
  end

  defp github_url do
    "https://github.com/smartepsh/plug_timeout.git"
  end

  defp description do
    "A plug to set timeout for each action"
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"Github" => github_url()}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: github_url(),
      source_ref: "v#{@version}",
      extras: ["README.md", "LICENSE"]
    ]
  end
end
