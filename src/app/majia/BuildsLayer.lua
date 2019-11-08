BuildsLayer = class("BuildsLayer",function()
    return cc.Layer:create()
end)


-- name 名字
-- income 收入
-- time_interval 收入时间间隔
-- levelup_coin 升级所需金币
-- levelup_piece 提升星等所需碎片
-- quality 品质
-- use 用途

-- type 特殊加成类型 1 增加建筑收入 2 收入时间间隔减少
-- build 加成建筑 0 为没有特殊加成
-- gain 增益 
-- txt 详情文字
BuildsLayer.val = {
    -- 民宅
    {
        name = "home",  
        income = {1 ,2 ,3 ,5 ,6 ,8 ,10 ,12 ,15 ,20 ,22 ,25 ,30 ,35 ,45 ,50 ,60 ,70 ,75 ,100}, 
        time_interval = 15 , 
        levelup_coin = {3, 6, 10, 20, 50, 100, 180, 250, 350, 480, 670, 890, 1120, 2050, 2500, 3080, 4200, 5620, 10000},
        quality = "普通",
        use = "住宅",

        levelup_piece = {50, 100, 9999}, 
        type = 1,
        build =  {2},
        gain = {100, 200, 300},
        txt = "集市的收入增加"
    },

    --集市
    {
        name = "market",  
        income = {3, 5, 10, 18, 30, 40, 55, 68, 80, 94, 123, 164, 210, 285, 333, 452, 6020, 840, 1150, 1545}, 
        time_interval = 20 , 
        levelup_coin = {10, 35, 64, 82, 120, 164, 225, 280, 548, 845, 1055, 1225, 1645, 2546, 4580, 6680, 8488, 14000, 28000},
        quality = "普通",
        use = "商业",

        levelup_piece = {50, 100, 9999},
        type = 1,
        build =  {1},
        gain = {100, 200, 300},
        txt = "民宅的收入增加"
    },

    --伐木场
    {
        name = "loggingyard",  
        income = {3, 8, 15, 23, 40, 58, 72, 92, 113, 142, 168, 210, 254, 313, 374, 452, 682, 946, 1348, 2863}, 
        time_interval = 25 , 
        levelup_coin = {20, 55, 84, 122, 160, 234, 305, 580, 888, 1145, 1355, 1725, 2645, 4346, 6580, 8980, 11000, 22000, 45000},
        quality = "优秀",
        use = "工业",

        levelup_piece = {20, 50, 9999},
        type = 2,
        build =  {1,2,3,4,5,6},
        gain = {1, 2, 3},
        txt = "收入间隔减少"
    },

    --矿石山
    {
        name = "miningcamps",  
        income = {15, 35, 58, 85, 120, 164, 255, 468, 690, 899, 1100,1500, 2300, 3000, 5000, 8400, 10000, 15000, 23000, 50000}, 
        time_interval = 15 ,
        levelup_coin = {20, 83, 145, 268, 554, 900, 1251, 1654, 2560, 3940, 5555, 8456, 12000, 19000, 29000, 48000, 64000, 80000, 145000},
        quality = "稀有",
        use = "资源",

        levelup_piece = {80, 150, 9999},
        type = 1,
        build =  {5},
        gain = {200, 300, 500},
        txt = "冶金场的收入增加"
    },

    --冶金场
    {
        name = "refinery",  
        income = {25, 40, 68, 95, 130, 180, 295, 588, 830, 1000, 1400, 1900, 3100, 4800, 6400, 9800, 16000, 28000, 37000, 64000}, 
        time_interval = 20, 
        levelup_coin = {20, 83, 145, 268, 554, 900, 1251, 1654, 2560, 3940, 5555, 8456, 12000, 19000, 29000, 48000, 64000, 80000, 155000},
        quality = "稀有",
        use = "工业",

        levelup_piece = {80, 150, 9999},
        type = 1,
        build =  {4},
        gain = {200, 300, 500},
        txt = "矿石山的收入增加"
    },

    --兵营
    {
        name = "barracks",  
        income = {45, 60, 82, 113, 160, 234, 355, 680, 900, 1200, 1800, 2900, 4700, 6300, 8800, 12000, 26000, 38000, 52000, 87000}, 
        time_interval = 35, 
        levelup_coin = {50, 103, 186, 357, 749, 1254, 1640, 2588, 4790, 6485, 8410, 12000, 29000, 46000, 62000, 84000, 112000, 155000, 205000},
        quality = "珍品",
        use = "战斗",

        levelup_piece = {100, 200, 9999},
        type = 1,
        build =  {1,2,3,4,5,6},
        gain = {100, 200, 400},
        txt = "所有建筑收入增加"
    }

}

