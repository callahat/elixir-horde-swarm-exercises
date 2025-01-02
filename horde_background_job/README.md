# HordeBackgroundJob

```
iex --sname nX -S mix

# to kill the process
HordeBackgroundJob.DatabaseCleaner.Starter.whereis("CleanerX") |> GenServer.cast(:boom)

# to see where the process is/get the PID
HordeBackgroundJob.DatabaseCleaner.Starter.whereis

# launch additional named cleaner processes, (the first 6 are created during
# application startup):
Enum.each(7..30, fn(i) -> HordeBackgroundJob.DatabaseCleaner.Starter.start_link([name: "Cleaner#{ i }"]) end)

```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `horde_background_job` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:horde_background_job, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/horde_background_job>.

