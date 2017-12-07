defmodule TunkTest do
	use ExUnit.Case 
	doctest Tunk.Router

	@data "{\"message\":{\"data\":\"eyJ0aW1lb3V0IjoiNjAwLjAwMHMiLCJzdGVwcyI6W3sibmFtZSI6Imdjci5pby9jbG91ZC1idWlsZGVycy9kb2NrZXIiLCJhcmdzIjpbInB1bGwiLCJnY3IuaW8vbXlvcmdhbml6YXRpb24tcHJvZHVjdGlvbi9lbGl4aXI6bWFzdGVyIl19LHsibmFtZSI6Imdjci5pby9jbG91ZC1idWlsZGVycy9kb2NrZXIiLCJhcmdzIjpbImJ1aWxkIiwiLS1jYWNoZS1mcm9tIiwiZ2NyLmlvL215b3JnYW5pemF0aW9uLXByb2R1Y3Rpb24vZWxpeGlyOm1hc3RlciIsIi10IiwiZ2NyLmlvL215b3JnYW5pemF0aW9uLXByb2R1Y3Rpb24vZWxpeGlyOm1hc3RlciIsIi4vZWxpeGlyIl19XSwic3RhdHVzIjoiU1VDQ0VTUyIsInN0YXJ0VGltZSI6IjIwMTctMTItMDVUMjI6Mjg6MDcuOTAyMzMzODE0WiIsInNvdXJjZVByb3ZlbmFuY2UiOnsicmVzb2x2ZWRSZXBvU291cmNlIjp7InJlcG9OYW1lIjoiZ2l0aHViLWdyZWF0Z3JvdXAtbXlvcmdhbml6YXRpb24iLCJwcm9qZWN0SWQiOiJteW9yZ2FuaXphdGlvbi1wcm9kdWN0aW9uIiwiY29tbWl0U2hhIjoiZjA4YmMyOTA3MTQ1MGVjZmE2NjNhZGVkNzhhYWQ1NTVkNTRkNGRlZiJ9fSwic291cmNlIjp7InJlcG9Tb3VyY2UiOnsicmVwb05hbWUiOiJnaXRodWItZ3JlYXRncm91cC1teW9yZ2FuaXphdGlvbiIsInByb2plY3RJZCI6Im15b3JnYW5pemF0aW9uLXByb2R1Y3Rpb24iLCJicmFuY2hOYW1lIjoibWFzdGVyIn19LCJyZXN1bHRzIjp7ImltYWdlcyI6W3sibmFtZSI6Imdjci5pby9teW9yZ2FuaXphdGlvbi1wcm9kdWN0aW9uL2VsaXhpcjptYXN0ZXIiLCJkaWdlc3QiOiJzaGEyNTY6ZmMxYzRjNDQwN2M5MjQzNmRhc2RmMWQ5MzQwMDU5ZjU0MjFjNmI0NjI1YTdmNjU1NzFkOTJhOGI0M2YifV0sImJ1aWxkU3RlcEltYWdlcyI6WyJzaGEyNTY6ZTEzOWJiNjFlNTk4ZjQ5MzRkOTVkNzhmZTVmNGIwZmZmMWMxMzY1OGMwNGEyYjg4ODRlYWE1YzJjMmFmZWM3YjQiLCJzaGEyNTY6ZTE1OWJiNjFlMzQyM2Y5MTlkOTV3NzhmZTVmNGIwZmZmMWMxMzY1OGMwNGEyYjg4ODRlYWE1YzJjMmFmZWM3YjQiXX0sInByb2plY3RJZCI6Im15b3JnYW5pemF0aW9uLXByb2R1Y3Rpb24iLCJsb2dzQnVja2V0IjoiZ3M6Ly81MzUzNDM0MzIzNTk4LmNsb3VkYnVpbGQtbG9ncy5nb29nbGV1c2VyY29udGVudC5jb20iLCJsb2dVcmwiOiJodHRwczovL2NvbnNvbGUuY2xvdWQuZ29vZ2xlLmNvbS9nY3IvYnVpbGRzL2RlYzRhOGE4LTM0ZGYtNDIxNi04MDI4LTZmMGNjMTcxZTE2Zj9wcm9qZWN0PW15b3JnYW5pemF0aW9uLXByb2R1Y3Rpb24iLCJpbWFnZXMiOlsiZ2NyLmlvL215b3JnYW5pemF0aW9uLXByb2R1Y3Rpb24vZWxpeGlyOm1hc3RlciJdLCJpZCI6ImRlNDM0OGE4LTRkejQtNTIxNi04MDI4LTZmMGNjMTcxZTE2ZiIsImZpbmlzaFRpbWUiOiIyMDE3LTEyLTA1VDIyOjI5OjE1Ljg4ODQ2MVoiLCJjcmVhdGVUaW1lIjoiMjAxNy0xMi0wNVQyMjoyODowNy4xMzc1OTQwMzBaIiwiYnVpbGRUcmlnZ2VySWQiOiJjNzNkMzA0Yi0zZDU1LTRmZjMtYmVhNy0zOTM0YjhhZDJmNmMifQ==\"}}"

	@expected %{
		branch: "master", 
		context: "gcr.io/myorganization-production/elixir",
		images: ["gcr.io/myorganization-production/elixir:master"],
		owner: "greatgroup", 
		repo: "myorganization",
		sha: "f08bc29071450ecfa663aded78aad555d54d4def", 
		status: "success",
		target_url: "https://console.cloud.google.com/gcr/builds/de4348a8-4dz4-5216-8028-6f0cc171e16f?project=myorganization-production"
	}

	test "Tunk.Router.format correctly extracts correct info" do
		assert Tunk.Router.format(@data) == @expected
	end

	test "post /gcp/message returns a 200" do 
		{:ok, %{status_code: status_code}} = HTTPoison.post("localhost:4000/gcp/message", @data)
		assert status_code == 200
	end 
	
	test "Tunk.Router.enabled correctly enables features" do 
		github = %{
			user: nil, 
			auth: nil, 
			enabled: true
		}

		Application.put_env(:tunk, :github, github)
		enabled_list = Tunk.Router.enabled
		
		assert enabled_list |> Enum.member?(Tunk.Github) == true 
		assert enabled_list |> Enum.member?(Tunk.Slack) == false
	end
end

