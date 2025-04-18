defmodule EvalioApp.MeetingsTest do
  use EvalioApp.DataCase

  alias EvalioApp.Meetings
  alias EvalioApp.Meetings.Meeting

  describe "meetings" do
    @valid_attrs %{
      title: "Test Meeting",
      date: ~D[2024-03-20],
      time: ~T[10:00:00],
      tag: "none"
    }
    @update_attrs %{
      title: "Updated Meeting",
      date: ~D[2024-03-21],
      time: ~T[11:00:00],
      tag: "none"
    }
    @invalid_attrs %{title: nil, date: nil, time: nil}

    def meeting_fixture(attrs \\ %{}) do
      {:ok, meeting} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Meetings.create_meeting()

      meeting
    end

    test "list_meetings/0 returns all meetings" do
      meeting = meeting_fixture()
      assert Meetings.list_meetings() == [meeting]
    end

    test "get_meeting!/2 returns the meeting with given id" do
      meeting = meeting_fixture()
      assert Meetings.get_meeting!(meeting.id) == meeting
    end

    test "create_meeting/1 with valid data creates a meeting" do
      assert {:ok, %Meeting{} = meeting} = Meetings.create_meeting(@valid_attrs)
      assert meeting.title == "Test Meeting"
      assert meeting.date == ~D[2024-03-20]
      assert meeting.time == ~T[10:00:00]
      assert meeting.tag == "none"
    end

    test "create_meeting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meetings.create_meeting(@invalid_attrs)
    end

    test "update_meeting/2 with valid data updates the meeting" do
      meeting = meeting_fixture()
      assert {:ok, %Meeting{} = meeting} = Meetings.update_meeting(meeting, @update_attrs)
      assert meeting.title == "Updated Meeting"
      assert meeting.date == ~D[2024-03-21]
      assert meeting.time == ~T[11:00:00]
    end

    test "update_meeting/2 with invalid data returns error changeset" do
      meeting = meeting_fixture()
      assert {:error, %Ecto.Changeset{}} = Meetings.update_meeting(meeting, @invalid_attrs)
      assert meeting == Meetings.get_meeting!(meeting.id)
    end

    test "delete_meeting/1 deletes the meeting" do
      meeting = meeting_fixture()
      assert {:ok, %Meeting{}} = Meetings.delete_meeting(meeting)
      assert_raise Ecto.NoResultsError, fn -> Meetings.get_meeting!(meeting.id) end
    end

    test "change_meeting/1 returns a meeting changeset" do
      meeting = meeting_fixture()
      assert %Ecto.Changeset{} = Meetings.change_meeting(meeting)
    end

    test "update_meeting_tag/2 updates the meeting's tag" do
      meeting = meeting_fixture()
      assert {:ok, %Meeting{} = updated_meeting} = Meetings.update_meeting_tag(meeting, "important")
      assert updated_meeting.tag == "important"
    end
  end
end
