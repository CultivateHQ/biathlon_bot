defmodule GameState do
  @moduledoc """
  Holds game state
  """

  use GenServer

  @name __MODULE__

  defstruct state: :unstarted, start_secs: nil, finish_secs: nil

  def start_link do
    GenServer.start_link(__MODULE__, {}, name: @name)
  end

  def init(_) do
    Events.subscribe("light_level_triggers")
    {:ok, %__MODULE__{}}
  end

  def reset do
    GenServer.cast(@name, :reset)
  end

  def start do
    GenServer.cast(@name, :start)
  end

  def state do
    GenServer.call(@name, :state)
  end

  def start_secs do
    GenServer.call(@name, :start_secs)
  end

  def finish_secs do
    GenServer.call(@name, :finish_secs)
  end

  def handle_cast(:reset, s) do
    {:noreply, %{s | state: :unstarted, start_secs: nil, finish_secs: nil}}
  end

  def handle_cast(:start, s) do
    {:noreply, %{s | state: :started, start_secs: secs(), finish_secs: nil}}
  end

  def handle_call(:state, _, s = %{state: state}) do
    {:reply, state, s}
  end

  def handle_call(:start_secs, _, s = %{start_secs: start_secs}) do
    {:reply, start_secs, s}
  end

  def handle_call(:finish_secs, _, s = %{finish_secs: finish_secs}) do
    {:reply, finish_secs, s}
  end

  def handle_info({:event, "light_level_triggers", :triggered}, s = %{state: :started}) do
    {:noreply, %{s | state: :finished, finish_secs: secs()}}
  end
  def handle_info({:event, "light_level_triggers", _}, s) do
    {:noreply, s}
  end

  defp secs do
    DateTime.utc_now |> DateTime.to_unix
  end
end
