defmodule Mix.Botanist do
  @moduledoc false

  require Logger

  def repo do
    case Mix.env() do
      :test ->
        Botanist.Repo

      _ ->
        case Application.get_env(:botanist, :ecto_repo, nil) do
          nil ->
            Mix.raise(
              "A repo must be added to your Botanist config. Check your config.exs for the 'ecto_repo' field under botanist"
            )

          repo ->
            repo
        end
    end
  end

  def seed_path do
    seed_path =
      case Application.get_env(:botanist, :seeds_path, nil) do
        nil -> Path.join(["priv", "repo", "seeds"])
        seed_path -> seed_path
      end

    Path.join([File.cwd!(), seed_path])
  end

  def gather_seed_files() do
    Path.wildcard(Path.join(Mix.Botanist.seed_path(), "*.exs"))
  end

  def run_seed(seed_file) do
    basename = Path.basename(seed_file)

    case resolve_seed_module(seed_file) do
      {:ok, mod} ->
        case run_module(mod) do
          {:ok, _} ->
            Logger.info("#{basename} ran successfully")
            nil

          {:repeat, _} ->
            Logger.info("#{basename} has already run")
            nil

          {:error, error} ->
            Logger.error("Failed to run #{basename}")
            %{file: basename, msg: error}

          _ ->
            """
            Unexpected output at the end of #{basename}'s planter/1 function. Ensure that the output of a Botanist macro is returned.
            """
            |> Logger.warn()

            nil
        end

      {:error, error} ->
        Logger.error(error)
    end
  end

  defp run_module(mod) do
    try do
      mod.planter()
    rescue
      error -> {:error, Exception.message(error)}
    catch
      error when is_binary(error) -> {:error, error}
      error -> {:error, Exception.message(error)}
    end
  end

  defp resolve_seed_module(seed_file) do
    case Code.load_file(seed_file) do
      modules when is_list(modules) ->
        case Enum.find(modules, fn mod -> mod |> elem(0) |> is_seed_module?() end) do
          nil -> {:error, "#{Path.basename(seed_file)} does not have a Botanist created module"}
          {module, _bin} -> {:ok, module}
        end

      error ->
        {:error, "Failed to load #{Path.basename(seed_file)}: #{error}"}
    end
  end

  defp is_seed_module?(module) do
    base_module =
      module
      |> Module.split()
      |> Enum.slice(0, 3)
      |> Module.concat()

    base_module == Module.concat([Mix.Botanist.repo(), Seeds])
  end
end
