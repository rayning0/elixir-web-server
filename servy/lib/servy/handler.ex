defmodule Servy.Handler do
	require Logger

	def handle(request) do
		# conv = parse(request)
		# conv = route(conv)
		# format_response(conv)

		request
		|> parse
		|> rewrite_path
		|> log
		|> route
		|> emojify
		|> format_response
	end

	def emojify(%{status: 200, resp_body: resp_body} = conv) do
		%{ conv | resp_body: "🏄💃#{resp_body}👯💋👀"}
	end

	def emojify(conv), do: conv

	def rewrite_path(%{path: path} = conv) do
		regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
		captures = Regex.named_captures(regex, path)
		rewrite_path_captures(conv, captures)
	end

	def rewrite_path(conv), do: conv

	def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
		%{ conv | path: "/#{thing}/#{id}" }
	end

	def rewrite_path_captures(conv, nil), do: conv

	def log(conv), do: IO.inspect conv

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

	def route(%{method: "GET", path: "/wildthings"} = conv) do
		%{ conv | status: 200, resp_body: "Lions, Tigers, Bears" }
	end

	def route(%{method: "GET", path: "/bears"} = conv) do
		%{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
	end

	def route(%{method: "GET", path: "/bears/new"} = conv) do
		Path.expand("../../pages", __DIR__)	#absolute path of current file
		|> Path.join("form.html")
		|> File.read
		|> handle_file(conv)
	end

	def route(%{method: "GET", path: "/bears/" <> id} = conv) do
		%{ conv | status: 200, resp_body: "Bear #{id}" }		
	end

	def route(%{method: "GET", path: "/about"} = conv) do
		Path.expand("../../pages", __DIR__)	#absolute path of current file
		|> Path.join("about.html")
		|> File.read
		|> handle_file(conv)
	end

	# define one generic route function that handles arbitrary requests:
	# 	/pages/contact
	# 	/pages/faq
	# 	/pages/any-other-page
	def route(%{method: "GET", path: "/pages/" <> page} = conv) do
		# regex = ~r{\/pages\/(?<page>[\w'-]+)}
		# page = Regex.named_captures(regex, path)["page"]
		Path.expand("../../pages", __DIR__)	#absolute path of current file
		|> Path.join(page <> ".html")
		|> File.read
		|> handle_file(conv)
	end

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

	# def route(%{method: "GET", path: "/about"} = conv) do
	# 	file =
	# 		Path.expand("../../pages", __DIR__)	#absolute path of current file
	# 		|> Path.join("about.html")

	# 	case File.read(file) do
	# 		{:ok, content} ->
	# 			%{ conv | status: 200, resp_body: content }

	# 		{:error, :enoent} ->
	# 			%{ conv | status: 404, resp_body: "File not found" }

	# 		{:error, reason} ->
	# 			%{ conv | status: 500, resp_body: "File error: #{reason}" }
	# 	end
	# end

	def route(%{method: "DELETE", path: "/bears/" <> _id} = conv) do
		%{ conv | status: 403, resp_body: "You may not delete a bear" }		
	end

	def route(%{path: path} = conv) do
		%{ conv | status: 404, resp_body: "No #{path} here!"}
	end

	def format_response(conv) do
		# Use values in map to make HTTP response string
		"""
		HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
		Content-Type: text/html
		Content-Length: 20

		#{conv.resp_body}
		"""
	end

	defp status_reason(code) do
		%{
			200 => "OK",
			201 => "Created",
			401 => "Unauthorized",
			403 => "Forbidden",
			404 => "Not Found",
			500 => "Internal Server Error"
		}[code]
	end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bears?id=5 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /pages/contact HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /pages/any_other-page HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)
