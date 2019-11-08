ShopLayer = class("ShopLayer",function()
    return cc.Layer:create()
end)


function ShopLayer:ctor(scene, ID)

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

    local price = {1000, 10000, 20000}
    for i = 1, 3 do

        local btn = ccui.Button:create("majia/images/shop/btn_" .. i ..".png","","majia/images/shop/btn_" .. i ..".png")
        btn:setPosition(cc.p(display.width * ((i - 1) * 0.25 + 0.3) , display.cy))
        btn:addTouchEventListener(function(sender, state)   
            if state == 2 then                    
                if self.scene.userMoney < price[i] then
                    sender:setEnabled(false)
                    local tips = self:createTips()                
                    self:addChild(tips) 
                    tips:runAction(
                        cc.Sequence:create(
                            cc.DelayTime:create(1.3),
                            cc.CallFunc:create(function()
                                tips:removeFromParent()
                            end)
                    ))
                    
                else
                    if MainScene.isOpenEffect then
                        AudioEngine.playEffect("majia/sound/box_open.mp3")
                    end 
                    self.scene:upDataMoney(-price[i])
                    self:createAnimation(i)
                    
                end
                
            end                 
        end)
        layerColor:addChild(btn) 

        local spr_money =  cc.Sprite:create("majia/images/shop/shop_moneybg.png")
        spr_money:setPosition(cc.p(104, 72))
        btn:addChild(spr_money) 

        local txt_monet = cc.Label:createWithTTF(price[i], "majia/font/font.ttf", 20)
        txt_monet:enableOutline(cc.c4b(0x89,0x23,0x23,255), 1)
        txt_monet:setPosition(cc.p(89, 67))
        txt_monet:setAnchorPoint(0, 0.5)
        btn:addChild(txt_monet)
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


local plistName = {"majia/images/shop/treasure1.plist", "majia/images/shop/treasure2.plist", "majia/images/shop/treasure3.plist"}

-- 没钱提示
function ShopLayer:createTips()
    local layerColor = CCLayerColor:create(ccc4(0,0,0, 200), display.width, display.height)
    --layerColor:setAnchorPoint(ccp(0.5,0.5))
    layerColor:setScale(0.5)

    local txt_tips = cc.Label:createWithTTF("对不起，资产不足", "majia/font/font.ttf", 40)
    txt_tips:setPosition(cc.p(display.width / 2, display.height / 2))
    --txt_tips:setAnchorPoint(0, 0)
    layerColor:addChild(txt_tips)

    return layerColor

end

