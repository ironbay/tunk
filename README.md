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

Both integrations are options. In `lib/tunk/config`, enable integrations by setting the `enabled` field to `true`: 

```
# lib/tunk/config.ex

slack: %{
	token: nil, 
	channel: nil, 
	enabled: true	
}
```

There are some env variables that need to get set properly:

|name|description|
|--- |---|
GITHUB_AUTH|Github authorization. Needs to have "commit statuses" set.
GITHUB_USER|Github user with authorization|
SLACK_CHANNEL|The name of the slack channel to post statuses. 
SLACK_TOKEN|Slack API token

You can add your own integrations easily. Add them in the same format as slack and github in `lib/tunk/config.ex`. Then 
name your module accoding to the config (i.e. if you add `new` to your config, create a `Tunk.New` module inside of lib. 
To trigger the new module on status updates, update `enabled` to check for the update config (and don't forget to set 
`enabled:true` in the new config. 