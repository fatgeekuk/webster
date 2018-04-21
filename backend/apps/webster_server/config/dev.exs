use Mix.Config

config :webster_server, s3_region: System.get_env("S3_REGION")
config :webster_server, s3_media_bucket: System.get_env("S3_MEDIA_BUCKET")
config :webster_server, s3_media_access_key: System.get_env("MEDIA_ACCESS_KEY_ID")
config :webster_server, s3_media_secret_key: System.get_env("MEDIA_SECRET_ACCESS_KEY")