-- 宝箱动画
function ShopLayer:createAnimation(idx)

    local layerColor = CCLayerColor:create(ccc4(0,0,0, 250),display.width,display.height)
    layerColor:setPosition(ccp(0,0))
    layerColor:setAnchorPoint(ccp(0,0))
    self:addChild(layerColor)

    local btn_close = ccui.Button:create("majia/images/btn_close.png","","")
    btn_close:setPosition(cc.p(display.width * 0.1, display.height * 0.85))
    btn_close:addTouchEventListener(function(sender, state)   
        if state == 2 then
            if MainScene.isOpenEffect then
                AudioEngine.playEffect("majia/sound/click.mp3")
            end    
            layerColor:removeFromParent()
        end      

    end)
    btn_close:setPressedActionEnabled(true)
    layerColor:addChild(btn_close)   

    local percent = {1,1,1,1,1,1,1,1,1,1,1,2,2,2,3,3,4,4,5,6,1,1,1,1,1,1,1,1,1,1,1,2,2,2,3,3,4,4,5,6}

    -- 开宝箱结果
    math.randomseed(os.time())
    local cardAnimation = {}
    for i = 1, 3 do
        local ranIdx = math.random(1, 40)
        
        local temp = {}  
        temp.spr = cc.Sprite:create("majia/images/place/place_" .. percent[ranIdx] .. ".png")
        temp.spr:setOpacity(0)
        temp.spr:setPosition(cc.p(display.width * ((i - 1) * 0.25 + 0.27) , display.height * 0.72))
        layerColor:addChild(temp.spr)

        if MainScene.UserData[percent[ranIdx]].isunlock then
            MainScene.UserData[percent[ranIdx]].scraps = MainScene.UserData[percent[ranIdx]].scraps + idx + 1
            temp.txt_scraps = cc.Label:createWithTTF( "x" .. idx + 1, "majia/font/font.ttf", 30)
            temp.txt_scraps:setOpacity(0)
            temp.txt_scraps:enableOutline(cc.c4b(0x89,0x23,0x23,255), 1)
            temp.txt_scraps:setPosition(cc.p(130, 50))
            temp.spr:addChild(temp.txt_scraps)

            
            temp.txt_new = cc.Label:createWithTTF( "碎片", "majia/font/font.ttf", 30)
            temp.txt_new:setOpacity(0)
            temp.txt_new:enableOutline(cc.c4b(0xFF,0x00,0x00,255), 1)
            temp.txt_new:setPosition(cc.p(50, 270))
            temp.spr:addChild(temp.txt_new)
        else
            MainScene.UserData[percent[ranIdx]].isunlock = true
            temp.txt_scraps = cc.Label:createWithTTF( "x1", "majia/font/font.ttf", 30)
            temp.txt_scraps:setOpacity(0)
            temp.txt_scraps:enableOutline(cc.c4b(0x89,0x23,0x23,255), 1)
            temp.txt_scraps:setPosition(cc.p(130, 50))
            temp.spr:addChild(temp.txt_scraps)

            temp.txt_new = cc.Label:createWithTTF( "新!", "majia/font/font.ttf", 30)
            temp.txt_new:setOpacity(0)
            temp.txt_new:enableOutline(cc.c4b(0xFF,0x00,0x00,255), 1)
            temp.txt_new:setPosition(cc.p(50, 270))
            temp.spr:addChild(temp.txt_new)


        end
        
        temp.name = cc.Label:createWithTTF( MainScene.UserData[percent[ranIdx]].name, "majia/font/font.ttf", 30)
        temp.name:setOpacity(0)
        temp.name:enableOutline(cc.c4b(0x89,0x23,0x23,255), 1)
        temp.name:setPosition(cc.p(130, 90))
        temp.spr:addChild(temp.name)
        table.insert( cardAnimation, temp)
    end

    self.scene:saveFile(cc.FileUtils:getInstance():getWritablePath().."UserData.json", MainScene.UserData)
    
    cc.SpriteFrameCache:getInstance():addSpriteFrames(plistName[idx])

    if not cc.SpriteFrameCache:getInstance():isSpriteFramesWithFileLoaded(plistName[idx]) then
        cc.SpriteFrameCache:getInstance():addSpriteFrames(plistName[idx])
    end

    local spriteFrame = cc.SpriteFrameCache:getInstance()  
  
    local spriteTest = cc.Sprite:createWithSpriteFrameName("box" .. idx .. "_00000.png")  
    spriteTest:setAnchorPoint( 0.5, 0.5 )  
    spriteTest:setPosition(cc.p(display.cx, display.cy))  
    layerColor:addChild( spriteTest )  
  

    local animation = cc.Animation:create()  
    for i = 1, 30 do  
        local frameName = string.format("box" .. idx .. "_000%02d.png", i )  
        local blinkFrame = spriteFrame:getSpriteFrame(frameName)  
        animation:addSpriteFrame( blinkFrame )  
    end  

    animation:setDelayPerUnit( 0.08 )--设置每帧的播放间隔  
    animation:setRestoreOriginalFrame( false )--设置播放完成后是否回归最初状态  
    animation:setLoops(1)
    local action = cc.Animate:create(animation)  
    -- spriteTest:runAction( cc.RepeatForever:create( action ) )  无限循环播放
    spriteTest:setScale(1.2)
    spriteTest:runAction(cc.Sequence:create(
    cc.Repeat:create( action, 1 ), 
    cc.MoveTo:create(0.1, cc.p(display.cx, display.height * 0.2)),
    cc.CallFunc:create(function() 

            for i = 1, 3 do
                cardAnimation[i].spr:runAction(
                    cc.Sequence:create(
                        cc.DelayTime:create(i / 10),
                        cc.FadeIn:create(0.5)
                    )
                )

                cardAnimation[i].txt_scraps:runAction(
                    cc.Sequence:create(
                        cc.DelayTime:create(i / 10),
                        cc.FadeIn:create(0.5)
                    )
                )

                cardAnimation[i].name:runAction(
                    cc.Sequence:create(
                        cc.DelayTime:create(i / 10),
                        cc.FadeIn:create(0.5)
                    )
                )

                cardAnimation[i].txt_new:runAction(
                    cc.Sequence:create(
                        cc.DelayTime:create(i / 10),
                        cc.FadeIn:create(0.5)
                    )
                )
            end
        end)
    ))

     local function onTouchBegan( touch, event )
        return true
    end

    local function onTouchMoved( touch, event )
    end

    local function onTouchEnded( touch, event )
      --  layerColor:removeFromParent()
    end

    local listener1 = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    listener1:setSwallowTouches(true)  --是否向下传递
    listener1:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener1:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener1:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED ) 
    local eventDispatcher = layerColor:getEventDispatcher() 
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener1, layerColor) --分发监听事件
end

return ShopLayer
