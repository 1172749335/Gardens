GloryLayer = class("GloryLayer",function()
    return cc.Layer:create()
end)

function GloryLayer:ctor(scend)
    self._scend = scend
    local layerColor = CCLayerColor:create(ccc4(0,0,0, 250),display.width,display.height)
    layerColor:setPosition(ccp(0,0))
    layerColor:setAnchorPoint(ccp(0,0))
    self:addChild(layerColor)

    local txt_Title = cc.Label:createWithTTF("成就一览", "majia/font/font.ttf", 35)
    txt_Title:enableOutline(cc.c4b(0x1E,0x90,0xFF,255), 1)
    txt_Title:setPosition(cc.p(display.cx, display.height * 0.9))
    layerColor:addChild(txt_Title) 

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

    local count = {0, 0}
    for i = 1, 6 do
        -- 获得建筑数量
        if MainScene.UserData[i].isunlock then
            count[1] = count[1] + 1
        end  
        
        -- 获得三星建筑数量
        if MainScene.UserData[i].numberOfstars >= 3 then
            count[2] = count[2] + 1
        end
    end


    local txtT = {"获得3个建筑", "获得全部建筑", "升级获得1幢3星建筑", "升级获得3幢3星建筑", "升级获得所有3星建筑", "拥有资产1000K"}
    local T = {3, 6, 1, 3 ,6, 1000000}
    local content = {}
    for i = 1, 3 do
        local content2 = {}
        for j = 1, 2 do
            tb = {}
            tb.idx = (i - 1) * 3 + j
            tb.title = txtT[idx]
            tb.taks = cc.UserDefault:getInstance():getBoolForKey("task".. tb.idx) 
            tb.total = T[idx]
            tb.num = 0
            tb.money = cc.UserDefault:getInstance():getIntegerForKey("myMoney") 
            table.insert( content2, tb)         
        end
        table.insert(content, content2)
    end
   
    ---------获得建筑成就--------------
    if count[1] >= 3 then
        content[1][1].num = 3
    else
        content[1][1].num = count[1]
    end

    if count[1] >= 6 then
        content[1][2].num = 6
    else
        content[1][2].num = count[1] 
    end  

    ---------------- 三星建筑成就-------------
    if count[2] >= 1 then
        content[2][1].num = 1
    else
        content[2][1].num = 0
    end

    if count[2] >= 3 then
        content[2][2].num = 3
    else
        content[2][2].num = count[2] 
    end   

    if count[2] >= 6 then
        content[3][1].num = 6
    else
        content[3][1].num = count[2] 
    end   

    ---------------资产成就 --------------
    content[3][2].num = content[3][2].money

    ---------奖励------------
    local reward = {100000, 300000, 500000, 1000000, 1500000, 1000000}

    local listView = ccui.ListView:create();	
    listView:setPosition(cc.p(236, 55));	
    listView:setContentSize(cc.size(800, 500));	
    listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);	
    listView:setBounceEnabled(true);	
    listView:setItemsMargin(20)
    listView:setClippingEnabled(true)
    layerColor:addChild(listView)

    for k = 1, 3 do
        local spr = 0
        local layer = ccui.Layout:create()
        layer:setContentSize(cc.size(800, 200))
        for i = 1, 2 do

            local idx = (k - 1) * 2 + i
            spr = cc.Sprite:create("majia/images/glory/GloryLayer" .. i ..".png")
            spr:setPosition(cc.p(0 + (i - 1) * 400, 0))
            spr:setAnchorPoint(0, 0)
            layer:addChild(spr)

            local txt = cc.Label:createWithTTF(txtT[idx], "majia/font/font.ttf", 25)
            txt:enableOutline(cc.c4b(0x7b,0xbb,0xf8,255), 1)
            txt:setPosition(cc.p(245, 157))
            spr:addChild(txt) 

    
            local Slider = cc.ControlSlider:create(
                cc.Sprite:create("majia/images/sliderBG.png"),
                cc.Sprite:create("majia/images/slider.png"),
                cc.Sprite:create("majia/images/transparent.png")
            )
            Slider:setPosition(cc.p(235, 109))
            Slider:setValue(content[k][i].num /  T[idx])           
            spr:addChild(Slider)  

            local txt = cc.Label:createWithTTF(content[k][i].num .. "/" .. T[idx], "majia/font/font.ttf", 25)
            txt:enableOutline(cc.c4b(0x7b,0xbb,0xf8,255), 1)
            txt:setPosition(cc.p(235, 66))
            spr:addChild(txt) 
            

            local btn = ccui.Button:create("majia/images/glory/btn_getN.png","","")--"majia/images/btn_getP.png")
            btn:setPressedActionEnabled(true)     
            btn:setTag(idx)
            btn:setEnabled(false)
            btn:setPosition(cc.p(235, 17))
            btn:addTouchEventListener(function(sender, state)   
                if state == 2 then
                    cc.UserDefault:getInstance():setBoolForKey("task".. sender:getTag(), true)    
                    sender:setVisible(false) 
                    
                    local enabled = cc.Sprite:create("majia/images/glory/btn_getP.png")
                    enabled:setPosition(cc.p(235, 17))
                    layer:addChild(enabled)   
                    
                    self._scend:upDataMoney(reward[sender:getTag()])
                end               
            end)

            if content[k][i].taks == true then
                btn:setVisible(false) 
                local enabled = cc.Sprite:create("majia/images/glory/btn_getP.png")
                enabled:setPosition(cc.p(235, 17))
                layer:addChild(enabled)     
            else
                if content[k][i].num >= T[idx] then
                    btn:setEnabled(true)
                end
            end

            spr:addChild(btn)
             
        end

        listView:pushBackCustomItem(layer)
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
return GloryLayer
