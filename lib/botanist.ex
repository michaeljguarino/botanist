defmodule Botanist do
  @moduledoc """
  Botanist is a seeding library which uses [Ecto](https://github.com/elixir-ecto/ecto). Its intended purpose
  is for seeding a database in a safe and atomic manner.
  """

  @doc """
  Macro for seeding the database. No seed can be run more than once. If extra data is to be added or
  removed, a new seed must be generated with `mix ecto.gen.seed` or use `perennial_seed/1`.

  A seed must be encased in a function named `planter` to be run. Only a single seed can fit into a
  planter.

  ### Example
  ```elixir
  import Botanist

  alias MyApp.Repo
  alias MyApp.User

  def planter do
    seed do
      Repo.insert(%User{email: "email@gmail.com", name: "John Smith"})
    end
  end
  ```

  If at any point an error is thrown or raised or the `seed` returns `{:error, error_msg}`, the seed
  will be listed as failed. In order for the seed to take root, it will need to be corrected and reran.

  As the seed takes place in a transaction, it is not possible for a seed to run partially.
  """
  defmacro seed(do: block) do
    quote do
      alias unquote(Mix.Botanist.repo())
      alias Botanist.Seed
      alias Ecto.Changeset
      alias Botanist.Migrations.CreateSeedTable
      import Ecto.Query
      require Logger

      Seed.ensure_seed_table!(Repo)

      seed_name = Path.basename(__ENV__.file, ".exs")

      seeds =
        from(
          s in Seed,
          where: s.name == ^seed_name
        )
        |> Repo.all()

      cond do
        length(seeds) > 0 ->
          {:repeat, "The seed #{seed_name} has already run."}

        true ->
          case Repo.transaction(fn ->
                 case unquote(block) do
                   {:error, error} -> Repo.rollback(error)
                   _ = output -> output
                 end
               end) do
            {:ok, out} ->
              Repo.insert(%Seed{name: seed_name, inserted_at: NaiveDateTime.utc_now()})
              {:ok, out}

            {:error, error} ->
              Logger.error("Error occurred #{error}")
              {:error, error}

            other ->
              other
          end
      end
    end
  end

  @doc """
  Macro for seeds which can be run recurrently. Functionally equivilant to `seed/1` in terms of atomicity and robustness
  but will run every time `mix ecto.seed` is called rather than once.

  Unlike `seed/1`, multiple `perennial_seed` can be planted in a single `planter` function.

  ### Example
  ```elixir
  import Botanist

  def planter do
    perennial_seed do
      # Recurrent work here
    end
  end
  ```
  """
  defmacro perennial_seed(do: block) do
    quote do
      alias unquote(Mix.Botanist.repo())
      require Logger

      seed_name = Path.basename(__ENV__.file, ".exs")

      case Repo.transaction(
             fn ->
               case unquote(block) do
                 {:error, error} -> Repo.rollback(error)
                 _ = output -> output
               end
             end,
             timeout: :infinity,
             pool_timeout: :infinity
           ) do
        {:ok, out} ->
          out

        {:error, error} ->
          Logger.error("Error occurred #{error}")
          {:error, error}

        other ->
          other
      end
    end
  end
end
