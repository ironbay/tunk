defmodule Tunk.Router do
	use Plug.Router
	require Logger

	plug :match 
	plug :dispatch

	def init(options), do: options

	get "/" do
		conn = fetch_query_params(conn)
		send_resp(conn, 200, "received #{inspect(conn.params)}")
	end

	post "/gcp/message" do
		{:ok, body , _} = Plug.Conn.read_body(conn)

		body 
		|> Poison.decode!
		|> Dynamic.get(["message", "data"])
		|> Base.decode64!
		|> Poison.decode!
		|> IO.inspect
		send_resp(conn, 200, "")
	end


	def start_link() do
		{:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, []
	end

	def check_config do
		IO.inspect Tunk.Config.myapp_somefield()
	end

	def make_it do
		base = "https://api.github.com/AlanRice93/tunk/statuses/38418b447d0e2105872fb066e5143d3017b5534a"
		body = "{
			\"state\": \"success\",
			\"target_url\": \"https://example.com/build/status\",
			\"description\": \"The build succeeded!\",
			\"context\": \"continuous-integration/jenkins\"
		  }"

		HTTPotion.post(
			base, 
			[
				headers: [
					"User-Agent": "AlanRice93",
					"client_secret": " "
				], 
				body: body, 
			]
		)
	end

	match _ do
		IO.inspect(conn.params)
		send_resp(conn, 404, "ooops")
	end
end
