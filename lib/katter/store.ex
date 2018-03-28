defmodule Katter.Store do
  require Logger

  def query(%{"mention" => user}) do
    Logger.debug("loading katters which mention: #{user}")
    []
  end

  def query(%{"username" => user}) do
    Logger.debug("loading katters for: #{user}")
    []
  end

  def query(other) do
    Logger.warn("not match on request: #{inspect other}")
    []
  end
end
