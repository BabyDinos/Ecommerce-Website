defmodule EcommercewebsiteWeb.ShopLive do
  use EcommercewebsiteWeb, :live_view

  alias Ecommercewebsite.Items
  alias Ecommercewebsite.Shop
  alias Ecommercewebsite.Accounts
  alias Ecommercewebsite.Accounts.UserInfo

  @posts_on_each_page 9

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
        cart = Shop.get_cart(socket.assigns.current_user.id)
        post = Shop.get_items_from_cart(cart)
        socket =
          socket
          |> reset_socket(shop_id)
          |> assign(:show_alert, false)
          |> assign(:alert_message, "")
          |> assign(:current_cart, cart)
          |> assign(:cart_posts, post)
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
      initial_form_data = for post <- posts, do: %{
        "item_name" => post.item_name,
        "description" => post.description,
        "price" => post.price,
        "quantity" => post.quantity,
        "id" => post.id
      }

      socket =
        socket
        |> assign(:form_data, initial_form_data)
        |> assign(:page_number, 0)
        |> assign(:item_name, "")
        |> assign(:description, "")
        |> assign(:price, "")
        |> assign(:quantity, "")
        |> assign(:posts, posts)
        |> assign(:posts_on_each_page, @posts_on_each_page)
        |> assign(:current_posts, min(length(posts), @posts_on_each_page))
        |> assign(:total_posts, length(posts))
      socket
    end

    def handle_event("toggle_edit_mode", _params, socket) do
      socket =
        if socket.assigns.edit_mode do
          socket
        else
          shoptitle_changeset = UserInfo.shop_title_changeset(%UserInfo{}, %{shop_title: socket.assigns.userinfo.shop_title})
          shopdescription_changeset = UserInfo.shop_description_changeset(%UserInfo{}, %{shop_description: socket.assigns.userinfo.shop_description})
          socket
            |> assign_form(shoptitle_changeset, "shoptitle", :shoptitle_form)
            |> assign_form(shopdescription_changeset, "shopdescription", :shopdescription_form)
        end
      socket =
        socket
        |> assign(:edit_mode, not socket.assigns.edit_mode)
      {:noreply, socket}
    end

    def handle_event("dismiss_alert", _params, socket) do
      socket = assign(socket, :show_alert, false)
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
      socket = case Accounts.update_user_info(socket.assigns.userinfo.id, userinfo) do
        {:ok, _} ->
          show_alert(socket, "Shop title successfully updated")
        {:error, _} ->
          show_alert(socket, "Shop title not successfully updated")
        end
      {:noreply, socket}
    end

    def handle_event("validate_shop_description", %{"shopdescription" => userinfo}, socket) do
      changeset = UserInfo.shop_description_changeset(%UserInfo{}, userinfo)
      socket =
        socket
        |> assign(:shop_description, userinfo["shop_description"])
        |> assign_form(changeset, "shopdescription", :shopdescription_form)
      {:noreply, socket}
    end

    def handle_event("submit_shop_description", %{"shopdescription" => userinfo}, socket) do
      socket = case Accounts.update_user_info(socket.assigns.userinfo.id, userinfo) do
        {:ok, _} ->
          show_alert(socket, "Shop description successfully updated")
        {:error, _} ->
          show_alert(socket, "Shop description not successfully updated")
      end
      {:noreply, socket}
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

    def handle_event("validate_old_item", %{"items" => items}, socket) do
      post_id = String.to_integer(items["id"])
      index = Enum.find_index(socket.assigns.form_data, fn %{ "id" => id } -> id == post_id end)
      new_data = %{
        "item_name" => items["item_name"],
        "description" => items["description"],
        "price" => items["price"],
        "quantity" => items["quantity"],
        "id" => post_id
      }
      form_data = List.replace_at(socket.assigns.form_data, index, new_data)

      changeset = Items.changeset(%Items{} ,items)
      socket =
        socket
        |> assign(:form_data, form_data)
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
              {:ok, "/uploads/#{Path.basename(dest)}"}
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
                    |> show_alert("File #{client_name} has been uploaded!")
                  {:noreply, socket}
                {:error, _}->
                  {:noreply, socket}
              end

            [] ->
              IO.puts("No files uploaded")
              {:noreply, socket}
            end
        _ ->
          # Files are still in progress, do not consume them yet
          socket =
            socket
            |> show_alert("File has not finished uploading")
          {:noreply, socket}
      end
    end

    def handle_event("update_item", %{"items" => items}, socket) do
      IO.inspect(items)
      old_img_file_name = items["old_img_file_name"]
      case socket.assigns.uploads.image.entries do
        [%Phoenix.LiveView.UploadEntry{done?: true, ref: ref, client_name: client_name} | _] ->
          file_type = Path.extname(client_name)

          uploaded_entries = consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
              dest = Path.join("uploads", Path.basename(path)) <> file_type
              File.cp!(path, dest)
              {:ok, "/uploads/#{Path.basename(dest)}"}
          end)

          case uploaded_entries do
            [first | _rest] ->
              items =
                items
                |> Map.put("img_file_name", first)
                |> Map.put("shop_id", socket.assigns.userinfo.id)
              res = Shop.update_items(items, items["id"])
              case res do
                {:ok, _items} ->
                  delete_file(old_img_file_name)
                  cancel_upload(socket, :image, ref)
                  socket =
                    reset_socket(socket, socket.assigns.userinfo.id)
                    |> assign_form(Items.changeset(%Items{}), "items", :items_form)
                    |> show_alert("File #{client_name} has been uploaded!")
                  {:noreply, socket}
                {:error, _}->
                  {:noreply, socket}
              end

            [] ->
              IO.puts("No files uploaded")
              {:noreply, socket}
            end
        _ ->
          items =
            items
            |> Map.put("shop_id", socket.assigns.userinfo.id)
            res = Shop.update_items(items, items["id"])
            case res do
              {:ok, _items} ->
                socket =
                  reset_socket(socket, socket.assigns.userinfo.id)
                  |> assign_form(Items.changeset(%Items{}), "items", :items_form)
                  |> show_alert("Post has been updated!")
                {:noreply, socket}
              {:error, _}->
                {:noreply, socket}
            end
      end
    end

    def handle_event("decrease_page_number", %{"page_number" => page_number, "posts_on_each_page" => posts_on_each_page}, socket) do
      page_number = String.to_integer(page_number)
      posts_on_each_page = String.to_integer(posts_on_each_page)
      if page_number != 0 do
        page_number = page_number - 1
        current_posts = length(Enum.slice(socket.assigns.posts, (page_number) * posts_on_each_page, (posts_on_each_page)))
        socket =
          socket
          |> assign(:page_number, page_number)
          |> assign(:current_posts, current_posts)
        {:noreply, socket}
      else
        {:noreply, socket}
      end
    end

    def handle_event("increase_page_number", %{"page_number" => page_number, "posts_on_each_page" => posts_on_each_page}, socket) do
      page_number = String.to_integer(page_number)
      posts_on_each_page = String.to_integer(posts_on_each_page)
      if (page_number + 1) * posts_on_each_page + 1 > socket.assigns.total_posts do
        {:noreply, socket}
      else
        page_number = page_number + 1
        current_posts = length(Enum.slice(socket.assigns.posts, (page_number) * posts_on_each_page, (posts_on_each_page)))
        socket =
          socket
          |> assign(:page_number, page_number)
          |> assign(:current_posts, current_posts)
        {:noreply, socket}
      end
    end

    def handle_event("delete_post", %{"id" => id, "file_path" => file_path}, socket) do
      socket =
        case Shop.delete_item(id) do
          {:ok, message} ->
            delete_file(file_path)
            socket
            |> show_alert(message)
          {:error, message} ->
            socket
            |> show_alert(message)
        end
      {:noreply, reset_socket(socket, socket.assigns.userinfo.id)}
    end

    def handle_event("add_to_cart", %{"item_id" => item_id}, socket) do
      cart = %{"item_id" => item_id, "user_id" => socket.assigns.current_user.id, "quantity" => 1}
      post = Shop.get_item(item_id)
      case Shop.upload_cart(cart) do
        {:ok, _} ->
          current_cart = Shop.get_cart(socket.assigns.current_user.id)
          current_cart_posts = Shop.get_items_from_cart(current_cart)
          socket =
            socket
            |> assign(:current_cart, current_cart)
            |> assign(:cart_posts, current_cart_posts)
            |> show_alert("Successfully added #{post.item_name} to cart")
          {:noreply, socket}
        {:error, _} ->
          socket =
            socket
            |> show_alert("Could not add #{post.item_name} to cart")
          {:noreply, socket}
      end
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
      case File.rm(full_path) do
        :ok ->
          {:ok, "File deleted successfully"}

        {:error, reason} ->
          {:error, "File deletion failed: #{reason}"}
      end
    end

    defp show_alert(socket, message) do
      socket
        |> assign(:show_alert, true)
        |> assign(:alert_message, message)
    end



end
