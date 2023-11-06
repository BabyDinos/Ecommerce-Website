defmodule EcommercewebsiteWeb.UserRegistrationLive do
  use EcommercewebsiteWeb, :live_view

  alias Ecommercewebsite.Accounts
  alias Ecommercewebsite.Accounts.User
  alias Ecommercewebsite.Accounts.UserInfo

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm flex flex-col items-center">
      <.header class="text-center mt-5 align-middle">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Sign in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <%= if @first_step == true do %>
        <.simple_form
          for={@form1}
          id="username_form"
          phx-change="validate_username"
          phx-submit="save"
          class = "align-middle justify-center min-w-full"
        >
          <.input field={@form1[:username]} type="text" label="Username" required />
          <.input field={@form1[:shop_title]} type="text" label="Shop Title" required />

          <.button phx-disable-with="Continue" class = "min-w-full">Continue</.button>
        </.simple_form>

      <% else %>
        <.simple_form
          for={@form2}
          id="registration_form"
          phx-submit="submit"
          phx-change="validate_registration"
          phx-trigger-action={@trigger_submit}
          action={~p"/users/log_in?_action=registered"}
          method="post"
          class = "align-middle justify-center min-w-full"
        >
          <.error :if={@check_errors}>
            Oops, something went wrong! Please check the errors below.
          </.error>

          <.input field={@form2[:email]} type="email" label="Email" required />
          <.input field={@form2[:password]} type="password" label="Password" required />

          <:actions>
            <.button phx-disable-with="Create Account..." class = "min-w-full">Create Account</.button>
          </:actions>
        </.simple_form>
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    username_changeset = UserInfo.changeset(%UserInfo{}, %{}, [validate_username: true, validate_shop_title: true])
    user_changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(:first_step, true)
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_username_form(username_changeset)
      |> assign_register_form(user_changeset)

    {:ok, socket}
  end

  def handle_event("validate_username", %{"userinfo" => user_params}, socket) do
    changeset = UserInfo.changeset(%UserInfo{}, user_params, [validate_username: true, validate_shop_title: true])
    {:noreply, assign_username_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("save", %{"userinfo" => user_params}, socket) do
    socket =
      socket
      |> assign(form1_data: user_params)
      |> assign(:first_step, false)
    {:noreply, socket}
  end

  def handle_event("validate_registration", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_register_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("submit", %{"user" => user}, socket) do

    user_info = socket.assigns.form1_data

    case Accounts.register_user(user, user_info) do
      {:ok, %{user: user, user_info: _user_info}} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_register_form(changeset)}

      {:error, %{user: user, user_info: _user_info}} ->
        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(check_errors: true) |> assign_register_form(changeset)}
    end
  end

  defp assign_username_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "userinfo")

    if changeset.valid? do
      assign(socket, form1: form, check_errors: false)
    else
      assign(socket, form1: form)
    end
  end

  defp assign_register_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form2: form, check_errors: false)
    else
      assign(socket, form2: form)
    end
  end
end
