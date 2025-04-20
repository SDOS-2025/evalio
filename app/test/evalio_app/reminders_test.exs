defmodule EvalioApp.RemindersTest do
  use EvalioApp.DataCase

  alias EvalioApp.Reminders
  alias EvalioApp.Reminders.Reminder

  describe "reminders" do
    @valid_attrs %{
      title: "Test Reminder",
      date: ~D[2024-03-20],
      time: ~T[10:00:00],
      tag: "none"
    }
    @update_attrs %{
      title: "Updated Reminder",
      date: ~D[2024-03-21],
      time: ~T[11:00:00],
      tag: "none"
    }
    @invalid_attrs %{title: nil, date: nil, time: nil}

    def reminder_fixture(attrs \\ %{}) do
      {:ok, reminder} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reminders.create_reminder()

      reminder
    end

    test "list_reminders/0 returns all reminders" do
      reminder = reminder_fixture()
      assert Reminders.list_reminders() == [reminder]
    end

    test "get_reminder!/2 returns the reminder with given id" do
      reminder = reminder_fixture()
      assert Reminders.get_reminder!(reminder.id) == reminder
    end

    test "create_reminder/1 with valid data creates a reminder" do
      assert {:ok, %Reminder{} = reminder} = Reminders.create_reminder(@valid_attrs)
      assert reminder.title == "Test Reminder"
      assert reminder.date == ~D[2024-03-20]
      assert reminder.time == ~T[10:00:00]
      assert reminder.tag == "none"
    end

    test "create_reminder/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reminders.create_reminder(@invalid_attrs)
    end

    test "update_reminder/2 with valid data updates the reminder" do
      reminder = reminder_fixture()
      assert {:ok, %Reminder{} = reminder} = Reminders.update_reminder(reminder, @update_attrs)
      assert reminder.title == "Updated Reminder"
      assert reminder.date == ~D[2024-03-21]
      assert reminder.time == ~T[11:00:00]
    end

    test "update_reminder/2 with invalid data returns error changeset" do
      reminder = reminder_fixture()
      assert {:error, %Ecto.Changeset{}} = Reminders.update_reminder(reminder, @invalid_attrs)
      assert reminder == Reminders.get_reminder!(reminder.id)
    end

    test "delete_reminder/1 deletes the reminder" do
      reminder = reminder_fixture()
      assert {:ok, %Reminder{}} = Reminders.delete_reminder(reminder)
      assert_raise Ecto.NoResultsError, fn -> Reminders.get_reminder!(reminder.id) end
    end

    test "change_reminder/1 returns a reminder changeset" do
      reminder = reminder_fixture()
      assert %Ecto.Changeset{} = Reminders.change_reminder(reminder)
    end

    test "update_reminder_tag/2 updates the reminder's tag" do
      reminder = reminder_fixture()

      assert {:ok, %Reminder{} = updated_reminder} =
               Reminders.update_reminder_tag(reminder, "important")

      assert updated_reminder.tag == "important"
    end
  end
end
