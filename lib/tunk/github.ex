defmodule Tunk.Github do 
	alias Tunk.Config

	def send(info) do 
		Tentacat.Repositories.Statuses.create(
			Config.tunk_github_user, 
			info.repo, 
			info.sha,
			%{
				"state": info.status, 
				"target_url": info.target_url, 
				"description": info.status, 
				"context": info.context
			},
			Tentacat.Client.new(%{
				access_token: Config.tunk_github_auth
			})
		)
	end 

end