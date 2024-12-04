defmodule ExpenseTrackerWeb.IncomesLive.Show do
  use ExpenseTrackerWeb, :live_view

  alias ExpenseTracker.Accounts
  alias ExpenseTracker.Transactions
  alias ExpenseTrackerWeb.IncomesLive.FormComponent

  @impl true
  def mount(%{"id" => id}, %{"user_token" => token}, socket) do
    socket =
      socket
      |> assign(:income, Transactions.get_income(id))
      |> assign(:page_title, "Showing Details")
      |> assign(:page_id, :show)
      |> assign_new(:current_user, fn -> Accounts.get_user_by_session_token(token) end)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket =
      socket
      |> assign(:page_id, :edit)
      |> assign(:page_title, "Edit Income")

    {:noreply, socket}
  end

  @impl true
  def handle_info({:created, income}, socket) do
    {:noreply, assign(socket, :income, income)}
  end
end
