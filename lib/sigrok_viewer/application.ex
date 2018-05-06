defmodule SigrokViewer.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      {SigrokViewerWeb.Endpoint, []},
      {SigrokViewer.TcpServer, []}
      # {DynamicSupervisor, strategy: :one_for_one, name: SigrokViewer.Tcp.DynamicSupervisor},
      # {Task, &SigrokViewer.Tcp.DynamicSupervisor.listen/0 },
    ]

    opts = [strategy: :one_for_one, name: SigrokViewer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SigrokViewerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
