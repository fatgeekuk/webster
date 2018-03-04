defmodule BackendWeb.UploadSignatureController do
  use BackendWeb, :controller
  require Logger

  def create(conn, %{"filename" => filename, "mimetype" => mimetype}) do
    conn
    |> put_status(:created)
    |> render("create.json", signature: sign(filename, mimetype))
  end

  defp sign(filename, mimetype) do
    tick = Timex.now()

    policy = policy(filename, mimetype, tick)
    signing_key = signing_key(tick);

    %{
      action: endpoint(),
      params: %{
        "key": s3_key(filename),
        "policy": policy,
        "x-amz-algorithm": aws_auth_alg(),
        "x-amz-credential": credentials(tick),
        "x-amz-signature": hmac_sha1(signing_key, policy),
        "x-amz-date": Timex.format!(tick, "%Y%m%dT%H%M%SZ", :strftime),
        "acl": aws_acl(),
        "Content-Type": mimetype
      }
    }
  end

  defp s3_key(filename) do
    "#{ filename }"
  end

  defp aws_auth_alg do
    "AWS4-HMAC-SHA256"
  end

  defp aws_acl() do
    "public-read"
  end

  defp aws_region() do
    System.get_env("S3_REGION")
  end

  defp aws_secret do
    System.get_env("MEDIA_SECRET_ACCESS_KEY")
  end
  
  defp aws_access_key do
    System.get_env("MEDIA_ACCESS_KEY_ID")
  end
  
  defp aws_bucket do
    System.get_env("S3_MEDIA_BUCKET")
  end

  defp endpoint do
    "https://s3-#{ aws_region() }.amazonaws.com/#{ aws_bucket() }"
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

    pp = %{
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
Logger.info "pp= #{inspect(pp)}"
    pp
    # Let's make this into JSON.
    # We also need to base64 encode it.
    |> Base.encode64
  end
end