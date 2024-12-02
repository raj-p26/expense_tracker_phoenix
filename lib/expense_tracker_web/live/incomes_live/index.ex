defmodule ExpenseTrackerWeb.IncomesLive.Index do
  alias ExpenseTracker.Accounts
  alias ExpenseTrackerWeb.IncomesLive.FormComponent

  use ExpenseTrackerWeb, :live_view

  def mount(_params, %{"user_token" => token}, socket) do
    socket =
      socket
      |> assign(:page_id, :index)
      |> assign_new(:current_user, fn -> Accounts.get_user_by_session_token(token) end)

    {:ok, socket}
  end

  def handle_params(%{}, _, socket),
    do: {:noreply, apply_action(socket, socket.assigns.live_action)}

  def handle_event("add", _params, socket) do
    {:noreply, socket}
  end

  def apply_action(socket, :add) do
    socket
    |> assign(:page_title, "Add Income")
    |> assign(:page_id, :add)
  end

  def apply_action(socket, :index) do
    socket
    |> assign(:page_title, "Incomes")
  end

  def apply_action(socket, _param), do: socket
end
