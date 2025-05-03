# id
# cohort
# date
# duration
# transcript
# number of attendees
# attendance percentage

defmodule EvalioApp.Session do
  @moduledoc """
  Defines the Session struct and its functions.

  The struct represents a session in the system with attributes including:
  - id: Unique identifier
  - cohort: Associated cohort
  - date: Date of the session
  - duration: Duration of the session in minutes
  - transcript: Session transcript
  - num_attendees: Number of attendees
  - attendance_percentage: Percentage of attendance
  """
  require Logger

  defstruct [
    :id,
    :topic,
    :cohort,
    :date,
    :duration,
    :transcript,
    :num_attendees,
    :attendance_percentage
  ]

  def new(attrs) do
    Logger.info("Creating new session with ID: #{attrs[:id]}")

    %__MODULE__{
      id: attrs[:id],
      topic: attrs[:topic],
      cohort: attrs[:cohort],
      date: attrs[:date],
      duration: attrs[:duration],
      transcript: attrs[:transcript],
      num_attendees: attrs[:num_attendees],
      attendance_percentage: attrs[:attendance_percentage]
    }
  end

  @doc """
  Updates a session with new attributes.
  """
  def update(session, attrs) do
    Logger.info("Updating session with ID: #{session.id}")

    %{
      session
      | cohort: attrs[:cohort] || session.cohort,
        date: attrs[:date] || session.date,
        duration: attrs[:duration] || session.duration,
        transcript: attrs[:transcript] || session.transcript,
        num_attendees: attrs[:num_attendees] || session.num_attendees,
        attendance_percentage: attrs[:attendance_percentage] || session.attendance_percentage
    }
  end

  @doc """
  Lists all sessions from the database.
  """
  def list_sessions do
    case Ecto.Adapters.SQL.query(EvalioApp.Repo, """
           SELECT session_id, topic, cohort, date, duration, transcript,
                  num_attendees, attendance_percentage
           FROM sessions
           ORDER BY date DESC;
         """) do
      {:ok, %{rows: rows}} ->
        Enum.map(rows, &row_to_struct/1)

      {:error, error} ->
        Logger.error("Failed to fetch sessions: #{inspect(error)}")
        []
    end
  end

  @doc """
  Searches sessions by cohort or transcript content.
  """
  def search_sessions(search_term) do
    search = "%#{search_term}%"

    case Ecto.Adapters.SQL.query(
           EvalioApp.Repo,
           """
             SELECT session_id, topic, cohort, date, duration, transcript,
                    num_attendees, attendance_percentage
             FROM sessions
             WHERE LOWER(cohort) LIKE LOWER($1)
                OR LOWER(transcript) LIKE LOWER($1)
             ORDER BY date DESC;
           """,
           [search]
         ) do
      {:ok, %{rows: rows}} ->
        Enum.map(rows, &row_to_struct/1)

      {:error, error} ->
        Logger.error("Failed to search sessions: #{inspect(error)}")
        []
    end
  end

  @doc """
  Gets a session by ID.
  """
  def get_session(id) do
    case Ecto.Adapters.SQL.query(
           EvalioApp.Repo,
           """
             SELECT session_id, topic, cohort, date, duration, transcript,
                    num_attendees, attendance_percentage
             FROM sessions
             WHERE session_id = $1;
           """,
           [id]
         ) do
      {:ok, %{rows: [row]}} ->
        row_to_struct(row)

      {:ok, %{rows: []}} ->
        nil

      {:error, error} ->
        Logger.error("Failed to fetch session: #{inspect(error)}")
        nil
    end
  end

  @doc """
  Calculates attendance percentage based on number of attendees and total cohort size.
  """
  def calculate_attendance_percentage(num_attendees, total_cohort_size) do
    if total_cohort_size > 0 do
      Float.round(num_attendees / total_cohort_size * 100, 2)
    else
      0.0
    end
  end

  # Convert a database row to a Session struct
  defp row_to_struct([
         id,
         topic,
         cohort,
         date,
         duration,
         transcript,
         num_attendees,
         attendance_percentage
       ]) do
    %__MODULE__{
      id: id,
      topic: topic,
      cohort: cohort,
      date: date,
      duration: duration,
      transcript: transcript,
      num_attendees: num_attendees,
      attendance_percentage: attendance_percentage
    }
  end
end
