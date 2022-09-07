local default_config = {
  iminsert = 0,
  imsearch = -1,
  map_insert = '<c-\\>',
  map_normal = '<c-\\>',
}

local function switch_normal()
  vim.o.iminsert = math.floor((2 - vim.o.iminsert) / 2)
end

local key = vim.api.nvim_replace_termcodes('<c-^>', true, true, true)
local function switch_insert()
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
    vim.keymap.set('i', config.map_insert, switch_insert)
  end
  if config.map_normal then
    vim.keymap.set('n', config.map_normal, switch_normal)
  end
end

return { setup = setup }
