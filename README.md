# Tunk

An Elixir app for forwarding Google Cloud Platform build statuses to Slack and Github. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tunk` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tunk, "~> 0.1.0"}
  ]
end
```

The web server runs on port 4000, which can be swapped out in the Dockerfile.

There are some env variables that need to get set properly:

|name|description|
|--- |---|
GITHUB_AUTH|Github authorization. Needs to have "commit statuses" set.
GITHUB_USER|Github user with authorization|
SLACK_CHANNEL|The name of the slack channel to post statuses. 
SLACK_TOKEN|Slack API token

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/tunk](https://hexdocs.pm/tunk).
