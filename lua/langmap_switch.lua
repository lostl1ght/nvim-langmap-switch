local default_config = {
  iminsert = 0,
  imsearch = -1,
  map_insert = '<c-\\>',
  map_normal = '<c-\\>',
  map_command = '<c-\\>',
}

local function switch_n()
  vim.o.iminsert = math.floor((2 - vim.o.iminsert) / 2)
end

local key = vim.api.nvim_replace_termcodes('<c-^>', true, true, true)
local function switch_ic()
  vim.api.nvim_feedkeys(key, 'n', false)
end

---Setup input_switch.nvim
---@param opts table
local function setup(opts)
  if not opts or not opts.keymap then
    vim.notify("Setting 'keymap' required", vim.log.levels.ERROR)
    return
  end

  local config = vim.tbl_extend('force', default_config, opts)

  vim.o.keymap = config.keymap
  vim.o.iminsert = config.iminsert
  vim.o.imsearch = config.imsearch

  if config.map_insert then
    vim.keymap.set('i', config.map_insert, switch_ic)
  end
  if config.map_command then
    vim.keymap.set('c', config.map_command, switch_ic)
  end
  if config.map_normal then
    vim.keymap.set('n', config.map_normal, switch_n)
  end
end

---Statusline condition
---@return boolean
local function condition()
  return vim.b.keymap_name
    and (vim.o.imsearch ~= -1 and vim.fn.mode() == 'c' and vim.o.imsearch == 1 or vim.o.iminsert == 1)
end

---Statusline provider
---@return string
local function provider()
  return string.upper(vim.b.keymap_name)
end

return { setup = setup, condition = condition, provider = provider }
