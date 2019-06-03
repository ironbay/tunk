defmodule Tunk do
  require Logger
  alias Tunk.Github
  alias Tunk.Config

  def tick() do
    {:ok, token} = Gondola.for_scope("https://www.googleapis.com/auth/cloud-platform")
    conn = GoogleApi.PubSub.V1.Connection.new(token.access_token)

    {:ok, response} =
      GoogleApi.PubSub.V1.Api.Projects.pubsub_projects_subscriptions_pull(
        conn,
        Config.tunk_google_project(),
        Config.tunk_google_subscription(),
        body: %GoogleApi.PubSub.V1.Model.PullRequest{
          maxMessages: 10
        }
      )

    if response.receivedMessages != nil do
      Enum.each(response.receivedMessages, fn message ->
        process(message.message.data)

        GoogleApi.PubSub.V1.Api.Projects.pubsub_projects_subscriptions_acknowledge(
          conn,
          Config.tunk_google_project(),
          Config.tunk_google_subscription(),
          body: %GoogleApi.PubSub.V1.Model.AcknowledgeRequest{
            ackIds: [message.ackId]
          }
        )
      end)
    end
  end

  def process(body) do
    body
    |> Base.decode64!()
    |> Poison.decode!()
    |> IO.inspect()
    |> extract
    |> case do
      :noop -> :noop
      message -> broadcast(message)
    end
  end

  def get_data_field(body) do
    body
    |> Poison.decode!()
    |> Dynamic.get(["message", "data"])
  end

  def extract(message) do
    case message do
      %{
        "sourceProvenance" => %{
          "resolvedRepoSource" => %{"commitSha" => sha, "repoName" => repo}
        },
        "status" => status,
        "id" => id,
        "projectId" => project_id,
        "source" => %{
          "repoSource" => %{
            "branchName" => branch
          }
        }
      } ->
        splits =
          case String.contains?(repo, "_") do
            true ->
              String.split(repo, "_")

            false ->
              String.split(repo, "-")
          end

        [_, owner | rest] = splits

        %{
          sha: sha,
          context: "",
          target_url: "https://console.cloud.google.com/gcr/builds/#{id}?project=#{project_id}",
          repo: rest |> Enum.join("-"),
          owner: owner,
          status: translate(status),
          branch: branch,
          images: []
        }

      _ ->
        :noop
    end
  end

  def enabled do
    [
      if(Config.tunk_slack_enabled(), do: Tunk.Slack, else: nil),
      if(Config.tunk_github_enabled(), do: Tunk.Github, else: nil)
    ]
    |> Enum.filter(&(&1 !== nil))
  end

  def broadcast(info) do
    enabled()
    |> Enum.each(fn x -> x.send(info) end)
  end

  def translate(status) do
    case status do
      "SUCCESS" -> String.downcase(status)
      "FAILURE" -> String.downcase(status)
      "WORKING" -> "pending"
      _ -> :noop
    end
  end
end