local name = {"民宅", "集市", "伐木场", "矿石山", "冶金场", "兵营"}
function BuildsLayer:ctor(scend)
    self._scend = scend
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
           self:removeFromParent()
       end      
   
   end)
   btn_close:setPressedActionEnabled(true)
   layerColor:addChild(btn_close)   

   local txt_Title = cc.Label:createWithTTF("建筑中心", "majia/font/font.ttf", 40)
   txt_Title:enableOutline(cc.c4b(0x7b,0xbb,0xf8,255), 1)
   txt_Title:setPosition(cc.p(display.width * 0.52, display.height * 0.92))
   layerColor:addChild(txt_Title) 
 
    self.btn = {}
    self.level = {}
    for i = 1, 2 do
        for j = 1, 3 do
            local idx = (i - 1) * 3 + j
            local btn = ccui.Button:create("majia/images/builds/build_" .. idx ..".png","majia/images/builds/build_" .. idx ..".png","majia/images/builds/build_" .. idx ..".png")
            local driftX = (j - 1) * 0.21 + 0.31
            local driftY = 0.68 - (i - 1) * 0.42
            btn:setPosition(cc.p(display.width * driftX, display.height * driftY))
            btn:addTouchEventListener(function(sender, state)   
                if state == 2 then
                    if MainScene.isOpenEffect then
                        AudioEngine.playEffect("majia/sound/click.mp3")
                    end    
                    self:createDetails(idx)
                    
                end                 
            end)
            layerColor:addChild(btn) 
            table.insert(self.btn, btn)

            -- 未解锁蒙版
            local spr_mask =  cc.Sprite:create("majia/images/builds/builUnlock.png")
            local driftX = (j - 1) * 0.21 + 0.31
            local driftY = 0.68 - (i - 1) * 0.42
            spr_mask:setVisible(false)
            spr_mask:setPosition(cc.p(display.width * driftX, display.height * driftY))
            layerColor:addChild(spr_mask) 

            if not MainScene.UserData[idx].isunlock then
                btn:setEnabled(false)
                spr_mask:setVisible(true)
            else
                -- 等级
                local txt_level = cc.Label:createWithTTF(MainScene.UserData[idx].level, "majia/font/font.ttf", 20)
                txt_level:enableOutline(cc.c4b(0x8F,0x20,0x20,255), 1)
                txt_level:setPosition(cc.p(35, 223))
                btn:addChild(txt_level)
                self.level[idx] = txt_level

                -- 名字
                local txt_monet = cc.Label:createWithTTF(name[idx], "majia/font/font.ttf", 20)
                txt_monet:enableOutline(cc.c4b(0x8F,0x20,0x20,255), 1)
                txt_monet:setPosition(cc.p(100, 40))
                btn:addChild(txt_monet)

                --星级
                for k = 1,MainScene.UserData[idx].numberOfstars do
                    local stars = cc.Sprite:create("majia/images/stars.png")
                    stars:setPosition(cc.p(75 + (k - 1) * 30, 65))
                    btn:addChild(stars)
                end
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

