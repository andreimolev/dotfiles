local modal = {}
local stateMachine = require "statemachine"
local utils = require "utils"
local windows = require "windows"
local layout = require "layout"
local config = require "config"

modal.displayModalText = function(txt)
  hs.alert.closeAll()
  alert(txt, 999999)
end

modal.exitAllModals = function()
  hs.fnutils.each(modal.states, function(s)
                    if s.hotkeyModal then s.hotkeyModal:exit() end
  end)
end

modal.addState = function(name,state)
  modal.states[name] = state
end

-- Filtering applications having dedicated hotkeys
local filterAllowedApps = function(w)
  local applications = config.getApplications()
  local allowedApps = {}
  allowedApps["Hammerspoon"] = "Hammerspoon"
  for key, app in pairs(applications) do
    allowedApps[app[2]] = app[2]
  end
  --local allowedApps = {"Emacs", "iTerm2", "VLC", }
  if (hs.fnutils.contains(allowedApps, w:application():name())) then
    return false;
  end
  return true;
end

modal.states = {
  idle =  {
    from = "*", to = "idle",
    callback = function(self, event, from, to)
      hs.alert.closeAll()
      modal.exitAllModals()
    end
  },
  main = {
    from = "*", to = "main",
    init = function(self, fsm)
      if self.hotkeyModal then
        self.hotkeyModal:enter()
      else
        -- Ctrl-Option-Command-Space is the hotkey to enter the Main Modal
        -- Use Karabiner to rebind this hotkey to LeftCommand-Space,
        -- leaving RightCommand-Space free for other useful action
        self.hotkeyModal = hs.hotkey.modal.new({"ctrl", "option", "cmd"}, "space")
      end
      self.hotkeyModal:bind("","space", nil, function() fsm:toIdle(); windows.activateApp("Alfred 3") end)
      self.hotkeyModal:bind("","w", nil, function() fsm:toWindows() end)
      self.hotkeyModal:bind("","r", nil, function() fsm:toIdle(); layout.layoutUpdate() end)
      self.hotkeyModal:bind("","m", nil, function() fsm:toMedia() end)
      self.hotkeyModal:bind("","j", nil, function()
                        local wns = hs.fnutils.filter(hs.window.allWindows(), filterAllowedApps)
                        hs.hints.windowHints(wns, nil, true)
                        fsm:toIdle() end)
      self.hotkeyModal:bind({"ctrl"}, "l", nil, function() hs.caffeinate.lockScreen(); fsm:toIdle() end)
      self.hotkeyModal:bind({"ctrl"}, "r", nil, function() hs.reload(); fsm:toIdle() end)
      self.hotkeyModal:bind("","escape", function() fsm:toIdle() end)

      local applications = config.getApplications()

      -- Binding keys for configured apps
      for key, app in pairs(applications) do
       self.hotkeyModal:bind("", key, function() windows.activateApp(app[1], app[2], false) fsm:toIdle() end)
       if (app[3] == true) then
         self.hotkeyModal:bind({"command"}, key, function() windows.activateApp(app[1], app[2], true) fsm:toIdle() end)
       end
      end

      -- Hint displayed in main Modal
      hintText = "w \t- windows\nj \t- jump\nm \t- media\nr \t- refresh layout\n"
      for key, app in pairs(applications) do
        hintText = hintText .. "\n" .. key .. "\t- " .. app[1]
      end
      function self.hotkeyModal:entered()
        modal.displayModalText(hintText)
      end
    end
  }
}

-- -- each modal has: name, init function
modal.createMachine = function()
  -- build events based on modals
  local events = {}
  local params = function(fsm)
    local callbacks = {}
    for k, s in pairs (modal.states) do
      table.insert(events, { name = "to" .. utils.capitalize(k),
                             from = s.from or {"main", "idle"},
                             to = s.to or k})
      if s.callback then
        cFn = s.callback
      else
        cFn = function(self, event, from, to)
          local st = modal.states[to]
          st.init(st, self)
        end
      end
      callbacks["on" .. k] = cFn
    end

    return callbacks
  end

  return stateMachine.create({ initial = "idle",
                               events = events,
                               callbacks = params(self)})
end

return modal
