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
		|> extract
		|> broadcast
		send_resp(conn, 200, "")
	end

	post "/" do
		{:ok, body, _} = Plug.Conn.read_body(conn)

		body |> IO.inspect

		send_resp(conn, 200, "wow")
	end

	def extract (%{
		"sourceProvenance" => %{"resolvedRepoSource" => %{"commitSha" => sha, "repoName" => repo}}, 
		"status" => status, 
		"images" => images, 
		"id" => id, 
		"projectId" => project_id, 
		"source" => %{"repoSource" => %{"branchName" => branch}}
	}) do
		[_, owner, repository] = repo |> String.split("-")
		%{
			sha: sha, 
			context: images |> Enum.at(0) |> String.split(":") |> Enum.at(0),
			target_url: "https://console.cloud.google.com/gcr/builds/#{id}?project=#{project_id}", 
			repo: repository, 
			owner: owner,
			status: translate(status), 
			branch: branch, 
			images: images
		}
	end 

	def extract(%{}), do: :noop

	def broadcast(info) do
		if info.status != :noop do
			Github.send(info)
			Tunk.Slack.send(info)
		else 
			:noop
		end
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
