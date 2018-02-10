defmodule BackendWeb.TestController do
  use BackendWeb, :controller
  
  # plug :action

  def index(conn, _params) do
    render conn, results: %{}
  end
end