local M = {}

local default_size = 14
local cache_max_age = 86400

local function state_path(name)
  return vim.fs.joinpath(vim.fn.stdpath("state"), name)
end

local function read_json(path)
  if not vim.uv.fs_stat(path) then
    return nil
  end

  local ok, decoded = pcall(
    vim.json.decode,
    table.concat(vim.fn.readfile(path), "\n")
  )
  return ok and decoded or nil
end

local function write_json(path, value)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  vim.fn.writefile({ vim.json.encode(value) }, path)
end

local function notify_terminal()
  vim.notify("Font controls are available in GUI Neovim clients")
end

function M.is_gui()
  return vim.fn.has("gui_running") == 1
    or vim.g.neovide
    or vim.g.goneovim
    or vim.g.fvim_loaded
    or vim.g.GuiLoaded
    or vim.g.nvui
end

function M.parse_fonts(output)
  local fonts = {}
  local seen = {}

  for line in output:gmatch("[^\r\n]+") do
    local full_name = line:match("^%s*Full Name:%s*(.+)")
    local metadata = line:match("^%s*[%w ]+:%s") or line:match(":%s*$")

    if full_name or not metadata then
      local family = (full_name or vim.trim(line)):match("^(.+ Nerd Font)")
      if family and not seen[family] then
        seen[family] = true
        table.insert(fonts, family)
      end
    end
  end

  table.sort(fonts)
  return fonts
end

local function font_command()
  if vim.fn.has("win32") == 1 then
    local shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
    local script = table.concat({
      "Add-Type -AssemblyName System.Drawing.Common -ErrorAction SilentlyContinue;",
      "Add-Type -AssemblyName System.Drawing -ErrorAction SilentlyContinue;",
      "$fonts = New-Object System.Drawing.Text.InstalledFontCollection;",
      "$fonts.Families | ForEach-Object Name |",
      "Where-Object { $_ -match 'Nerd Font' } |",
      "Sort-Object -Unique",
    }, " ")
    return { shell, "-NoProfile", "-NonInteractive", "-Command", script }
  end

  if vim.fn.has("mac") == 1 then
    return { "system_profiler", "SPFontsDataType" }
  end

  return { "fc-list", "--format", "%{family}\n" }
end

function M.detect_fonts()
  local command = font_command()
  if vim.fn.executable(command[1]) ~= 1 then
    return nil, command[1] .. " is not available"
  end

  local result = vim.system(command, { text = true }):wait(15000)
  if result.code ~= 0 then
    local message = result.code == 124 and "Font discovery timed out"
      or vim.trim(result.stderr or "")
    return nil, message ~= "" and message or "Font discovery failed"
  end

  return M.parse_fonts(result.stdout or "")
end

function M.fonts(force)
  local cache_path = state_path("font-cache.json")
  local cached = read_json(cache_path)

  if not force
    and cached
    and type(cached.timestamp) == "number"
    and os.time() - cached.timestamp < cache_max_age
    and type(cached.fonts) == "table"
  then
    return cached.fonts
  end

  local fonts, error_message = M.detect_fonts()
  if not fonts then
    if cached and type(cached.fonts) == "table" and #cached.fonts > 0 then
      return cached.fonts, error_message, true
    end
    return nil, error_message
  end

  write_json(cache_path, {
    timestamp = os.time(),
    fonts = fonts,
  })
  return fonts
end

function M.read_state(path)
  local value = read_json(path or state_path("font.json"))
  if not value
    or type(value.name) ~= "string"
    or value.name == ""
    or type(value.size) ~= "number"
  then
    return nil
  end
  return value
end

function M.write_state(value, path)
  write_json(path or state_path("font.json"), value)
end

function M.current()
  local name, size = vim.o.guifont:match("^(.-):h(%d+)$")
  if name and name ~= "" then
    return { name = name, size = tonumber(size) }
  end
  return M.read_state()
end

function M.apply(value, persist)
  if not value or not value.name or not value.size then
    return false
  end

  local size = math.max(6, math.min(72, math.floor(value.size)))
  vim.o.guifont = value.name .. ":h" .. size
  if persist then
    M.write_state({ name = value.name, size = size })
  end
  return true
end

function M.change_size(delta)
  if not M.is_gui() then
    notify_terminal()
    return
  end

  local current = M.current()
  if not current then
    vim.notify("Pick a font before changing its size", vim.log.levels.WARN)
    return
  end

  current.size = current.size + delta
  M.apply(current, true)
  vim.notify("Font size: " .. M.current().size)
end

function M.refresh()
  local fonts, error_message, stale = M.fonts(true)
  if not fonts then
    vim.notify(error_message, vim.log.levels.ERROR)
    return
  end
  if stale then
    vim.notify(
      "Font refresh failed; using cached fonts: " .. error_message,
      vim.log.levels.WARN
    )
    return
  end
  vim.notify(string.format("Font cache refreshed (%d fonts)", #fonts))
end

function M.pick()
  if not M.is_gui() then
    notify_terminal()
    return
  end

  local fonts, error_message, stale = M.fonts()
  if not fonts then
    vim.notify(error_message, vim.log.levels.ERROR)
    return
  end
  if stale then
    vim.notify(
      "Font discovery failed; using cached fonts: " .. error_message,
      vim.log.levels.WARN
    )
  end
  if #fonts == 0 then
    vim.notify("No Nerd Fonts found", vim.log.levels.WARN)
    return
  end

  local pick = require("mini.pick")
  local original = vim.o.guifont
  local current = M.current()
  local size = current and current.size or default_size
  local active = true

  local chosen = pick.start({
    source = {
      name = "Fonts",
      items = fonts,
      choose = function() end,
      show = function(bufnr, items, query)
        pick.default_show(bufnr, items, query)
        vim.schedule(function()
          if not active or not pick.is_picker_active() then
            return
          end
          local matches = pick.get_picker_matches()
          if matches and matches.current then
            M.apply({ name = matches.current, size = size }, false)
          end
        end)
      end,
    },
  })

  active = false
  if chosen then
    M.apply({ name = chosen, size = size }, true)
    vim.notify("Font: " .. chosen)
  else
    vim.o.guifont = original
  end
end

function M.setup()
  if M.is_gui() then
    M.apply(M.read_state(), false)
  end

  vim.api.nvim_create_user_command("FontPick", M.pick, {
    desc = "Pick a GUI font",
  })
  vim.api.nvim_create_user_command("FontRefresh", M.refresh, {
    desc = "Refresh installed fonts",
  })

  vim.keymap.set("n", "<leader>tf", M.pick, { desc = "Pick font" })
  vim.keymap.set("n", "<leader>tF", M.refresh, { desc = "Refresh fonts" })
  vim.keymap.set("n", "<C-=>", function()
    M.change_size(1)
  end, { desc = "Increase font size" })
  vim.keymap.set("n", "<C-->", function()
    M.change_size(-1)
  end, { desc = "Decrease font size" })
end

return M
