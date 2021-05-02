defmodule EctoMapSetTest.Repo do
  use Ecto.Repo,
    otp_app: :ecto_map_set,
    adapter: Ecto.Adapters.Postgres
end
