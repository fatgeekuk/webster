defmodule BackendWeb.APIControllerTest do
  use ExUnit.Case, async: false
  use Plug.Test
  alias Backend.Repo
  alias Ecto.Adapters.SQL

  setup do
    SQL.Sandbox.mode(Repo, :manual)
  end

  test "/test returns an empty hash" do
    response = conn(:get, "/api/test") |> send_request

    assert response.status == 200
    assert response.resp_body == "{}"
  end

  defp send_request(conn) do
    conn
    |> put_private(:plug_skip_csrf_protection, true)
    |> BackendWeb.Endpoint.call([])
  end
end