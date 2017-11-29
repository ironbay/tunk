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
			repo: repo |> String.split("-") |> Enum.at(1)
		}

		case status do
			"SUCCESS" -> Github.send("success", info)
			"FAILURE" -> Github.send("failure", info)
			"WORKING" -> Github.send("pending", info)
			_ -> :noop
		end
	end 
end