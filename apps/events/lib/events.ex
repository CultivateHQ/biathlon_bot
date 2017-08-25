defmodule Events do
  @moduledoc """
  Enables a process to subscribe to events on a topic, and for
  events to be broadcat to a topic
  """

  alias Phoenix.PubSub
  @doc """
  Subscribe the current process to the topic
  """
  @spec subscribe(binary) :: :ok | {:error, any}
  def subscribe(topic) do
    # Registry.register(:events_registry, topic, [])
    PubSub.subscribe(:events_registry, topic)
  end

  @doc """
  Broadcast an event to the topic. The topic receives
  {:event, topic, event}
  """
  @spec broadcast(binary, any) :: :ok | {:error, any}
  def broadcast(topic, event) do
    # Registry.dispatch(:events_registry, topic, fn entries ->
    #   for {pid, _} <- entries, do: send(pid, {:event, topic, event})
    # end)
    PubSub.broadcast(:events_registry, topic, {:event, topic, event})
  end
end
