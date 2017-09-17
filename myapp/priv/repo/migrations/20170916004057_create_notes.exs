defmodule Myapp.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :word, :string

      timestamps()
    end

  end
end
