defmodule Mix.Tasks.Ecto.Gen.Seed do
  use Mix.Task
  import Mix.Generator

  @shortdoc "generates new seed"

  @moduledoc """
  Creates a new seed file in `priv/repo/seeds` or your `seeds_path` if configured.

  ### Example
  ```elixir
  mix ecto.gen.seed my_seed
  ```
  The generated migration filename will be prefixed with the current timestamp in UTC which is used for versioning and ordering.
  """

  @doc false
  def run(args) do
    case OptionParser.parse(args) do
      {_, [name], _} ->
        path = Mix.Botanist.seed_path()
        unless File.dir?(path), do: File.mkdir(path)
        base_name = "#{Macro.underscore(name)}.exs"

        fuzzy_path = Path.join(path, "*_#{base_name}")

        if Path.wildcard(fuzzy_path) != [] do
          Mix.raise("seed can't be created, there is already a seed file with name #{name}.")
        end

        Path.join(path, "#{timestamp()}_#{base_name}")
        |> create_file(seed_template([]))

      {_, _, _} ->
        Mix.raise("Expected a seed name e.g. mix.ecto.gen my_seed")
    end
  end

  defp timestamp do
    n = NaiveDateTime.utc_now()
    "#{n.year}#{pad(n.month)}#{pad(n.day)}#{pad(n.hour)}#{pad(n.minute)}#{pad(n.second)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)

  embed_template(:seed, """
  import Botanist

  seed do

  end
  """)
end
