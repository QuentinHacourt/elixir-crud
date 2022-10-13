defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(), do: %TodoList{}

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)

    new_entries =
      Map.put(
        todo_list.entries,
        todo_list.auto_id,
        entry
      )

    %TodoList{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def entry(todo_list, id) do
    todo_list.entries
    |> Stream.filter(fn {entry_id, _} -> id == entry_id end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        new_entry = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(todo_list, id) do
    new_entries =
      todo_list.entries
      |> Enum.filter(fn {entry_id, _} -> entry_id != id end)

    %TodoList{entries: new_entries, auto_id: todo_list.auto_id}
  end
end

# todoList =
#   TodoList.new()
#   |> TodoList.add_entry(%{date: ~D[2022-12-12], title: "Distributed Applications"})
#   |> TodoList.add_entry(%{date: ~D[2022-12-13], title: "System Administration"})
#   |> TodoList.add_entry(%{date: ~D[2022-12-12], title: "Database Foundations"})

# todoList =
#   TodoList.new() |>
#   TodoList.add_entry(%{date: ~D[2022-12-12], title: "Distributed Applications"}) |>
#   TodoList.add_entry(%{date: ~D[2022-12-13], title: "System Administration"}) |>
#   TodoList.add_entry(%{date: ~D[2022-12-12], title: "Database Foundations"})

# TodoList.entries(todoList, ~D[2022-12-12])
#
# TodoList.update_entry(todoList, 3, fn x -> %{id: x.id, date: x.date, title: "Databanken 1"} end)
#
# todoList = TodoList.delete_entry(todoList, 1)
