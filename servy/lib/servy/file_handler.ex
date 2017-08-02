defmodule Servy.FileHandler do
	def handle_file({:ok, content}, conv) do
		%{ conv | status: 200, resp_body: content }
	end

	def handle_file({:error, :enoent}, conv) do
		page = String.split(conv.path, "/") |> List.last
		%{ conv | status: 404, resp_body: "#{page}.html not found" }
	end

	def handle_file({:error, reason}, conv) do
		%{ conv | status: 500, resp_body: "File error: #{reason}" }
	end
end