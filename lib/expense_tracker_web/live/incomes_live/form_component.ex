defmodule ExpenseTrackerWeb.IncomesLive.FormComponent do
  alias ExpenseTracker.Categories
  alias ExpenseTracker.Transactions

  use ExpenseTrackerWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Fill up informations to add a new Income</:subtitle>
      </.header>
      <.simple_form
        for={@income_form}
        id="income-form"
        phx-change="validate"
        phx-target={@myself}
        phx-submit="submit"
      >
        <.input field={@income_form[:amount]} label="Amount:" />
        <.input field={@income_form[:description]} label="Description:" type="textarea" />
        <.input field={@income_form[:add_date]} label="Date:" type="date" />
        <.input
          field={@income_form[:category_id]}
          label="Category:"
          type="select"
          options={Enum.into(@user_categories, %{})}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{income: income} = assigns, socket) do
    income_changeset = Transactions.change_income(income)

    socket =
      socket
      |> assign(assigns)
      |> assign_new(:income_form, fn -> to_form(income_changeset) end)
      |> assign(:user_categories, Categories.get_category_by_user_id(assigns.user.id))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"income" => income_params}, socket) do
    changeset = Transactions.change_income(socket.assigns.income, income_params)

    {:noreply, assign(socket, :income_form, to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("submit", %{"income" => income_params}, socket) do
    income_params = Map.put(income_params, "user_id", socket.assigns.user.id)

    case socket.assigns.page do
      :new -> create_income(socket, income_params)
      :edit -> update_income(socket, income_params)
    end
  end

  defp create_income(socket, income_params) do
    case Transactions.create_income(income_params) do
      {:ok, income} ->
        socket =
          socket
          |> put_flash(:info, "Income added")
          |> push_patch(to: socket.assigns.patch)

        notify_parent({:created, income.id})

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :income_form, to_form(changeset))}
    end
  end

  defp update_income(%{assigns: %{income: income}} = socket, income_params) do
    case Transactions.update_income(income, income_params) do
      {:ok, income} ->
        notify_parent({:created, income.id})

        socket =
          socket
          |> put_flash(:info, "Income updated")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :income_form, to_form(changeset))}
    end
  end

  def notify_parent(data), do: send(self(), data)
end
