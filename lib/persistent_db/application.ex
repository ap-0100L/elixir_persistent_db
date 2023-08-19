defmodule PersistentDb.Application do
  ##################################################################################################################
  ##################################################################################################################
  @moduledoc """
  ## Module
  """
  use Application
  use Utils

  alias PersistentDb, as: PersistentDbWorker
  alias ApiCore.Db.Persistent.RepoRo, as: PersistentRepoRo
  alias ApiCore.Db.Persistent.RepoRw, as: PersistentRepoRw

  @supervisor_name PersistentDb.Supervisor
  @cluster_supervisor_name PersistentDb.ClusterSupervisor

  ##################################################################################################################
  @doc """
  # get_topologies.
  """
  defp get_topologies do
    {:ok, lib_cluster_topologies} = Utils.get_app_env(:libcluster, :lib_cluster_topologies)
    raise_if_empty!(lib_cluster_topologies, :list, "Wrong lib_cluster_topologies value")

    {:ok, lib_cluster_topologies}
  end

  ##################################################################################################################
  @doc """
  # get_opts.
  """
  defp get_opts do
    result = [
      strategy: :one_for_one,
      name: @supervisor_name
    ]

    {:ok, result}
  end

  ##################################################################################################################
  @doc """
  # get_children!
  """
  defp get_children! do
    {:ok, topologies} = get_topologies()

    result = [
      PersistentRepoRo,
      PersistentRepoRw,
      {PersistentDbWorker, []},
      {Cluster.Supervisor, [topologies, [name: @cluster_supervisor_name]]}
    ]

    {:ok, result}
  end

  ##################################################################################################################
  @doc """
  # Start application.
  """
  @impl true
  def start(_type, _args) do
    {:ok, children} = get_children!()
    {:ok, opts} = get_opts()

    Supervisor.start_link(children, opts)
  end

  ##################################################################################################################
  ##################################################################################################################
end
