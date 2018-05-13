local layout = {}
require "tabletools"
local config = require "config"

local displayLayouts = config.getDisplayLayouts()

function notify(text)
    hs.alert(text)
end

local lastNumberOfScreens = #hs.screen.allScreens()

-- Get a list of screen, ordered by X-coordinate
local function getOrderedScreens()
    local screens = hs.screen.allScreens()
    table.sort(screens, function (left, right)
      return left:position() < right:position()
    end)

    return screens
end

-- Windows layout update
function layout.layoutUpdate()
    print(table.show(hs.screen.allScreens(), "allScreens"))

    -- Choosing appropriate displayLayout for current number os screens
    local numberOfScreens = #hs.screen.allScreens()
    if numberOfScreens > #displayLayouts then
      numberOfScreens = #displayLayouts
    end
    local displayLayout = displayLayouts[numberOfScreens]

    -- Constructing windows layout, required by hs.layout.apply() method
    local hsLayout = {}
    screens = getOrderedScreens{}
    for ind, app in ipairs(displayLayout) do
      hsLayout[ind] = { app[1], nil, screens[app[2]], app[3], nil, nil }
    end
    hs.layout.apply(hsLayout)
    notify("Screens layout updated")
end

-- Screen Watcher callback
local function screenWatcherCallback()
    newNumberOfScreens = #hs.screen.allScreens()

    if lastNumberOfScreens ~= newNumberOfScreens then
        layout.layoutUpdate()
    end

    lastNumberOfScreens = newNumberOfScreens
end

hs.screen.watcher.new(layout.layoutUpdate):start()

return layout
