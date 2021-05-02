import Config

if Mix.env() == :test do
  config :ecto_map_set, ecto_repos: [EctoMapSetTest.Repo]

  if url = System.get_env("ECTO_MAP_SET_DB_URL") do
    config :ecto_map_set, EctoMapSetTest.Repo,
      url: url,
      pool: Ecto.Adapters.SQL.Sandbox
  else
    config :ecto_map_set, EctoMapSetTest.Repo,
      database: "ecto_map_set",
      username: System.get_env("ECTO_MAP_SET_DB_USERNAME", "postgres"),
      password: System.get_env("ECTO_MAP_SET_DB_PASSWORD", "postgres"),
      hostname: "localhost",
      pool: Ecto.Adapters.SQL.Sandbox
  end

  config :ecto_map_set, EctoMapSetTest.Repo, priv: "test"
end
