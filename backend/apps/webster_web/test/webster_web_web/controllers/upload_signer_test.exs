defmodule WebsterWeb.UploadSignerControllerTest do
  use WebsterWebWeb.ConnCase

  import Mock

  describe "create/2" do

    test "creates the expected packet of information" do
      expected = %{
        "data" => [
          %{ "name" => "user1.name", "email" => "user1.email" },
          %{ "name" => "user2.name", "email" => "user2.email" }
        ]
      }
      with_mock(S3DirectUploader, [:passthrough], [
        generate_packet: fn(_file_name, _mime_type) -> expected end
      ]) do
        response = 
          conn
          |> post(upload_signer_path(conn, :create, filename: 'file', mimetype: 'mime'))
          |> json_response(200)


        assert response == expected
      end
    end
  end
end