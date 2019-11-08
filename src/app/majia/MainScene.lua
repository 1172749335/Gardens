require "app.majia.HelpLayer"
require "app.majia.BuildsLayer"
require "app.majia.PlaceLayer"
require "app.majia.ShopLayer"
require "app.majia.GloryLayer"
local json = require("json")
--require "app.majia.HelpLayer"
MainScene = class("MainScene",function()
    return cc.Scene:create()
end)

function MainScene:create()
    local scene = MainScene.new()
    scene:addChild(scene:createLayer())
    return scene
end

MainScene.isOpenMusic = true
MainScene.isOpenEffect = true

-- 用户建筑数据
MainScene.UserData = {}

function MainScene:ctor()
    
    -- 玩家金钱
    self.userMoney = 0

    -- 放置区域
    self.placePositio = {
        {x = 0.21, y = 0.41},
        {x = 0.34, y = 0.53},
        {x = 0.47, y = 0.40},
        {x = 0.47, y = 0.65},
        {x = 0.61, y = 0.52},
        {x = 0.75, y = 0.43},
    }

    -- 筑物数值表
    self.buildsVal = {{},{},{},{},{},{}}
end

--读取json文件
function MainScene:loadFile(filename)
    local file
    if filename == nil then
        file = io.stdin
    else
        local err
        file, err = io.open(filename, "rb")
        if file == nil then
            error(("Unable to read '%s': %s"):format(filename, err))
        end
    end
    local data = file:read("*a")

    if filename ~= nil then
        file:close()
    end

    if data == nil then
        error("Failed to read " .. filename)
    end
    data = json.decode(data)
    return data
end

-- Function 保存文件
function MainScene:saveFile(filename, data) --filename 全路径    data为lua中的table

    local file
    if filename == nil then
        file = io.stdout
    else
        local err
        file, err = io.open(filename, "wb")
        if file == nil then
            error(("Unable to write '%s': %s"):format(filename, err))
        end
    end
    data = json.encode(data)
    file:write(data)
    if filename ~= nil then
        file:close()
    end
end

local buildsName = {"民宅", "集市", "伐木场", "矿石山", "冶金场", "兵营"}

function MainScene:initData()
    for i = 1, 6 do
        local temp = {}
        -- 建筑名字
        temp.name = buildsName[i]
        -- 建筑标识
        temp.tag = i
        -- 是否解锁
        temp.isunlock = false
        if i == 1 then
            temp.isunlock = true
        end

        -- 放置位置 0为为未放置
        temp.place = 0
        -- 碎片数量
        temp.scraps = 0
        -- 等级
        temp.level = 1
        -- 星级
        temp.numberOfstars = 1
        -- 收入时间间隔增益
        temp.time_gain = 0
        -- 收入增益
        temp.income_gain = 0
        -- 当前收入
        temp.income = BuildsLayer.val[i].income[1]
        -- 当前收入时间间隔
        temp.time_interval = BuildsLayer.val[i].time_interval
        --领取倒计时
        temp.countDown = BuildsLayer.val[i].time_interval
        -- 获得金钱
        temp.productive = 0

        table.insert(MainScene.UserData, temp)

    end

    self:saveFile(cc.FileUtils:getInstance():getWritablePath().."UserData.json", MainScene.UserData)
end

