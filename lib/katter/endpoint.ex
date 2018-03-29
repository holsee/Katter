defmodule Katter.Endpoint do
  use Plug.Router

  plug(Plug.Logger)
  plug(Plug.RequestId)
  plug(:match)
  plug(:dispatch)

  def child_spec() do
    endpoint_port = 1337
    endpoint_scheme = :http

    {Plug.Adapters.Cowboy2,
     scheme: endpoint_scheme, plug: Katter.Endpoint, options: [port: endpoint_port]}
  end

  get "/katter/messages" do
    %{query_params: params} = fetch_query_params(conn)
    results = Katter.Store.query(params) |> Jason.encode!()
    send_resp(conn, 200, results)
  end

  post "/katter/messages" do
    body = read_body(conn) |> elem(1) |> Jason.decode!()
    Katter.Store.insert(body)
    send_resp(conn, 200, "ain't got time for it, crocodiles!")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
