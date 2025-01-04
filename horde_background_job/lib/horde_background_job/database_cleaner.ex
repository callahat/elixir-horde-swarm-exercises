defmodule HordeBackgroundJob.DatabaseCleaner do
  use GenServer
  use HordeBackgroundJob.Logger

  alias __MODULE__.Runner

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    timeout = Keyword.get(opts, :timeout, :timer.seconds(2))
    count = Keyword.get(opts, :count, 0)

    GenServer.start_link(__MODULE__, {timeout, name, count}, name: name)
  end

  @impl GenServer
  def init({timeout, name, count}) do
    Process.set_label(_name(name))
    polisher_name = "#{_name(name)}Polisher"
    log_msg("starting")

    schedule(timeout)

    log_msg("starting horde super for the polisher - #{ inspect _name(name) }")
    {:ok, polish_supervisor} = Horde.DynamicSupervisor.start_link([strategy: :one_for_one, name: :"#{polisher_name}"])
    log_msg("should have started polish supervisor - #{ inspect polish_supervisor }")

    child_spec = %{
      id: polisher_name,
      start: {HordeBackgroundJob.DatabasePolisher, :start_link, [[name: polisher_name, timeout: timeout]]},
      type: :worker,
      restart: :temporary,
      shutdown: 500,
    }

    {:ok, _pid} = Horde.DynamicSupervisor.start_child(polish_supervisor, child_spec)

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