-- 创建层
function MainScene:createLayer()

    -- 是否是第一次登陆
    if not cc.UserDefault:getInstance():getBoolForKey("noviceguidance", false) then
        cc.UserDefault:getInstance():setIntegerForKey("myMoney", 0)
        cc.UserDefault:getInstance():setBoolForKey("noviceguidance", true)
        self.userMoney = 0
        self:initData()
        
        -- 成就
        cc.UserDefault:getInstance():setBoolForKey("task1", false)
        cc.UserDefault:getInstance():setBoolForKey("task2", false)
        cc.UserDefault:getInstance():setBoolForKey("task3", false)
        cc.UserDefault:getInstance():setBoolForKey("task4", false)
        cc.UserDefault:getInstance():setBoolForKey("task5", false)
        cc.UserDefault:getInstance():setBoolForKey("task6", false)

    else
        self.userMoney = cc.UserDefault:getInstance():getIntegerForKey("myMoney")
      
        if cc.FileUtils:getInstance():isFileExist("UserData.json") then
            MainScene.UserData = self:loadFile("UserData.json")  
        else
            cc.UserDefault:getInstance():setIntegerForKey("myMoney", 100)
            cc.UserDefault:getInstance():setBoolForKey("noviceguidance", true)
            self.userMoney = 100
            self:initData()
            
            -- 成就
            cc.UserDefault:getInstance():setBoolForKey("task1", false)
            cc.UserDefault:getInstance():setBoolForKey("task2", false)
            cc.UserDefault:getInstance():setBoolForKey("task3", false)
            cc.UserDefault:getInstance():setBoolForKey("task4", false)
            cc.UserDefault:getInstance():setBoolForKey("task5", false)
            cc.UserDefault:getInstance():setBoolForKey("task6", false)
        end

        MainScene.isOpenMusic = cc.UserDefault:getInstance():getBoolForKey("isOpenMusic")
        MainScene.isOpenEffect = cc.UserDefault:getInstance():getBoolForKey("isOpenEffect")
        self:upDataBuildInfo()

 
    end

    if MainScene.isOpenMusic then 
        PLAY_BACKGROUND_MUSIC()
    end


    -- add background image
    local layer = cc.Layer:create()
    local sprite = cc.Sprite:create("majia/images/gamebg.png")
    sprite:setPosition(cc.p(display.cx, display.cy))
    layer:addChild(sprite)
    local scX = display.width/sprite:getContentSize().width
    local scY = display.height/sprite:getContentSize().height
    sprite:setScaleX(scX)
    sprite:setScaleY(scY)

    -- 帮助
    local btn_help = ccui.Button:create("majia/images/btn_help.png","","")
    btn_help:setPosition(display.width * 0.74, display.height * 0.9)
    btn_help:addTouchEventListener(function(sender, state)   
        if state == 2 then
            if MainScene.isOpenEffect then
                AudioEngine.playEffect("majia/sound/click.mp3")
            end    
            layer:addChild(HelpLayer:create())                     
        end           
    end)
    btn_help:setPressedActionEnabled(true)
    layer:addChild(btn_help)

    -- 音乐
    local musicBtn = ccui.Button:create("majia/images/muisc_on.png","","")
    musicBtn:setPosition(display.width * 0.83, display.height * 0.9)
    musicBtn:addTouchEventListener(function(sender, state)   
        if state == 2 then
            if MainScene.isOpenMusic then
                AudioEngine.playEffect("majia/sound/click.mp3")
            end 
            
            if MainScene.isOpenMusic then
                MainScene.isOpenMusic = false
                musicBtn:loadTextureNormal("majia/images/music_off.png")
                cc.UserDefault:getInstance():setBoolForKey("isOpenMusic" , MainScene.isOpenMusic)
                cc.SimpleAudioEngine:getInstance():pauseMusic()
            else
                MainScene.isOpenMusic = true
                musicBtn:loadTextureNormal("majia/images/muisc_on.png")
                cc.UserDefault:getInstance():setBoolForKey("isOpenMusic" , MainScene.isOpenMusic)
                PLAY_BACKGROUND_MUSIC()
            end
        end      
    end)
    musicBtn:setPressedActionEnabled(true)
    layer:addChild(musicBtn)
    if MainScene.isOpenMusic then
        musicBtn:loadTextureNormal("majia/images/muisc_on.png")       
    else
        musicBtn:loadTextureNormal("majia/images/music_off.png")
    end

    -- 音效
    local effectBtn = ccui.Button:create("majia/images/effects_on.png","","")
    effectBtn:setPosition(display.width * 0.92, display.height * 0.9)
    effectBtn:addTouchEventListener(function(sender, state)   
        if state == 2 then
            
            if MainScene.isOpenEffect then
                MainScene.isOpenEffect = false
                effectBtn:loadTextureNormal("majia/images/effects_off.png")
                cc.UserDefault:getInstance():setBoolForKey("isOpenEffect" , MainScene.isOpenEffect)
                
            else
                MainScene.isOpenEffect = true
                effectBtn:loadTextureNormal("majia/images/effects_on.png")
                cc.UserDefault:getInstance():setBoolForKey("isOpenEffect" , MainScene.isOpenEffect)
                if MainScene.isOpenEffect then
                    AudioEngine.playEffect("majia/sound/click.mp3")
                end 
            end
        end      
    end)
    effectBtn:setPressedActionEnabled(true)
    layer:addChild(effectBtn)
    if MainScene.isOpenEffect then
        effectBtn:loadTextureNormal("majia/images/effects_on.png")       
    else
        effectBtn:loadTextureNormal("majia/images/effects_off.png")
    end

    -- 建筑
    local btn_builds = ccui.Button:create("majia/images/btn_buildings.png","","")
    btn_builds:setPosition(display.width * 0.68, display.height * 0.14)
    btn_builds:addTouchEventListener(function(sender, state)   
        if state == 2 then
            if MainScene.isOpenEffect then
                AudioEngine.playEffect("majia/sound/click.mp3")
            end    
                      
            layer:addChild(BuildsLayer:create(self))
        end       
    end)
    btn_builds:setPressedActionEnabled(true)
    layer:addChild(btn_builds) 

    -- 商店
    local btn_shop = ccui.Button:create("majia/images/btn_shop.png","","")
    btn_shop:setPosition(display.width * 0.8,  display.height * 0.14)
    btn_shop:addTouchEventListener(function(sender, state)   
        if state == 2 then
            if MainScene.isOpenEffect then
                AudioEngine.playEffect("majia/sound/click.mp3")
            end    

            layer:addChild(ShopLayer:create(self))
        end       
    end)
    btn_shop:setPressedActionEnabled(true)
    layer:addChild(btn_shop)

    -- 成就
    local btn_glory = ccui.Button:create("majia/images/btn_glory.png","","")
    btn_glory:setPosition(display.width * 0.92,  display.height * 0.14)
    btn_glory:addTouchEventListener(function(sender, state)   
        if state == 2 then
            if MainScene.isOpenEffect then
                AudioEngine.playEffect("majia/sound/click.mp3")
            end    
            layer:addChild(GloryLayer:create(self))
        end      
    end)
    btn_glory:setPressedActionEnabled(true)
    layer:addChild(btn_glory)

    -- 玩家金币
    local spr_moneyBg = cc.Sprite:create("majia/images/bg_money.png")
    spr_moneyBg:setPosition(cc.p(display.width * 0.13, display.height * 0.9))
    layer:addChild(spr_moneyBg)

    self.txt_money = cc.Label:createWithTTF(self:formatMoney(self.userMoney), "majia/font/font.ttf", 30)
    self.txt_money:setAnchorPoint(cc.p(0, 0.5))
    self.txt_money:setPosition(cc.p(display.width * 0.1, display.height * 0.9))
    layer:addChild(self.txt_money)

    self.placeTable = {}
    -- 放置区域
    for i = 1, 6 do
        local temp = {}
        temp.btn = ccui.Button:create("majia/images/placeBG.png","","")
        temp.btn:setPressedActionEnabled(true)      
        temp.btn:setTag(i)
        temp.btn:setScale(1.1)
        temp.btn:setPosition(cc.p(display.width * self.placePositio[i].x, display.height * self.placePositio[i].y))
        temp.btn:addTouchEventListener(function(sender, state)   
            if state == 2 then
                for j = 1, #self.placeTable do
                    self.placeTable[j].mask:setVisible(false)
                    self.placeTable[j].arrow:setVisible(false)
                    if sender:getTag() == j then
                        self.placeTable[j].mask:setVisible(true)
                        self.placeTable[j].arrow:setVisible(true)
                    end
                end
                layer:addChild(PlaceLayer:create(self, i))
            end               
        end)
        layer:addChild(temp.btn)

        temp.mask = cc.Sprite:create("majia/images/place.png")
        temp.mask:setAnchorPoint(0, 0.5)
        temp.mask:setVisible(false)
        temp.mask:setPosition(cc.p(0, 48))
        temp.btn:addChild(temp.mask)
        

        temp.arrow = cc.Sprite:create("majia/images/placearrows.png")
        temp.arrow:setPosition(cc.p(60, 50))
        temp.arrow:setAnchorPoint(0, 0)
        temp.arrow:setVisible(false)
        temp.btn:addChild(temp.arrow)
        temp.arrow:runAction(cc.RepeatForever:create(cc.Sequence:create(
            cc.MoveTo:create(0.4, cc.p(60, 70)),
            cc.MoveTo:create(0.4, cc.p(60, 50))
        )))

        table.insert(self.placeTable, temp)
    end

    self.layer = layer

    local NoPlace = {}
    for i = 1, 6 do
        if MainScene.UserData[i].place ~= 0 then
            self:createBuild(i, MainScene.UserData[i].place)
            table.insert(NoPlace, MainScene.UserData[i].place)            
        end
    end

    for i = 1, 6 do
        local isHave = true
        for j = 1, #NoPlace do
            if NoPlace[j] == i then
                isHave = false
            end
        end
        if isHave then
            self.placeTable[i].mask:setVisible(true)
            self.placeTable[i].arrow:setVisible(true)
            break
        end
    end

    self:createClock()
    return layer

