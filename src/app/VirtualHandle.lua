local VirtualHandleEvent = {
  A='A',
  B='B',

  CANCEL_A='CANCEL_A',
  CANCEL_B='CANCEL_B',

  LEFT='LEFT',
  RIGHT='RIGHT',

  CANCEL_LEFT='CANCEL_LEFT',
  CANCEL_RIGHT='CANCEL_RIGHT',
}

local VirtualHandle = class('VirtualHandle',function()
  return display.newLayer('VirtualHandle')
end)

local _rockerRange = nil
local _rocker = nil
-- 按钮a和b
local _a = nil 
local _b = nil
local _callback = nil

local _rockerRangeValue = 300
local function callback(event)
  if _callback~=nil then
    _callback(event)
  end
end

local function touchEvent(obj,type)
  if type==ccui.TouchEventType.began then
    if obj==_a then
      if _callback~=nil then
        callback(VirtualHandleEvent.A)
      end
    end
    elseif obj==_b then
      callback(VirtualHandleEvent.B)
      end
end
function VirtualHandle:ctor()
  local size = display.size
  -- 获取控件
  _rockerRange = ccui.Widget:create()
  -- 创建一个button
  _rocker = ccui.Button:create('btn.PNG')
  _a = ccui.Button:create('btn.PNG')
  _b = ccui.Button:create('btn.PNG')

  -- 设置滑杆区域宽高
  _rockerRange:setContentSize(cc.size(_rockerRangeValue, _rocker:getContentSize().height))

  -- 设置滑杆区域中间对齐 
  _a:setPosition(cc.p(size.width-_a:getContentSize().width,0))
  _b:setPosition(cc.p(size.width-_a:getContentSize().width*2-10,0))

  _rocker:setPosition(cc.p(_rockerRangeValue/2,_rocker:getContentSize().height/2))
  _rocker:setTouchEnabled(false)
  
  _rockerRange:addChild(_rocker)

  self:addChild(_rockerRange)
  self:addChild(_a)
  self:addChild(_b)

  _a:addTouchEventListener(touchEvent)
end

function VirtualHandle:setCallback(callback)
  _callback = callback 
  
end

return VirtualHandle