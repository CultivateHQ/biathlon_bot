defmodule LocalEvents do
  @moduledoc """
  Enables a process to subscribe to events on a topic, and for
  events to be broadcat to a topic
  """


  @doc """
  Subscribe the current process to the topic
  """
  @spec subscribe(String.t) ::  {:ok, pid} | {:error, {:already_registered, pid}}
  def subscribe(topic) do
    Registry.register(:local_events_registry, topic, [])
  end

  @doc """
  Broadcast an event to the topic. The topic receives
  {:event, topic, event}
  """
  @spec broadcast(String.t, String.t) :: :ok
  def broadcast(topic, event) do
    Registry.dispatch(:local_events_registry, topic, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:local_event, topic, event})
    end)
  end
end
