# Polyglot

[![Build Status](https://travis-ci.org/padde/polyglot.svg)](https://travis-ci.org/padde/polyglot)
[![Hex Version](https://img.shields.io/hexpm/v/polyglot.svg)](https://hex.pm/packages/polyglot)

Polyglot is a localization library for Elixir that provides reusable formatting
rules and translations for a large number of languages.

The data is fetched from the Unicode Common Locale Data Repository (CLDR) and
prepared for easy usage from within Elixir.

## Installation

Add `:polyglot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:polyglot, "~> 0.0.1"}]
end
```

## Usage

Use `Polyglot.Data.get/2` to retrieve translations. A comprehensive list of all
available translations is available in the documentation for the `Polyglot.Data`
module.

```elixir
iex> Polyglot.Data.get(:weekdays, :fr)
{:ok, ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"]}

iex> Polyglot.Data.get(:weekdays_abbr, :en)
{:ok, ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]}
```

## Configuration

By default, translations for all available locales will be available. You can
provide a list of enabled locales to speed up compilation time via Mix
configuration, for example:

    config :polyglot, enabled_locales: [:de, :en, :es, :fr, :it]

For a list of all available locales, use `Polyglot.Data.available_locales/0`.
For a list of enabled locales, use `Polyglot.Data.enabled_locales/0`.

## Contributing

All contributions are welcome. Please feel free to open a pull request on
[GitHub](https://github.com/padde/polyglot).

## License

Polyglot is released under the [MIT license](http://padde.mit-license.org/).
See the LICENSE file.

The Unicode CLDR data is released under the [Unicode Terms of
Use](http://www.unicode.org/copyright.html), a copy of which is included as
UNICODE_LICENSE.
