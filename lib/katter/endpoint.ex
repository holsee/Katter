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
    results = Katter.Store.query(params)
    send_resp(conn, 200, results)
  end


  match _ do
    send_resp(conn, 404, "oops")
  end
end
