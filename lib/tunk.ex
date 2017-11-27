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

	get "https://alanrice.pagekite.me/gcp/message" do
		send_resp(conn, 200, "received #{inspect(conn.params)}")
	end


	def start_link() do
		{:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, []
	end

	match _ do
		IO.inspect(conn.params)
		send_resp(conn, 404, "ooops")
	end
end
