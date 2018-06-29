defmodule Botanist.Repo.Seeds.ThrowSeed do
  import Botanist

  def planter do
    seed do
      throw("bang bang")
    end
  end
end
