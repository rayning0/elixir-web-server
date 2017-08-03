defmodule Servy.Parser do
	alias Servy.Conv
	# alias Servy.Conv, as: Conv

	def parse(request) do
		# Parse request string into map
		# first_line = request |> String.split("\n") |> List.first
		# [method, path, _] = String.split(first_line, " ")

		[method, path, _] =
			request
			|> String.split("\n")
			|> List.first
			|> String.split(" ")
			
		%Conv{
			method: method,
			path: path
		}
	end
end