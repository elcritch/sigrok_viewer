# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sigrok_viewer,
  ecto_repos: [SigrokViewer.Repo],
  generators: [binary_id: true]

config :sigrok_viewer,
  ip: {0, 0, 0, 0},
  port: 5555

# Configures the endpoint
config :sigrok_viewer, SigrokViewerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FFIY/g9W3Zx2TN4eLNDyHsTXFSZFKFEjtDh+PBy2DtNpDMpU22lMkTZjzXODJwqI",
  render_errors: [view: SigrokViewerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SigrokViewer.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
