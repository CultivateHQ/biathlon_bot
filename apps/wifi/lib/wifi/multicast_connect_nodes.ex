defmodule Wifi.MulticastConnectNodes do
  @moduledoc """
  Based heavily on https://dbeck.github.io/Scalesmall-W5-UDP-Multicast-Mixed-With-TCP/, and when I say based I mean cargo culted.
  I don't know much about UDP multicast.

  * every second broadcasts to the UDP multicast group 224.1.1.1 on prot 49999 the name of this node
  * listens for those same broadcasts from other nodes. When one is found, which is not in the current node list, attempts to connect
  to the received node name at the received ip.

  This is highly insecure and as atoms must be constructed to bind to the appropriate id, it is also makes us subject
  to attack by filling up the atom table space, even without knowing the shared cookie.
  """
  use GenServer
  require Logger

  @ip {224, 1, 1, 1}
  @port 49_999
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
      add_membership:  {@ip, {0, 0, 0, 0}},
      multicast_if:    {0, 0, 0, 0},
      multicast_loop:  false,
      multicast_ttl:   4,
      reuseaddr:       true
    ]
    send(self(), :broadcast)
    {:ok, socket} = :gen_udp.open(@port, udp_options)
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
    Logger.debug fn -> "Unexpected incomping udp: #{inspect(msg)}" end
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
