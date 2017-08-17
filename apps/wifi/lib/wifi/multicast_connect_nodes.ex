defmodule Wifi.MulticastConnectNodes do
  @moduledoc """
  Based heavily on https://dbeck.github.io/Scalesmall-W5-UDP-Multicast-Mixed-With-TCP/
  """
  use GenServer
  require Logger

  @ip {224, 1, 1, 1}
  @port 49999
  @name __MODULE__
  @broadcast_inverval 1_000

  defstruct socket: nil, my_name: nil

  def start_link(my_name) do
    GenServer.start_link(__MODULE__, my_name, name: @name)
  end

  def init(my_name) do
    udp_options = [
      :binary,
      active:          10,
      add_membership:  {@ip, {0,0,0,0} },
      multicast_if:    {0, 0, 0,0 },
      multicast_loop:  false,
      multicast_ttl:   4,
      reuseaddr:       true
    ]
    send(self(), :broadcast)
    {:ok, socket} = :gen_udp.open(49999, udp_options)
    {:ok, %__MODULE__{socket: socket, my_name: my_name}}
  end


  def handle_info({:udp, socket, {ip1, ip2, ip3, ip4}, _port, "iamnode:" <> node}, state) do
    incoming_node = String.to_atom("#{node}@#{ip1}.#{ip2}.#{ip3}.#{ip4}") #ddos memory attack alert! What to do?
    unless incoming_node  in Node.list do
      node_connect(incoming_node)
    end
    :inet.setopts(socket, [active: 1])

    {:noreply, state}
  end

  def handle_info(msg = {:udp, socket, _ip, _port, _data}, state) do
    Logger.debug "Unexpected incomping udp: #{inspect(msg)}"
    :inet.setopts(socket, [active: 1])
    {:noreply, state}
  end

  def handle_info(:broadcast, s = %{socket: socket, my_name: my_name}) do
    :gen_udp.send(socket, @ip, @port, "iamnode:#{my_name}")
    Process.send_after(self(), :broadcast, @broadcast_inverval)
    {:noreply, s}
  end

  def handle_info(_, s), do: {:noreply, s}

  defp node_connect(incoming_node) do
    case Node.connect(incoming_node) do
      true ->
        Logger.info "Yay! Connected to #{incoming_node}#"
      meh ->
        Logger.info "Spurious request: #{incoming_node}"
    end
  end
end
