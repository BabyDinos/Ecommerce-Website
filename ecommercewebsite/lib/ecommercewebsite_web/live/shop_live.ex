defmodule EcommercewebsiteWeb.ShopLive do
  use EcommercewebsiteWeb, :live_view

  alias Ecommercewebsite.Items
  alias Ecommercewebsite.Shop

  def render(assigns) do
    ~H"""
      <!DOCTYPE html>
      <head>
      </head>
      <body>
        <div class = "w-full h-2/5 flex justify-center bg-[url('/images/home-background.jpg')] bg-auto bg-center bg-no-repeat">
          <div class = "w-4/5 justify-center">
            <h1 class = "text-white font-semibold text-8xl text-center mt-64">
            My Store
            </h1>
            <h2 class = "p-20 font-medium text-6xl text-white">
            Welcome to my store!
            </h2>
          </div>
        </div>
        <div class = "w-full h-1/6 flex justify-center">
          <h1 class = "font-semibold text-8xl text-center mt-64">
          This is where my store will be
          </h1>
        </div>
        <div class = "w-2/5 h-1/8 flex mx-auto items-start justify-center">
          <.button type="button" phx-click={show_modal("upload-form")} class = "w-2/6 h-1/6 font-medium text-6xl">Upload New Item</.button>

            <.modal id = "upload-form" >
              <.form for={@upload_form} phx-change= "validate_new_item" phx-submit="upload_new_item"
                class = "mt-[5%] ml-[5%] font-medium text-6xl w-3/5" enctype="multipart/form-data">
                <.input field={@upload_form[:item_name]} value = {@item_name} placeholder = {@item_name} type="text" label="Item Name" required />
                <.input field={@upload_form[:description]}  value = {@description} placeholder = {@description} type="textarea" label="Description" required />
                <.input field={@upload_form[:price]} value = {@price} placeholder = {@price} type="number" label="Price" required />
                <.input field={@upload_form[:quantity]} value = {@quantity} placeholder = {@quantity} type="number" label="Quantity" required />
                <.live_file_input upload={@uploads.image} required class = "w-full text-xl mb-5"/>
                <%= for entry <- @uploads.image.entries do %>
                  <.live_img_preview entry={entry} />
                <% end %>
                <div class = "justify-end w-full flex">
                  <button phx-click={hide_modal("upload-form")} class = "mt-5 text-2xl text-black bg-green-600 p-4 rounded-md">Submit</button>
                </div>
              </.form>
            </.modal>
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
              <div class = "flex items-center justify-center">
                <button class ="mt-5 text-2xl text-black bg-red-600 p-4 rounded-md" phx-click="delete_post" phx-value-id={post.id} phx-value-file_path={post.img_file_name} >DELETE</button>
              </div>
            </div>
          <% end %>
        </div>
        <div class = "flex items-start justify-center pt-12">
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
      </body>
    """
    end

    def mount(_params, _session, socket) do
      IO.inspect(socket.assigns)
      changeset = Items.changeset(%Items{})
      socket =
        reset_socket(socket)
        |> assign_form(changeset)
        |> allow_upload(:image, accept: ~w(.png .jpg), max_entries: 1, auto_upload: true)
      {:ok, socket}
    end

    def reset_socket(socket) do
      posts = Shop.get_items()
      socket =
        socket
        |> assign(:page_number, 1)
        |> assign(page_title: "Home")
        |> assign(:item_name, "")
        |> assign(:description, "")
        |> assign(:price, "")
        |> assign(:quantity, "")
        |> assign(:posts, posts)
      socket
    end

    def handle_event("validate_new_item", %{"items" => items}, socket) do
      changeset = Items.changeset(%Items{} ,items)
      socket =
        socket
        |> assign(:item_name, items["item_name"])
        |> assign(:description, items["description"])
        |> assign(:price, items["price"])
        |> assign(:quantity, items["quantity"])
        |> assign_form(changeset)
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
              res = Shop.upload_items(items)
              case res do
                {:ok, _items} ->
                  cancel_upload(socket, :image, ref)
                  socket =
                    reset_socket(socket)
                    |> assign_form(Items.changeset(%Items{}))
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
      IO.inspect(file_path)
      socket =
        case Shop.delete_item(id) do
          {:ok, message} ->
            res = delete_file(file_path)
            IO.inspect(res)
            put_flash(socket, :info, message)
          {:error, message} ->
            put_flash(socket, :error, message)
        end
      {:noreply, reset_socket(socket)}
    end

    defp assign_form(socket, %Ecto.Changeset{} = changeset) do
      upload_form =
        changeset
        |> Map.put(:action, :validate)
        |> to_form(as: "items")

      if changeset.valid? do
        assign(socket, upload_form: upload_form, check_errors: false)
      else
        assign(socket, upload_form: upload_form)
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
