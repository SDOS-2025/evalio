defmodule EvalioApp.Mentor do
  @moduledoc """
  Defines the Mentor struct and its functions.

  The struct represents a mentor in the system with attributes including:
  - id: Unique identifier
  - first_name: Mentor's first name
  - last_name: Mentor's last name
  - email: Mentor's email address
  - pronouns: Mentor's preferred pronouns
  - profile_picture: URL to a robohash.org avatar
  - year_since: Year since the mentor started
  """
  require Logger

  defstruct [
    :id,
    :first_name,
    :last_name,
    :email,
    :pronouns,
    :profile_picture,
    :year_since
  ]

  def new(attrs) do
    Logger.info("Creating new mentor with ID: #{attrs[:id]}")

    %__MODULE__{
      id: attrs[:id],
      first_name: attrs[:first_name],
      last_name: attrs[:last_name],
      email: attrs[:email],
      pronouns: attrs[:pronouns],
      profile_picture: attrs[:profile_picture],
      year_since: attrs[:year_since]
    }
  end

  @doc """
  Updates a mentor with new attributes.
  """
  def update(mentor, attrs) do
    Logger.info("Updating mentor with ID: #{mentor.id}")

    %{
      mentor
      | first_name: attrs[:first_name] || mentor.first_name,
        last_name: attrs[:last_name] || mentor.last_name,
        email: attrs[:email] || mentor.email,
        pronouns: attrs[:pronouns] || mentor.pronouns,
        profile_picture: attrs[:profile_picture] || mentor.profile_picture,
        year_since: attrs[:year_since] || mentor.year_since
    }
  end

  @doc """
  Returns the full name of the mentor.
  """
  def full_name(mentor) do
    "#{mentor.first_name} #{mentor.last_name}"
  end

  @doc """
  Generates a new robohash.org profile picture URL for a mentor.
  The URL is based on the mentor's ID to ensure consistency.
  """
  def generate_profile_picture_url(mentor_id) do
    "https://robohash.org/#{mentor_id}.png?size=50x50&set=set1"
  end

  @doc """
  Updates a mentor's profile picture with a new robohash.org URL.
  """
  def update_profile_picture(mentor) do
    new_url = generate_profile_picture_url(mentor.id)
    Logger.info("Updating profile picture for mentor #{mentor.id} to #{new_url}")
    %{mentor | profile_picture: new_url}
  end

  @doc """
  Lists all mentors from the database.
  """
  def list_mentors do
    case Ecto.Adapters.SQL.query(EvalioApp.Repo, """
           SELECT mentor_id, first_name, last_name, email, pronouns,
                  profile_picture, year_since
           FROM mentors
           ORDER BY first_name, last_name;
         """) do
      {:ok, %{rows: rows}} ->
        Enum.map(rows, &row_to_struct/1)

      {:error, error} ->
        Logger.error("Failed to fetch mentors: #{inspect(error)}")
        []
    end
  end

  @doc """
  Searches mentors by name or email.
  """
  def search_mentors(search_term) do
    search = "%#{search_term}%"

    case Ecto.Adapters.SQL.query(
           EvalioApp.Repo,
           """
             SELECT mentor_id, first_name, last_name, email, pronouns,
                    profile_picture, year_since
             FROM mentors
             WHERE LOWER(first_name || ' ' || last_name) LIKE LOWER($1)
                OR LOWER(email) LIKE LOWER($1)
             ORDER BY first_name, last_name;
           """,
           [search]
         ) do
      {:ok, %{rows: rows}} ->
        Enum.map(rows, &row_to_struct/1)

      {:error, error} ->
        Logger.error("Failed to search mentors: #{inspect(error)}")
        []
    end
  end

  # Convert a database row to a Mentor struct
  defp row_to_struct([
         id,
         first_name,
         last_name,
         email,
         pronouns,
         profile_picture,
         year_since
       ]) do
    %__MODULE__{
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email,
      pronouns: pronouns,
      profile_picture: profile_picture,
      year_since: year_since
    }
  end
end
