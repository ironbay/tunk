defmodule Tunk.Slack do
	alias Slack.Web.Chat, as: Slack
	
	def send(info) do
		context = "http://" <> info.context

		branch_url = case info.branch do
			"master" -> "https://github.com/" <> info.owner <> "/" <> info.repo
			_ -> "https://github.com/" <> info.owner <> "/" <> info.repo <> "/tree/" <> info.branch
		end

		branch_display = "<#{branch_url}|#{info.branch}>"

		attachments = [
			%{
				"color": status_color(info.status), 
				"text": "*Build Status*: #{String.capitalize(info.status)}\n*<#{info.target_url}|Build details>*\n*Branch*: #{branch_display}\n*Repo*: #{info.repo}\n*Images*: #{readable_list(info.images)}\n*<#{context}|Container registry>*", 
				"mrkdwn_in": ["text"]
			}
		] |> Poison.encode!
		
		Tunk.Config.slack_channel()
		|> Slack.post_message("", 
			%{
				token: Tunk.Config.slack_token(), 
				username: "Tunk", 
				icon_emoji: ":chart_with_upwards_trend:",
				attachments: [attachments] 
			}
		)
	end
	
	def status_color(status) do
		case status do
			"pending" -> "#FFA100"
			"success" -> "#006F13"
			"failure" -> "#DC2B30"
		end
	end

	def readable_list(images) do
		images 
		|> List.foldl("", fn(x, acc) -> acc <> x <> "\n" end)
	end
end
