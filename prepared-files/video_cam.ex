defmodule Servy.VideoCam do
  @doc """
  Simulates sending a request to an external API
  to get a snapshot image from a video camera.
  """
  def get_snapshot(camera_name) do
    # CODE GOES HERE TO SEND A REQUEST TO THE EXTERNAL API

    # Sleep for 1 second to simulate that the API can be slow:
    :timer.sleep(1000)

    # Example response returned from the API:
    "#{camera_name}-snapshot.jpg"
  end
end
