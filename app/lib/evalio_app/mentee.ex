defmodule EvalioApp.Mentee do
  @moduledoc """
  Defines the Mentee struct and its functions.

  The struct represents a mentee in the system with attributes including:
  - id: Unique identifier
  - first_name: Mentee's first name
  - last_name: Mentee's last name
  - email: Mentee's email address
  - pronouns: Mentee's preferred pronouns
  - profile_picture: URL to a robohash.org avatar
  - cohort: Mentee's cohort identifier
  - batch: Mentee's batch number
  - attendance_percent: Percentage of attendance
  - assignment_percent: Percentage of assignments completed
  - is_expanded: Boolean indicating if the mentee's card is expanded
  """
  require Logger

  defstruct [
    :id,
    :first_name,
    :last_name,
    :email,
    :pronouns,
    :profile_picture,
    :cohort,
    :batch,
    :attendance_percent,
    :assignment_percent,
    :is_expanded
  ]

  def new(attrs) do
    Logger.info("Creating new mentee with ID: #{attrs[:id]}")

    %__MODULE__{
      id: attrs[:id],
      first_name: attrs[:first_name],
      last_name: attrs[:last_name],
      email: attrs[:email],
      pronouns: attrs[:pronouns],
      profile_picture: attrs[:profile_picture],
      cohort: attrs[:cohort],
      batch: attrs[:batch],
      attendance_percent: attrs[:attendance_percent],
      assignment_percent: attrs[:assignment_percent]
    }
  end

  @doc """
  Updates a mentee with new attributes.
  """
  def update(mentee, attrs) do
    Logger.info("Updating mentee with ID: #{mentee.id}")

    %{
      mentee
      | first_name: attrs[:first_name] || mentee.first_name,
        last_name: attrs[:last_name] || mentee.last_name,
        email: attrs[:email] || mentee.email,
        pronouns: attrs[:pronouns] || mentee.pronouns,
        profile_picture: attrs[:profile_picture] || mentee.profile_picture,
        cohort: attrs[:cohort] || mentee.cohort,
        batch: attrs[:batch] || mentee.batch,
        attendance_percent: attrs[:attendance_percent] || mentee.attendance_percent,
        assignment_percent: attrs[:assignment_percent] || mentee.assignment_percent
    }
  end

  @doc """
  Returns the full name of the mentee.
  """
  def full_name(mentee) do
    "#{mentee.first_name} #{mentee.last_name}"
  end

  @doc """
  Generates a new robohash.org profile picture URL for a mentee.
  The URL is based on the mentee's ID to ensure consistency.
  """
  def generate_profile_picture_url(mentee_id) do
    "https://robohash.org/#{mentee_id}.png?size=50x50&set=set1"
  end

  @doc """
  Updates a mentee's profile picture with a new robohash.org URL.
  """
  def update_profile_picture(mentee) do
    new_url = generate_profile_picture_url(mentee.id)
    Logger.info("Updating profile picture for mentee #{mentee.id} to #{new_url}")
    %{mentee | profile_picture: new_url}
  end

  @doc """
  Lists all mentees from the database.
  """
  def list_mentees do
    case Ecto.Adapters.SQL.query(EvalioApp.Repo, """
           SELECT mentee_id, first_name, last_name, email, pronouns,
                  profile_picture, cohort, batch, attendance_percent, assignment_percent
           FROM mentees
           ORDER BY first_name, last_name;
         """) do
      {:ok, %{rows: rows}} ->
        Enum.map(rows, &row_to_struct/1)

      {:error, error} ->
        Logger.error("Failed to fetch mentees: #{inspect(error)}")
        []
    end
  end

  @doc """
  Searches mentees by name or email.
  """
  def search_mentees(search_term) do
    search = "%#{search_term}%"

    case Ecto.Adapters.SQL.query(
           EvalioApp.Repo,
           """
             SELECT mentee_id, first_name, last_name, email, pronouns,
                    profile_picture, cohort, batch, attendance_percent, assignment_percent
             FROM mentees
             WHERE LOWER(first_name || ' ' || last_name) LIKE LOWER($1)
                OR LOWER(email) LIKE LOWER($1)
             ORDER BY first_name, last_name;
           """,
           [search]
         ) do
      {:ok, %{rows: rows}} ->
        Enum.map(rows, &row_to_struct/1)

      {:error, error} ->
        Logger.error("Failed to search mentees: #{inspect(error)}")
        []
    end
  end

  # Convert a database row to a Mentee struct
  defp row_to_struct([
         id,
         first_name,
         last_name,
         email,
         pronouns,
         profile_picture,
         cohort,
         batch,
         attendance_percent,
         assignment_percent
       ]) do
    %__MODULE__{
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email,
      pronouns: pronouns,
      profile_picture: profile_picture,
      cohort: cohort,
      batch: batch,
      attendance_percent: attendance_percent,
      assignment_percent: assignment_percent,
      is_expanded: false
    }
  end
end
