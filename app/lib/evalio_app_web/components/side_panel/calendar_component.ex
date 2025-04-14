defmodule EvalioAppWeb.CalendarComponent do
  use EvalioAppWeb, :live_component
  
  alias PetalComponents.Card
  alias EvalioAppWeb.CalendarHelper
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full h-full flex flex-col">
      <div class="flex justify-between items-center mb-2">
        <button phx-click="prev_month" phx-target={@myself} class="text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-white">
          <HeroiconsV1.Outline.chevron_left class="w-5 h-5" />
        </button>
        <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100">
          <%= CalendarHelper.month_name(@current_month) %> <%= @current_year %>
        </h3>
        <button phx-click="next_month" phx-target={@myself} class="text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-white">
          <HeroiconsV1.Outline.chevron_right class="w-5 h-5" />
        </button>
      </div>
      
      <div class="grid grid-cols-7 gap-1 mb-1">
        <%= for day <- ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"] do %>
          <div class="text-center text-xs font-medium text-gray-500 dark:text-gray-400">
            <%= day %>
          </div>
        <% end %>
      </div>
      
      <div class="grid grid-cols-7 gap-1 flex-grow">
        <%= for {day, index} <- Enum.with_index(@calendar_days) do %>
          <div 
            class={[
              "aspect-square p-1 rounded-md text-center text-sm relative cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700",
              day_class(day, @today, @selected_date)
            ]}
            phx-click="select_date"
            phx-value-date={CalendarHelper.format_date(day.date)}
            phx-target={@myself}
          >
            <div class="w-full h-full flex flex-col">
              <span class={[
                "text-xs font-medium",
                text_color_class(day, @today, @selected_date)
              ]}>
                <%= day.day %>
              </span>
              
              <%= if has_events?(day.date, @events) do %>
                <div class="mt-1 flex flex-wrap gap-1 justify-center">
                  <%= for event <- get_events_for_day(day.date, @events) do %>
                    <div class={[
                      "w-1.5 h-1.5 rounded-full",
                      event_color(event)
                    ]}></div>
                  <% end %>
                </div>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>
      
      <%= if @selected_date && has_events?(@selected_date, @events) do %>
        <div class="mt-4 p-2 bg-gray-100 dark:bg-gray-700 rounded-lg">
          <h4 class="text-sm font-semibold text-gray-800 dark:text-gray-200 mb-2">
            Events for <%= CalendarHelper.format_date(@selected_date) %>
          </h4>
          <div class="space-y-2">
            <%= for event <- get_events_for_day(@selected_date, @events) do %>
              <div class="flex items-center">
                <div class={[
                  "w-3 h-3 rounded-full mr-2",
                  event_color(event)
                ]}></div>
                <div>
                  <p class="text-xs font-medium text-gray-900 dark:text-gray-100">
                    <%= event.title %>
                  </p>
                  <p class="text-xs text-gray-500 dark:text-gray-400">
                    <%= event.time %>
                  </p>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
  
  @impl true
  def mount(socket) do
    today = Date.utc_today()
    current_month = today.month
    current_year = today.year
    
    socket = 
      socket
      |> assign(:today, today)
      |> assign(:current_month, current_month)
      |> assign(:current_year, current_year)
      |> assign(:selected_date, today)
      |> assign(:events, [])
      |> assign(:calendar_days, generate_calendar_days(current_month, current_year, today))
    
    {:ok, socket}
  end
  
  @impl true
  def update(assigns, socket) do
    events = CalendarHelper.convert_to_events(assigns[:reminders] || [], assigns[:meetings] || [])
    
    socket = 
      socket
      |> assign(assigns)
      |> assign(:events, events)
      |> assign(:calendar_days, generate_calendar_days(socket.assigns.current_month, socket.assigns.current_year, socket.assigns.today))
    
    {:ok, socket}
  end
  
  @impl true
  def handle_event("prev_month", _, socket) do
    {new_month, new_year} = 
      if socket.assigns.current_month == 1 do
        {12, socket.assigns.current_year - 1}
      else
        {socket.assigns.current_month - 1, socket.assigns.current_year}
      end
    
    socket = 
      socket
      |> assign(:current_month, new_month)
      |> assign(:current_year, new_year)
      |> assign(:calendar_days, generate_calendar_days(new_month, new_year, socket.assigns.today))
    
    {:noreply, socket}
  end
  
  @impl true
  def handle_event("next_month", _, socket) do
    {new_month, new_year} = 
      if socket.assigns.current_month == 12 do
        {1, socket.assigns.current_year + 1}
      else
        {socket.assigns.current_month + 1, socket.assigns.current_year}
      end
    
    socket = 
      socket
      |> assign(:current_month, new_month)
      |> assign(:current_year, new_year)
      |> assign(:calendar_days, generate_calendar_days(new_month, new_year, socket.assigns.today))
    
    {:noreply, socket}
  end
  
  @impl true
  def handle_event("select_date", %{"date" => date_string}, socket) do
    case Date.from_iso8601(date_string) do
      {:ok, date} ->
        socket = assign(socket, :selected_date, date)
        {:noreply, socket}
      _ ->
        {:noreply, socket}
    end
  end
  
  # Helper functions
  
  defp generate_calendar_days(month, year, today) do
    first_day = Date.new!(year, month, 1)
    last_day = Date.end_of_month(first_day)
    
    # Get the day of week for the first day (0 = Sunday, 6 = Saturday)
    first_day_of_week = day_of_week(first_day)
    
    # Calculate days from previous month to show
    prev_month_days = if first_day_of_week > 0, do: first_day_of_week, else: 6
    
    # Calculate total days to show (previous month + current month + next month)
    total_days = prev_month_days + last_day.day
    
    # Generate all days
    days = 
      if prev_month_days > 0 do
        # Get days from previous month
        prev_month = if month == 1, do: 12, else: month - 1
        prev_year = if month == 1, do: year - 1, else: year
        prev_month_last_day = Date.end_of_month(Date.new!(prev_year, prev_month, 1)).day
        
        prev_days = 
          for day <- (prev_month_last_day - prev_month_days + 1)..prev_month_last_day do
            %{
              day: day,
              date: Date.new!(prev_year, prev_month, day),
              current_month: false
            }
          end
        
        # Get days from current month
        current_days = 
          for day <- 1..last_day.day do
            %{
              day: day,
              date: Date.new!(year, month, day),
              current_month: true
            }
          end
        
        # Get days from next month
        next_month = if month == 12, do: 1, else: month + 1
        next_year = if month == 12, do: year + 1, else: year
        
        remaining_days = 42 - (length(prev_days) + length(current_days))
        
        next_days = 
          for day <- 1..remaining_days do
            %{
              day: day,
              date: Date.new!(next_year, next_month, day),
              current_month: false
            }
          end
        
        prev_days ++ current_days ++ next_days
      else
        # Get days from current month
        current_days = 
          for day <- 1..last_day.day do
            %{
              day: day,
              date: Date.new!(year, month, day),
              current_month: true
            }
          end
        
        # Get days from next month
        next_month = if month == 12, do: 1, else: month + 1
        next_year = if month == 12, do: year + 1, else: year
        
        remaining_days = 42 - length(current_days)
        
        next_days = 
          for day <- 1..remaining_days do
            %{
              day: day,
              date: Date.new!(next_year, next_month, day),
              current_month: false
            }
          end
        
        current_days ++ next_days
      end
    
    days
  end
  
  # Calculate the day of week (0 = Sunday, 6 = Saturday)
  defp day_of_week(date) do
    # Zeller's congruence algorithm
    q = date.day
    m = if date.month <= 2, do: date.month + 12, else: date.month
    y = if date.month <= 2, do: date.year - 1, else: date.year
    
    h = rem(q + ((13 * (m + 1)) |> div(5)) + y + (y |> div(4)) - (y |> div(100)) + (y |> div(400)), 7)
    
    # Convert to 0 = Sunday, 6 = Saturday format
    rem(h + 6, 7)
  end
  
  defp day_class(day, today, selected_date) do
    base_classes = "border border-transparent"
    
    cond do
      Date.compare(day.date, today) == :eq and Date.compare(day.date, selected_date) == :eq ->
        "#{base_classes} bg-gray-700 dark:bg-gray-300"
      Date.compare(day.date, today) == :eq ->
        "#{base_classes} bg-gray-300 dark:bg-gray-600"
      Date.compare(day.date, selected_date) == :eq ->
        "#{base_classes} bg-blue-200 dark:bg-blue-800"
      true ->
        base_classes
    end
  end
  
  defp text_color_class(day, today, selected_date) do
    cond do
      Date.compare(day.date, today) == :eq ->
        "text-white dark:text-gray-900"
      Date.compare(day.date, selected_date) == :eq and Date.compare(day.date, today) != :eq ->
        "text-gray-900 dark:text-gray-100"
      day.current_month ->
        "text-gray-900 dark:text-gray-100"
      true ->
        "text-gray-400 dark:text-gray-500"
    end
  end
  
  defp has_events?(date, events) do
    Enum.any?(events, fn event -> 
      event.date && Date.compare(event.date, date) == :eq
    end)
  end
  
  defp get_events_for_day(date, events) do
    Enum.filter(events, fn event -> 
      event.date && Date.compare(event.date, date) == :eq
    end)
  end
  
  defp event_color(event) do
    case event.type do
      :reminder -> "bg-yellow-500"
      :meeting -> "bg-green-500"
      _ -> "bg-gray-500"
    end
  end
end 