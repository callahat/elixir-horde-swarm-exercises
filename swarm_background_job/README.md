# SwarmBackgroundJob

```
iex --sname nX -S mix

# see whats registered
Swarm.registered

# kill the process
SwarmBackgroundJob.DatabaseCleaner |> Swarm.whereis_name |> GenServer.call(:derp)
```
