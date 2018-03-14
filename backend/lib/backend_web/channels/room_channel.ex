defmodule BackendWeb.RoomChannel do
  use Phoenix.Channel

  def join(_room, _message, socket) do
    {:ok, socket}
  end
end