defmodule Refuge.Wildthings do
  @moduledoc """
  The Wildthings context.
  """

  import Ecto.Query, warn: false
  alias Refuge.Repo

  alias Refuge.Wildthings.Bear

  @doc """
  Returns the list of bears.

  ## Examples

      iex> list_bears()
      [%Bear{}, ...]

  """
  def list_bears do
    Repo.all(Bear)
  end

  @doc """
  Gets a single bear.

  Raises `Ecto.NoResultsError` if the Bear does not exist.

  ## Examples

      iex> get_bear!(123)
      %Bear{}

      iex> get_bear!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bear!(id), do: Repo.get!(Bear, id)

  @doc """
  Creates a bear.

  ## Examples

      iex> create_bear(%{field: value})
      {:ok, %Bear{}}

      iex> create_bear(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bear(attrs \\ %{}) do
    %Bear{}
    |> Bear.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bear.

  ## Examples

      iex> update_bear(bear, %{field: new_value})
      {:ok, %Bear{}}

      iex> update_bear(bear, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bear(%Bear{} = bear, attrs) do
    bear
    |> Bear.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Bear.

  ## Examples

      iex> delete_bear(bear)
      {:ok, %Bear{}}

      iex> delete_bear(bear)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bear(%Bear{} = bear) do
    Repo.delete(bear)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bear changes.

  ## Examples

      iex> change_bear(bear)
      %Ecto.Changeset{source: %Bear{}}

  """
  def change_bear(%Bear{} = bear) do
    Bear.changeset(bear, %{})
  end
end
