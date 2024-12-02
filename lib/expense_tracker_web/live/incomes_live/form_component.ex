defmodule ExpenseTrackerWeb.IncomesLive.FormComponent do
  alias ExpenseTracker.Categories
  use ExpenseTrackerWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>
      <% IO.inspect(assigns) %>
      <%!-- <.simple_form for={@for}></.simple_form> --%>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:user_categories, Categories.get_category_by_user_id(assigns.user.id))

    {:ok, socket}
  end
end
