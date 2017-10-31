defmodule Myapp.Router do
  @moduledoc """
  Router for Myapp
  """
  use Plug.Router
  plug :match
  plug :dispatch

  def start_link() do
    {:ok, _} =
      Plug.Adapters.Cowboy.http Myapp.Router, [], [port: 4000]
  end

  get "/" do
    conn
    |> send_resp(200, "<h1>YAY</h1>")
  end

  get "/get_poke/:id_or_name" do
    conn = Plug.Conn.fetch_query_params(conn)
    response = Myapp.ApiHandler.get_pokemon(conn.params["id_or_name"])

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  match _ do
    conn
    |> send_resp(404, "Not found")
  end
end
