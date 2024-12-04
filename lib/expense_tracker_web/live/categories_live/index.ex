defmodule ExpenseTrackerWeb.CategoriesLive.Index do
  alias ExpenseTracker.Categories
  alias ExpenseTracker.Accounts
  alias ExpenseTrackerWeb.CategoriesLive.FormComponent

  use ExpenseTrackerWeb, :live_view

  def mount(_params, %{"user_token" => token}, socket) do
    socket =
      socket
      |> assign_new(:user, fn -> Accounts.get_user_by_session_token(token) end)
      |> assign_categories

    {:ok, socket}
  end

  defp assign_categories(socket) do
    categories = Categories.list_categories_by_user_id(socket.assigns.user.id)

    socket
    |> stream(:categories, categories)
  end

  def handle_event("delete", %{"id" => id}, socket) do
    category = Categories.get_category!(id)
    {:ok, category} = Categories.delete_category(category)
    {:noreply, stream_delete(socket, :categories, category)}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action)}
  end

  def apply_action(socket, :new) do
    socket
    |> assign(:page_title, "New Category")
  end

  def apply_action(socket, :index) do
    socket
    |> assign(:page_title, "Categories")
  end

  def apply_action(socket, _live_action), do: socket

  def handle_info({:saved, category_id}, socket) do
    category = Categories.get_category(category_id)

    {:noreply, stream_insert(socket, :categories, category)}
  end
end
