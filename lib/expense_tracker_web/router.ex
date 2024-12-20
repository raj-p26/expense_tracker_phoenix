defmodule ExpenseTrackerWeb.Router do
  use ExpenseTrackerWeb, :router

  import ExpenseTrackerWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ExpenseTrackerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExpenseTrackerWeb do
    pipe_through :browser

    get "/", Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExpenseTrackerWeb do
  #   pipe_through :api
  # end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:expense_tracker, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", ExpenseTrackerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", ExpenseTrackerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/incomes", IncomesLive.Index, :index
    live "/incomes/new", IncomesLive.Index, :new
    live "/incomes/:id/edit", IncomesLive.Index, :edit
    live "/incomes/:id/show", IncomesLive.Show
    live "/incomes/:id/show/edit", IncomesLive.Show, :edit

    live "/expenses", ExpensesLive.Index, :index
    live "/expenses/new", ExpensesLive.Index, :new
    live "/expenses/:id/edit", ExpensesLive.Index, :edit
    live "/expenses/:id/show", ExpensesLive.Show
    live "/expenses/:id/show/edit", ExpensesLive.Show, :edit

    live "/categories", CategoriesLive.Index, :index
    live "/categories/new", CategoriesLive.Index, :new

    live "/dashboard", DashboardLive

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", ExpenseTrackerWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
