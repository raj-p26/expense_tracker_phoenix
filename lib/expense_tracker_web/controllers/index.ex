defmodule ExpenseTrackerWeb.Index do
  use ExpenseTrackerWeb, :controller

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      redirect(conn, to: "/incomes")
    else
      redirect(conn, to: "/users/log_in")
    end

    conn
  end
end
