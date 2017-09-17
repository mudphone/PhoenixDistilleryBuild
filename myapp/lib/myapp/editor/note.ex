defmodule Myapp.Editor.Note do
  use Ecto.Schema
  import Ecto.Changeset
  alias Myapp.Editor.Note


  schema "notes" do
    field :word, :string

    timestamps()
  end

  @doc false
  def changeset(%Note{} = note, attrs) do
    note
    |> cast(attrs, [:word])
    |> validate_required([:word])
  end
end
