defmodule Tunk do
	use Plug.Router

	plug :match
	plug :dispatch

	get "/hello" do
		Plug.Conn.send_resp(conn, 200, "ok")		
	end

	def child_spec() do
		Plug.Adapters.Cowboy2.child_spec(:http, __MODULE__, [], [port: 13000])
	end

  @moduledoc """
  Documentation for Tunk.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Tunk.hello
      :world

  """
  def hello do
    :world
  end
end
