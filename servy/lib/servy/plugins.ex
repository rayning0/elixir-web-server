defmodule Servy.Plugins do

	alias Servy.Conv

  @doc "Logs 404 requests"
  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts "\nWarning: #{path} doesn't exist!\n"
    conv
  end

  def track(%Conv{} = conv) do
  	IO.puts ""
  	conv
  end

	def rewrite_path(%Conv{path: path} = conv) do
		regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
		captures = Regex.named_captures(regex, path)
		rewrite_path_captures(conv, captures)
	end

	def rewrite_path(%Conv{} = conv), do: conv

	def rewrite_path_captures(%Conv{} = conv, %{"thing" => thing, "id" => id}) do
		%{ conv | path: "/#{thing}/#{id}" }
	end

	def rewrite_path_captures(%Conv{} = conv, nil), do: conv

	def log(%Conv{} = conv), do: IO.inspect conv
end