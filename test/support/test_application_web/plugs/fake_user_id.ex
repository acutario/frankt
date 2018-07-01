defmodule Frankt.TestApplicationWeb.Plugs.FakeUserId do
  @moduledoc """
  Generates a fake user ID and stores it in the session.
  """
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_or_create_id(conn)

    conn
    |> put_session(:user_id, user_id)
    |> assign(:user_id, user_id)
  end

  defp get_or_create_id(conn) do
    case get_session(conn, :user_id) do
      nil -> Ecto.UUID.generate()
      id -> id
    end
  end
end
