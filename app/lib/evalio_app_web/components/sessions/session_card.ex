defmodule EvalioAppWeb.Components.Sessions.SessionCard do
  use Phoenix.Component
  import Phoenix.LiveView
  import PetalComponents

  attr :session, :map, required: true
  attr :on_click, :string, default: nil

  def session_card(assigns) do
    ~H"""
    <div
      class="bg-white rounded-lg shadow-md p-4 cursor-pointer hover:shadow-lg transition-shadow"
      phx-click={@on_click}
      phx-value-id={@session.id}
    >
      <div class="flex flex-col space-y-2">
        <div class="flex justify-between items-start">
          <div>
            <h3 class="text-lg font-semibold text-gray-900">{@session.topic}</h3>
            <p class="text-sm text-gray-500">{Calendar.strftime(@session.date, "%B %d, %Y")}</p>
          </div>
          <div class="text-right">
            <p class="text-sm text-gray-500">{@session.cohort}</p>
            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
              {@session.duration} min
            </span>
          </div>
        </div>

        <div class="flex justify-between items-center text-sm text-gray-600">
          <div>
            <span class="font-medium">Attendees:</span>
            <span>{@session.num_attendees}</span>
          </div>
          <div>
            <span class="font-medium">Attendance:</span>
            <span>{Float.round(@session.attendance_percentage, 1)}%</span>
          </div>
        </div>

        <div class="mt-2">
          <p class="text-sm text-gray-600 line-clamp-2">
            {if @session.transcript, do: @session.transcript, else: "No transcript available"}
          </p>
        </div>
      </div>
    </div>
    """
  end
end
