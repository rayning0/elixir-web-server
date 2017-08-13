defmodule Servy.BearView do
  require EEx

  @templates_path Path.expand("../../templates", __DIR__)

  # "function_from_file," to precompile templates inside a module for speed
  EEx.function_from_file :def, :index, Path.join(@templates_path, "index.eex"), [:bears]
  EEx.function_from_file :def, :show, Path.join(@templates_path, "show.eex"), [:bear]
end
