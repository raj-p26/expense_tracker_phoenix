defmodule ExpenseTrackerWeb.ExpensesLive.FormComponent do
  alias ExpenseTracker.Categories
  alias ExpenseTracker.Transactions
  use ExpenseTrackerWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          Fill up these informations to create a new expense.
        </:subtitle>
      </.header>
      <.simple_form for={@expense_form} phx-change="validate" phx-submit="save" phx-target={@myself}>
        <.input field={@expense_form[:amount]} label="Amount:" />
        <.input
          field={@expense_form[:description]}
          label="Description:"
          placeholder="(Optional)"
          type="textarea"
        />
        <.input field={@expense_form[:add_date]} label="Date:" type="date" />
        <.input
          field={@expense_form[:category_id]}
          label="Category:"
          type="select"
          options={Enum.into(@categories, %{})}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    expense = Transactions.change_expense(assigns.expense)

    socket =
      socket
      |> assign(assigns)
      |> assign_new(:expense_form, fn -> to_form(expense) end)
      |> assign_categories

    {:ok, socket}
  end

  def assign_categories(socket) do
    categories = Categories.get_category_by_user_id(socket.assigns.user.id, "expense")

    assign(socket, :categories, categories)
  end

  @impl true
  def handle_event("validate", %{"expense" => expense_params}, socket) do
    changeset = Transactions.change_expense(socket.assigns.expense, expense_params)

    socket =
      socket
      |> assign(:expense_form, to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"expense" => expense_params}, socket) do
    expense_params = Map.put(expense_params, "user_id", socket.assigns.user.id)

    case socket.assigns.page_id do
      :new -> create_expense(socket, expense_params)
      :edit -> update_expense(socket, expense_params)
    end
  end

  def create_expense(socket, expense_params) do
    case Transactions.create_expense(expense_params) do
      {:ok, expense} ->
        notify_parent({:saved, expense.id})
        {:noreply, put_flash(socket, :info, "Expense Created!")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :expense_form, to_form(changeset))}
    end
  end

  def update_expense(socket, expense_params) do
    case Transactions.update_expense(socket.assigns.expense, expense_params) do
      {:ok, expense} ->
        notify_parent({:saved, expense.id})

        socket =
          socket
          |> put_flash(:info, "Expense Updated!")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :expense_form, to_form(changeset))}
    end
  end

  defp notify_parent(data), do: send(self(), data)
end
