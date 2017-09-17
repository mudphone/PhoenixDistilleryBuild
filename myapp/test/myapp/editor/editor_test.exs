defmodule Myapp.EditorTest do
  use Myapp.DataCase

  alias Myapp.Editor

  describe "notes" do
    alias Myapp.Editor.Note

    @valid_attrs %{word: "some word"}
    @update_attrs %{word: "some updated word"}
    @invalid_attrs %{word: nil}

    def note_fixture(attrs \\ %{}) do
      {:ok, note} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Editor.create_note()

      note
    end

    test "list_notes/0 returns all notes" do
      note = note_fixture()
      assert Editor.list_notes() == [note]
    end

    test "get_note!/1 returns the note with given id" do
      note = note_fixture()
      assert Editor.get_note!(note.id) == note
    end

    test "create_note/1 with valid data creates a note" do
      assert {:ok, %Note{} = note} = Editor.create_note(@valid_attrs)
      assert note.word == "some word"
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Editor.create_note(@invalid_attrs)
    end

    test "update_note/2 with valid data updates the note" do
      note = note_fixture()
      assert {:ok, note} = Editor.update_note(note, @update_attrs)
      assert %Note{} = note
      assert note.word == "some updated word"
    end

    test "update_note/2 with invalid data returns error changeset" do
      note = note_fixture()
      assert {:error, %Ecto.Changeset{}} = Editor.update_note(note, @invalid_attrs)
      assert note == Editor.get_note!(note.id)
    end

    test "delete_note/1 deletes the note" do
      note = note_fixture()
      assert {:ok, %Note{}} = Editor.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> Editor.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      note = note_fixture()
      assert %Ecto.Changeset{} = Editor.change_note(note)
    end
  end
end
