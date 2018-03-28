defmodule Katter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    children = [
      Katter.Endpoint.child_spec(),
      Katter.Store.child_spec()
    ]

    Logger.info("Started application")

    opts = [strategy: :one_for_one, name: Katter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
