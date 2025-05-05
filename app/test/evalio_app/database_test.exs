defmodule EvalioApp.DatabaseTest do
  use EvalioApp.DataCase

  alias EvalioApp.{Mentee, Cohort}

  describe "database connectivity" do
    test "can connect to the database" do
      assert {:ok, _} = Ecto.Adapters.SQL.query(EvalioApp.Repo, "SELECT 1")
    end
  end

  describe "mentees table" do
    test "can query mentees table" do
      result = Mentee.list_mentees()
      assert is_list(result)
    end

    test "mentee search functionality works" do
      # First ensure we have some mentees
      mentees = Mentee.list_mentees()

      if length(mentees) > 0 do
        first_mentee = List.first(mentees)
        search_term = first_mentee.first_name
        search_results = Mentee.search_mentees(search_term)
        assert is_list(search_results)
        assert length(search_results) > 0
      end
    end

    test "mentee struct creation works" do
      attrs = %{
        id: "test_id",
        first_name: "Test",
        last_name: "User",
        email: "test@example.com",
        pronouns: "they/them",
        profile_picture: "https://example.com/pic.png",
        cohort: "Test Cohort",
        batch: 1,
        attendance_percent: 100,
        assignment_percent: 100
      }

      mentee = Mentee.new(attrs)
      assert mentee.id == attrs.id
      assert mentee.first_name == attrs.first_name
      assert mentee.last_name == attrs.last_name
      assert mentee.email == attrs.email
    end
  end

  describe "cohorts table" do
    test "can query cohorts table" do
      result = Cohort.list_cohorts()
      assert is_list(result)
    end

    test "cohort struct has correct fields" do
      cohorts = Cohort.list_cohorts()

      if length(cohorts) > 0 do
        cohort = List.first(cohorts)
        assert Map.has_key?(cohort, :id)
        assert Map.has_key?(cohort, :name)
        assert Map.has_key?(cohort, :batch)
        assert Map.has_key?(cohort, :year)
        assert Map.has_key?(cohort, :mentee_count)
      end
    end
  end
end
