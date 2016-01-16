defmodule Polyglot.DataTest do
  use ExUnit.Case
  doctest Polyglot.Data

  alias Polyglot.Data, as: D

  # get/2

  test "get/2 with valid key and locale" do
    assert match? {:ok, value} when is_binary(value), D.get(:date_format, :en)
  end

  test "get/2 with fallback to parent locale" do
    expected = D.get(:date_format, :en)
    assert expected == D.get(:date_format, :en_US)
  end

  test "get/2 with nested fallback to parent locale" do
    expected = D.get(:date_format, :en)
    assert expected == D.get(:date_format, :en_US_POSIX)
  end

  test "get/2 with invalid key and valid locale" do
    assert {:error, :invalid_key} == D.get(:foo, :en)
  end

  test "get/2 with valid key and invalid locale" do
    assert {:error, :invalid_locale} == D.get(:date_format, :gibberish)
  end

  # get!/2

  test "get!/2 with valid key and locale" do
    assert is_binary D.get!(:date_format, :en)
  end

  test "get!/2 with invalid key and valid locale" do
    assert_raise RuntimeError, "Invalid key :foo", fn ->
      D.get!(:foo, :en)
    end
  end

  test "get!/2 with valid key and invalid locale" do
    assert_raise RuntimeError, "Invalid locale :gibberish", fn ->
      D.get!(:date_format, :gibberish)
    end
  end
end
