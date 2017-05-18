defmodule Pxblog.UserTest do
  use Pxblog.ModelCase

  alias Pxblog.User
  alias Pxblog.Factory

  @valid_attrs %{email: "test@test.com", password: "test1234", password_confirmation: "test1234", username: "testuser"}
  @invalid_attrs %{}

  setup do
    role = Factory.insert(:role, admin: false)
    {:ok, role: role}
  end

  defp valid_attrs(role) do
    Map.put(@valid_attrs, :role_id, role.id)
  end

  test "changeset with valid attributes", %{role: role} do
    changeset = User.changeset(%User{}, valid_attrs(role))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "password_digest value gets set to a hash" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert Comeonin.Bcrypt.checkpw(@valid_attrs.password,
    Ecto.Changeset.get_change(changeset, :password_digest))
  end

  test "password_digest value does not get set if password is nil" do
    changeset = User.changeset(%User{}, %{email: "test@test.com",
    password: nil, password_confirmation: nil, username: "test"})
    refute Ecto.Changeset.get_change(changeset, :password_digest)
  end

 #  test "changeset is invalid if password and confirmation do not match", %{role: role} do
 #   changeset = User.changeset(%User{}, %{email: "test12345@test.com", password: "foo", password_confirmation: "bar", username: "test12345", role_id: role.id})
 #   refute changeset.valid?
 #   assert changeset.errors[:password_confirmation] == "does not match password!"
 # end
 #
 # test "changeset is invalid if username is used already", %{role: role} do
 #   user1 = Factory.insert(:user)
 #   user2 = User.changeset(%User{}, %{username: user1.username, email: "unique@test.com", password: "test", password_confirmation: "test", role_id: role.id})
 #   assert {:error, changeset} = Repo.insert(user2)
 #   assert changeset.errors[:username] == "has already been taken"
 # end
 #
 # test "changeset is invalid if email is used already", %{role: role} do
 #   user1 = Factory.insert(:user)
 #   user2 = User.changeset(%User{}, %{username: "unique", email: user1.email, password: "test", password_confirmation: "test", role_id: role.id})
 #   assert {:error, changeset} = Repo.insert(user2)
 #   assert changeset.errors[:email] == "has already been taken"
 # end
 #
 # test "changeset is invalid if password is too short" do
 #   attrs = %{@valid_attrs | password: "t", password_confirmation: "t"}
 #   changeset = User.changeset(%User{}, attrs)
 #   refute changeset.valid?
 #   assert Dict.has_key?(changeset.errors, :password)
 # end


end
