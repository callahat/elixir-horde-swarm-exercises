# SwarmBackgroundJob

```
iex --sname nX -S mix

# see whats registered
Swarm.registered

# kill the process
SwarmBackgroundJob.DatabaseCleaner |> Swarm.whereis_name |> GenServer.call(:derp)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `swarm_background_job` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:swarm_background_job, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/swarm_background_job>.

