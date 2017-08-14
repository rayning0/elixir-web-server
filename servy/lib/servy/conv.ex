defmodule Servy.Conv do
  defstruct method: "",
            path: "",
            params: %{},
            headers: %{},
            resp_headers: %{"Content-Type" => "text/html"},
            resp_body: "",
            status: nil

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
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

  def put_resp_content_type(conv, type) do
    %{ conv | resp_headers: Map.put(conv.resp_headers, "Content-Type", type) }
  end

  def put_conv_content_length(conv) do
    %{ conv | resp_headers: Map.put(conv.resp_headers, "Content-Length", String.length(conv.resp_body)) }
  end

  def format_response_headers(conv) do
    for {key, val} <- conv.resp_headers do
      "#{key}: #{val}\r\n"
    end |> Enum.sort(&(&1 > &2))  # sort in descending order
    #     OR
    # Enum.map(conv.resp_headers, fn{key, val} -> "#{key}: #{val}\r\n" end)
    # |> Enum.sort(&(&1 > &2))
    #     OR
    # |> Enum.sort |> Enum.reverse |> Enum.join("\n")

    # Content-Type: #{conv.resp_headers["Content-Type"]}\r
    # Content-Length: #{conv.resp_headers["Content-Length"]}\r
  end
end
