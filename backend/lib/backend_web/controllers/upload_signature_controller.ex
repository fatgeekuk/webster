defmodule BackendWeb.UploadSignatureController do
  use BackendWeb, :controller
  require Logger

  def create(conn, %{"filename" => filename, "mimetype" => mimetype}) do
    conn
    |> put_status(:created)
    |> render("create.json", signature: sign(filename, mimetype))
  end

  defp sign(filename, mimetype) do
    policy = policy(filename, mimetype)
    signing_key = signing_key();
    Logger.info "signing key #{ signing_key }";
    %{
      key: filename,
      'Content-Type': mimetype,
      acl: "public-read",
      success_action_status: "201",
      action: "https://s3.amazonaws.com/#{System.get_env("S3_BUCKET_NAME")}",
      'AWSAccessKeyId': System.get_env("AWS_ACCESS_KEY_ID"),
      policy: policy,
      signature: hmac_sha1(signing_key, policy)
    }
  end

  defp now_plus(minutes) do
    import Timex
    now
    |> shift(minutes: minutes)
    |> format!("{ISO:Extended:Z}")
  end

  defp signing_key() do
    s1key = Timex.format!(Timex.now(), "%Y%m%d", :strftime);
    s2key = "eu-west-2";
    s3key = "s3";
    s4key = "aws4_request";

    #  Iterates over the data (defined in the array above), hashing it each time.
    initial = "AWS4#{ System.get_env("AWS_SECRET_ACCESS_KEY") }";
    Logger.info "initial #{ initial }";
    Logger.info "s1 #{s1key}";
    step1 = :crypto.hmac(:sha256, initial, s1key);
    step2 = :crypto.hmac(:sha256, step1, s2key);
    step3 = :crypto.hmac(:sha256, step2, s3key);
    signing_key = :crypto.hmac(:sha256, step3, s4key);

    signing_key
  end

  defp hmac_sha1(secret, msg) do

    Logger.info  "Logging this text!"
    Logger.debug "Var value: #{inspect(msg)}"
    Logger.debug "Var valueq: #{inspect(secret)}"

    qq = :crypto.hmac(:sha256, secret, msg)
    Logger.info "signed dingus #{ qq }";
    qq |> Base.encode16(case: :lower)
  end

  defp policy(key, mimetype, expiration_window \\ 60) do
    pp = %{
      # This policy is valid for an hour by default.
      expiration: now_plus(expiration_window),
      conditions: [
        # You can only upload to the bucket we specify.
        %{bucket: System.get_env("S3_BUCKET_NAME")},
        # The uploaded file must be publicly readable.
        %{acl: "public-read"},
        # You have to upload the mime type you said you would upload.
        ["starts-with", "$Content-Type", mimetype],
        ["starts-with", "$x-amz-date", "2018"],
        ["starts-with", "$x-amz-algorithm", "AWS4-HMAC-SHA256"],
        ["starts-with", "$x-amz-credential", System.get_env("AWS_ACCESS_KEY_ID")],
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