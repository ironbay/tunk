defmodule Tunk.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
		Tunk.child_spec()
		# Starts a worker by calling: Tunk.Worker.start_link(arg)
      # {Tunk.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tunk.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
