# #!/bin/bash
# while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
# do
#   echo "$(date) - waiting for database to start"
#   sleep 2
# done

# # Create, migrate, and seed database if it doesn't exist.
# if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
#   echo "Database $PGDATABASE does not exist. Creating..."
#   createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
#   echo "Migrating..."
#   mix ecto.migrate
#   echo "Seeds..."
#   mix run priv/repo/seeds.exs
#   echo "Database $PGDATABASE created."
# fi

# exec mix phx.server

# File: my_app/entrypoint.sh
#!/bin/bash
# docker entrypoint script.

# assign a default for the database_user
DB_USER=${DATABASE_USER:-postgres}

# wait until Postgres is ready
while ! pg_isready -q -h $DATABASE_HOST -p 5432 -U $DB_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# # Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $DATABASE_DB does not exist. Creating..."
  createdb -E UTF8 $DATABASE_DB -l en_US.UTF-8 -T template0
  echo "Migrating..."
  mix ecto.migrate
  echo "Seeds..."
  mix run priv/repo/seeds.exs
  echo "Database $DATABASE_DB created."
fi

bin="/app/bin/fastpass"
# start the elixir application
exec "$bin" "start"
