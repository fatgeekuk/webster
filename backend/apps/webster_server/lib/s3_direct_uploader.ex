defmodule S3DirectUploader do
  @moduledoc """
  Documentation for S3DirectUploader.

  This module is used to generate an upload packet that will allow a frontend client to
  perform an upload directly from the browser.

  It requires some information related to the file :-

  file name
  file mime type
  timestamp of the upload

  And, in addition, a number of configuration values stored in various ENVIRONMENT variables


  """

  @doc """
  Generate Packet. This is the publicly available method.

  Note, no doctests are included here as there are seperate tests
  defined within the tests folder
  
  """
  def generate_packet(file_name, mime_type, tick \\ Timex.now) do
    policy = policy(file_name, mime_type, tick)
    signing_key = signing_key(tick);

    %{
      action: endpoint(),
      params: %{
        "key": s3_key(file_name),
        "policy": policy,
        "x-amz-algorithm": aws_auth_alg(),
        "x-amz-credential": credentials(tick),
        "x-amz-signature": hmac_sha1(signing_key, policy),
        "x-amz-date": Timex.format!(tick, "%Y%m%dT%H%M%SZ", :strftime),
        "acl": aws_acl(),
        "Content-Type": mime_type
      }
    }
  end

  defp aws_auth_alg do
    "AWS4-HMAC-SHA256"
  end

  defp aws_acl() do
    "public-read"
  end

  defp aws_region() do
    Application.get_env(:webster_server, :s3_region)
  end

  defp aws_secret do
    Application.get_env(:webster_server, :s3_media_secret_key)
  end
  
  defp aws_access_key do
    Application.get_env(:webster_server, :s3_media_access_key)
  end
  
  defp aws_bucket() do
    Application.get_env(:webster_server, :s3_media_bucket)
  end

  defp endpoint() do
    "https://s3-#{ aws_region() }.amazonaws.com/#{ aws_bucket() }"
  end

  defp s3_key(filename) do
    "#{ filename }"
  end

  defp short_date(tick) do
    Timex.format!(tick, "%Y%m%d", :strftime)
  end

  defp credentials(tick) do
    "#{ aws_access_key() }/#{ short_date(tick) }/#{ aws_region() }/#{ service_type() }/#{ request_type() }"  
  end 

  defp service_type do
    's3'
  end

  defp request_type do
    'aws4_request'
  end

  defp signing_key(tick) do
    s1key = short_date(tick);
    s2key = aws_region();
    s3key = service_type();
    s4key = request_type();

    #  Iterates over the data (defined in the array above), hashing it each time.
    initial = "AWS4#{ aws_secret() }";
    step1 = :crypto.hmac(:sha256, initial, s1key);
    step2 = :crypto.hmac(:sha256, step1, s2key);
    step3 = :crypto.hmac(:sha256, step2, s3key);
    signing_key = :crypto.hmac(:sha256, step3, s4key);

    signing_key
  end
  
  defp hmac_sha1(secret, msg) do
    :crypto.hmac(:sha256, secret, msg)
    |> Base.encode16(case: :lower)
  end

  defp policy(key, mimetype, tick, expiration_window \\ 60) do
    import Timex
    expiry = tick
      |> shift(minutes: expiration_window)
      |> format!("{ISO:Extended:Z}")

    %{
      # This policy is valid for an hour by default.
      expiration: expiry,
      conditions: [
        # You can only upload to the bucket we specify.
        %{ bucket: aws_bucket() },
        %{acl: "public-read"},
        # You have to upload the mime type you said you would upload.
        ["starts-with", "$Content-Type", mimetype],
        ["starts-with", "$x-amz-date", short_date(tick)],
        ["starts-with", "$x-amz-algorithm", "AWS4-HMAC-SHA256"],
        ["starts-with", "$x-amz-credential", aws_access_key()],
        # You have to upload the file name you said you would upload.
        ["starts-with", "$key", key],
        # When things work out ok, AWS should send a 201 response.
        #%{success_action_status: "201"}
      ]
    }
    |> Poison.encode!
    # Let's make this into JSON.
    # We also need to base64 encode it.
    |> Base.encode64
  end
end
