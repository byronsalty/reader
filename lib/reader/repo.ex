defmodule Reader.Repo do
  use Ecto.Repo,
    otp_app: :reader,
    adapter: Ecto.Adapters.Postgres
end
