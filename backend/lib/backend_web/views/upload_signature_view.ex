defmodule BackendWeb.UploadSignatureView do
  use BackendWeb, :view

  def render("create.json", %{signature: signature}) do
    signature
  end
end








