defmodule Botanist.BotanistTest do
  use Botanist.Case

  import Botanist

  alias Botanist.Seed

  test "seed does not repeat" do
    # -- Given
    #
    Repo.insert(%Seed{name: "botanist_test", inserted_at: Seed.now()})

    # -- When
    #
    {:repeat, error_msg} =
      seed do
        {:ok, "hi"}
      end

    # -- Then
    #
    seeds =
      from(s in Seed)
      |> Repo.all()

    assert length(seeds) == 1
    seed_names = Enum.map(seeds, fn s -> s.name end)
    assert Enum.member?(seed_names, "botanist_test")
    assert error_msg == "The seed botanist_test has already run."
  end

  test "seed without explicit name" do
    seed do
      {:ok, "hi"}
    end

    expected =
      from(s in Seed)
      |> Repo.all()

    assert length(expected) == 1
    assert Enum.at(expected, 0).name == "botanist_test"
  end

  test "perennial seeding" do
    # -- Given
    #
    Repo.insert(%Seed{name: "botanist_test", inserted_at: Seed.now()})

    # -- When
    #
    {:ok, out} =
      perennial_seed do
        {:ok, "hi"}
      end

    # -- Then
    #
    assert out == "hi"
  end
end
