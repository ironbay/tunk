defmodule TunkTest do
  use ExUnit.Case
  doctest Tunk.Router

	test "Tunk.Router.Translate" do
		assert Tunk.Router.translate("SUCCESS") == "success"
		assert Tunk.Router.translate("FAILURE") == "failure"
		assert Tunk.Router.translate("WORKING") == "pending"
		assert Tunk.Router.translate(:invalid) == :noop
		assert Tunk.Router.translate(nil) == :noop
	end
end
