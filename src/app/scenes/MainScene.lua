
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    -- cc.ui.UILabel.new({
    --         UILabelType = 2, text = "Hello, World", size = 64})
    --     :align(display.CENTER, display.cx, display.cy)
    --     :addTo(self)
    local v = require('src.app.VirtualHandle').new()

    self:addChild(v)

    v:setPositionY(display.height/3)

    v:setCallback(function(event)
        print(event)
    end)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
