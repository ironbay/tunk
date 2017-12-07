defmodule TunkTest do
  use ExUnit.Case
  doctest Tunk.Router


	test "Tunk.Router.Translate" do
		assert Tunk.Router.translate("SUCCESS") == "success"
		assert Tunk.Router.translate("FAILURE") == "failure"
		assert Tunk.Router.translate("WORKING") == "pending"
		assert Tunk.Router.translate(:invalid) == :noop
		assert Tunk.Router.translate(nil) == :noop
	end

	test "make a google" do
		json = "example.json"
		|> File.read! 
		|> Poison.decode! 
		
		encoded = json
		|> Dynamic.get(["message", "data"])
		|> Poison.encode!
		|> Base.encode64 

		mock = json |>  Dynamic.put(["message", "data"], encoded) |> Poison.encode!

		response = HTTPoison.post("localhost:4000/gcp/message", mock)
		{:ok, thing} = response
		
		returned = thing 
		|> Dynamic.get([:body])
		|> Poison.decode!

		expected = %{
			"branch" => "master", 
			"context" => "gcr.io/myorganization-production/elixir",
			"images" => ["gcr.io/myorganization-production/elixir:master"],
			"owner" => "greatgroup", 
			"repo" => "myorganization",
			"sha" => "f08bc29071450ecfa663aded78aad555d54d4def", 
			"status" => "success",
			"target_url" => "https://console.cloud.google.com/gcr/builds/de4348a8-4dz4-5216-8028-6f0cc171e16f?project=myorganization-production"
		}
		
		assert returned == expected
	end
end
