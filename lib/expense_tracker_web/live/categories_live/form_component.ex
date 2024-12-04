defmodule ExpenseTrackerWeb.CategoriesLive.FormComponent do
  alias ExpenseTracker.Categories.Category
  alias ExpenseTracker.Categories

  use ExpenseTrackerWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        id="add-category"
        for={@category_form}
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
      >
        <.input field={@category_form[:name]} label="Category Name:" />
        <.input
          field={@category_form[:transaction_type]}
          label="Transaction Type:"
          type="select"
          options={[Expense: "expense", Income: "income"]}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def update(assigns, socket) do
    category = Categories.change_category(%Category{})

    socket =
      socket
      |> assign(assigns)
      |> assign(:category, %Category{})
      |> assign(:category_form, to_form(category))

    {:ok, socket}
  end

  def handle_event("validate", %{"category" => category_params}, socket) do
    category_params = Map.put(category_params, "user_id", socket.assigns.user.id)

    category = Categories.change_category(socket.assigns.category, category_params)

    {:noreply, assign(socket, :category_form, to_form(category, action: :validate))}
  end

  def handle_event("save", %{"category" => category_params}, socket) do
    category_params = Map.put(category_params, "user_id", socket.assigns.user.id)

    case Categories.create_category(category_params) do
      {:ok, category} ->
        notify_parent({:saved, category.id})

        socket =
          socket
          |> push_patch(to: ~p"/categories")
          |> put_flash(:info, "Category Created!")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        socket =
          socket
          |> put_flash(:error, "Some Error occured!")
          |> assign(:category_form, to_form(changeset, action: :validate))

        {:noreply, socket}
    end
  end

  defp notify_parent(data), do: send(self(), data)
end
