defmodule Tunk.Mixfile do
  use Mix.Project

  def project do
    [
      app: :tunk,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
	  deps: deps(), 
	  elixirc_paths: ["lib"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Tunk.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
			{:cowboy, "~> 1.0.0"},
			{:plug, "~> 0.12"},
			{:poison, "~> 3.1"}, 
			{:dynamic_ex, github: "ironbay/dynamic_ex"},
			{:fig, github: "ironbay/fig"},
			{:httpoison, "~> 0.13"},
			{:tentacat, "~> 0.5"}, 
			{:distillery, "~> 1.4", runtime: false},
			{:slack, "~> 0.12.0"}, 
    ]
  end
end
