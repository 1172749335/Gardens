PlaceLayer = class("PlaceLayer",function()
    return cc.Layer:create()
end)


function PlaceLayer:ctor(scene, ID)
    local layerColor = CCLayerColor:create(ccc4(0,0,0, 250),display.width,display.height)
    layerColor:setPosition(ccp(0,0))
    layerColor:setAnchorPoint(ccp(0,0))
    self:addChild(layerColor)
    self.scene = scene
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

    for i = 1, 2 do
        for j = 1, 3 do
            local idx = (i - 1) * 3 + j
            local spr =  cc.Sprite:create("majia/images/place/place_" .. idx ..".png")
            local driftX = (j - 1) * 0.25 + 0.31
            local driftY = 0.68 - (i - 1) * 0.42
            spr:setPosition(cc.p(display.width * driftX, display.height * driftY))
            layerColor:addChild(spr) 
     
            -- 未解锁蒙版
            local spr_mask =  cc.Sprite:create("majia/images/place/place_unlock.png")
            local driftX = (j - 1) * 0.25 + 0.31
            local driftY = 0.68 - (i - 1) * 0.42
            spr_mask:setVisible(false)
            spr_mask:setPosition(cc.p(display.width * driftX, display.height * driftY))
            layerColor:addChild(spr_mask) 

            local btn = ccui.Button:create("majia/images/place/btn_placeN.png", "", "majia/images/place/btn_placeP.png")
            btn:setPosition(cc.p(135, 60))
            btn:addTouchEventListener(function(sender, state)   
                if state == 2 then
                    if MainScene.isOpenEffect then
                        AudioEngine.playEffect("majia/sound/click.mp3")
                    end    
                    
                    if MainScene.isOpenEffect then
                        AudioEngine.playEffect("majia/sound/building.mp3")
                    end
                    scene:createBuild(idx, ID)
                    self:removeFromParent()                   
                    
                end             
            end)
            spr:addChild(btn)
            if MainScene.UserData[idx].place ~= 0 then
                btn:setEnabled(false)
            end
            if not MainScene.UserData[idx].isunlock then
                spr_mask:setVisible(true)
                btn:setVisible(false)
            end
             
        end
    end

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
return PlaceLayer
