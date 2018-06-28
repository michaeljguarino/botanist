defmodule Botanist.EctoSeedTest do
  use Botanist.Case

  test "seed task" do
    # -- Given
    #

    # -- When
    #
    Mix.Tasks.Ecto.Seed.run([])

    # -- Then
    #
    seeds =
      from(s in Botanist.Seed)
      |> Repo.all()

    assert length(seeds) == 3
    assert Enum.at(seeds, 0).name == "20180628181051_test_seed_1"
    assert Enum.at(seeds, 1).name == "20180628181054_test_seed_2"
    assert Enum.at(seeds, 2).name == "20180628181057_test_seed_3"
  end
end
