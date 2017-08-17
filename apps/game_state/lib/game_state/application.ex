defmodule GameState.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(GameState, [])
    ]

    opts = [strategy: :one_for_one, name: GameState.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
