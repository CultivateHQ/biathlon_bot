defmodule Web.Router do
  @moduledoc """
  A Plug router that acts as an interface to control the robot. The
  control page is displayed initially with `get /`. All state changing operations
  are posts.

  There's some last minute hacks here around game state. Much of the logic
  doesn't really belong here at all, but I haven't got round to cleaning it up
  (because there's real work to do).
  """

  use Plug.Router
  plug Plug.Parsers, parsers: [:urlencoded]
  alias Locomotion.Locomotion
  alias Laser.LaserControl
  alias Web.Html

  plug :match
  plug :dispatch

  def start_link do
    cowboy_options = Application.fetch_env!(:web, :cowboy_options)
    {:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, [], cowboy_options
  end

  get "/" do
    case GameState.state do
      :started -> send_resp(conn, 200, "Hello" |> Html.control_page)
      :unstarted -> send_resp(conn, 200, Html.unstarted)
      :finished ->
        # Horrible hack
        Locomotion.stop
        send_resp(conn, 200, Html.finished)
    end
  end

  get "/cultivatormobile.css" do
    send_resp(conn, 200, Html.css)
  end

  post "start" do
    GameState.start
    redirect_home(conn)
  end

  post "reset" do
    GameState.reset
    redirect_home(conn)
  end

  post "fire" do
    LaserControl.fire
    redirect_home(conn)
  end

  post "forward" do
    Locomotion.forward
    redirect_home(conn)
  end

  post "back" do
    Locomotion.reverse
    redirect_home(conn)
  end

  post "stop" do
    Locomotion.stop
    redirect_home(conn)
  end

  post "step_rate" do
    case Integer.parse(conn.params["step_rate"]) do
      {step_rate, _} -> Locomotion.set_step_rate(step_rate)
      _ -> nil
    end
    redirect_home(conn)
  end

  post "turn_left" do
    Locomotion.turn_left
    redirect_home(conn)
  end

  post "turn_right" do
    Locomotion.turn_right
    redirect_home(conn)
  end

  match _ do
    redirect_home(conn)
  end

  defp redirect_home(conn) do
    conn
    |> put_resp_header("location", "/")
    |> send_resp(303, "")
  end

end
