defmodule Tunk.Mixfile do
  use Mix.Project

  def project do
    [
      app: :tunk,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
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
		{:plug_cowboy2, github: "voicelayer/plug_cowboy2"},
		{:ranch, github: "ninenines/ranch", ref: "1.3.0", override: true, manager: :rebar3},
		{:cowlib, github: "ninenines/cowlib", ref: "master", override: true, manager: :rebar3},
		{:plug, "~> 1.3.0"},
	{:cowboy, github: "ninenines/cowboy", ref: "2.0.0-pre.7", override: true, manager: :rebar3},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
