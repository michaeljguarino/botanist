defmodule Botanist.EctoGenSeedTest do
  use Botanist.Case

  setup_all do
    File.mkdir(Path.join([File.cwd!(), "test", "tmp"]))
    Application.put_env(:botanist, :seeds_path, "test/tmp")
    File.rm_rf(Path.join([File.cwd!(), "test", "tmp"]))
    :ok
  end

  test "seed generation" do
    with_mock NaiveDateTime,
      utc_now: fn ->
        %NaiveDateTime{
          calendar: Calendar.ISO,
          day: 1,
          hour: 1,
          microsecond: {999_999, 6},
          minute: 1,
          month: 1,
          second: 1,
          year: 1
        }
      end do
      # -- Given
      #

      # -- When
      #
      Mix.Tasks.Ecto.Gen.Seed.run(["some_seed"])

      # -- Then
      #
      seed_files = Path.wildcard(Path.join(Mix.Botanist.seed_path(), "*_some_seed.exs"))
      assert length(seed_files) == 1
      assert Path.basename(Enum.at(seed_files, 0)) == "10101010101_some_seed.exs"

      # -- Clean up
      #
      Application.put_env(:botanist, :seeds_path, nil)
    end
  end
end
