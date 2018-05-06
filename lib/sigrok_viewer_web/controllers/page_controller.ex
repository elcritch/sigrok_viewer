defmodule SigrokViewerWeb.PageController do
  use SigrokViewerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
