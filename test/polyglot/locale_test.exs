defmodule Polyglot.LocaleTest do
  use ExUnit.Case
  doctest Polyglot.Locale

  alias Polyglot.Locale, as: L

  test "parent/1 with atom containing no _" do
    assert nil == L.parent(:en)
  end

  test "parent/1 with atom containing a single _" do
    assert :en == L.parent(:en_US)
  end

  test "parent/1 with atom containing multiple _" do
    assert :en_US == L.parent(:en_US_POSIX)
  end
end
