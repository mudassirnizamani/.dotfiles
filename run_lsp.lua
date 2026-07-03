vim.defer_fn(function()
  local file = io.open("lsp_out.txt", "w")
  local clients = vim.lsp.get_clients() -- get_clients is the newer API for Neovim 0.10+
  if #clients == 0 then
    file:write("No LSP clients attached\n")
  else
    for _, c in ipairs(clients) do
      file:write("Attached: " .. c.name .. "\n")
    end
  end
  file:close()
  vim.cmd('qa!')
end, 2000)
