require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Example Name",
      email: "email@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    refute @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    refute @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    refute @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    refute @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                     first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                         foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email validates uniqueness" do
    dup_user = @user.dup
    @user.save
    refute dup_user.valid?
  end

  test "email uniqueness validation is case insensitive" do
    dup_user = @user.dup
    @user.save
    dup_user.email = dup_user.email.upcase
    refute dup_user.valid?
  end

  test "password cannot be blank" do
    @user.password = @user.password_confirmation = " " * 6
    refute @user.valid?
  end

  test "password is minimum 6 characters long" do
    @user.password = @user.password_confirmation = "a" * 5
    refute @user.valid?
  end
end
