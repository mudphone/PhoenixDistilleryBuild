defmodule Myapp.ReleaseTasks do

  @myapp :myapp
  @myapp_repo Myapp.Repo
  
  @start_apps [
    :postgrex,
    :ecto
  ]
  
  @myapps [
    @myapp
  ]

  @repos [
    @myapp_repo
  ]

  defp initialize_app do
    info "Loading myapp.."
    # Load the code for myapp, but don't start it
    :ok = Application.load(@myapp)

    info "Starting dependencies.."
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for myapp
    info "Starting repos.."
    Enum.each(@repos, &(&1.start_link(pool_size: 1)))
  end

  def create do
    initialize_app()
    create_database()

    # Signal shutdown
    info "Success!"
    # :init.stop()
    System.halt(0)
  end
  
  def migrate do
    initialize_app()
        
    # Run migrations
    Enum.each(@myapps, &run_migrations_for/1)

    # Run the seed script if it exists
    # seed_script = Path.join([priv_dir(@myapp), "repo", "seeds.exs"])
    # if File.exists?(seed_script) do
    #   IO.puts "Running seed script.."
    #   Code.eval_file(seed_script)
    # end

    # Signal shutdown
    info "Success!"
    # :init.stop()
    System.halt(0)
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(app) do
    IO.puts "Running migrations for #{app}"
    Ecto.Migrator.run(@myapp_repo, migrations_path(app), :up, all: true)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
  # defp seed_path(app), do: Path.join([priv_dir(app), "repo", "seeds.exs"])

  defp info(message) do
    IO.puts(message)
  end

  defp fatal(message) do
    IO.puts :stderr, message
    System.halt(1)
  end
  
  defp create_database do
    info "Creating database for #{inspect @myapp_repo}.."
    # https://github.com/elixir-ecto/ecto/blob/master/lib/mix/tasks/ecto.create.ex
    case @myapp_repo.__adapter__.storage_up(@myapp_repo.config) do
      :ok ->
        info "The database for #{inspect @myapp_repo} has been created"
      {:error, :already_up} ->
        info "The database for #{inspect @myapp_repo} has already been created"
      {:error, term} when is_binary(term) ->
        fatal "The database for #{inspect @myapp_repo} couldn't be created: #{term}"
      {:error, term} ->
        fatal "The database for #{inspect @myapp_repo} couldn't be created: #{inspect term}"
    end
  end
  
end
