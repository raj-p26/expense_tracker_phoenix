defmodule ExpenseTrackerWeb.ExpensesLive.Index do
  # alias ExpenseTracker.Transactions
  alias ExpenseTracker.Transactions
  alias ExpenseTracker.Transactions.Expense
  alias ExpenseTracker.Accounts
  use ExpenseTrackerWeb, :live_view

  alias ExpenseTrackerWeb.ExpensesLive.FormComponent

  def mount(_params, %{"user_token" => token}, socket) do
    socket =
      socket
      |> assign_new(:current_user, fn -> Accounts.get_user_by_session_token(token) end)
      |> assign_expenses

    {:ok, socket}
  end

  defp assign_expenses(socket) do
    expenses = Transactions.list_expenses(socket.assigns.current_user.id)

    socket
    |> stream(:expenses, expenses)
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_actions(socket, socket.assigns.live_action, params)}
  end

  def apply_actions(socket, :new, _params) do
    socket
    |> assign(:expense, %Expense{})
    |> assign(:page_title, "New Expense")
  end

  def apply_actions(socket, :index, _params) do
    socket
    |> assign(:page_title, "Expenses")
  end

  def apply_actions(socket, :edit, %{"id" => id}) do
    expense = Transactions.get_expense(id)

    socket
    |> assign(:page_title, "Edit Expense")
    |> assign(:expense, expense)
  end

  def apply_actions(socket, _live_action, _params), do: socket

  def handle_info({:saved, expense_id}, socket) do
    expense = Transactions.get_expense(expense_id)

    {:noreply,
     socket
     |> stream_insert(:expenses, expense)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    expense = Transactions.get_expense!(id)
    {:ok, expense} = Transactions.delete_expense(expense)

    {:noreply, stream_delete(socket, :expenses, expense)}
  end
end
