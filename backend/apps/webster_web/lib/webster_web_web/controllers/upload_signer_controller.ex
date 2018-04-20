defmodule WebsterWebWeb.UploadSignerController do
  use WebsterWebWeb, :controller

  def create(conn, %{"filename" => filename, "mimetype" => mimetype}) do
    render conn, "create.json", file: S3DirectUploader.generate_packet(filename, mimetype)
  end
end
