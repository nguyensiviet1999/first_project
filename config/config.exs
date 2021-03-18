# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :first_project,
  ecto_repos: [FirstProject.Repo]

# Configures the endpoint
config :first_project, FirstProjectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9DwTnujk027xzvy1xddzUbhq7VAoqDKfA5qKpR0nEMJfsdh/fKVL4UZxzId75tex",
  render_errors: [view: FirstProjectWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FirstProject.PubSub,
  live_view: [signing_salt: "ARKcQJo0"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
