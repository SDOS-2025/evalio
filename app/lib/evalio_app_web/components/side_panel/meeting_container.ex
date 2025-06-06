defmodule EvalioAppWeb.MeetingContainer do
  use EvalioAppWeb, :live_component
  alias PetalComponents.Card
  alias EvalioAppWeb.MeetingCard
  alias EvalioAppWeb.MeetingFormComponent
  alias EvalioAppWeb.TagManager
  alias EvalioApp.Meeting
  alias EvalioApp.Meetings
  require Logger

  def render(assigns) do
    ~H"""
    <div>
      <Card.card class="w-400 mx-auto aspect-square bg-white dark:bg-gray-800 shadow-md rounded-2xl relative p-4 flex flex-col">
        <div class="flex justify-between items-center">
          <h4 class="text-xl font-bold text-gray-800 dark:text-gray-200">Meetings</h4>
          <button phx-click="show_meeting_form" phx-target={@myself}>
            <span class="text-2xl text-gray-600 dark:text-gray-300">+</span>
          </button>
        </div>

        <div class="mt-4 flex-grow w-[350px] max-h-[310px] overflow-y-auto bg-transparent rounded-lg px-0 py-2 space-y-2">
          <%= for {meeting, index} <- Enum.with_index(@sorted_meetings) do %>
            <.live_component
              module={MeetingCard}
              id={"meeting-#{meeting.id}"}
              meeting={meeting}
              on_edit="edit_meeting"
            />
          <% end %>
        </div>
      </Card.card>

      <%= if @show_meeting_form do %>
        <div class="fixed inset-0 z-[9999]">
          <div class="fixed inset-0 bg-black/30 backdrop-blur-lg"></div>
          <div class="fixed inset-0 flex items-center justify-center">
            <div class="relative z-[10000]">
              <.live_component
                module={MeetingFormComponent}
                id="meeting_form"
                myself={@myself}
                meeting={@editing_meeting}
                current_user={@current_user}
              />
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  def update(%{update_meeting_tag: {id, tag}} = assigns, socket) do
    # Find the meeting in the current list
    meeting = Enum.find(socket.assigns.meetings, &(&1.id == id))

    if meeting do
      # Update the meeting's tag in the database
      case Meetings.update_meeting_tag(meeting, tag) do
        {:ok, updated_meeting} ->
          # Update the meetings list
          updated_meetings =
            Enum.map(socket.assigns.meetings, fn m ->
              if m.id == id, do: updated_meeting, else: m
            end)

          # Sort the meetings
          sorted_meetings = sort_meetings(updated_meetings)

          {:ok, assign(socket, meetings: updated_meetings, sorted_meetings: sorted_meetings)}

        {:error, _changeset} ->
          {:ok, socket}
      end
    else
      {:ok, socket}
    end
  end

  def update(%{delete_meeting_id: id} = _assigns, socket) do
    # Get the meeting from the database
    case Meetings.get_meeting!(id) do
      nil ->
        {:ok, socket}

      meeting ->
        # Delete from database
        case Meetings.delete_meeting(meeting) do
          {:ok, _} ->
            # Update UI state
            updated_meetings = Enum.reject(socket.assigns.meetings, &(&1.id == id))
            sorted_meetings = sort_meetings(updated_meetings)

            {:ok,
             assign(socket,
               meetings: updated_meetings,
               sorted_meetings: sorted_meetings
             )}

          {:error, _} ->
            {:ok, socket}
        end
    end
  end

  def update(%{edit_meeting_id: id} = _assigns, socket) do
    # Find the meeting to edit
    meeting = Enum.find(socket.assigns.meetings, &(&1.id == id))

    socket =
      socket
      |> assign(:show_meeting_form, true)
      |> assign(:editing_meeting, meeting)

    {:ok, socket}
  end

  def update(assigns, socket) do
    meetings = assigns[:meetings] || []

    # Log the data for debugging
    Logger.info("MeetingContainer update - Meetings: #{inspect(meetings)}")

    # Sort meetings
    sorted_meetings = sort_meetings(meetings)

    socket =
      socket
      |> assign(:meetings, meetings)
      |> assign(:sorted_meetings, sorted_meetings)
      |> assign(:show_meeting_form, assigns[:show_meeting_form] || false)
      |> assign_new(:editing_meeting, fn -> nil end)
      |> assign_new(:current_user, fn -> assigns[:current_user] || %{} end)

    Logger.info("Current user in MeetingContainer: #{inspect(socket.assigns[:current_user])}")

    {:ok, socket}
  end

  def handle_event("show_meeting_form", _params, socket) do
    {:noreply, assign(socket, show_meeting_form: true, editing_meeting: nil)}
  end

  def handle_event("edit_meeting", %{"id" => id}, socket) do
    meeting = Meetings.get_meeting!(id)

    socket =
      socket
      |> assign(:show_meeting_form, true)
      |> assign(:editing_meeting, meeting)

    {:noreply, socket}
  end

  def handle_event("delete_meeting", %{"id" => id}, socket) do
    case Meetings.get_meeting!(id) do
      nil ->
        {:noreply, socket}

      meeting ->
        case Meetings.delete_meeting(meeting) do
          {:ok, _} ->
            Logger.info("Meeting deleted successfully: #{id}")
            updated_meetings = Enum.reject(socket.assigns.meetings, &(&1.id == id))
            sorted_meetings = sort_meetings(updated_meetings)

            {:noreply,
             assign(socket, meetings: updated_meetings, sorted_meetings: sorted_meetings)}

          {:error, _} ->
            Logger.error("Failed to delete meeting: #{id}")
            {:noreply, socket}
        end
    end
  end

  def handle_event(
        "save_meeting",
        %{"date" => date, "time" => time, "title" => title, "link" => link},
        socket
      ) do
    if date == "" or time == "" or title == "" or link == "" do
      {:noreply, socket}
    else
      editing_meeting = socket.assigns[:editing_meeting]

      cond do
        editing_meeting == nil or Map.get(editing_meeting, :id) == nil ->
          # Create new meeting
          case Meetings.create_meeting(%{
                 title: title,
                 date: date,
                 time: time,
                 link: link,
                 tag: "none"
               }) do
            {:ok, saved_meeting} ->
              updated_meetings = [saved_meeting | socket.assigns.meetings]
              sorted_meetings = sort_meetings(updated_meetings)

              socket =
                socket
                |> assign(:meetings, updated_meetings)
                |> assign(:sorted_meetings, sorted_meetings)
                |> assign(:show_meeting_form, false)
                |> assign(:editing_meeting, nil)

              {:noreply, socket}

            {:error, _changeset} ->
              {:noreply, socket}
          end

        true ->
          # Update existing meeting
          case Meetings.update_meeting(editing_meeting, %{
                 title: title,
                 date: date,
                 time: time,
                 link: link
               }) do
            {:ok, saved_meeting} ->
              updated_meetings =
                Enum.map(socket.assigns.meetings, fn m ->
                  if m.id == editing_meeting.id do
                    saved_meeting
                  else
                    m
                  end
                end)

              sorted_meetings = sort_meetings(updated_meetings)

              socket =
                socket
                |> assign(:meetings, updated_meetings)
                |> assign(:sorted_meetings, sorted_meetings)
                |> assign(:show_meeting_form, false)
                |> assign(:editing_meeting, nil)

              {:noreply, socket}

            {:error, _changeset} ->
              {:noreply, socket}
          end
      end
    end
  end

  def handle_event("hide_meeting_form", _params, socket) do
    {:noreply, assign(socket, :show_meeting_form, false)}
  end

  def handle_event("create_gmeet", %{"title" => title, "date" => date, "time" => time}, socket) do
    Logger.info("create_gmeet event triggered")

    if date == "" or time == "" or title == "" do
      Logger.info("Missing required fields for GMeet creation")

      {:noreply,
       put_flash(
         socket,
         :error,
         "Please fill in title, date, and time before creating a Google Meet link."
       )}
    else
      user = socket.assigns[:current_user] || %{}
      email = user["email"] || user[:email] || ""
      Logger.info("Attempting to fetch tokens for email: #{email}")

      tokens_url = "http://127.0.0.1:5000/api/user_tokens?email=#{email}"
      Logger.info("Calling Flask tokens endpoint: #{tokens_url}")

      case HTTPoison.get(tokens_url, [], hackney: [recv_timeout: 5000]) do
        {:ok, %HTTPoison.Response{status_code: 200, body: tokens_body}} ->
          Logger.info("Received tokens from Flask: #{tokens_body}")

          %{"session_token" => session_token, "refresh_token" => refresh_token} =
            Jason.decode!(tokens_body)

          start_time = "#{date}T#{time}:00+05:30"
          end_time = "#{date}T#{add_one_hour(time)}:00+05:30"

          body = %{
            "title" => title,
            "start_time" => start_time,
            "end_time" => end_time,
            "token" => session_token,
            "refresh_token" => refresh_token
          }

          Logger.info("Calling Flask create_gmeet endpoint")

          case HTTPoison.post("http://127.0.0.1:5000/api/create_gmeet", Jason.encode!(body), [
                 {"Content-Type", "application/json"}
               ]) do
            {:ok, %HTTPoison.Response{status_code: 200, body: resp_body}} ->
              Logger.info("Received meet link from Flask: #{resp_body}")
              %{"meet_link" => meet_link} = Jason.decode!(resp_body)

              updated_meeting =
                case socket.assigns[:editing_meeting] do
                  nil ->
                    %{
                      id: nil,
                      title: title,
                      date: date,
                      time: time,
                      link: meet_link,
                      tag: "none"
                    }

                  meeting ->
                    Map.merge(meeting, %{
                      title: title,
                      date: date,
                      time: time,
                      link: meet_link
                    })
                end

              {:noreply, assign(socket, editing_meeting: updated_meeting)}

            error ->
              Logger.error("HTTPoison failed (create_gmeet): #{inspect(error)}")
              {:noreply, put_flash(socket, :error, "Failed to create Google Meet link")}
          end

        {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
          Logger.error("Failed to fetch tokens: status=#{status}, body=#{body}")

          {:noreply,
           put_flash(
             socket,
             :error,
             "Failed to fetch Google tokens for user. Please re-authenticate with Google."
           )}

        error ->
          Logger.error("HTTPoison failed (user_tokens): #{inspect(error)}")

          {:noreply,
           put_flash(
             socket,
             :error,
             "Failed to fetch Google tokens for user. Please re-authenticate with Google."
           )}
      end
    end
  end

  defp add_one_hour(time_str) do
    [h, m] = String.split(time_str, ":") |> Enum.map(&String.to_integer/1)
    h = rem(h + 1, 24)

    "#{String.pad_leading(Integer.to_string(h), 2, "0")}:#{String.pad_leading(Integer.to_string(m), 2, "0")}"
  end

  # Helper function to sort meetings
  defp sort_meetings(meetings) do
    Enum.sort_by(meetings, fn meeting ->
      {meeting.date, meeting.time}
    end)
  end
end
