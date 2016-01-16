defmodule Polyglot.Data do
  @moduledoc ~S"""
  Provides access to a subset of data from the Unicode CLDR.  The following data
  is currently available:

  | `key`              | Example value                  | Description                       |
  | ------------------ | ------------------------------ | --------------------------------- |
  | `:weekdays`        | `["Sunday", "Monday", ...]`    | List of weekday names             |
  | `:weekdays_abbr`   | `["Sun", "Mon", "Tue", ...]`   | List of abbreviated weekday names |
  | `:months`          | `["January", "February", ...]` | List of month names               |
  | `:months_abbr`     | `["Jan", "Feb", "Mar", ...]`   | List of abbreviated month names   |
  | `:date_format`     | `"M/d/y"`                      | Date format                       |
  | `:time_format`     | `"HH:mm:ss"`                   | Time format                       |
  | `:datetime_format` | `"E, MMM d, y"`                | Combined date and time format     |
  """

  alias Polyglot.XML
  alias Polyglot.Locale

  @path "priv/cldr/data/common/main"

  @available_locales (
    Path.wildcard("#{@path}/*.xml")
    |> Enum.map(fn(file) -> file |> Path.basename(Path.extname(file)) |> String.to_atom end)
  )

  @enabled_locales Application.get_env(:polyglot, :enabled_locales, @available_locales)

  @sources (for locale <- @enabled_locales, locale in @enabled_locales do
    {locale, Path.join([@path, "#{locale}.xml"])}
  end)

  @keys [
    {:weekdays, "//calendar[@type='gregorian']//dayContext[@type='format']/dayWidth[@type='wide']//day"},
    {:weekdays_abbr, "//calendar[@type='gregorian']//dayContext[@type='format']/dayWidth[@type='abbreviated']//day"},
    {:months, "//calendar[@type='gregorian']//monthContext[@type='format']/monthWidth[@type='wide']//month"},
    {:months_abbr, "//calendar[@type='gregorian']//monthContext[@type='format']/monthWidth[@type='abbreviated']//month"},
    {:date_format, "//calendar[@type='gregorian']//dateFormatItem[@id='yMd']"},
    {:time_format, "//calendar[@type='gregorian']//dateFormatItem[@id='Hms']"},
    {:datetime_format, "//calendar[@type='gregorian']//dateFormatItem[@id='yMMMEd']"},
  ]

  @doc ~S"""
  Fetch the translated value for a given key and locale. If a translation is not
  found in the given locale, an attempt is made to fetch the key from its parent
  locales.

  Returns one of the following:

  * `{:ok, value}` when the translation is found for the locale or any of its
    parent locales.

  * `{:error, :missing_translation}` when the translation is not found for the
    locale or any of its parent locales.

  * `{:error, :invalid_key}` when the key is not known.

  * `{:error, :invalid_locale}` when the locale is not known or not enabled.

  * `{:error, reason}` for any other errors that might occur.

  # Examples

      iex> Polyglot.Data.get(:weekdays, :fr)
      {:ok, ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"]}

      iex> Polyglot.Data.get(:weekdays_abbr, :en)
      {:ok, ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]}
  """
  def get(key, locale)
  for {locale, file} <- @sources do
    IO.puts("Extracting translations for #{locale}")
    doc = XML.parse_file(file)
    parent_locale = Locale.parent(locale)

    for {key, xpath} <- @keys do

      data = XML.get(doc, xpath)
      cond do
        data ->
          def get(unquote(key), unquote(locale)), do: {:ok, unquote(data)}
        parent_locale ->
          def get(unquote(key), unquote(locale)), do: get(unquote(key), unquote(parent_locale))
        true ->
          def get(unquote(key), unquote(locale)), do: {:error, :missing_translation}
      end
    end
  end
  def get(_, locale) when locale in @available_locales do
    {:error, :invalid_key}
  end
  def get(_, _) do
    {:error, :invalid_locale}
  end

  @doc ~S"""
  Like `get/2`, but will return the value directly or raise an error.

  # Examples

      iex> Polyglot.Data.get!(:weekdays, :fr)
      ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"]

      iex> Polyglot.Data.get!(:weekdays_abbr, :en)
      ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
  """
  def get!(key, locale) do
    case get(key, locale) do
      {:ok, value} ->
        value
      {:error, :invalid_key} ->
        raise "Invalid key #{inspect key}"
      {:error, :invalid_locale} ->
        raise "Invalid locale #{inspect locale}"
      {:error, reason} ->
        raise "Cannot get translation for #{inspect key} in #{inspect locale} (#{inspect reason})"
    end
  end

  @doc ~S"""
  The list of available locales according to the locales present in the Unicode
  CLDR data.
  """
  def available_locales, do: @available_locales

  @doc ~S"""
  The list of enabled locales according to your Mix configuration.
  """
  def enabled_locales, do: @enabled_locales
end
