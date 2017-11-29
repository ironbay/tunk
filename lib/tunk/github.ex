defmodule Tunk.Github do 
	def send(status, info) when status == "success" or status == "failure" or status == "pending" do
		Tentacat.Repositories.Statuses.create(
			Tunk.Config.github_user(), 
			info.repo, 
			info.sha,
			%{
				"state": status, 
				"target_url": info.target_url, 
				"description": description(status), 
				"context": info.context
				},
			Tentacat.Client.new(%{
				access_token: Tunk.Config.github_auth()
			})
		)
	end 

	def send(status, _info) do
		IO.inspect status
		:noop
	end

	def description(status) do
		case status do
			"success" -> "Build succeeded" 
			"failure" -> "Build failed."
			"pending" -> "Build in progress."
		end
	end
end