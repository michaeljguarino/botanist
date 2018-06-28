defmodule Mix.Tasks.Ecto.Seed do
  require Logger

  @shortdoc "runs all pending seeds"

  @moduledoc """
  Runs all pending seeds in `priv/repo/seeds` or, if configured, the `seeds_path` directory.
  If a seed has already run, it cannot be rerun. Failed seeds however, can be rerun.
  The generated migration filename will be prefixed with the current timestamp in UTC which is used for versioning and ordering.

  ### Example
  ```elixir
  mix ecto.seed
  ```
  """

  @doc false
  def run(_args) do
    Logger.configure(level: :info)

    Mix.Task.run("app.start", [])

    case run_seeds() do
      {:ok, failed_seeds} ->
        cond do
          length(failed_seeds) > 0 ->
            Logger.error("The following seeds failed to run:")
            Enum.each(failed_seeds, fn fs -> Logger.error(fs) end)

          true ->
            Logger.info("All seeds ran successfully.")
        end
    end
  end

  defp run_seeds() do
    {
      :ok,
      Enum.reject(
        Enum.map(Mix.Botanist.gather_seed_files(), fn seed_file ->
          Logger.info("Running seed #{seed_file}")
          run_seed(seed_file)
        end),
        &is_nil/1
      )
    }
  end

  defp run_seed(seed_file) do
    case Code.eval_file(seed_file) do
      {{:ok, _}, _} ->
        Logger.info("#{seed_file} ran successfully")
        nil

      {{:repeat, _}, _} ->
        Logger.info("#{seed_file} has already run")
        nil

      {{:error, error}, _} ->
        Logger.error("Error running #{seed_file}", error: error)
        seed_file
    end
  end
end
