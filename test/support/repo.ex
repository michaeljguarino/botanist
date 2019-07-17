defmodule Botanist.Repo do
  use Ecto.Repo, otp_app: :botanist,
                 adapter: Ecto.Adapters.Postgres
end
