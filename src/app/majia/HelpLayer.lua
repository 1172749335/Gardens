

HelpLayer = class("HelpLayer",function()
    return cc.Layer:create()
end)

function HelpLayer:ctor()
    local layerColor = CCLayerColor:create(ccc4(0,0,0, 250),display.width,display.height)
    layerColor:setPosition(ccp(0,0))
    layerColor:setAnchorPoint(ccp(0,0))
    self:addChild(layerColor)

    
    local sprite = cc.Sprite:create("majia/images/ruleBG.png")
    sprite:setPosition(cc.p(display.cx, display.cy))
    layerColor:addChild(sprite)

    local btn_close = ccui.Button:create("majia/images/btn_close.png","","")
    btn_close:setPosition(cc.p(display.width * 0.1, display.height * 0.85))
    btn_close:addTouchEventListener(function(sender, state)   
        if state == 2 then
            if MainScene.isOpenEffect then
                AudioEngine.playEffect("majia/sound/click.mp3")
            end    
            self:removeFromParent()
        end      

    end)
    btn_close:setPressedActionEnabled(true)
    layerColor:addChild(btn_close)   

    local function onTouchBegan( touch, event )
        return true
    end

    local function onTouchMoved( touch, event )
    end

    local function onTouchEnded( touch, event )
    end

    local listener1 = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    listener1:setSwallowTouches(true)  --是否向下传递
    listener1:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener1:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener1:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED ) 
    local eventDispatcher = layerColor:getEventDispatcher() 
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener1, layerColor) --分发监听事件

end
return HelpLayer
