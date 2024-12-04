defmodule ExpenseTrackerWeb.ExpensesLive.Show do
  alias ExpenseTracker.Accounts
  alias ExpenseTracker.Transactions
  alias ExpenseTrackerWeb.ExpensesLive.FormComponent
  use ExpenseTrackerWeb, :live_view

  def mount(_params, %{"user_token" => token}, socket) do
    socket =
      socket
      |> assign(:page_title, "Showing Expense")
      |> assign_new(:current_user, fn -> Accounts.get_user_by_session_token(token) end)

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, params, socket.assigns.live_action)}
  end

  def apply_actions(socket, _params, :edit) do
    socket
    |> assign(:page_title, "Edit Expense")
  end

  def apply_action(socket, %{"id" => id}, _live_action) do
    expense = Transactions.get_expense(id)

    assign(socket, :expense, expense)
  end

  def handle_info({:saved, expense_id}, socket) do
    expense = Transactions.get_expense(expense_id)

    {:noreply, assign(socket, :expense, expense)}
  end
end