end

-- 放置建筑
function MainScene:createBuild(idx, ID)
 
    local val = {}
    local bg = cc.Sprite:create("majia/images/"..idx..".png")
    bg:setPosition(self.placeTable[ID].btn:getPosition())
    self.layer:addChild(bg)

    local stars = cc.Sprite:create("majia/images/stars.png")
    stars:setPosition(cc.p(55, 10))
    bg:addChild(stars)

    local btn = ccui.Button:create("majia/images/btn_getN.png","","majia/images/btn_getP.png")
    btn:setPressedActionEnabled(true)      
    btn:setPosition(cc.p(74, -20))
    btn:setEnabled(false)
    btn:setTag(idx)
    btn:addTouchEventListener(function(sender, state)   
        if state == 2 then

            if MainScene.isOpenEffect then
                AudioEngine.playEffect("majia/sound/coin.mp3")
            end

            btn:setEnabled(false)
            local count = math.floor((math.abs(MainScene.UserData[btn:getTag()].countDown) +  MainScene.UserData[btn:getTag()].time_interval) / MainScene.UserData[btn:getTag()].time_interval)       
            local productive = count * MainScene.UserData[btn:getTag()].income * MainScene.UserData[btn:getTag()].time_interval
            if productive > MainScene.UserData[btn:getTag()].productive then
                self:upDataMoney(MainScene.UserData[btn:getTag()].productive) 
                MainScene.UserData[btn:getTag()].productive = MainScene.UserData[btn:getTag()].productive - MainScene.UserData[btn:getTag()].productive
                self.buildsVal[MainScene.UserData[btn:getTag()].place].txt:setString("0")               
            else
                self:upDataMoney(val.num) 
                MainScene.UserData[btn:getTag()].productive = MainScene.UserData[btn:getTag()].productive - productive  
                self.buildsVal[MainScene.UserData[btn:getTag()].place].txt:setString(MainScene.UserData[btn:getTag()].productive)               
            end
                
            MainScene.UserData[btn:getTag()].countDown = MainScene.UserData[btn:getTag()].countDown + MainScene.UserData[btn:getTag()].time_interval * count
                               
        end               
    end)
    bg:addChild(btn)
    val.btn = btn
    local txt = cc.Label:createWithTTF("生产中...", "majia/font/font.ttf", 12)
    txt:enableOutline(cc.c4b(0x04,0xa6,0x04,255), 1)
    txt:setPosition(cc.p(74, 80))
    bg:addChild(txt)

    local txt_monet = cc.Label:createWithTTF("0", "majia/font/font.ttf", 15)
    txt_monet:enableOutline(cc.c4b(0x04,0xa6,0x04,255), 1)
    txt_monet:setPosition(cc.p(89, 10))
    bg:addChild(txt_monet)
    val.txt = txt_monet
    val.idx = idx
    val.num = 0

    self.placeTable[ID].btn:setVisible(false)
    self.buildsVal[ID] = val

    MainScene.UserData[idx].place = ID
    self:saveFile(cc.FileUtils:getInstance():getWritablePath().."UserData.json", MainScene.UserData)

