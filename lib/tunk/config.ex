defmodule Tunk.Config do
	use Fig

	config :github, %{
		user: nil, 
		auth: nil
	}

	config :slack, %{
		token: nil, 
		channel: nil
	}
end
