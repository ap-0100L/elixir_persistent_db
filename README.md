# PersistentDb

**TODO: Add description**

## Installation

Use it as module, run as node!

### Config
#### Runtime config
```elixir
  config :persistent_db,
    cookie: get_env!(get_env_name!("CLUSTER_COOKIE"), :atom)

  config :persistent_db, ApiCore.Db.Persistent.Repo,
    hostname: get_env!(get_env_name!("POSTGRESQL_RW_DB_HOSTNAME"), :string),
    port: get_env!(get_env_name!("POSTGRESQL_DB_PORT"), :integer, 5432),
    database: get_env!(get_env_name!("POSTGRESQL_DB_NAME"), :string),
    username: get_env!(get_env_name!("POSTGRESQL_DB_USER_NAME"), :string),
    password: get_env!(get_env_name!("POSTGRESQL_DB_PASSWORD_NAME"), :string),
    after_connect: {
      ApiCore.Db.Persistent.Repo,
      :set_search_path,
      [get_env!(get_env_name!("POSTGRESQL_DB_SCHEMA_NAME"), :string)]
    },
    timeout: get_env!(get_env_name!("POSTGRESQL_TIMEOUT"), :integer, 60_000),
    # pool_timeout: 60_000,
    pool_size: get_env!(get_env_name!("POSTGRESQL_POOL_SIZE"), :integer, 100),
    max_overflow: get_env!(get_env_name!("POSTGRESQL_MAX_OVERFLOW"), :integer, 32),
    log: get_env!(get_env_name!("POSTGRESQL_LOG"), :atom, :info),
    show_sensitive_data_on_connection_error: get_env!(get_env_name!("POSTGRESQL_SHOW_SENSITIVE_DATA"), :boolean, false)
```

