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
		|> update_github
		send_resp(conn, 200, "")
	end

	def update_github (%{
		"sourceProvenance" => %{"resolvedRepoSource" => %{"commitSha" => sha}}, 
		"status" => status, 
		"images" => images, 
		"id" => id, 
		"projectId" => project_id
	}) do 		
		info = %{
			sha: sha, 
			context: images |> Enum.at(0) |> String.split(":") |> Enum.at(0),
			target_url: "https://console.cloud.google.com/gcr/builds/#{id}?project=#{project_id}"
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

	def update_github(status, info) when status == "SUCCESS" or status == "FAILURE" or status == "WORKING" do
		Tentacat.Repositories.Statuses.create(
			System.get_env("GITHUB_USER"), 
			System.get_env("GITHUB_REPO"), 
			info.sha,
			%{
				"state": info.status, 
				"target_url": info.target_url, 
				"description": description(status), 
				"context": info.context
				},
			Tentacat.Client.new(%{
				access_token: System.get_env("GITHUB_AUTH")
			})
		)
	end 

	def update_github(_status, _info) do
		:noop
	end
end
