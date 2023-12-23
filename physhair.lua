return function (mod)
    
    ---@class hairlib
    ---@field SetHairData fun(playertype:PlayerType, data:PlayerHairDataIn)

    local mod = BethHair
    local Isaac = Isaac
    local game = Game()
    local Room 
    local Wtr = 20/13

    local maxcoord = 4
    local scretch = math.ceil(5* Wtr)-- 30/(maxcoord+1)
    local headsize = 20* Wtr


    local ExampleRenderLayers = { -- first bit = visible, second bit = layer
        [3] = {3,3}, --HeadDown
        [0] = {2,3}, --HeadLeft
        [1] = {3,3}, --HeadUp
        [2] = {3,2}, --HeadRight
    }
    

    _HairCordData = {PlayerData = {}, Callbacks = {}}
    ---@type PlayerHairData[]
    PlayerData = _HairCordData.PlayerData

    local function addCallbackID(name)
        _HairCordData.Callbacks[name] = setmetatable({},{__concat = function(t,b) return "[Phys Hair] "..name..b end})
    end 
    local callbacks = {
        HAIR_POST_UPDATE = {},
    }
    for i,k in pairs(callbacks) do
        addCallbackID(i)
    end

    ---@class PlayerHairDataIn
    ---@field CordSpr Sprite|any
    ---@field Scretch number?
    ---@field DotCount integer?
    ---@field TailCount integer?
    ---@field RenderLayers integer[][]
    ---@field CostumeNullposes string[]
    ---@field HeadBackSpr Sprite?

    ---@class PlayerHairData
    ---@field CordSpr Sprite|any
    ---@field Scretch number
    ---@field DotCount integer
    ---@field TailCount integer
    ---@field RL integer[][]
    ---@field Null string[]
    ---@field BackSpr Sprite?

    function _HairCordData.SetHairData(playertype, data)
        if playertype then
            PlayerData[playertype] = {
                CordSpr = data.CordSpr,
                Scretch = data.Scretch or scretch,
                DotCount = data.DotCount or maxcoord,
                TailCount = data.TailCount or 1,
                RL = data.RenderLayers,
                Null = data.CostumeNullposes,
                BackSpr = data.HeadBackSpr,
            }
            
        end
    end



    local function sign(val)
        return val>0 and 1 or val<0 and -1 or 0
    end
    
    local z = Vector(0,0)
    local worldToScreen1 = Isaac.WorldToScreen
    local function worldToScreen(vec)
        return worldToScreen1(z) + vec/Wtr
    end
    
    local function ScreenToWorld(vec)
        return  (vec-worldToScreen1(Vector(0,0))) * Wtr
    end
    
    local function physhair(HairData, StartPos, scale, headpos)
        local cdat = HairData
        local tail1 = HairData
        local plpos1 = StartPos
        local scretch = cdat.scretch
    
        for i=0, maxcoord-1 do
            local prep, nextp
            local cur = tail1[i]
            local lpos = cur[1]
    
            
            local srch = cur[3]
            if i == 0 then
                prep = plpos1 --+(plpos1-lpos):Resized(scretch*.7)
            else
                prep = tail1[i-1][1]
            end
            --if i < maxcoord-1 then
            --    nextp = tail1[i+1][1]
            --end
    
            cur[2] = cur[2] + Vector(0,.8*scale)
            if prep then
                local bttdis = lpos:Distance(prep)
                
                if bttdis > scretch then
                    cur[1] = prep-(prep-lpos):Resized(scretch*scale)
                    lpos = cur[1]
                    bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
                end
    
                --local velic = Vector(1,0):Rotated( (nextpos - data.SWkishki.pos[i]):GetAngleDegrees() ):Resized( math.max(0,(nextpos:Distance(data.SWkishki.pos[i])-Stretch)*0.10) ) --0.07
                local vel = (prep-lpos):Resized(math.max(-1,bttdis-scretch))
                cur[2] = (cur[2]* .88 + vel * .12)
                --cur[2] = cur[2] * 0.2 + vel * .8
            end
            --if nextp then
            --    local bttdis = lpos:Distance(nextp)
    
                --local velic = Vector(1,0):Rotated( (nextpos - data.SWkishki.pos[i]):GetAngleDegrees() ):Resized( math.max(0,(nextpos:Distance(data.SWkishki.pos[i])-Stretch)*0.10) ) --0.07
            --    local vel = (nextp-lpos):Resized(bttdis-cdat.scretch)
                --cur[2] = (cur[2] + vel)* .68
             --   cur[2] = cur[2]  + vel * .2 
            --end
    
            if headpos then
                local bttdis = lpos:Distance(headpos)/scale
                
                local vel = (lpos - headpos):Resized(math.max(0,headsize-bttdis)*.08)
                cur[2] = cur[2] *.8 + vel* .2
            end
    
            cur[1] = cur[1] + cur[2]
    
            local bttdis = cur[1]:Distance(prep)
            if bttdis > scretch then
                cur[1] = prep-(prep-cur[1]):Resized(scretch*scale)
                --lpos = cur[1]
                bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
                
                --print(cur[1],"|", prep, "|", (prep-lpos), "|", cur[1]:Distance(prep))
            end
        end
    end 


    function _HairCordData.playerUpdate(_, player)
        if not PlayerData[player:GetPlayerType()] then
            return
        end
        local data = player:GetData()
        local playerPos = player.Position + player:GetFlyingOffset() * Wtr -- (Isaac.WorldToRenderPosition(player.Position) + player:GetFlyingOffset())
        local listdecap = Isaac.FindByType(3, FamiliarVariant.DECAP_ATTACK)
        if #listdecap > 0 then
            for i=1,#listdecap do
                local ent = listdecap[i]
                if ent:ToFamiliar().Player.Index == player.Index then
                    playerPos = data._BethsHairCord and ScreenToWorld(data._BethsHairCord.RealHeadPos) or ent.Position -- Isaac.WorldToRenderPosition(ent.Position)
                end
            end
        end
        
        local hairPos1 = player:GetCostumeNullPos("bethshair_cord1", true, Vector(0,0)) * Wtr
        local hairPos2 = player:GetCostumeNullPos("bethshair_cord2", true, Vector(0,0)) * Wtr
        --local headpos = playerPos + player:GetCostumeNullPos("BethHair_headref", true, Vector(0,0))
        if not data._BethsHairCord then
            local datattab = PlayerData[player:GetPlayerType()]
            data._BethsHairCord = {
                cord = datattab.CordSpr, tailCount = datattab.TailCount, rL = datattab.RL, NullPoses = datattab.Null, 
                BackSpr = datattab.BackSpr, scretch = datattab.Scretch, DotCount = datattab.DotCount,
            }
            local cdat = data._BethsHairCord

            for tail=1, cdat.tailCount do
                cdat["tail"..tail] = {}
                for i=0, cdat.DotCount-1 do --pos                         velocity,     длина
                    cdat["tail"..tail][i] = {playerPos + Vector(0,30/cdat.DotCount*i), Vector(0,0), 30/cdat.DotCount*i+12-i*2}
                end
            end
        else
            local cdat = data._BethsHairCord
            --playerPos = cdat.RealHeadPos or playerPos
    
            local tail1 = cdat.tail1
            local plpos1 = playerPos + hairPos1
            local plpos2 = playerPos + hairPos2
            local scale = player.SpriteScale.Y
            local headpos = playerPos + player:GetCostumeNullPos("BethHair_headref", true, Vector(0,0)) * Wtr + Vector(0, -10)
    
            for tail=1, cdat.tailCount do
                --print(cdat["tail"..tail])
                cdat["tail"..tail].scretch = cdat.scretch
                local hairPos = player:GetCostumeNullPos(cdat.NullPoses[tail], true, Vector(0,0))
                physhair(cdat["tail"..tail], playerPos + hairPos* Wtr, scale, headpos)
            end
            --physhair(cdat.tail2, plpos2, scale, headpos)
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, _HairCordData.playerUpdate)
    
    ---@param player EntityPlayer
    function _HairCordData.HairPostRender(_, player, offset)
        ---@type Room
        if not PlayerData[player:GetPlayerType()] or not player:IsExtraAnimationFinished() then
            return
        end
        Room = Room or game:GetRoom()
        local data = player:GetData()
        if data._BethsHairCord then --and Room:GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
            local hdir = player:GetHeadDirection()
            local playerCol = player:GetColor()
    
            local isreflect = Room:GetRenderMode() == RenderMode.RENDER_WATER_REFLECT
    
            local realplayerPos
            local playerPos = data._BethsHairCord.RealHeadPos 
                or (worldToScreen(player.Position) + player:GetFlyingOffset())
            
            --playerPos = playerPos -- (Isaac.WorldToRenderPosition(player.Position) + player:GetFlyingOffset())
            if isreflect then
                realplayerPos = (worldToScreen(player.Position) + player:GetFlyingOffset()) -- offset
                local copyc = playerCol
                local cof = playerCol:GetOffset()
                local ctint = playerCol:GetTint()
                local ccoz = playerCol:GetColorize ()
                playerCol = Color(copyc.R, copyc.G, copyc.B, copyc.A-.5, cof.R, cof.G, cof.B, ccoz.R, ccoz.G, ccoz.B, ccoz.A)
                --playerCol:SetTint( ctint.R, ctint.G, ctint.B,ctint.A)
                --playerCol.A = playerCol.A -.2
            end
            --local hairPos1 = player:GetCostumeNullPos("bethshair_cord1", true, Vector(0,0))
            --local hairPos2 = player:GetCostumeNullPos("bethshair_cord2", true, Vector(0,0))
    
            local cdat = data._BethsHairCord
            local cord = cdat.cord
            local rl = cdat.rL[hdir]
    
            ---@type Sprite
            local BackSpr = cdat.BackSpr
            if BackSpr then
                local spr =  player:GetSprite()
                BackSpr.Scale = spr.Scale
                if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
                    local list = player:GetCostumeSpriteDescs()
                    local sec = false
                    for i=1, #list do
                        local costume = list[i]
                        if costume:GetItemConfig().ID == CollectibleType.COLLECTIBLE_BRIMSTONE then
                            if not sec then
                                sec = true
                            else 
                                BackSpr.Scale = BackSpr.Scale * costume:GetSprite():GetLayer(0):GetSize()
                                break
                            end
                        end
                    end
                end
                BackSpr:SetFrame(spr:GetOverlayAnimation(), spr:GetOverlayFrame())
                BackSpr:Render(playerPos)
            end
    
            for tail=1, cdat.tailCount do
                local taildata = cdat["tail"..tail]
               
                local hairPos = player:GetCostumeNullPos(cdat.NullPoses[tail], true, Vector(0,0))
    
                local rlt = rl[tail] 
                if rlt & 2 == 2 and rlt & 1 == 1 then
                    local tail1 = taildata
                    local hap1 --= playerPos+hairPos1 --(Isaac.WorldToScreen(player.Position) + player:GetFlyingOffset())
                    if isreflect then
                        hap1 = playerPos+Vector(hairPos.X,-hairPos.Y)
                    else
                        hap1 = playerPos+hairPos  + Vector(0,1)
                    end
                    local off =  (hap1-worldToScreen(tail1[0][1])):Resized(player.SpriteScale.X*cdat.scretch*.16) + game.ScreenShakeOffset
                    cord:Add(hap1 + off, player.SpriteScale.X*.95, 5 , playerCol)
                    
                    for i=0, maxcoord-1 do
                        local cur = tail1[i]
                        local pos = worldToScreen(cur[1]) --+ hairPos1
                        if isreflect then
                            local yof = realplayerPos.Y-pos.Y
                            pos = pos + offset
                            pos.Y = pos.Y + yof*2
                        end
                        
                        cord:Add(pos,player.SpriteScale.X,cur[3]+2 , playerCol)
                    end
                    cord:Render()
                end
            end
    
            --[[if headDirToRender[hdir] & 2 == 2 then
                local tail2 = cdat.tail2
                local hap2 --= playerPos+hairPos2
                --local reflectOff = playerPos+Vector(hairPos2.X,-hairPos2.Y)
                if isreflect then
                    hap2 = playerPos+Vector(hairPos2.X,-hairPos2.Y)
                else
                    hap2 = playerPos+hairPos2 -----+ Vector(1,0)
                end
                local off =  (hap2-worldToScreen(tail2[0][1])):Resized(player.SpriteScale.X*scretch*.16)
                cord:Add(hap2 + off+Vector(0,1), player.SpriteScale.X*.95, 5 , playerCol)
                
                for i=0, maxcoord-1 do
                    local cur = tail2[i]
                    local pos =  worldToScreen(cur[1]) --+ hairPos2
                    if isreflect then
                        local yof = realplayerPos.Y-pos.Y
                        --print(yof, "|", playerPos.Y, "|" ,pos.Y)
                        pos = pos + offset
                        pos.Y = pos.Y + yof*2
                    end
                    
                    cord:Add(pos,player.SpriteScale.X,cur[3]+2 , playerCol)
                end
                cord:Render()
            end]]
    
            --local p1, p2 = worldToScreen(cdat.tail1[0][1]),  worldToScreen(cdat.tail2[0][1])
            --Isaac.DrawLine(p1, p2,KColor(1,1,1,1),KColor(1,1,1,1),1)
    
            if mod.DR then
                local tail1 = cdat.tail1
                for i=0, maxcoord-1 do
                    local cur = tail1[i]
                    local pos = worldToScreen( cur[1] )
                    Isaac.DrawLine(pos-Vector(.5,0),pos+Vector(.5,0),KColor(1,1,1,1),KColor(1,1,1,1),5)
                    local vel = worldToScreen( cur[1]+ cur[2] )
                    Isaac.DrawLine(pos, vel,KColor(2,.2,.2,1),KColor(2,.2,.2,1),1)
                    Isaac.RenderScaledText(i, pos.X,pos.Y-5, .5, .5, 1,1,1,1)
                end
            end
    
            --local rp = playerPos + Vector(0,-40)
            --Isaac.RenderScaledText(player:GetHeadDirection().. " ".. headDirToRender[hdir], rp.X,rp.Y-5, .5, .5, 1,1,1,1)
        end
    end
    mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_RENDER, -10, _HairCordData.HairPostRender)
    
    function _HairCordData.HairPreRender(_, player, offset)
        ---@type Room
        if not PlayerData[player:GetPlayerType()] or not player:IsExtraAnimationFinished() then
            return
        end
        
        Room = Room or game:GetRoom()
        local data = player:GetData()
        if data._BethsHairCord and Room:GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
            data._BethsHairCord.RealHeadPos = offset -- Isaac.WorldToScreen(player.Position)
            local hdir = player:GetHeadDirection()
            
            local playerCol = player:GetColor()
    
            local isreflect = Room:GetRenderMode() == RenderMode.RENDER_WATER_REFLECT
    
            local playerPos = offset -- Isaac.WorldToScreen(player.Position) --Isaac.WorldToScreen(player.Position) + player:GetFlyingOffset()
            --local hairPos1 = player:GetCostumeNullPos("bethshair_cord1", true, Vector(0,0))
            --local hairPos2 = player:GetCostumeNullPos("bethshair_cord2", true, Vector(0,0))
    
            --local screenOffset =  playerPos - Isaac.WorldToScreen(player.Position)
    
            local cdat = data._BethsHairCord
            if isreflect then
                --realplayerPos = (Isaac.WorldToScreen(player.Position) + player:GetFlyingOffset()) -- offset
                local copyc = playerCol
                local cof = playerCol:GetOffset()
                local ctint = playerCol:GetTint()
                local ccoz = playerCol:GetColorize ()
                playerCol = Color(copyc.R, copyc.G, copyc.B, copyc.A-.2, cof.R, cof.G, cof.B, ccoz.R, ccoz.G, ccoz.B, ccoz.A)
                playerCol:SetTint( ctint.R, ctint.G, ctint.B,ctint.A)
                --playerCol.A = playerCol.A -.2
            end
    
            --if headDirToRender[hdir] & 1 == 0 then
            local rl = cdat.rL[hdir]
    
            for tail=1, cdat.tailCount do
                local taildata = cdat["tail"..tail]
               
                local hairPos = player:GetCostumeNullPos(cdat.NullPoses[tail], true, Vector(0,0))
    
                local rlt = rl[tail] 
    
                if rlt & 2 == 2 and rlt & 1 == 0 then
                    local tail1 = taildata
                    local hap1 = playerPos+hairPos
                    local off = Vector(0,0) -- (hap1-tail1[0][1]):Resized(player.SpriteScale.X*scretch*.3)
                    cdat.cord:Add(hap1+off,player.SpriteScale.X*.95,5, playerCol)
                    for i=0, maxcoord-1 do
                        local cur = tail1[i]
                        local pos = worldToScreen(cur[1]) --+ hairPos1
                        
                        cdat.cord:Add(pos,player.SpriteScale.X,cur[3]+2, playerCol)
                    end
                    cdat.cord:Render()
                end
            end
    
            --[[if headDirToRender[hdir] & 2 == 0 then
                local tail2 = cdat.tail2
                local hap2 = playerPos+hairPos2
                local off = Vector(0,0) -- (hap2-tail2[0][1]):Resized(player.SpriteScale.X*scretch*.3)
                cordSpr:Add(hap2+off,player.SpriteScale.X*.95,5, playerCol)
                for i=0, maxcoord-1 do
                    local cur = tail2[i]
                    local pos = worldToScreen(cur[1]) --+ hairPos2
                    
                    cordSpr:Add(pos,player.SpriteScale.X,cur[3]+2, playerCol)
                end
                cordSpr:Render()
            end]]
        end
    end
    mod:AddPriorityCallback(ModCallbacks.MC_PRE_RENDER_PLAYER_HEAD, 10, _HairCordData.HairPreRender)


    return _HairCordData
end