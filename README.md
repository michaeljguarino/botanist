# Botanist

Botanist is a seeding library which uses [Ecto](https://github.com/elixir-ecto/ecto). Its intended purpose
is for run-once seeding of a database in a safe and intelligent manner.

### Installation
Add `botanist` to your `mix.exs` file:
```elixir
  defp deps do
    [
      {:ecto, "~> 2.2.10"},
      {:postgrex, "~> 0.11"},
      {:botanist, "~> 0.1.0"}, # <--
    ]
  end
```

### Set up
Configure `Botanist` by passing in your repo via your `config.exs`:
```elixir
config :botanist, 
  ecto_repo: MyApp.Repo
```
You can also configure the following fields:
```elixir
seeds_path: "priv/repo/seeds" # Location of seed files, defaults to priv/repo/seeds
```

### Usage
Botanist is very similar to `Ecto` in terms of usage. To generate a seed, run:
 ```elixir
 mix ecto.gen.seed my_seed
 ```
You'll find this seed in either the `seeds_path` field you listed in your config or in the 
`priv/repo/seeds` directory by default. 

Tell the seed what to do (see the example) and run your seed with 
```elixir
mix ecto.seed
``` 
Voila! Your database has now been seeded.

### Example seed file
```elixir
import Botanist

alias MyApp.Repo
alias MyApp.User

seed do
  Repo.insert(%User{email: "email@gmail.com", name: "John Smith"})
end
```

### [Documentation](https://hexdocs.pm/botanist/api-reference.html)