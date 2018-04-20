defmodule WebsterWebWeb.UploadSignerView do
  use WebsterWebWeb, :view

  def render("create.json", %{file: file}) do
    file
  end
end