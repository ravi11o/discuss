defmodule Discusss.Plugs.SetUser do
  import Plug.Conn
  
  alias Discusss.Repo
  alias Discusss.User

  def init(_opts) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) -> 
        assign(conn, :user, user)
      true -> 
        assign(conn, :user, nil)

    end
  end
end