defmodule Polyglot.Locale do
  @moduledoc ~S"""
  Internal helpers to work with locale identifiers.
  """

  @doc ~S"""
  Returns the parent locale for the specified locale by stripping of one
  trailing subtype and underscore. Returns `nil` if there is no parent locale to
  be extracted from the locale. Does *not* check if the parent locale actually
  exists.

  # Examples

      iex> Polyglot.Locale.parent(:fr)
      nil
  
      iex> Polyglot.Locale.parent(:de_AT)
      :de

      iex> Polyglot.Locale.parent(:en_US_POSIX)
      :en_US
  """
  def parent(locale) do
    if has_parent?(locale) do
      locale
      |> Atom.to_string
      |> String.reverse
      |> String.split("_")
      |> Enum.drop(1)
      |> Enum.join("_")
      |> String.reverse
      |> String.to_atom
    else
      nil
    end
  end

  @doc ~S"""
  Returns true if the locale looks like it is the subtype of another locale.
  Does *not* check if the parent locale actually exists.

  # Examples

      iex> Polyglot.Locale.has_parent?(:fr)
      false
  
      iex> Polyglot.Locale.has_parent?(:de_AT)
      true
  """
  def has_parent?(locale) do
    locale
    |> Atom.to_string
    |> String.contains?("_")
  end
end

