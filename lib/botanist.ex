defmodule Botanist do
  @moduledoc """
  Botanist is an atomic seeding library which uses [Ecto](https://github.com/elixir-ecto/ecto). Its intended purpose
  is for run-once seeding of a database in a safe and intelligent manner.
  """

  @doc """
  Macro for seeding the database. No seed can be run more than once. If extra data is to be added or
  removed, a new seed must be generated with `mix ecto.gen.seed`.

  ### Example
  ```elixir
  import Botanist

  alias MyApp.Repo
  alias MyApp.User

  seed do
    Repo.insert(%User{email: "email@gmail.com", name: "John Smith"})
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
                 try do
                   case unquote(block) do
                     {:error, error} -> Repo.rollback(error)
                     {:ok, output} -> output
                     out = output -> output
                   end
                 rescue
                   error -> Repo.rollback(error.message)
                 catch
                   error -> Repo.rollback(error)
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
end
