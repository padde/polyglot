defmodule Polyglot.XML do
  @moduledoc ~S"""
  Elixir wrapper for xmerl adapted from Exml https://github.com/expelledboy/exml
  """

  import Record

  defrecord :xmlElement, extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  defrecord :xmlAttribute, extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  defrecord :xmlText, extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  @doc "Parse the specified file and return an xmerl document."
  def parse_file(file) do
    {doc, _} = :xmerl_scan.file String.to_char_list(file)
    doc
  end

  @doc "Get the text at the specified xpath location from doc."
  def get(doc, path) do
    xpath(doc, path) |> text
  end

  @doc "Get the xmerl node at the specified xpath location from doc."
  def xpath(doc, path) do
    :xmerl_xpath.string(String.to_char_list(path), doc)
  end

  @doc "Extract text from an xmerl node."
  def text([]), do: nil
  def text([item]), do: text(item)
  def text(xmlElement(content: node)), do: text(node)
  def text(xmlAttribute(value: value)), do: List.to_string(value)
  def text(xmlText(value: value)), do: List.to_string(value)
  def text(list) when is_list(list) do
    if Enum.all?(list, &parsable/1) do
      Enum.map(list, &(text &1))
    else
      fatal(list)
    end
  end
  def text(term), do: fatal(term)

  defp parsable(term) do
    is_record(term, :xmlText) or
    is_record(term, :xmlElement) or
    is_record(term, :xmlAttribute)
  end

  defp fatal(term) do
    raise "Cannot extract text from xmerl node: #{inspect term}"
  end
end
