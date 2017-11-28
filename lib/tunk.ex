defmodule Tunk.Router do
	use Plug.Router
	require Logger

	plug :match 
	plug :dispatch

	def init(options), do: options

	def start_link() do
		{:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, []
	end

	post "/gcp/message" do
		{:ok, body , _} = Plug.Conn.read_body(conn)
		body 
		|> Poison.decode!
		|> Dynamic.get(["message", "data"])
		|> Base.decode64!
		|> Poison.decode!
		|> IO.inspect
		|> process
		send_resp(conn, 200, "")
	end

	def process (%{
		"sourceProvenance" => %{"resolvedRepoSource" => %{"commitSha" => sha, "repoName" => repo}}, 
		"status" => status, 
		"images" => images, 
		"id" => id, 
		"projectId" => project_id
	}) do 		
		info = %{
			sha: sha, 
			context: images |> Enum.at(0) |> String.split(":") |> Enum.at(0),
			target_url: "https://console.cloud.google.com/gcr/builds/#{id}?project=#{project_id}", 
			repo: repo |> String.split("-") |> Enum.at(1)
		}

		case status do
			"SUCCESS" -> update_github("success", info)
			"FAILURE" -> update_github("failure", info)
			"WORKING" -> update_github("pending", info)
			_ -> :noop
		end
	end 

	def description(status) do
		case status do
			"success" -> "Build succeeded" 
			"failure" -> "Build failed."
			"pending" -> "Build in progress."
		end
	end

	def update_github(status, info) when status == "success" or status == "failure" or status == "pending" do
		Tentacat.Repositories.Statuses.create(
			Tunk.Config.github_user(), 
			info.repo, 
			info.sha,
			%{
				"state": status, 
				"target_url": info.target_url, 
				"description": description(status), 
				"context": info.context
				},
			Tentacat.Client.new(%{
				access_token: Tunk.Config.github_auth()
			})
		)
	end 

	def update_github(status, _info) do
		IO.inspect status
		:noop
	end
end
