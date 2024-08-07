local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font "JetBrains Mono"
config.font_size = 12.0
if wezterm.target_triple:find("darwin") ~= nil then
    config.font_size = 14.0
end
config.initial_cols = 160
config.initial_rows = 40

config.scrollback_lines = 20000

config.leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 }

local act = wezterm.action
config.keys = {
    -- Send "CTRL-S" to the terminal when pressing CTRL-S, CTRL-S
    { key = 's', mods = 'LEADER|CTRL', action = act.SendKey { key = 's', mods = 'CTRL' }, },

    { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
    { key = ':', mods = 'LEADER', action = act.ActivateCommandPalette },
    { key = 'f', mods = 'LEADER', action = act.QuickSelect },

    -- Split Panes
    { key = 'v', mods = 'LEADER', action = act.SplitHorizontal },
    { key = 's', mods = 'LEADER', action = act.SplitVertical },

    -- Navigate Panes
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'h', mods = 'LEADER|CTRL', action = act.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'LEADER|CTRL', action = act.ActivatePaneDirection 'Right' },
    { key = 'k', mods = 'LEADER|CTRL', action = act.ActivatePaneDirection 'Up' },
    { key = 'j', mods = 'LEADER|CTRL', action = act.ActivatePaneDirection 'Down' },
    { key = 'w', mods = 'LEADER', action = act.PaneSelect },

    -- Move Panes
    { key = 'r', mods = 'LEADER', action = act.RotatePanes 'Clockwise' },
    { key = 'r', mods = 'LEADER|SHIFT', action = act.RotatePanes 'CounterClockwise' },

    -- Tabs
    { key = 't', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    { key = 'p', mods = 'LEADER|CTRL', action = act.ActivateTabRelative(-1) },
    { key = 'n', mods = 'LEADER|CTRL', action = act.ActivateTabRelative(1) },

    -- Super-S-c and Super-S-v to copy and paste
    { key = 'c', mods = 'SUPER|SHIFT', action = act.CopyTo 'Clipboard' },
    { key = 'v', mods = 'SUPER|SHIFT', action = act.PasteFrom 'Clipboard' },
}

-- Copy mode keybindings
copy_mode_keys = wezterm.gui.default_key_tables().copy_mode
table.insert( copy_mode_keys, { key = 'j', mods = 'CTRL', action = act.CopyMode 'Close' })
table.insert( copy_mode_keys, { key = '/', action = act.Search 'CurrentSelectionOrEmptyString' })

-- Search mode keybindings
search_mode_keys = wezterm.gui.default_key_tables().search_mode
table.insert( search_mode_keys, { key = 'j', mods = 'CTRL', action = act.CopyMode 'Close' })

config.key_tables = {
    search_mode = search_mode_keys,
    copy_mode = copy_mode_keys,
}

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'zenwritten_dark'
  else
    return 'Atelierheath (light) (terminal.sexy)'
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())

--for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
  --if gpu.backend == 'Vulkan' and gpu.driver == 'NVIDIA' then
    --config.webgpu_preferred_adapter = gpu
    --config.front_end = 'WebGpu'
    --break
  --end
--end

return config
