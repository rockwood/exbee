use Mix.Config

config :exbee, adapter: Exbee.NervesUARTAdapter

import_config "#{Mix.env()}.exs"
