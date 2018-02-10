defmodule BackendWeb.TestView do
  use BackendWeb, :view

  def render("index.json", %{results: data}) do
    data
  end
end