end

-- 格式化金钱
function MainScene:formatMoney(txt)

    local str = ""
    if txt > 9999 then
        str = tostring(math.floor(txt / 1000)) .. "...k"
    else
        str = tostring(txt)
    end
    return str
end

-- 刷新金钱
function MainScene:upDataMoney(num)
    self.userMoney = self.userMoney + num
    self.txt_money:setString(self:formatMoney(self.userMoney))
    cc.UserDefault:getInstance():setIntegerForKey("myMoney", self.userMoney)
end

-- 创建时钟
function MainScene:createClock()

    local scheduler = cc.Director:getInstance():getScheduler()
    self.schedulerID = nil
    self.schedulerID = scheduler:scheduleScriptFunc(function()
       -- dump(MainScene.UserData)
        for i = 1, 6 do
            if MainScene.UserData[i].place ~= 0 then
                -- 刷新金币       
                MainScene.UserData[i].productive = MainScene.UserData[i].productive + MainScene.UserData[i].income + MainScene.UserData[i].income_gain * MainScene.UserData[i].income
                self.buildsVal[MainScene.UserData[i].place].txt:setString(self:formatMoney(MainScene.UserData[i].productive))
                self.buildsVal[MainScene.UserData[i].place].num = MainScene.UserData[i].productive
                --是否可以领取
                MainScene.UserData[i].countDown = MainScene.UserData[i].countDown - 1
                if MainScene.UserData[i].countDown < 1 then
                    self.buildsVal[MainScene.UserData[i].place].btn:setEnabled(true)
                end                

            end
        end
      --  dump(MainScene.UserData)
        self:saveFile(cc.FileUtils:getInstance():getWritablePath().."UserData.json", MainScene.UserData)
    end,1,false)  

