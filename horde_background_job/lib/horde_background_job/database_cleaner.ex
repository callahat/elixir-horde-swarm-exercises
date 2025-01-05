defmodule HordeBackgroundJob.DatabaseCleaner do
  use GenServer
  use HordeBackgroundJob.Logger

  alias __MODULE__.Runner

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    timeout = Keyword.get(opts, :timeout, :timer.seconds(2))
    count = Keyword.get(opts, :count, 0)

    case GenServer.start_link(__MODULE__, {timeout, name, count}, name: name) do
      {:ok, pid} ->
        nil # nothing to do

      {:error, {:already_started, pid}} ->
        # also nothing to do but log it - mostly interested if a name is being set incorrectly
        log_msg("already started at #{inspect(pid)} for #{ name }")
    end
  end

  @impl GenServer
  def init({timeout, name, count}) do
    Process.set_label(_name(name))
    polisher_name = "#{_name(name)}Polisher"
    log_msg("starting")
    log_msg("polisher name")
    log_msg(inspect name)
    log_msg(inspect polisher_name)

    schedule(timeout)

    log_msg("starting horde super for the polisher - #{ inspect _name(name) }")

    polish_supervisor = \
      case Horde.DynamicSupervisor.start_link(strategy: :one_for_one, members: :auto, name: :"#{polisher_name}") do
        {:ok, pid} ->
          log_msg("success #{ inspect pid }")
          pid

        {:error, {:already_started, pid}} ->
          log_msg("already started polisher at #{inspect(pid)} for #{ polisher_name }")
          pid

        something_else ->
          log_msg("uh oh - #{ inspect something_else }")
          nil
      end

    log_msg("should have started polish supervisor - #{ inspect polish_supervisor }")

    # a random number of polishers
    Enum.map(1..:rand.uniform(4), fn(i) ->
      polisher_name_x = "#{polisher_name}#{i}"

      child_spec = %{
        id: polisher_name_x,
        start: {HordeBackgroundJob.DatabasePolisher, :start_link, [[name: polisher_name_x, timeout: timeout]]},
        type: :worker,
        restart: :temporary,
        shutdown: 500,
      }

      # keeps returning an :error tuple, but seems the process starts anyway :/
      IO.inspect Horde.DynamicSupervisor.start_child(:"#{polisher_name}", child_spec)
    end)

    {:ok, {timeout, name, count}}
  end

  @impl GenServer
  def handle_info(:execute, {timeout, name, count}) do
    log_msg("deleting - #{ _name name }")
    Task.start(Runner, :execute, [_name(name), count])

    schedule(timeout)

    {:noreply, {timeout, name, count + 1}}
  end

  defp schedule(timeout) do
    log_msg("scheduling")

    Process.send_after(self(), :execute, timeout)
  end

  defp _name({:via, Horde.Registry, {_, name}}), do: name
  defp _name(name), do: name

end
