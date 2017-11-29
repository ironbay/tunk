defmodule Tunk.Github do 
	def send(info) do 
		Tentacat.Repositories.Statuses.create(
			Tunk.Config.github_user(), 
			info.repo, 
			info.sha,
			%{
				"state": info.status, 
				"target_url": info.target_url, 
				"description": info.status, 
				"context": info.context
			},
			Tentacat.Client.new(%{
				access_token: Tunk.Config.github_auth()
			})
		)
	end 

end