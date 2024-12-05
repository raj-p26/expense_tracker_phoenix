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
      |> assign_chart_svg

    {:ok, socket}
  end

  def assign_chart_svg(%{assigns: assigns} = socket) do
    user_incomes = Transactions.get_avg_income(assigns.user.id)
    user_expenses = Transactions.get_avg_expense(assigns.user.id)

    income_dataset = Dataset.new(user_incomes)
    expense_dataset = Dataset.new(user_expenses)

    income_chart = BarChart.new(income_dataset)
    expense_chart = BarChart.new(expense_dataset)

    income_svg =
      Plot.new(300, 300, income_chart)
      |> Plot.to_svg()

    expense_svg =
      Plot.new(300, 300, expense_chart)
      |> Plot.to_svg()

    assign(socket, incomes_chart: income_svg, expenses_chart: expense_svg)
  end
end
