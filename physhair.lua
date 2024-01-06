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
    local defscretch = scretch
    local headsize = 20* Wtr

    


    local ExampleRenderLayers = { -- first bit = visible, second bit = layer
        [3] = {3,3}, --HeadDown
        [0] = {2,3}, --HeadLeft
        [1] = {3,3}, --HeadUp
        [2] = {3,2}, --HeadRight
    }
    
    ---@class _HairCordData
    ---@field Callbacks HairCordcallbacks
    ---@field PlayerData table
    _HairCordData = _HairCordData or {PlayerData = {}, Callbacks = {}}
    ---@type PlayerHairData[]
    PlayerData = _HairCordData.PlayerData

    local function addCallbackID(name)
        _HairCordData.Callbacks[name] = setmetatable({},{__concat = function(t,b) return "[Phys Hair] "..name..b end})
    end
    ---@enum HairCordcallbacks
    local callbacks = {
        HAIR_POST_UPDATE = {},
        HAIR_POST_INIT = {}
    }
    for i,k in pairs(callbacks) do
        addCallbackID(i)
    end

    ---@class PlayerHairDataIn
    ---@field CordSpr Sprite|any
    ----@field Scretch number?
    ----@field DotCount integer?
    ----@field TailCount integer?
    ----@field RenderLayers integer[][]
    ----@field CostumeNullposes string[]
    ---@field HeadBackSpr Sprite?
    ---@field [1] HairDataIn
    ---@field [2] HairDataIn

    ---@class PlayerHairData
    ----@field CordSpr Sprite|any
    ----@field Scretch number
    ----@field DotCount integer
    ----@field TailCount integer
    ----@field RL integer[][]
    ----@field Null string[]
    ---@field BackSpr Sprite?
    ---@field TargetCostume TargetCostume?
    ---@field ReplaceCostumeSheep string|string[]?

    ---@class HairData
    ---@field Cord Sprite|Beam|any
    ---@field PhysFunc function?
    ---@field Scretch number?
    ---@field DotCount integer?
    ---@field RL integer[][]
    ---@field Null string
    ---@field Length number
    ---@field Mass number?

    ---@class HairDataIn
    ---@field CordSpr Sprite|Beam|any
    ---@field PhysFunc function?
    ---@field Scretch number?
    ---@field DotCount integer?
    ---@field RenderLayers integer[][]
    ---@field CostumeNullpos string
    ---@field Length number?
    ---@field Mass number?

    ---@class TargetCostume
    ---@field ID integer
    ---@field Type ItemType?
    ---@field pos 0|1?

    ---@class SetHairDataParam
    ---@field HeadBackSpr Sprite?
    ---@field TargetCostume TargetCostume?
    ---@field ReplaceCostumeSheep string|string[]?
    ---@field [integer] HairDataIn

    ---@param data SetHairDataParam
    function _HairCordData.SetHairData(playertype, data)
        if playertype then
            PlayerData[playertype] = {
                --CordSpr = data.CordSpr,
                --Scretch = data.Scretch or scretch,
                --DotCount = data.DotCount or maxcoord,
                --TailCount = data.TailCount or 1,
                --RL = data.RenderLayers,
                --Null = data.CostumeNullposes,
                BackSpr = data.HeadBackSpr,
                TargetCostume = data.TargetCostume,
                ReplaceCostumeSheep = data.ReplaceCostumeSheep,
            }
            for i = 1, #data do
                ---@type HairData
                PlayerData[playertype][i] = {
                    Cord = data[i].CordSpr,
                    PhysFunc = data[i].PhysFunc,
                    Scretch = data[i].Scretch or scretch,
                    DotCount = data[i].DotCount or maxcoord,
                    RL = data[i].RenderLayers,
                    Null = data[i].CostumeNullpos,
                    Length = data[i].Length or 32,
                    Mass = data[i].Mass or 10,
                }
            end

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
        local scretch = cdat.Scretch
        local mass = 10 / cdat.Mass   --/ 10
    
        for i=0, #tail1 do
            local prep, nextp
            local cur = tail1[i]
            local lpos = cur[1]
            --local scretch = scretch
    
            
            local srch = cur[3]
            if i == 0 then
                prep = plpos1 --+(plpos1-lpos):Resized(scretch*.7)
                --scretch = 0
            else
                prep = tail1[i-1][1]
            end
            --if i < maxcoord-1 then
            --    nextp = tail1[i+1][1]
            --end
    
            cur[2] = cur[2] + Vector(0,.8*scale * (scretch/defscretch))
            if prep then
                local bttdis = lpos:Distance(prep)
                
                if bttdis > scretch*3 then
                    cur[1] = prep-(prep-lpos):Resized(scretch*3*scale)
                    --lpos = cur[1]
                    --bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
                end
    
                --local velic = Vector(1,0):Rotated( (nextpos - data._JudasFezFakeCord.pos[i]):GetAngleDegrees() ):Resized( math.max(0,(nextpos:Distance(data._JudasFezFakeCord.pos[i])-Stretch)*0.10) ) --0.07
                local vel = (prep-lpos):Resized(math.max(-1,bttdis-scretch))
                
                local lerp = 1 - (.12 * mass )
                cur[2] = (cur[2]* lerp + vel * (1-lerp))
                --cur[2] = cur[2] * 0.2 + vel * .8
            end
            if nextp then
                --local bttdis = lpos:Distance(nextp)
    
                --local velic = Vector(1,0):Rotated( (nextpos - data._JudasFezFakeCord.pos[i]):GetAngleDegrees() ):Resized( math.max(0,(nextpos:Distance(data._JudasFezFakeCord.pos[i])-Stretch)*0.10) ) --0.07
                --local vel = (nextp-lpos):Resized(bttdis-cdat.scretch)
                --cur[2] = (cur[2] + vel)* .68
                --cur[2] = cur[2]  + vel * .1
            end
    
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

    ---@param player EntityPlayer
    function _HairCordData.playerUpdate(_, player)
        if not PlayerData[player:GetPlayerType()] then
            return
        end
        local data = player:GetData()
        local playerPos = player.Position + player:GetFlyingOffset() * Wtr -- (Isaac.WorldToRenderPosition(player.Position) + player:GetFlyingOffset())
        local listdecap = Isaac.FindByType(3, FamiliarVariant.DECAP_ATTACK)
        local Headent = player
        if #listdecap > 0 then
            for i=1,#listdecap do
                local ent = listdecap[i]
                if ent:ToFamiliar().Player.Index == player.Index then
                    Headent = ent
                    playerPos = data._BethsHairCord and ScreenToWorld(data._BethsHairCord.RealHeadPos) or ent.Position -- Isaac.WorldToRenderPosition(ent.Position)
                end
            end
        end
        local listScis = Isaac.FindByType(3, FamiliarVariant.SCISSORS)
        if #listScis > 0 then
            for i=1,#listScis do
                local ent = listScis[i]
                if ent:ToFamiliar().Player.Index == player.Index then
                    Headent = ent
                    playerPos = data._BethsHairCord and ScreenToWorld(data._BethsHairCord.RealHeadPos) or ent.Position -- Isaac.WorldToRenderPosition(ent.Position)
                end
            end
        end
        
        --local hairPos1 = player:GetCostumeNullPos("bethshair_cord1", true, Vector(0,0)) * Wtr
        --local hairPos2 = player:GetCostumeNullPos("bethshair_cord2", true, Vector(0,0)) * Wtr
        
        if not data._BethsHairCord then
            local datattab = PlayerData[player:GetPlayerType()]
            data._BethsHairCord = {
                BackSpr = datattab.BackSpr,
                TargetCostume = datattab.TargetCostume,
                ReplaceCostumeSheep = datattab.ReplaceCostumeSheep,
            }
            local cdat = data._BethsHairCord

            --[[for tail=1, cdat.tailCount do
                cdat["tail"..tail] = {}
                for i=0, cdat.DotCount-1 do --pos                         velocity,     длина
                    cdat["tail"..tail][i] = {playerPos + Vector(0,30/cdat.DotCount*i), Vector(0,0), 30/cdat.DotCount*i+12-i*2}
                end
            end]]
            for tail = 1, #datattab do
                local tld = datattab[tail]
                ---@type HairData
                cdat[tail] = { Cord = tld.Cord, PhysFunc = tld.PhysFunc or physhair,
                    RL = tld.RL, Null = tld.Null, Scretch = tld.Scretch, DotCount = tld.DotCount, Length = tld.Length, Mass = tld.Mass }
                
                local taildata = cdat[tail]
                for i=0, taildata.DotCount-1 do --pos                         velocity,     длина
                    cdat[tail][i] = {playerPos + Vector(0,taildata.Length/taildata.DotCount*i), Vector(0,0), taildata.Length/taildata.DotCount*i+(12)-i*2}
                end
            end

            Isaac.RunCallbackWithParam(_HairCordData.Callbacks.HAIR_POST_INIT, player:GetPlayerType(), player, cdat)
        else
            local cdat = data._BethsHairCord
            
            if cdat.HeadPosCheckFrame and (player.FrameCount - cdat.HeadPosCheckFrame <= 1) then
                playerPos = cdat.RealHeadPos and ScreenToWorld(cdat.RealHeadPos + Headent.Velocity/2) or playerPos
            end

            local tarcost = cdat.TargetCostume
            if tarcost then
                if player:IsExtraAnimationFinished() and not cdat.CostumeReplaced then
                    cdat.CostumeReplaced = true
                    cdat.OrigCostume = {}
                    local pos = 0
                    for i, csd in pairs(player:GetCostumeSpriteDescs()) do
                        local conf = csd:GetItemConfig()
                        if tarcost.ID == conf.ID and (not tarcost.Type or tarcost.Type == conf.Type) then
                            if not tarcost.pos or tarcost.pos == pos then
                                cdat.HairCostume = csd
                                local cspr = csd:GetSprite()
                                local rep = cdat.ReplaceCostumeSheep
                                if rep then
                                    if type(rep) == "table" then
                                        for id, gfx in pairs(rep) do
                                            cdat.OrigCostume[id] = cspr:GetLayer(id):GetSpritesheetPath()
                                            cspr:ReplaceSpritesheet(id, gfx)
                                        end
                                        cspr:LoadGraphics()
                                    else
                                        for id=0, cspr:GetLayerCount()-1 do
                                            cdat.OrigCostume[id] = cspr:GetLayer(id):GetSpritesheetPath()
                                            cspr:ReplaceSpritesheet(id, rep)
                                        end
                                        cspr:LoadGraphics()
                                    end
                                end
                            else
                                if tarcost.pos > pos then
                                    pos = pos + 1
                                end
                            end
                            
                        end
                    end
                elseif not player:IsExtraAnimationFinished() and cdat.CostumeReplaced and cdat.OrigCostume then
                    cdat.CostumeReplaced = false
                    if cdat.HairCostume then
                        local csd = cdat.HairCostume
                        local conf = csd:GetItemConfig()

                        local cspr = csd:GetSprite()
                        for id, gfx in pairs(cdat.OrigCostume) do
                            cspr:ReplaceSpritesheet(id, gfx)
                        end
                        cspr:LoadGraphics()
                    else
                        local pos = 0
                        for i, csd in pairs(player:GetCostumeSpriteDescs()) do
                            local conf = csd:GetItemConfig()
                            if tarcost.ID == conf.ID and (not tarcost.Type or tarcost.Type == conf.Type) then
                                if not tarcost.pos or tarcost.pos == pos then
                                    local cspr = csd:GetSprite()
                                    for id, gfx in pairs(cdat.OrigCostume) do
                                        cspr:ReplaceSpritesheet(id, gfx)
                                    end
                                    cspr:LoadGraphics()
                                else
                                    if tarcost.pos > pos then
                                        pos = pos + 1
                                    end
                                end
                                
                            end
                        end
                    end
                    
                end
            end
    
            --local tail1 = cdat.tail1
            --local plpos1 = playerPos + hairPos1
            --local plpos2 = playerPos + hairPos2
            local scale = player.SpriteScale.Y
            local headpos = playerPos + player:GetCostumeNullPos("BethHair_headref", true, Vector(0,0)) / Wtr + Vector(0, -10)
    
            for tail = 1, #cdat do
                local taildata = cdat[tail]
                if #taildata > 0 then
                    local hairPos = player:GetCostumeNullPos(taildata.Null, true, Vector(0,0))
                    
                    --physhair(taildata, playerPos + hairPos* Wtr, scale, headpos)
                    taildata.PhysFunc(taildata, playerPos + hairPos* Wtr, scale, headpos)
                end
            end
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
        if data._BethsHairCord then 
            local hdir = player:GetHeadDirection()
            local playerCol = player:GetColor()
    
            local rendermode = Room:GetRenderMode()
            local isreflect = rendermode == RenderMode.RENDER_WATER_REFLECT

            local realplayerPos
            local playerPos = data._BethsHairCord.RealHeadPos 
                or (worldToScreen(player.Position) + player:GetFlyingOffset())
            
            if isreflect then
                realplayerPos = (worldToScreen(player.Position) + player:GetFlyingOffset()) -- offset
                local copyc = playerCol
                local cof = playerCol:GetOffset()
                local ctint = playerCol:GetTint()
                local ccoz = playerCol:GetColorize ()
                playerCol = Color(copyc.R, copyc.G, copyc.B, copyc.A-.5, cof.R, cof.G, cof.B, ccoz.R, ccoz.G, ccoz.B, ccoz.A)
            end
    
            local cdat = data._BethsHairCord

            if rendermode == RenderMode.RENDER_WATER_ABOVE then
                cdat.reflectOffset = offset
            end
    
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
                BackSpr.Color = playerCol
                BackSpr:SetFrame(spr:GetOverlayAnimation(), spr:GetOverlayFrame())
                if isreflect then
                    BackSpr:Render(playerPos + offset)
                else
                    BackSpr:Render(playerPos)
                end
            end
    
            local pause = game:IsPaused()
            --for tail=1, cdat.tailCount do
            for tail=1, #cdat do
                ---@type HairData
                local taildata = cdat[tail]

                if #taildata > 0 then
                    local cord = taildata.Cord
                    local cordspr = cord:GetSprite()

                    --local hairPos = player:GetCostumeNullPos(cdat.NullPoses[tail], true, Vector(0,0))
                    local hairPos = player:GetCostumeNullPos(taildata.Null, true, Vector(0,0))
        
                    local rlt = taildata.RL[hdir]
                    
                    if rlt & 2 == 2 and rlt & 1 == 1 then
                        local tail1 = taildata
                        local hap1 --= playerPos+hairPos1 --(Isaac.WorldToScreen(player.Position) + player:GetFlyingOffset())
                        if isreflect then
                            hap1 = playerPos+Vector(hairPos.X,-hairPos.Y)+offset
                            if cdat.reflectOffset then
                                hap1 = hap1 - cdat.reflectOffset
                                if not pause then
                                    hap1 = hap1 + player.Velocity * Wtr
                                end
                            end
                        else
                            hap1 = playerPos+hairPos  + Vector(0,1)
                        end
                        local off =  (hap1-worldToScreen(tail1[0][1])):Resized(player.SpriteScale.X*taildata.Scretch*.16) + game.ScreenShakeOffset
                        cord:Add(hap1 + off, player.SpriteScale.X*.95*cordspr.Scale.X, 5 , playerCol)
                        
                        for i=0, #tail1 do
                            local cur = tail1[i]
                            local pos = worldToScreen(cur[1]) --+ hairPos1
                            if isreflect then
                                local yof = realplayerPos.Y-pos.Y
                                pos = pos + offset
                                pos.Y = pos.Y + yof*2
                                if cdat.reflectOffset then
                                    pos = pos - cdat.reflectOffset
                                end
                            end
                            
                            cord:Add(pos,player.SpriteScale.X*cordspr.Scale.X,cur[3]+2 , playerCol)
                        end
                        cord:Render()
                    end
                end
            end
    
            if mod.DR then
                local tail1 = cdat[1]
                local hairPos = player:GetCostumeNullPos(tail1.Null, true, Vector(0,0))
                local hap1 --= playerPos+hairPos1 --(Isaac.WorldToScreen(player.Position) + player:GetFlyingOffset())
                if isreflect then
                    hap1 = playerPos+Vector(hairPos.X,-hairPos.Y)
                else
                    hap1 = playerPos+hairPos  + Vector(0,1)
                end
                local off =  (hap1-worldToScreen(tail1[0][1])):Resized(player.SpriteScale.X*tail1.Scretch*.16) + game.ScreenShakeOffset
                local pos = hap1 --+ off
                Isaac.DrawLine(pos-Vector(.5,0),pos+Vector(.5,0),KColor(1,1,1,1),KColor(1,1,1,1),5)

                for i=0, #tail1 do
                    local cur = tail1[i]
                    local pos = worldToScreen( cur[1] )
                    Isaac.DrawLine(pos-Vector(.5,0),pos+Vector(.5,0),KColor(1,1,1,1),KColor(1,1,1,1),5)
                    local vel = worldToScreen( cur[1]+ cur[2] )
                    Isaac.DrawLine(pos, vel,KColor(2,.2,.2,1),KColor(2,.2,.2,1),1)
                    Isaac.RenderScaledText(i, pos.X,pos.Y-5, .5, .5, 1,1,1,1)
                end
            end
    
        end
    end
    mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_RENDER, -10, _HairCordData.HairPostRender)
    
    function _HairCordData.HairPreRender(_, player, offset)
        if not PlayerData[player:GetPlayerType()]  then
            return
        end
        
        Room = Room or game:GetRoom()
        local data = player:GetData()
        if data._BethsHairCord and Room:GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
            data._BethsHairCord.RealHeadPos = offset -- Isaac.WorldToScreen(player.Position)
            data._BethsHairCord.HeadPosCheckFrame = player.FrameCount

            if not player:IsExtraAnimationFinished() then
                return
            end

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
    
            for tail = 1, #cdat do
                ---@type HairData
                local taildata = cdat[tail]

                if #taildata > 0 then
                    local cord = taildata.Cord
                    local cordSpr = cord:GetSprite()
                
                    local hairPos = player:GetCostumeNullPos(taildata.Null, true, Vector(0,0))
        
                    local rl = taildata.RL
                    local rlt = rl[hdir] --[tail] 
        
                    if rlt & 2 == 2 and rlt & 1 == 0 then
                        local tail1 = taildata
                        local hap1 = playerPos+hairPos
                        local off = Vector(0,0) -- (hap1-tail1[0][1]):Resized(player.SpriteScale.X*scretch*.3)
                        cord:Add(hap1+off,player.SpriteScale.X*.95*cordSpr.Scale.X,5, playerCol)
                        for i=0, #tail1 do
                            local cur = tail1[i]
                            local pos = worldToScreen(cur[1]) --+ hairPos1
                            
                            cord:Add(pos,player.SpriteScale.X*cordSpr.Scale.X,cur[3]+2, playerCol)
                        end
                        cord:Render()
                    end
                end
            end
        end
    end
    mod:AddPriorityCallback(ModCallbacks.MC_PRE_RENDER_PLAYER_HEAD, 10, _HairCordData.HairPreRender)

    function _HairCordData.PreRoomHairFix()
        for i = 0, game:GetNumPlayers()-1 do
            local player = Isaac.GetPlayer(i)
            if PlayerData[player:GetPlayerType()] and player:GetData()._BethsHairCord then
                player:GetData()._BethsHairCord.RealHeadPos = worldToScreen(player.Position)
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, _HairCordData.PreRoomHairFix)

    return _HairCordData
end