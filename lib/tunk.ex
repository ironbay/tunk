defmodule Tunk.Router do
	use Plug.Router
	require Logger
	alias Tunk.Github

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
			repo: repo |> String.split("-") |> Enum.at(1), 
			description: description(status),
			status: translate(status)
		}

		if info.status == "success" or info.status == "failure" or info.status == "pending" do
			Github.send(info)
			Tunk.Slack.send(info)
		else 
			:noop
		end
	end 

	def translate(status) do
		case status do
			"SUCCESS" -> "success"
			"FAILURE" -> "failure"
			"WORKING" -> "pending"
			_ -> :noop
		end
	end
	
	def description(status) do
		case status do
			"SUCCESS" -> "Build succeeded" 
			"FAILURE" -> "Build failed."
			"WORKING" -> "Build in progress."
			_ -> :noop
		end
	end
end