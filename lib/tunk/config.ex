defmodule Tunk.Config do
	use Fig

	config :github, %{
		user: nil, 
		auth: nil
	}
end
