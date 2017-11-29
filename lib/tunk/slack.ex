defmodule Tunk.Slack do
	alias Slack.Web.Chat, as: Slack

	def send(info) do
		attachments = [
			%{
				"color": status_color(info.status), 
				"text": "*Build Status*: #{String.capitalize(info.status)}\n*Description*: #{info.description}\n*URL*: #{info.target_url}\n*Context*: #{info.context}", 
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
			"pending" -> "#ffe575"
			"success" -> "#ccff99"
			"failure" -> "#f90919"
		end
	end
end