function BuildsLayer:createDetails(idx)

    local layerColor = CCLayerColor:create(ccc4(0,0,0, 150),display.width,display.height)
    layerColor:setPosition(ccp(0,0))
    layerColor:setAnchorPoint(ccp(0,0))
    layerColor:setTouchEnabled(false)
    self:addChild(layerColor)
    self.layerColor = layerColor

    local money = cc.UserDefault:getInstance():getIntegerForKey("myMoney")

    local bg = cc.Sprite:create("majia/images/builds/details_".. idx ..".png")
    bg:setPosition(display.cx, display.cy)
    layerColor:addChild(bg)
 
    -- 星级
    for i = 1, MainScene.UserData[idx].numberOfstars do
        local stars = cc.Sprite:create("majia/images/stars.png")
        stars:setPosition(cc.p(display.width * (0.39 + (i - 1) * 0.03), display.height * 0.69))
        layerColor:addChild(stars)
    end

    -- 碎片
    if MainScene.UserData[idx].scraps >= BuildsLayer.val[idx].levelup_piece[MainScene.UserData[idx].numberOfstars] and MainScene.UserData[idx].numberOfstars < 3 then
        MainScene.UserData[idx].scraps = MainScene.UserData[idx].scraps - BuildsLayer.val[idx].levelup_piece[MainScene.UserData[idx].numberOfstars]
        MainScene.UserData[idx].numberOfstars = MainScene.UserData[idx].numberOfstars + 1

        self:createAnimation(idx)
        self._scend:upDataBuildInfo()

    end
 
       -- 碎片
    if MainScene.UserData[idx].scraps >= BuildsLayer.val[idx].levelup_piece[MainScene.UserData[idx].numberOfstars] and MainScene.UserData[idx].numberOfstars < 3 then
        MainScene.UserData[idx].scraps = MainScene.UserData[idx].scraps - BuildsLayer.val[idx].levelup_piece[MainScene.UserData[idx].numberOfstars]
        MainScene.UserData[idx].numberOfstars = MainScene.UserData[idx].numberOfstars + 1

        self:createAnimation(idx)

        self._scend:upDataBuildInfo()

    end

    local txt = cc.Label:createWithTTF(MainScene.UserData[idx].scraps.."/" .. BuildsLayer.val[idx].levelup_piece[MainScene.UserData[idx].numberOfstars], "majia/font/font.ttf", 25)
    txt:setPosition(cc.p(display.width * 0.41, display.height * 0.59))
    txt:enableOutline(cc.c4b(0x98,0x98,0xFF,255), 1)
    layerColor:addChild(txt)

    --进度条

    local Slider = cc.ControlSlider:create(
        cc.Sprite:create("majia/images/sliderBG.png"),
        cc.Sprite:create("majia/images/slider.png"),
        cc.Sprite:create("majia/images/transparent.png")
    )
    Slider:setPosition(cc.p(display.width * 0.41, display.height * 0.64))
    Slider:setValue(MainScene.UserData[idx].scraps / BuildsLayer.val[idx].levelup_piece[MainScene.UserData[idx].numberOfstars])
    layerColor:addChild(Slider)  

    self.Slider = Slider
    -- 名字
    local txt_Title = cc.Label:createWithTTF(name[idx], "majia/font/font.ttf", 30)
    txt_Title:enableOutline(cc.c4b(0x8F,0x20,0x20,255), 1)
    txt_Title:setPosition(cc.p(display.cx, display.height * 0.8))
    layerColor:addChild(txt_Title)

    --等级
    local txt = cc.Label:createWithTTF("等级:", "majia/font/font.ttf", 20)
    txt:setPosition(cc.p(display.width * 0.58, display.height * 0.68))
    layerColor:addChild(txt)

    local txt_level = cc.Label:createWithTTF(MainScene.UserData[idx].level .. "级", "majia/font/font.ttf", 20)
    txt_level:setAnchorPoint(0, 0.5)
    txt_level:setPosition(cc.p(display.width * 0.62, display.height * 0.68))
    layerColor:addChild(txt_level)


   -- 用途
   local txt = cc.Label:createWithTTF("用途:", "majia/font/font.ttf", 20)
   txt:setPosition(cc.p(display.width * 0.58, display.height * 0.63))
   layerColor:addChild(txt)

   local txt = cc.Label:createWithTTF(BuildsLayer.val[idx].use, "majia/font/font.ttf", 20)
   txt:setAnchorPoint(0, 0.5)
   txt:setPosition(cc.p(display.width * 0.62, display.height * 0.63))
   layerColor:addChild(txt)

    --品质
    local txt = cc.Label:createWithTTF("品质:", "majia/font/font.ttf", 20)
    txt:setPosition(cc.p(display.width * 0.58, display.height * 0.58))
    layerColor:addChild(txt)

    local txt_quality = cc.Label:createWithTTF(BuildsLayer.val[idx].quality, "majia/font/font.ttf", 20)
    txt_quality:setAnchorPoint(0, 0.5)
    txt_quality:setPosition(cc.p(display.width * 0.62, display.height * 0.58))
    layerColor:addChild(txt_quality)
    
    -- 收入
    local src = "收入: " .. BuildsLayer.val[idx].income[MainScene.UserData[idx].level] .. "/秒"
    local txt_income = cc.Label:createWithTTF(src, "majia/font/font.ttf", 20)
    txt_income:setAnchorPoint(0, 0.5)
    txt_income:setPosition(cc.p(display.width * 0.37, display.height * 0.47))
    layerColor:addChild(txt_income)

    -- 收入间隔
  
    if MainScene.UserData[idx].time_gain > 0 then
        src = "收入时间间隔: " .. BuildsLayer.val[idx].time_interval  .. "(-" .. MainScene.UserData[idx].time_gain ..")秒"
    else
        src = "收入时间间隔: " .. BuildsLayer.val[idx].time_interval .."秒"
    end
    
    local txt = cc.Label:createWithTTF(src, "majia/font/font.ttf", 20)
    txt:setAnchorPoint(0, 0.5)
    txt:setPosition(cc.p(display.width * 0.37, display.height * 0.38))
    layerColor:addChild(txt)

    -- 加成
    if BuildsLayer.val[idx].type == 1 then
        --建筑加成增益
        src = BuildsLayer.val[idx].txt .. BuildsLayer.val[idx].gain[MainScene.UserData[idx].numberOfstars] .."%"
    else
        -- 收入时间间隔增益
        src = BuildsLayer.val[idx].txt .. BuildsLayer.val[idx].gain[MainScene.UserData[idx].numberOfstars] .. "秒"
    end
    local txt = cc.Label:createWithTTF(src, "majia/font/font.ttf", 20)
    txt:setAnchorPoint(0, 0.5)
    txt:setPosition(cc.p(display.width * 0.37, display.height * 0.3))
    layerColor:addChild(txt)

    -- 升级
    local btn = ccui.Button:create("majia/images/builds/btn_upgrad.png","","")
    btn:setPosition(cc.p(display.width * 0.6 , display.height * 0.23))
    btn:addTouchEventListener(function(sender, state)   
        if state == 2 then
            if MainScene.isOpenEffect then
                AudioEngine.playEffect("majia/sound/levelup.mp3")
            end    

            if money > BuildsLayer.val[idx].levelup_coin[MainScene.UserData[idx].level] then
                money = money - BuildsLayer.val[idx].levelup_coin[MainScene.UserData[idx].level]
                self._scend:upDataMoney(-BuildsLayer.val[idx].levelup_coin[MainScene.UserData[idx].level])
                MainScene.UserData[idx].level = MainScene.UserData[idx].level + 1
                self._scend:upDataBuildInfo() 
                self.level[idx]:setString(MainScene.UserData[idx].level)
                if MainScene.UserData[idx].level >= 20 then
                    btn:setVisible(false)
                    local btn_spr = cc.Sprite:create("majia/images/builds/spr_btn.png")
                    btn_spr:setPosition(cc.p(display.cx , display.height * 0.23))
                    layerColor:addChild(btn_spr)
                    self.txt:setVisible(false)
                else
                    self.txt:setString("升级所需:" .. BuildsLayer.val[idx].levelup_coin[MainScene.UserData[idx].level].."金币")                    
                end
               
                -- 更新收入
                local src = "收入: " .. BuildsLayer.val[idx].income[MainScene.UserData[idx].level] .. "/秒"
                txt_income:setString(src)
               
                --更新等级
                txt_level:setString(MainScene.UserData[idx].level.."级")          
                self._scend:saveFile(cc.FileUtils:getInstance():getWritablePath().."UserData.json", MainScene.UserData)
                if MainScene.UserData[idx].level < 20 then
                    if money < BuildsLayer.val[idx].levelup_coin[MainScene.UserData[idx].level] then
                        btn:setEnabled(false)
                    end
                end
            else

                btn:setEnabled(false)
            end             

        end                 
    end)
    layerColor:addChild(btn) 

    if MainScene.UserData[idx].level >= 20 then
        btn:setVisible(false)
        local btn_spr = cc.Sprite:create("majia/images/builds/spr_btn.png")
        btn_spr:setPosition(cc.p(display.cx , display.height * 0.23))
        layerColor:addChild(btn_spr)

    else

        if money < BuildsLayer.val[idx].levelup_coin[MainScene.UserData[idx].level] then
            btn:setEnabled(false)
        end

        self.txt = cc.Label:createWithTTF("升级所需:" .. BuildsLayer.val[idx].levelup_coin[MainScene.UserData[idx].level].."金币" , "majia/font/font.ttf", 20)
        self.txt:setAnchorPoint(0, 0.5)
        self.txt:setPosition(cc.p(display.width * 0.35 , display.height * 0.23))
        layerColor:addChild(self.txt)
    end


    local function onTouchBegan( touch, event )
        
        return true
    end

    local function onTouchMoved( touch, event )
    end

    local function onTouchEnded( touch, event )
        layerColor:removeFromParent()
    end

    local listener1 = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    listener1:setSwallowTouches(true)  --是否向下传递
    listener1:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener1:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener1:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED ) 
    local eventDispatcher = layerColor:getEventDispatcher() 
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener1, layerColor) --分发监听事件
end


function BuildsLayer:createAnimation(idx)

   local act = cc.Sprite:create("majia/images/stars.png")
    act:setPosition(cc.p(display.cx, display.cy))
    self.layerColor:addChild(act)
    act:runAction(cc.Sequence:create(
        cc.ScaleTo:create(0.5, 3),
        cc.DelayTime:create(0.2),
        cc.Spawn:create(cc.ScaleTo:create(0.5, 1),
        cc.MoveTo:create(0.5, cc.p(display.width * (0.39 + (MainScene.UserData[idx].numberOfstars - 1) * 0.03), display.height * 0.69))
     )       
    ))
    local stars = cc.Sprite:create("majia/images/stars.png")
    stars:setPosition(cc.p(75 + (MainScene.UserData[idx].numberOfstars - 1) * 30, 65))
    self.btn[idx]:addChild(stars)
end

return BuildsLayer
