defmodule Servy.Parser do
	def parse(request) do
		# Parse request string into map
		# first_line = request |> String.split("\n") |> List.first
		# [method, path, _] = String.split(first_line, " ")

		[method, path, _] =
			request
			|> String.split("\n")
			|> List.first
			|> String.split(" ")
			
		%{ method: method,
			 path: path,
			 resp_body: "",
			 status: nil
		 }
	end
end