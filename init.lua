if vim.g.vscode then
  require 'rewop.vscode'
else
  require 'rewop.core'
  require 'rewop.lazy'
end