end

-- 销毁时钟
function MainScene:closeClock()
    if self.schedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    end
end

function MainScene:onExit()
    self:closeClock()
end

--建筑信息校准
function MainScene:upDataBuildInfo()

 
    -- 先计算增益效果在计算产金能力
    for i = 1, 6 do        
        MainScene.UserData[i].income_gain = 0
        MainScene.UserData[i].time_gain = 0

        MainScene.UserData[i].income = 0
        MainScene.UserData[i].time_interval = 0
    end

    for i = 1, 6 do
        if MainScene.UserData[i].isunlock then
            -- 1为收入增益 2为收入时间间隔增益
            if BuildsLayer.val[i].type == 1 then
                for j = 1, #BuildsLayer.val[i].build do
                    if MainScene.UserData[BuildsLayer.val[i].build[j]].isunlock then
                        MainScene.UserData[BuildsLayer.val[i].build[j]].income_gain = BuildsLayer.val[i].gain[MainScene.UserData[BuildsLayer.val[i].build[j]].numberOfstars] / 100
                    end
                end
            elseif BuildsLayer.val[i].type == 2 then
                for j = 1, #BuildsLayer.val[i].build do
                    if MainScene.UserData[BuildsLayer.val[i].build[j]].isunlock then
                        MainScene.UserData[BuildsLayer.val[i].build[j]].time_gain = BuildsLayer.val[i].gain[MainScene.UserData[i].numberOfstars]
                    end
                end
            end
            
        end     
    end

    for i = 1, 6 do
        MainScene.UserData[i].income = BuildsLayer.val[i].income[MainScene.UserData[i].level] + BuildsLayer.val[i].income[MainScene.UserData[i].level] * MainScene.UserData[i].income_gain 
        MainScene.UserData[i].time_interval = BuildsLayer.val[i].time_interval - MainScene.UserData[i].time_gain
    end
    
    self:saveFile(cc.FileUtils:getInstance():getWritablePath().."UserData.json", MainScene.UserData)
   
end

return MainScene
