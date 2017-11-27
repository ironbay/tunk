defmodule Tunk do
	use Plug.Router

	plug :match
	plug :dispatch

	get "/hello" do
		Plug.Conn.send_resp(conn, 200, "ok")		
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
