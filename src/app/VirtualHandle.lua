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
local _rockerTouchID=-1
local _rockerWay = 0 --0:不动 1：向左 2：向右
local _rockerLastPoint=0
local _rockerRangeValue = 600
local function callback(event)
  if _callback~=nil then
    -- 执行回调function
    _callback(event)
  end
end

local function touchEvent(obj,type)
  if type==ccui.TouchEventType.began then
    if obj==_a then
      callback(VirtualHandleEvent.A)
    elseif obj==_b then
      callback(VirtualHandleEvent.B)
    elseif obj==_rocker then
      callback(VirtualHandleEvent)
    end
  elseif type==ccui.TouchEventType.ended then
    if obj==_a then
      callback(VirtualHandleEvent.CANCEL_A)
    elseif obj==_b then
      callback(VirtualHandleEvent.CANCEL_B)
    end
  elseif type==ccui.TouchEventType.canceled then
    
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

  _rocker:setPosition(cc.p(_rockerRangeValue,_rocker:getContentSize().height/2))
  _rocker:setTouchEnabled(false)
  
  _rockerRange:addChild(_rocker)

  self:addChild(_rockerRange)
  self:addChild(_a)
  self:addChild(_b)

  _a:addTouchEventListener(touchEvent)
  _b:addTouchEventListener(touchEvent)
  -- 获取全局的事件管理器
  local event=cc.Director:getInstance():getEventDispatcher()
  -- 创建点一对一的事件处理函数
  local rockerDangeEvent=cc.EventListenerTouchOneByOne:create()

  -- 注册事件
  rockerDangeEvent:registerScriptHandler(function(touch,e)
    -- 触摸开始
    local bound = _rockerRange:getBoundingBox()
    local newP = _rockerRange:convertToNodeSpace(cc.p(300, 300))
    bound.x=newP.x
    bound.y=newP.y
    local point=touch:getLocation()
    -- 碰撞检测
     print(bound.x,bound.y)
     print(point.x,point.y)
    if cc.rectContainsPoint(bound,point) then
      -- 记录触摸ID
      _rockerTouchID = touch:getId()
      _rockerLastPoint = point.x
      print('okokok')
      if math.abs( math.abs( point.x-bound.x )-_rockerRangeValue/2 )<20 then
        -- 原地不动
      elseif point.x-bound.x>_rockerRangeValue/2 then
        -- 向右
        _rockerWay=2
        callback(VirtualHandleEvent.RIGHT)
      else 
        -- 向左
        _rockerWay=1
        callback(VirtualHandleEvent.LEFT)
      end
      return
    end
    -- 没有碰撞
    return false

    end,cc.Handler.EVENT_TOUCH_BEGAN)
  rockerDangeEvent:registerScriptHandler(function(touch,e)
    
    end,cc.Handler.EVENT_TOUCH_MOVED)
  rockerDangeEvent:registerScriptHandler(function(touch,e)
    
    end,cc.Handler.EVENT_TOUCH_ENDED)
  rockerDangeEvent:registerScriptHandler(function(touch,e)
    
    end,cc.Handler.EVENT_TOUCH_CANCELLED)
  -- 将事件注册到屏幕上
  event:addEventListenerWithSceneGraphPriority(rockerDangeEvent, _rockerRange)
end

function VirtualHandle:setCallback(callback)
  _callback = callback 
end

return VirtualHandle