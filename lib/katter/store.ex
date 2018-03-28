defmodule Katter.Store do
  require Logger

  use GenServer

  @username_tbl :katters_by_username
  @mention_tbl :katters_by_mention

  def child_spec() do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [:noop]},
      restart: :transient,
      shutdown: 5000,
      type: :worker
    }
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    :ets.new(@username_tbl, [
      :bag,
      :public,
      :named_table,
      read_concurrency: true,
      write_concurrency: true
    ])
    :ets.new(@mention_tbl, [
      :bag,
      :public,
      :named_table,
      read_concurrency: true,
      write_concurrency: true
    ])

    {:ok, args}
  end


  def insert(%{"username" => username, "message" => msg, "mentions" => []}) do
    :ets.insert(@username_tbl, {username, msg, []})
  end
  def insert(%{"username" => username, "message" => msg, "mentions" => mentions}) do
    :ets.insert(@username_tbl, {username, msg, mentions})
    for mention <- mentions do
      :ets.insert(@mention_tbl, {mention, msg, username, mentions})
    end
  end

  def query(%{"mention" => user}) do
    Logger.debug("loading katters which mention: #{user}")
    case :ets.lookup(@mention_tbl, user) do
      [] -> []
      msgs -> Enum.map(msgs, fn({_,msg,u,ms}) ->
        %{"username" => u,
          "message" => msg,
          "mentions" => ms}
      end)
    end
  end

  def query(%{"username" => user}) do
    Logger.debug("loading katters for: #{user}")
    case :ets.lookup(@username_tbl, user) do
      [] -> []
      msgs -> Enum.map(msgs, fn({u,msg,ms}) ->
        %{"username" => u,
          "message" => msg,
          "mentions" => ms}
      end)
    end
  end

  def query(other) do
    Logger.warn("not match on request: #{inspect other}")
    []
  end

end


