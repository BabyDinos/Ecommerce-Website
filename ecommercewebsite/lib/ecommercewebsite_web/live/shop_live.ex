defmodule EcommercewebsiteWeb.ShopLive do
  use EcommercewebsiteWeb, :live_view

  alias Ecommercewebsite.Items
  alias Ecommercewebsite.Shop
  alias Ecommercewebsite.Accounts
  alias Ecommercewebsite.Accounts.UserInfo

  def render(assigns) do
    ~H"""
      <!DOCTYPE html>
      <head>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.0.0/flowbite.min.css" rel="stylesheet" />
      </head>
      <body>
        <div class = "relative w-full h-2/5 flex justify-center bg-[url('/images/home-background.jpg')] bg-auto bg-center bg-no-repeat">
          <%= if @show_edit_button do %>
            <div class="absolute justify-center items-center top-0 right-0 bg-white w-16 h-8 m-3 p-1 text-white">
              <span class="items-start align-top m-1 text-sm font-bold text-gray-900 dark:text-gray-300">Edit</span>
              <label class="relative inline-flex items-center cursor-pointer">
                <%= if @edit_mode do %>
                  <input type="checkbox" phx-click="toggle_edit_mode" value="" class="sr-only peer" checked>
                <% else %>
                  <input type="checkbox" phx-click="toggle_edit_mode" value="" class="sr-only peer">
                <% end %>
                <div class="w-11 h-6 bg-gray-200 rounded-full peer dark:bg-gray-700 peer-focus:ring-4 peer-focus:ring-green-300 dark:peer-focus:ring-green-800 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-green-600">
                </div>
              </label>

            </div>
          <% end %>


          <div class = "w-4/5">
            <div class = "w-full justify-center flex break-all" >
              <h1 class = "w-full flex text-white font-semibold text-8xl justify-center items-center align-middle text-center mt-64">
                <%= @shop_title %>
              </h1>
            </div>
            <div class = "w-full flex justify-center mt-4">
              <%= if @edit_mode do %>
                  <.form for={@shoptitle_form} phx-change="validate_shop_title" phx-submit="submit_shop_title">
                    <.input field={@shoptitle_form[:shop_title]} value={@shop_title} placeholder={@shop_title} type="text" required />
                    <div class = "justify-end w-full flex">
                      <button class = "mt-5 text-2xl text-black bg-green-600 p-4 rounded-md">Change Shop Title</button>
                    </div>
                  </.form>
              <% end %>
            </div>

            <div class = "w-full justify-center flex break-all" >
              <h2 class = "w-full flex text-white font-semibold text-5xl justify-center items-center align-middle text-center mt-64">
                <%= @shop_description %>
              </h2>
            </div>

            <div class = "w-full flex justify-center mt-4">
              <%= if @edit_mode do %>
                  <.form for={@shopdescription_form} phx-change="validate_shop_description" phx-submit="submit_shop_description">
                    <.input field={@shopdescription_form[:shop_description]} value={@shop_description} placeholder={@shop_description} type="text" required />
                    <div class = "justify-end w-full flex">
                      <button class = "mt-5 text-2xl text-black bg-green-600 p-4 rounded-md">Change Shop Description</button>
                    </div>
                  </.form>
              <% end %>
            </div>


          </div>
        </div>
        <div class = "w-full h-1/6 flex justify-center">
          <h1 class = "font-semibold text-8xl text-center mt-64">
          This is where my store will be

          </h1>
        </div>
        <div class = "w-2/5 h-1/8 flex mx-auto items-start justify-center">
          <%= if @edit_mode do %>
            <.button type="button" phx-click={show_modal("upload-form")} class = "w-2/6 h-1/6 font-medium text-6xl">Upload New Item</.button>
              <.modal id = "upload-form" >
                <.form for={@items_form} phx-change= "validate_new_item" phx-submit="upload_new_item"
                  class = "mt-[5%] ml-[5%] font-medium text-6xl w-3/5" enctype="multipart/form-data">
                  <.input field={@items_form[:item_name]} value = {@item_name} placeholder = {@item_name} type="text" label="Item Name" required />
                  <.input field={@items_form[:description]}  value = {@description} placeholder = {@description} type="textarea" label="Description" required />
                  <.input field={@items_form[:price]} value = {@price} placeholder = {@price} type="number" label="Price" required />
                  <.input field={@items_form[:quantity]} value = {@quantity} placeholder = {@quantity} type="number" label="Quantity" required />
                  <.live_file_input upload={@uploads.image} required class = "w-full text-xl mb-5"/>
                  <%= for entry <- @uploads.image.entries do %>
                    <.live_img_preview entry={entry} />
                  <% end %>
                  <div class = "justify-end w-full flex">
                    <button phx-click={hide_modal("upload-form")} class = "mt-5 text-2xl text-black bg-green-600 p-4 rounded-md">Submit</button>
                  </div>
                </.form>
              </.modal>
          <% end %>
        </div>
        <div class="m-12 grid grid-cols-3 gap-x-4 items-start justify-center space-y-0 w-full h-1/2">
          <%= for post <- Enum.slice(@posts, (@page_number - 1) * 9, (9)) do %>
            <div class="flex flex-col m-0">
              <div class = "flex items-center justify-center">
                <img src = {post.img_file_name} class = "max-w-full" />
              </div>
              <div class = "flex items-center justify-center">
                <div class = "items-center justify-center">
                  <h2> <%= post.item_name %> </h2>
                  <p>Description: <%= post.description %></p>
                  <p>Price: <%= post.price %></p>
                  <p>Quantity: <%= post.quantity %> </p>
                </div>
              </div>
              <%= if @edit_mode do %>
                <div class = "flex items-center justify-center">
                  <button class ="mt-5 text-2xl text-black bg-red-600 p-4 rounded-md" phx-click="delete_post" phx-value-id={post.id} phx-value-file_path={post.img_file_name} >DELETE</button>
                </div>
              <% end %>
            </div>
          <% end %>
        </div>
        <div class = "flex items-start justify-center pt-12 pb-12">
          <button class = "justify-center">
          Left Arrow
          </button>
          <form phx-change = "submit_page_number" class = "ml-5 mr-5">
            <input name = "input" value = {@page_number} placeholder = {@page_number} type="number" label="Page Number" />
          </form>
          <button class = "justify-center">
          Right Arrow
          </button>
        </div>
      <script src="../path/to/flowbite/dist/flowbite.min.js"></script>
      </body>
    """
    end

    def mount(%{"username" => username}, _session, socket) do
      case userinfo = Accounts.get_userinfo_by_username(username) do
        nil ->
          socket =
            socket
            |> put_flash(:error, "The shop #{username} does not exist")
            |> push_navigate(to: ~p"/")
          {:error, socket}
        _ ->
          shop_id = userinfo.id
          changeset = Items.changeset(%Items{})
          socket =
            reset_socket(socket, shop_id)
            |> assign(:show_edit_button, socket.assigns.current_user.id == userinfo.user_id)
            |> assign(:edit_mode, false)
            |> assign(userinfo: userinfo)
            |> assign(:shop_title, userinfo.shop_title)
            |> assign(:shop_description, userinfo.shop_description)
            |> assign(page_title: userinfo.shop_title)
            |> assign_form(changeset, "items", :items_form)
            |> allow_upload(:image, accept: ~w(.png .jpg), max_entries: 1, auto_upload: true)
          {:ok, socket}
        end
    end

    def reset_socket(socket, shop_id) do
      posts = Shop.get_items(shop_id)
      socket =
        socket
        |> assign(:page_number, 1)
        |> assign(:item_name, "")
        |> assign(:description, "")
        |> assign(:price, "")
        |> assign(:quantity, "")
        |> assign(:posts, posts)
      socket
    end

    def handle_event("toggle_edit_mode", _params, socket) do
      socket =
        if socket.assigns.edit_mode do
          put_flash(socket, :info, "You are exiting edit mode")
        else
          shoptitle_changeset = UserInfo.shop_title_changeset(%UserInfo{}, %{shop_title: socket.assigns.userinfo.shop_title})
          shopdescription_changeset = UserInfo.shop_description_changeset(%UserInfo{}, %{shop_description: socket.assigns.userinfo.shop_description})
          socket
            |> assign_form(shoptitle_changeset, "shoptitle", :shoptitle_form)
            |> assign_form(shopdescription_changeset, "shopdescription", :shopdescription_form)
            |> put_flash(:info, "You are now in edit mode")
        end
      socket = assign(socket, :edit_mode, not socket.assigns.edit_mode)
      {:noreply, socket}
    end

    def handle_event("validate_shop_title", %{"shoptitle" => userinfo}, socket) do
      changeset = UserInfo.shop_title_changeset(%UserInfo{}, userinfo)
      socket =
        socket
        |> assign(:shop_title, userinfo["shop_title"])
        |> assign_form(changeset, "shoptitle", :shoptitle_form)
      {:noreply, socket}
    end

    def handle_event("submit_shop_title", %{"shoptitle" => userinfo}, socket) do
      case Accounts.update_user_info(socket.assigns.userinfo.id, userinfo) do
        {:ok, _} ->
          {:noreply, put_flash(socket, :info, "Shop title successfully updated to #{userinfo["shop_title"]}")}
        {:error, _} ->
          {:noreply, put_flash(socket, :error, "Shop title not successfully updated")}
      end
    end

    def handle_event("validate_shop_description", %{"shopdescription" => userinfo}, socket) do
      changeset = UserInfo.shop_description_changeset(%UserInfo{}, userinfo)
      socket =
        socket
        |> assign(:shop_description, userinfo["shop_description"])
        |> assign_form(changeset, "shopdescription", :shopdescription_form)
        |> redirect(to: ~p"/")
      {:noreply, socket}
    end

    def handle_event("submit_shop_description", %{"shopdescription" => userinfo}, socket) do
      case Accounts.update_user_info(socket.assigns.userinfo.id, userinfo) do
        {:ok, _} ->
          {:noreply, put_flash(socket, :info, "Shop title successfully updated to #{userinfo["shop_description"]}")}
        {:error, _} ->
          {:noreply, put_flash(socket, :error, "Shop title not successfully updated")}
      end
    end

    def handle_event("validate_new_item", %{"items" => items}, socket) do
      changeset = Items.changeset(%Items{} ,items)
      socket =
        socket
        |> assign(:item_name, items["item_name"])
        |> assign(:description, items["description"])
        |> assign(:price, items["price"])
        |> assign(:quantity, items["quantity"])
        |> assign_form(changeset, "items", :items_form)
      {:noreply, socket}
    end

    def handle_event("upload_new_item", %{"items" => items}, socket) do
      case socket.assigns.uploads.image.entries do
        [%Phoenix.LiveView.UploadEntry{done?: true, ref: ref, client_name: client_name} | _] ->
          file_type = Path.extname(client_name)

          uploaded_entries = consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
              dest = Path.join("uploads", Path.basename(path)) <> file_type
              File.cp!(path, dest)
              {:postpone, "/uploads/#{Path.basename(dest)}"}
          end)

          case uploaded_entries do
            [first | _rest] ->
              items =
                items
                |> Map.put("img_file_name", first)
                |> Map.put("shop_id", socket.assigns.userinfo.id)
              res = Shop.upload_items(items)
              case res do
                {:ok, _items} ->
                  cancel_upload(socket, :image, ref)
                  socket =
                    reset_socket(socket, socket.assigns.userinfo.id)
                    |> assign_form(Items.changeset(%Items{}), "items", :items_form)
                  {:noreply, put_flash(socket, :info, "File #{client_name} has been uploaded!")}
                {:error, _}->
                  {:noreply, socket}
              end

            [] ->
              IO.puts("No files uploaded")
              {:noreply, socket}
            end
        _ ->
          # Files are still in progress, do not consume them yet
          {:noreply, put_flash(socket, :info, "file has not finished uploading")}
      end
    end

    def handle_event("submit_page_number", %{"input" => page_number}, socket) do
      page_number = String.to_integer(page_number)
      max_pages = :math.ceil(length(socket.assigns.posts) / 9)
      socket =
        socket
        |> assign(:page_number, max(1, min(page_number, max_pages)))
      {:noreply, socket}
    end

    def handle_event("delete_post", %{"id" => id, "file_path" => file_path}, socket) do
      socket =
        case Shop.delete_item(id) do
          {:ok, message} ->
            res = delete_file(file_path)
            IO.inspect(res)
            put_flash(socket, :info, message)
          {:error, message} ->
            put_flash(socket, :error, message)
        end
      {:noreply, reset_socket(socket, socket.assigns.userinfo.id)}
    end

    defp assign_form(socket, %Ecto.Changeset{} = changeset, name, form_name) do
      upload_form =
        changeset
        |> Map.put(:action, :validate)
        |> to_form(as: name)

      if changeset.valid? do
        socket
          |> assign(form_name, upload_form)
          |> assign(check_errors: false)
      else
        assign(socket, form_name, upload_form)
      end
    end

    defp delete_file(file_path) do

      full_path = Path.join(File.cwd!, file_path)
      IO.inspect(full_path)
      case File.rm(full_path) do
        :ok ->
          {:ok, "File deleted successfully"}

        {:error, reason} ->
          {:error, "File deletion failed: #{reason}"}
      end
    end
end
