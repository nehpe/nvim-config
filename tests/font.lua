local font = require("config.font")
local state_path = vim.fn.tempname() .. ".json"

local function test()
  local fonts = font.parse_fonts(table.concat({
    "CaskaydiaCove Nerd Font Bold (TrueType)",
    "CaskaydiaCove Nerd Font Regular (TrueType)",
    "Full Name: 0xProto Nerd Font Mono Regular",
    "Family: 0xProto Nerd Font",
    "Location: /Users/example/Library/Fonts/False Nerd Font.ttf",
    "False Nerd Font Complete.ttf:",
    "Unrelated Font",
  }, "\n"))

  assert(vim.deep_equal(fonts, {
    "0xProto Nerd Font",
    "CaskaydiaCove Nerd Font",
  }))

  font.write_state({ name = "Test Nerd Font", size = 15 }, state_path)
  assert(vim.deep_equal(font.read_state(state_path), {
    name = "Test Nerd Font",
    size = 15,
  }))

  local original = vim.o.guifont
  assert(font.apply({ name = "Test Nerd Font", size = 100 }, false))
  assert(vim.o.guifont == "Test Nerd Font:h72")
  vim.o.guifont = original

  assert(not font.is_gui())
end

local ok, error_message = pcall(test)
vim.fn.delete(state_path)

if not ok then
  error(error_message)
end

print("font configuration: ok")
