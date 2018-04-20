defmodule S3DirectUploaderTest do
  use ExUnit.Case
  doctest S3DirectUploader

  import Mock

  test "creates an appropriate upload packet" do
    with_mock(System, [:passthrough], [
      get_env: fn
        "S3_REGION" -> "eu-west-2"
        "S3_MEDIA_BUCKET" -> "bucket"
        "MEDIA_ACCESS_KEY_ID" -> "xxxx"
        "MEDIA_SECRET_ACCESS_KEY" -> "YYYY"
      end
    ]) do
      file_name = "the_file_name.mp3"
      mime_type = "audio/mp3"
      tick = Timex.from_unix(1234567890)

      expected_packet = %{
        action: "https://s3-eu-west-2.amazonaws.com/bucket",
        params: %{
          "key": file_name,
          "policy": "eyJleHBpcmF0aW9uIjoiMjAwOS0wMi0xNFQwMDozMTozMFoiLCJjb25kaXRpb25zIjpbeyJidWNrZXQiOiJidWNrZXQifSx7ImFjbCI6InB1YmxpYy1yZWFkIn0sWyJzdGFydHMtd2l0aCIsIiRDb250ZW50LVR5cGUiLCJhdWRpby9tcDMiXSxbInN0YXJ0cy13aXRoIiwiJHgtYW16LWRhdGUiLCIyMDA5MDIxMyJdLFsic3RhcnRzLXdpdGgiLCIkeC1hbXotYWxnb3JpdGhtIiwiQVdTNC1ITUFDLVNIQTI1NiJdLFsic3RhcnRzLXdpdGgiLCIkeC1hbXotY3JlZGVudGlhbCIsInh4eHgiXSxbInN0YXJ0cy13aXRoIiwiJGtleSIsInRoZV9maWxlX25hbWUubXAzIl1dfQ==",
          "x-amz-algorithm": "AWS4-HMAC-SHA256",
          "x-amz-credential": "xxxx/20090213/eu-west-2/s3/aws4_request",
          "x-amz-signature": "a332a7702ed686921cd16b50483f976b4b205464e846baa4bda444a3ec5fc6c8",
          "x-amz-date": "20090213T233130Z",
          "acl": "public-read",
          "Content-Type": mime_type
        }
      }

      assert S3DirectUploader.generate_packet(file_name, mime_type, tick) == expected_packet
    end
  end
end
