defmodule Tunk.Config do
	use Fig

	config :github, %{
		user: nil, 
		repo: nil, 
		auth: nil
	}
end
