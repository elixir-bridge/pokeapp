defmodule Myapp.ApiHandler do
  @moduledoc """
  ApiHandler genserver for handling
  pokemon api requests
  """
  use GenServer
  require HTTPoison

  def get_pokemon(id_or_name) do
    GenServer.call(__MODULE__, {:get_poke, id_or_name})
  end

  def start_link() do
    GenServer.start_link(
      __MODULE__,
      [],
      name: __MODULE__
    )
  end

  def init(_) do
    {:ok, []}
  end
  def terminate(_reason, state) do
    :ok
  end

  def handle_call({:get_poke, id_or_name}, _from, state) do
    {:ok, response} = get_poke_request(id_or_name)
    {:reply, [response], state}
  end
  def handle_call(_msg, _from, state) do
    {:reply, {:ok, "content"}, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  def get_poke_request(id_or_name) do
    url = api_path("pokemon/#{id_or_name}/")
    resp = make_request(url)
    {:ok, resp}
  end

  defp make_request(url) do
    case HTTPoison.get(url) do
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
      {:ok, %HTTPoison.Response{body: body}} ->
        body
    end
  end

  defp api_path(path) do
    "http://pokeapi.co/api/v2/#{path}"
  end

end
