defmodule Mix.Tasks.Cldr.Get do
  use Mix.Task

  @moduledoc false
  @shortdoc "Fetch the latest CLDR database from unicode.org"

  @url "http://www.unicode.org/Public/cldr/latest/core.zip"
  @dir "priv/cldr"
  @zip "#{@dir}/data.zip"
  @target "#{@dir}/data/"

  def run(_) do
    Mix.shell.cmd "mkdir -p #{@dir}"
    Mix.shell.cmd "rm -rf #{@dir}/*"

    Mix.shell.info "Fetching latest Unicode CLDR data..."
    Mix.shell.cmd "curl -#fL #{@url} -o #{@zip}"

    Mix.shell.info "Extracting..."
    Mix.shell.cmd "unzip -qq #{@zip} -d #{@target}"

    Mix.shell.info "Done."
  end
end

