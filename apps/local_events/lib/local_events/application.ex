defmodule LocalEvents.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Registry, [:duplicate,  :local_events_registry]),
    ]

    opts = [strategy: :one_for_one, name: LocalEvents.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
