local layout = {}
require "tabletools"

local display_single = 1
local display_left = 2
local display_right = 3
local display_center = 4

-- Define monitor names for layout purposes
local display_laptop = "Color LCD"
local display_dell_left = "DELL U2415 (0x604000057ed8)"
local display_dell_right = "DELL U2415 (0x604000453318)"

-- Define window layouts
--   Format reminder:
--     {"App name", "Window name", "Display Name", "unitrect", "framerect", "fullframerect"},
local single_display = {
    { "Intellij IDEA CE", nil,          display_single,   hs.layout.maximized, nil, nil},
    { "Kiwi for Gmail",   nil,          display_single,   hs.layout.maximized, nil, nil},
    { "iTerm2",           nil,          display_single,   hs.layout.maximized, nil, nil},
    { "Google Chrome",    nil,          display_single,   hs.layout.maximized, nil, nil},
    { "Radiant Player",   nil,          display_single,   hs.layout.maximized, nil, nil},
    { "Finder",           nil,          display_single,   hs.layout.maximized, nil, nil},
    { "Viber",            nil,          display_single,   hs.layout.maximized, nil, nil},
    { "Skype",            nil,          display_single,   hs.layout.maximized, nil, nil},
    { "Trello",           nil,          display_single,   hs.layout.maximized, nil, nil},
    { "Calendar",         nil,          display_single,   hs.layout.maximized, nil, nil},
}

local two_displays = {
    { "Intellij IDEA CE", nil,          display_left,     hs.layout.maximized, nil, nil},
    { "Kiwi for Gmail",   nil,          display_left,     hs.layout.maximized, nil, nil},
    { "iTerm2",           nil,          display_right,    hs.layout.maximized, nil, nil},
    { "Google Chrome",    nil,          display_left,     hs.layout.maximized, nil, nil},
    { "Radiant Player",   nil,          display_left,     hs.layout.maximized, nil, nil},
    { "Finder",           nil,          display_left,     hs.layout.maximized, nil, nil},
    { "Viber",            nil,          display_right,    hs.layout.left50,    nil, nil},
    { "Skype",            nil,          display_right,    hs.layout.right50,   nil, nil},
    { "Trello",           nil,          display_left,     hs.layout.left50,    nil, nil},
    { "Calendar",         nil,          display_left,     hs.layout.right50,   nil, nil},
}

function notify(text)
    hs.alert(text)
end

local lastNumberOfScreens = #hs.screen.allScreens()

-- Get a list of screen, ordered by X-coordinate
local function getOrderedScreens()
    local screens = hs.screen.allScreens()
    print(table.show(hs.screen.allScreens(), "allScreens"))
    table.sort(screens, function (left, right)
      return left:position() < right:position()
    end)

    return screens
end

-- Screen Watcher callback
local function screenWatcherCallback()
    newNumberOfScreens = #hs.screen.allScreens()

    if lastNumberOfScreens ~= newNumberOfScreens then
        layout.layoutUpdate()
    end

    lastNumberOfScreens = newNumberOfScreens
end

-- Windows layout update
function layout.layoutUpdate()
    print(table.show(hs.screen.allScreens(), "allScreens"))
    numberOfScreens = #hs.screen.allScreens()

    screens = getOrderedScreens{}
    local dict = {}
    currentLayout = {}

    if numberOfScreens == 1 then
        currentLayout = single_display
        dict = {
          [display_single] = screens[1],
        }
    elseif numberOfScreens == 2 then
        currentLayout = two_displays
        dict = {
          [display_left] = screens[1],
          [display_right] = screens[2],
        }
    end

    for _, app in ipairs(currentLayout) do
      app[3] = dict[app[3]]
    end
    hs.layout.apply(currentLayout)
    notify("Screens layout updated")
end

hs.screen.watcher.new(layout.layoutUpdate):start()

return layout
