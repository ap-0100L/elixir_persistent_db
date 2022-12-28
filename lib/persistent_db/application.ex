defmodule PersistentDb.Application do
  ##############################################################################
  ##############################################################################
  @moduledoc """
  ## Module
  """
  use Application
  use Utils

  alias PersistentDb, as: PersistentDbWorker
  alias ApiCore.Db.Persistent.Repo, as: PersistentRepo

  ##############################################################################
  @doc """
  # get_topologies.
  """
  defp get_topologies do
    {:ok, lib_cluster_topologies} = Utils.get_app_env!(:libcluster, :lib_cluster_topologies)
    raise_if_empty!(lib_cluster_topologies, :list, "Wrong lib_cluster_topologies value")

    {:ok, lib_cluster_topologies}
  end

  ##############################################################################
  @doc """
  # get_opts.
  """
  defp get_opts do
    result = [
      strategy: :one_for_one,
      name: PersistentDb.Supervisor
    ]

    {:ok, result}
  end

  ##############################################################################
  @doc """
  # get_children!
  """
  defp get_children! do

    {:ok, topologies} = get_topologies()

    #conf = Application.get_env(:persistent_db, PersistentRepo)
    #repo = Supervisor.child_spec({PersistentRepo, conf}, id: :argdfvsergwerg)

    result = [
      PersistentRepo,
      #repo,
      {PersistentDbWorker, []},
      {Cluster.Supervisor, [topologies, [name: PersistentDb.ClusterSupervisor]]}
    ]

    {:ok, result}
  end

  ##############################################################################
  @doc """
  # Start application.
  """
  @impl true
  def start(_type, _args) do
    {:ok, children} = get_children!()
    {:ok, opts} = get_opts()

    Supervisor.start_link(children, opts)
  end

  ##############################################################################
  ##############################################################################
end
