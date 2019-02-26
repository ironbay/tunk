defmodule Tunk.Config do
  use Fig

  config :tunk, %{
    github: %{
      user: nil,
      auth: nil,
      enabled: false
    },
    slack: %{
      token: nil,
      channel: nil,
      enabled: false
    },
    google: %{
      project: nil,
      subscription: nil
    }
  }
end
