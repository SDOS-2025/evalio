# defmodule EvalioAppWeb.Components.Note.ReadingNote do
#   use EvalioAppWeb, :live_component
#   import PetalComponents

#   def render(assigns) do
#     ~H"""
#     <div class="fixed inset-0 z-[300] overflow-y-auto">
#       <div class="fixed inset-0 bg-black/30 backdrop-blur-lg"></div>
#       <div class="relative min-h-screen flex items-center justify-center p-4">
#         <div class="relative bg-white rounded-lg shadow-xl max-w-4xl w-full p-8">
#           <div class="absolute top-4 right-4">
#             <.button
#               type="button"
#               phx-click="close_read_mode"
#               color="white"
#               size="sm"
#               label="Close"
#               class="!p-2"
#             >
#               <.icon name="hero-x-mark" class="w-5 h-5" />
#             </.button>
#           </div>

#           <div class="mb-6">
#             <h1 class="text-3xl font-bold mb-2"><%= @note.title %></h1>
#             <div class="flex items-center space-x-4 text-sm text-gray-500">
#               <span><%= format_date(@note.created_at) %></span>
#               <span>•</span>
#               <span class="capitalize"><%= @note.tag %></span>
#             </div>
#           </div>

#           <div class="prose prose-lg max-w-none">
#             <%= raw Earmark.as_html!(@note.content) %>
#           </div>
#         </div>
#       </div>
#     </div>
#     """
#   end

#   defp format_date(date) do
#     Calendar.strftime(date, "%B %d, %Y")
#   end
# end
