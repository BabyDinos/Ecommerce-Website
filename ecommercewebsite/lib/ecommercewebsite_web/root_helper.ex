defmodule RootHelper do

  defmacro __using__(_opts) do
    quote do

      def handle_event("test", _params, socket) do
        {:noreply, socket}
      end

    end
  end
end
