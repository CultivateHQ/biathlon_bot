defmodule Wifi.DistributeNode do
  use GenServer

  @moduledoc """
   fer
  """

  require Logger

  @name __MODULE__


  def start_link(node_name) do
    GenServer.start_link(__MODULE__, node_name, name: @name)
  end


  def init(node_name) do
    Registry.register(Nerves.Udhcpc, "wlan0", [])
    {:ok, node_name}
  end

  def handle_info({Nerves.Udhcpc, :bound, %{ipv4_address: address}}, node_name) do
    start_node(node_name, address)
    {:noreply, node_name}
  end
  def handle_info({Nerves.Udhcpc, _, _}, s),  do: {:noreply, s}


  defp start_node(node_name, address) do
    Node.stop
    full_node_name = "#{node_name}@#{address}" |> String.to_atom
    {:ok, _pid} = Node.start(full_node_name)
  end
end
