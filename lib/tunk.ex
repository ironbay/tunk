defmodule Tunk.Router do
	use Plug.Router
	require Logger
	alias Tunk.Github
	alias Tunk.Config

	plug :match 
	plug :dispatch

	def init(options) do 
		options
	end

	def start_link() do
		{:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, []
	end

	post "/gcp/message" do
		{:ok, body , _} = Plug.Conn.read_body(conn)	
		process(body)
		send_resp(conn, 200, "")
	end

	def process(body) do 
		body 
		|> format
		|> case do 
			:noop -> :noop 
			info -> broadcast(info)
		end
	end

	def format(body) do 
		body 
		|> Poison.decode!
		|> Dynamic.get(["message", "data"])
		|> Base.decode64!
		|> Poison.decode!
		|> extract
	end 

	def extract (%{
		"sourceProvenance" => %{"resolvedRepoSource" => %{"commitSha" => sha, "repoName" => repo}}, 
		"status" => status, 
		"images" => images, 
		"id" => id, 
		"projectId" => project_id, 
		"source" => %{"repoSource" => %{"branchName" => branch}}
	}) do
		[_, owner | rest] = repo |> String.split("-")
		%{
			sha: sha, 
			context: images |> Enum.at(0) |> String.split(":") |> Enum.at(0),
			target_url: "https://console.cloud.google.com/gcr/builds/#{id}?project=#{project_id}", 
			repo: rest |> Enum.join("-"), 
			owner: owner,
			status: translate(status), 
			branch: branch, 
			images: images
		} 
	end 

	def extract(%{}), do: :noop

	def enabled do
		[
			(if Config.tunk_slack_enabled(), do: Tunk.Slack, else: nil),
			(if Config.tunk_github_enabled(), do: Tunk.Github, else: nil)
		]
		|> Enum.filter(&(&1 !== nil))
	end 

	def broadcast(info) do
		enabled()
		|> Enum.each(fn(x) -> x.send(info) end)
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
