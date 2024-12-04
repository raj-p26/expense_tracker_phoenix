defmodule ExpenseTrackerWeb.IncomesLive.Index do
  alias ExpenseTracker.Transactions
  alias ExpenseTracker.Accounts
  alias ExpenseTracker.Transactions.Income
  alias ExpenseTrackerWeb.IncomesLive.FormComponent

  use ExpenseTrackerWeb, :live_view

  @impl true
  def mount(_params, %{"user_token" => token}, socket) do
    socket =
      socket
      |> assign_new(:current_user, fn -> Accounts.get_user_by_session_token(token) end)
      |> assign_incomes

    {:ok, socket}
  end

  def assign_incomes(socket) do
    stream(socket, :incomes, Transactions.list_incomes(socket.assigns.current_user.id))
  end

  @impl true
  def handle_event("delete", %{"id" => income_id}, socket) do
    income = Transactions.get_income!(income_id)

    {:ok, income} = Transactions.delete_income(income)
    {:noreply, stream_delete(socket, :incomes, income)}
  end

  @impl true
  def handle_params(params, _url, socket),
    do: {:noreply, apply_action(socket, socket.assigns.live_action, params)}

  @impl true
  def handle_info(data, socket) do
    {:noreply, apply_info(data, socket)}
  end

  def apply_info({:created, income_id}, socket) do
    income = Transactions.get_income(income_id)

    socket
    |> stream_insert(:incomes, income)
  end

  def apply_info(_data, socket), do: socket

  def apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Incomes")
  end

  def apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Add Income")
    |> assign(:page_id, :new)
    |> assign(:income, %Income{})
  end

  def apply_action(socket, :edit, %{"id" => id}) do
    income = Transactions.get_income(id)

    socket
    |> assign(:page_title, "Edit Income")
    |> assign(:page_id, :edit)
    |> assign(:income, income)
  end

  def apply_action(socket, _action, _params), do: socket
end
