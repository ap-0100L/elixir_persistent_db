defmodule PersistentDb do
  @moduledoc """
  Documentation for `PersistentDb`.
  """

  use GenServer
  use Utils

  alias __MODULE__, as: SelfModule

  ##############################################################################
  @doc """
  Supervisor's child specification
  """
  def child_spec(opts) do
    %{
      id: SelfModule,
      start: {SelfModule, :start_link, [opts]}
    }
  end

  ##############################################################################
  @doc """
  ## Function
  """
  def start_link(opts \\ []) do
    GenServer.start_link(SelfModule, %{}, opts)
  end

  ##############################################################################
  @doc """
  ## Function
  """
  @impl true
  def init(state) do
    UniError.rescue_error!(
      (
        Utils.ensure_all_started!([:inets, :ssl])

        Logger.info("[#{inspect(SelfModule)}][#{inspect(__ENV__.function)}] I will try set cookie")

        {:ok, cookie} = get_app_env!(:cookie)
        raise_if_empty!(cookie, :atom, "Wrong cookie value")
        Node.set_cookie(Node.self(), cookie)

        Logger.info("[#{inspect(SelfModule)}][#{inspect(__ENV__.function)}] I will try to enable notification monitor on node connection events")

        result = :net_kernel.monitor_nodes(true)

        if :ok != result do
          UniError.raise_error!(
            :CODE_CAN_NOT_ENABLE_MONITOR_ERROR,
            ["Can not enable notification monitor on node connection events"],
            reason: result
          )
        end

        # {:ok, throw_if_connect_to_node_fail} = Utils.get_app_env!(:throw_if_connect_to_node_fail)
        # raise_if_empty!(throw_if_connect_to_node_fail, :boolean)

        # Logger.info("[#{inspect(SelfModule)}][#{inspect(__ENV__.function)}] I will try to connect ot email sender nodes")
        # {:ok, email_sender_nodes} = Utils.get_app_env!(:email_sender_nodes)
        # raise_if_empty!(email_sender_nodes, :list)

        # {:ok, email_sender_nodes} = Utils.list_of_strings_to_list_of!(email_sender_nodes)
        # Utils.connect_to_nodes!(email_sender_nodes, throw_if_connect_to_node_fail)
      )
    )

    Logger.info("[#{inspect(SelfModule)}][#{inspect(__ENV__.function)}] I completed init part")
    {:ok, state}
  end

  ##############################################################################
  @doc """
  ## Function
  """
  @impl true
  def handle_info({:nodeup, node}, state) do
    Logger.info("[#{inspect(SelfModule)}][#{inspect(__ENV__.function)}] Node #{inspect(node)} connected")

    {:noreply, state}
  end

  @impl true
  def handle_info({:nodedown, node}, state) do
    Logger.info("[#{inspect(SelfModule)}][#{inspect(__ENV__.function)}] Node #{inspect(node)} disconnected")

    {:noreply, state}
  end

  ##############################################################################
  @doc """
  ping.

  ## Examples

      iex> Transport.ping()
      :pong

  """
  def ping do
    :pong
  end

  ##############################################################################
  ##############################################################################
end
