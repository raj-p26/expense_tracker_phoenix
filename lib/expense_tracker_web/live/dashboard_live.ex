defmodule ExpenseTrackerWeb.DashboardLive do
  alias Contex.BarChart
  alias Contex.Plot
  alias Contex.Dataset

  alias ExpenseTracker.Transactions
  alias ExpenseTracker.Accounts

  use ExpenseTrackerWeb, :live_view

  def mount(_params, %{"user_token" => token}, socket) do
    socket =
      socket
      |> assign_new(:user, fn -> Accounts.get_user_by_session_token(token) end)
      |> assign_incomes_chart
      |> assign_expenses_chart

    {:ok, socket}
  end

  def assign_incomes_chart(%{assigns: assigns} = socket) do
    user_incomes = Transactions.get_avg_income(assigns.user.id)

    income_svg =
      if length(user_incomes) > 0 do
        income_dataset = Dataset.new(user_incomes)
        income_chart = BarChart.new(income_dataset)

        Plot.new(300, 300, income_chart)
        |> Plot.to_svg()
      else
        nil
      end

    assign(socket, :incomes_chart, income_svg)
  end

  def assign_expenses_chart(%{assigns: assigns} = socket) do
    user_expenses = Transactions.get_avg_expense(assigns.user.id)

    expense_svg =
      if length(user_expenses) > 0 do
        expense_dataset = Dataset.new(user_expenses)
        expense_chart = BarChart.new(expense_dataset)

        Plot.new(300, 300, expense_chart)
        |> Plot.to_svg()
      else
        nil
      end

    assign(socket, :expenses_chart, expense_svg)
  end

  def handle_params(%{}, _uri, socket), do: {:noreply, socket}
end
