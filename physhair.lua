return function (mod)
    ---@class hairlib
    ---@field SetHairData fun(playertype:PlayerType, data:PlayerHairDataIn)

    --local mod = BethHair
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
    local PlayerData = _HairCordData.PlayerData

    local function addCallbackID(name)
        _HairCordData.Callbacks[name] = setmetatable({},{__concat = function(t,b) return "[Phys Hair] "..name..b end})
    end
    ---@enum HairCordcallbacks
    local callbacks = {
        HAIR_POST_UPDATE = {},
        HAIR_POST_INIT = {},
        HAIR_PRE_INIT = {},
        HAIRPHYS_PRE_UPDATE = {},
        PRE_COLOR_CHANGE = {},
        POST_COLOR_CHANGE = {},
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
    ---@field Back2Spr Sprite?
    ---@field TargetCostume TargetCostume?
    ---@field ReplaceCostumeSheep string|string[]?
    ---@field SyncBColor boolean?

    ---@class HairData
    ---@field Cord Sprite|Beam|any
    ---@field PhysFunc function?
    ---@field Scretch number?
    ---@field DotCount integer?
    ---@field RL integer[][]
    ---@field Null string
    ---@field Length number
    ---@field Mass number?
    ---@field STH number?
    ---@field CS table?

    ---@class HairDataIn
    ---@field CordSpr Sprite|Beam|any
    ---@field PhysFunc function?
    ---@field Scretch number?
    ---@field DotCount integer?
    ---@field RenderLayers integer[][]
    ---@field CostumeNullpos string
    ---@field Length number?
    ---@field Mass number?
    ---@field StartHeight number?
    ---@field CS table?

    ---@class TargetCostume
    ---@field ID integer
    ---@field Type ItemType?
    ---@field pos 0|1?

    ---@class SetHairDataParam
    ---@field HeadBackSpr Sprite?
    ---@field HeadBack2Spr Sprite?
    ---@field TargetCostume TargetCostume?
    ---@field ReplaceCostumeSheep string|string[]?
    ---@field ReplaceCostumeSuffix string|string[]?
    ---@field SyncWithCostumeBodyColor boolean?
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
                Back2Spr = data.HeadBack2Spr,
                TargetCostume = data.TargetCostume,
                ReplaceCostumeSheep = data.ReplaceCostumeSheep,
                ReplaceCostumeSuffix = data.ReplaceCostumeSuffix,
                TailCostumeSheep = data.TailCostumeSheep,
                SyncBColor = data.SyncWithCostumeBodyColor,
                NullposRefSpr = data.NullposRefSpr,
                SkinFolderSuffics = data.SkinFolderSuffics,
                ExtraAnimHairLayer = data.ExtraAnimHairLayer,
            }
            for i = 1, #data do
                local dd = data[i]
                ---@type HairData
                PlayerData[playertype][i] = {
                    Cord = dd.CordSpr,
                    PhysFunc = dd.PhysFunc,
                    Scretch = dd.Scretch or scretch,
                    DotCount = dd.DotCount or maxcoord,
                    RL = dd.RenderLayers,
                    Null = dd.CostumeNullpos,
                    Length = dd.Length or 32,
                    Mass = dd.Mass or 10,
                    STH = dd.StartHeight or 5.0,
                    CS = dd.CS,
                }
            end

        end
    end


    local bodycolor = {
        --[0] = "",
        [SkinColor.SKIN_BLACK] = "_black",
        [SkinColor.SKIN_BLUE] = "_blue",
        [SkinColor.SKIN_GREEN] = "_green",
        [SkinColor.SKIN_GREY] = "_grey",
        --[SkinColor.SKIN_PINK] = "",
        [SkinColor.SKIN_RED] = "_red",
        [SkinColor.SKIN_SHADOW] = "_shadow",
        [SkinColor.SKIN_WHITE] = "_white",
    }

    local function sign(val)
        return val>0 and 1 or val<0 and -1 or 0
    end
    
    local z = Vector(0,0)
    local worldToScreen1 = Isaac.WorldToScreen
    --local function worldToScreen(vec)
    --    return worldToScreen1(z) + vec/Wtr
    --end
    local worldToScreen = worldToScreen1
    
    local function ScreenToWorld(vec)
        return  (vec-worldToScreen1(z)) * Wtr
    end
    
    local function physhair(player, HairData, StartPos, scale, headpos)
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
    
            cur[2] = cur[2] + Vector(0,.8*scale * (scretch/defscretch) * (cdat.Mass/10))
            if prep then
                local bttdis = lpos:Distance(prep)
                
                if bttdis > scretch*3 then
                    cur[1] = prep-(prep-lpos):Resized(scretch*3*scale)
                    --lpos = cur[1]
                    --bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
                --elseif bttdis < scretch*.5 then
                --    cur[1] = prep-(prep-lpos):Resized(scretch*.5*scale)
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

    local cacheNoHairColor = {}

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
        local ptype = player:GetPlayerType()
        if not data._BethsHairCord and not mod.BlockedChar[ptype] then
            --[[Isaac.RunCallbackWithParam(_HairCordData.Callbacks.HAIR_PRE_INIT, ptype, player)
            
            local datattab = PlayerData[ptype]
            data._BethsHairCord = {
                BackSpr = datattab.BackSpr,
                TargetCostume = datattab.TargetCostume,
                ReplaceCostumeSheep = datattab.ReplaceCostumeSheep,
                ReplaceCostumeSuffix = datattab.ReplaceCostumeSuffix,
                SyncBColor = datattab.SyncBColor,
            }
            local cdat = data._BethsHairCord

            --[[for tail=1, cdat.tailCount do
                cdat["tail"..tail] = {}
                for i=0, cdat.DotCount-1 do --pos                         velocity,     длина
                    cdat["tail"..tail][i] = {playerPos + Vector(0,30/cdat.DotCount*i), Vector(0,0), 30/cdat.DotCount*i+12-i*2}
                end
            end] ]
            for tail = 1, #datattab do
                ---@type HairData
                local tld = datattab[tail]
                ---@type HairData
                cdat[tail] = { Cord = tld.Cord, PhysFunc = tld.PhysFunc or physhair,
                    RL = tld.RL, Null = tld.Null, Scretch = tld.Scretch, DotCount = tld.DotCount, Length = tld.Length, Mass = tld.Mass,
                    STH = tld.STH }
                
                local taildata = cdat[tail]
                for i=0, taildata.DotCount-1 do --pos                         velocity,     длина
                    cdat[tail][i] = {playerPos + Vector(0,taildata.Length/taildata.DotCount*i), Vector(0,0), taildata.Length/taildata.DotCount*i+(12)-i*2}
                end
            end

            Isaac.RunCallbackWithParam(_HairCordData.Callbacks.HAIR_POST_INIT, ptype, player, cdat)]]
            _HairCordData.InitHairData(player, data, ptype)
        elseif data._BethsHairCord then
            local cdat = data._BethsHairCord
            
            if cdat.HeadPosCheckFrame and (player.FrameCount - cdat.HeadPosCheckFrame <= 1) then
                playerPos = cdat.RealHeadPos and ScreenToWorld(cdat.RealHeadPos + Headent.Velocity/2) or playerPos
            end

            local tarcost = cdat.TargetCostume
            if tarcost then

                local bodcol = player:GetBodyColor()
                if cdat.BodyColorCheck ~= bodcol then
                    local refsting =  bodycolor[bodcol]  or ""

                    Isaac.RunCallbackWithParam(_HairCordData.Callbacks.PRE_COLOR_CHANGE, ptype, player, bodcol, refsting)

                    if cdat.SyncBColor then
                        cdat.CostumeReplaced = false
                        --local pos = 0
                        --[[for i, csd in pairs(player:GetCostumeSpriteDescs()) do
                            local conf = csd:GetItemConfig()
                            if tarcost.ID == conf.ID and (not tarcost.Type or tarcost.Type == conf.Type) then
                                if not tarcost.pos or tarcost.pos == pos then
                                    local cspr = csd:GetSprite()
                                    for id=0, cspr:GetLayerCount()-1 do
                                        local str = cspr:GetLayer(id):GetSpritesheetPath()
                                        for j=1, #bodycolor do
                                            local colstr = bodycolor[j]
                                            if str:find(colstr) then
                                                refsting = colstr
                                                break
                                            end
                                        end
                                    end
                                else
                                    if tarcost.pos > pos then
                                        pos = pos + 1
                                    end
                                end
                            end
                        end]]

                        if refsting then
                            local cache = {}
                            for tail = 1, #cdat do
                                local taildata = cdat[tail]

                                if taildata.Cord and not cache[taildata.Cord]  then
                                    cache[taildata.Cord] = true
                                end
                            end
                            for cord, k in pairs(cache) do
                                cdat.OrigCordSheep = cdat.OrigCordSheep or {}
                                cdat.OrigCordSheep[cord] = cdat.OrigCordSheep[cord] or {}
                                local OrigCordSheep = cdat.OrigCordSheep[cord]
                                ---@type Sprite
                                local spr = cord:GetSprite()
                                for layer = 0, spr:GetLayerCount()-1 do
                                    local shep = spr:GetLayer(layer):GetSpritesheetPath()
                                    if not OrigCordSheep[layer] then
                                        OrigCordSheep[layer] = shep
                                    else
                                        shep = OrigCordSheep[layer]
                                    end

                                    local finalpath = shep:sub(0, shep:len()-4) .. refsting .. ".png"
                                    local havecolorver = false
                                    if not cacheNoHairColor[finalpath] then
                                        havecolorver = pcall(Renderer.LoadImage, finalpath)
                                        cacheNoHairColor[finalpath] = havecolorver
                                    else
                                        havecolorver = cacheNoHairColor[finalpath]
                                    end
                                    if not havecolorver then
                                        finalpath = shep:sub(0, shep:len()-4) .. ".png"
                                    end

                                    spr:ReplaceSpritesheet(layer, finalpath ) --shep:sub(0, shep:len()-4) .. refsting .. ".png")
                                end
                                spr:LoadGraphics()
                            end
                        end
                    end
                    Isaac.RunCallbackWithParam(_HairCordData.Callbacks.POST_COLOR_CHANGE, ptype, player, bodcol, refsting)
                end
                cdat.BodyColorCheck = bodcol

                if player:IsExtraAnimationFinished() and not cdat.CostumeReplaced then --что за хуйню я написал?
                    local defSpriteSheep = data._PhysHairExtra and data._PhysHairExtra.DefCostumetSheetPath
                    cdat.CostumeReplaced = true
                    cdat.OrigCostume = {}
                    local pos = 0
                    
                    --Isaac.RunCallbackWithParam(_HairCordData.Callbacks.PRE_HAIR_COLOR_CHANGE, ptype, player, bodcol, refsting)

                    for i, csd in pairs(player:GetCostumeSpriteDescs()) do
                        local conf = csd:GetItemConfig()
                        if tarcost.ID == conf.ID and (not tarcost.Type or tarcost.Type == conf.Type) then
                            if not tarcost.pos or tarcost.pos == pos then
                                cdat.HairCostume = csd
                                local cspr = csd:GetSprite()
                                local suffix = cdat.ReplaceCostumeSuffix
                                local replacestr = cdat.ReplaceCostumeSheep
                                local refsting
                                if suffix or replacestr then
                                    if type(suffix) == "table" then
                                        for id, gfx in pairs(suffix) do
                                            local orig = cdat.ForceOrigCost and cdat.ForceOrigCost[id] 
                                                or defSpriteSheep and defSpriteSheep[id] or cspr:GetLayer(id):GetDefaultSpritesheetPath()
                                            cdat.OrigCostume[id] = orig
                                            if replacestr then
                                                orig = type(replacestr) == "table" and replacestr[id] or replacestr
                                            end
                                            refsting = orig:sub(0, orig:len()-4)
                                            
                                            local colorsuf = bodycolor[bodcol]  or ""
                                            --[[local str = cspr:GetLayer(id):GetSpritesheetPath()

                                            for j=1, #bodycolor do
                                                local colstr = bodycolor[j]
                                                if str:find(colstr) then
                                                    colorsuf = colstr
                                                    break
                                                end
                                            end]]
                                            local finalpath = refsting .. colorsuf .. gfx .. ".png"
                                            local havecolorver = false
                                            if not cacheNoHairColor[finalpath] then
                                                havecolorver = pcall(Renderer.LoadImage, finalpath)
                                                cacheNoHairColor[finalpath] = havecolorver
                                            else
                                                havecolorver = cacheNoHairColor[finalpath]
                                            end
                                            if not havecolorver then
                                                finalpath = refsting .. gfx .. ".png"
                                            end

                                            cspr:ReplaceSpritesheet(id, finalpath)
                                        end
                                        cspr:LoadGraphics()
                                    else
                                        for id=0, cspr:GetLayerCount()-1 do
                                            local orig = cdat.ForceOrigCost and cdat.ForceOrigCost[id] 
                                                or defSpriteSheep and defSpriteSheep[id] or cspr:GetLayer(id):GetDefaultSpritesheetPath()
                                            
                                            cdat.OrigCostume[id] = orig
                                            if replacestr then
                                                orig = type(replacestr) == "table" and replacestr[id] or replacestr
                                                
                                            end
                                            refsting = orig:sub(0, orig:len()-4)
                                            local colorsuf = bodycolor[bodcol] or ""
                                            --[[local str = cspr:GetLayer(id):GetSpritesheetPath()

                                            for j=1, #bodycolor do
                                                local colstr = bodycolor[j]
                                                if str:find(colstr) then
                                                    colorsuf = colstr
                                                    break
                                                end
                                            end]]
                                            local finalpath = refsting .. colorsuf .. (suffix or "") .. ".png"
                                            local havecolorver = false
                                            if not cacheNoHairColor[finalpath] then
                                                havecolorver = pcall(Renderer.LoadImage, finalpath)
                                                cacheNoHairColor[finalpath] = havecolorver
                                            else
                                                havecolorver = cacheNoHairColor[finalpath]
                                            end
                                            if not havecolorver then
                                                finalpath = refsting .. (suffix or "") .. ".png"
                                            end
                                            
                                            cspr:ReplaceSpritesheet(id, finalpath) -- refsting .. (suffix or "") .. ".png")  -- rep)
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
                    --local defSpriteSheep = data._PhysHairExtra and data._PhysHairExtra.DefCostumetSheetPath
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
            local spr = player:GetSprite()
            local scale = player.SpriteScale --.Y
            local headpos -- = playerPos + player:GetCostumeNullPos("BethHair_headref", true, Vector(0,0)) / Wtr + Vector(0, -10)
            --[[if cdat.NPRefSpr then
                local spr = player:GetSprite()
                local hspr = cdat.NPRefSpr
                hspr:SetFrame(spr:GetOverlayAnimation(), spr:GetOverlayFrame())
                local null = hspr:GetNullFrame("BethHair_headref")
                headpos = null and (playerPos + (null and null:GetPos() or Vector(0,0)) * scale / Wtr + Vector(0, -10)) or false
            else]]
                local headrefpos = player:GetCostumeNullPos("BethHair_headref", true, Vector(0,0))
                if headrefpos.Y ~= 0 then
                    headpos = playerPos + headrefpos / Wtr + Vector(0, -10)
                else
                    headpos = false
                end
            --end
    
            for tail = 1, #cdat do
                local taildata = cdat[tail]
                if #taildata > 0 then
                    local hairPos --= player:GetCostumeNullPos(taildata.Null, true, Vector(0,0))
                    --if cdat.NPRefSpr then
                    --    local null = cdat.NPRefSpr:GetNullFrame(taildata.Null)
                    --    local headscale
                    --    hairPos = (null and null:GetPos() or Vector(0,0)) * scale
                    --else
                        hairPos = player:GetCostumeNullPos(taildata.Null, true, Vector(0,0))
                    --end
                    hairPos = hairPos + player:GetCostumeNullPos("HeadTransform",true, Vector(0,0))
                    
                    --physhair(taildata, playerPos + hairPos* Wtr, scale, headpos)
                    Isaac.RunCallbackWithParam(_HairCordData.Callbacks.HAIRPHYS_PRE_UPDATE, ptype, player, taildata)
                    taildata.PhysFunc(player, taildata, playerPos + hairPos* Wtr, scale.Y, headpos)
                end
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, _HairCordData.playerUpdate)

    function _HairCordData.InitHairData(player, data, ptype, mode)
        if player then
            data = data or player:GetData()
            ptype = ptype or player:GetPlayerType()
            data._PhysHair_HairMode = mode
            Isaac.RunCallbackWithParam(_HairCordData.Callbacks.HAIR_PRE_INIT, ptype, player)
            local datattab = PlayerData[ptype]
            --print("INIT", datattab, ptype, mode)
            
            if mode == 1 then
                data._BethsHairCord = {
                    TargetCostume = datattab.TargetCostume,
                    ReplaceCostumeSheep = datattab.TailCostumeSheep,
                    SyncBColor = datattab.SyncBColor,
                    NPRefSpr = datattab.NullposRefSpr,
                }
    
                Isaac.RunCallbackWithParam(_HairCordData.Callbacks.HAIR_POST_INIT, ptype, player, data._BethsHairCord)

                return
            else

                data._BethsHairCord = {
                    BackSpr = datattab.BackSpr,
                    Back2Spr = datattab.Back2Spr,
                    TargetCostume = datattab.TargetCostume,
                    ReplaceCostumeSheep = datattab.ReplaceCostumeSheep,
                    ReplaceCostumeSuffix = datattab.ReplaceCostumeSuffix,
                    SyncBColor = datattab.SyncBColor,
                    NPRefSpr = datattab.NullposRefSpr,
                    EXAnim_HL = datattab.ExtraAnimHairLayer,
                }
                --print("   ", datattab.ReplaceCostumeSheep, "|", datattab.ReplaceCostumeSuffix)
                local cdat = data._BethsHairCord

                --[[for tail=1, cdat.tailCount do
                    cdat["tail"..tail] = {}
                    for i=0, cdat.DotCount-1 do --pos                         velocity,     длина
                        cdat["tail"..tail][i] = {playerPos + Vector(0,30/cdat.DotCount*i), Vector(0,0), 30/cdat.DotCount*i+12-i*2}
                    end
                end]]
                local playerPos = player.Position
                for tail = 1, #datattab do
                    ---@type HairData
                    local tld = datattab[tail]
                    ---@type HairData
                    cdat[tail] = { Cord = tld.Cord, PhysFunc = tld.PhysFunc or physhair,
                        RL = tld.RL, Null = tld.Null, Scretch = tld.Scretch, DotCount = tld.DotCount, Length = tld.Length, Mass = tld.Mass,
                        STH = tld.STH, CS = tld.CS }
                    
                    ---@type HairData
                    local taildata = cdat[tail]
                    for i=0, taildata.DotCount-1 do --pos                         velocity,     длина
                        cdat[tail][i] = {playerPos + Vector(0,taildata.Length/taildata.DotCount*i), Vector(0,0), taildata.Length/taildata.DotCount*i+(12)-i*2}
                    end
                    local cs = taildata.CS
                    if cs then
                        for i=0, taildata.DotCount-1 do
                            if cs[i] then
                                cdat[tail][i][3] = cs[i]
                            end
                        end
                    end
                end

                if cdat.EXAnim_HL then
                    local path = cdat.EXAnim_HL
                    cdat.EXAnim_HL = Sprite()
                    cdat.EXAnim_HL:Load("gfx/001.000_player.anm2", true)
                    --for i, layer in pairs(cdat.EXAnim_HL:GetAllLayers()) do
                        for h=0, 14 do
                            if h ~= 13 then
                                cdat.EXAnim_HL:ReplaceSpritesheet(h, path)
                            end
                        end
                        cdat.EXAnim_HL:LoadGraphics()
                    --end
                end

                Isaac.RunCallbackWithParam(_HairCordData.Callbacks.HAIR_POST_INIT, ptype, player, cdat)
            end
        end
    end
    
    --function _HairCordData.ColorChecker(_, player, flag)
    --    if flag == CacheFlag.CACHE_COLOR then
    --        player:GetData()._HairCordData.CostumeReplaced = false
    --    end
    --end
    local isbeth = {
        [PlayerType.PLAYER_BETHANY]=true,
        [PlayerType.PLAYER_BETHANY_B]=true,
    }

    ---@param player EntityPlayer
    function _HairCordData.HairPostRender(_, player, offset)
        local ptype = player:GetPlayerType()
        if not PlayerData[ptype] then
            return
        end

        local Room = game:GetRoom()

        if not player:IsExtraAnimationFinished() then
            local cdat = player:GetData()._BethsHairCord
            if cdat and cdat.EXAnim_HL then
                local spr =  player:GetSprite()
                local rendermode = Room:GetRenderMode()
                local isreflect = rendermode == RenderMode.RENDER_WATER_REFLECT
                local playerPos = (worldToScreen1(player.Position) + player:GetFlyingOffset())

                local EXAnim_HL = cdat.EXAnim_HL
                if EXAnim_HL then
                    EXAnim_HL:SetFrame(spr:GetAnimation(), spr:GetFrame())
                    if isreflect then
                        EXAnim_HL:Render(playerPos + offset)
                    else
                        EXAnim_HL:Render(playerPos)
                    end
                end
            end

            return
        end
        
        --Room = Room or game:GetRoom()
        local data = player:GetData()
        if data._BethsHairCord then 
            local hdir = player:GetHeadDirection()
            local playerCol = player:GetColor()
    
            local rendermode = Room:GetRenderMode()
            local isreflect = rendermode == RenderMode.RENDER_WATER_REFLECT

            local realplayerPos
            local playerPos = (worldToScreen(player.Position) + player:GetFlyingOffset())
            if data._BethsHairCord.RealHeadPos then
                playerPos = data._BethsHairCord.RealHeadPos
            end
            
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
            local spr =  player:GetSprite()
    
            ---@type Sprite
            local BackSpr = cdat.BackSpr
            if BackSpr then
                --local spr =  player:GetSprite()
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

            --[[local EXAnim_HL = cdat.EXAnim_HL
            if EXAnim_HL then
                EXAnim_HL:SetFrame(spr:GetAnimation(), spr:GetFrame())
                if isreflect then
                    EXAnim_HL:Render(playerPos + offset)
                else
                    EXAnim_HL:Render(playerPos)
                end
                print(EXAnim_HL:GetAnimation(), EXAnim_HL:GetOverlayAnimation(), "gsgs")
            end]]

            if isbeth[ptype] and mod.OdangoMode then
                return
            end
    
            local scale = spr.Scale
            local pause = game:IsPaused()

            --for i,k in pairs(cdat) do
            --    print(i,k)
            --end
            --for tail=1, cdat.tailCount do
            for tail=1, #cdat do
                ---@type HairData
                local taildata = cdat[tail]

                if #taildata > 0 then
                    local cord = taildata.Cord
                    local cordspr = cord:GetSprite()

                    --local hairPos = player:GetCostumeNullPos(cdat.NullPoses[tail], true, Vector(0,0))
                    local hairPos -- = player:GetCostumeNullPos(taildata.Null, true, Vector(0,0))

                    --[[if cdat.NPRefSpr then
                        --local spr = player:GetSprite()
                        local hspr = cdat.NPRefSpr
                        --hspr:SetFrame(spr:GetOverlayAnimation(), spr:GetOverlayFrame())
                        local null = hspr:GetNullFrame(taildata.Null)
                        hairPos = (null and null:GetPos() or Vector(0,0)) * scale --+ Vector(0, -10)
                    else]]
                        hairPos = player:GetCostumeNullPos(taildata.Null, true, Vector(0,0)) --+ Vector(0, -10)
                    --end
                    hairPos = hairPos + player:GetCostumeNullPos("HeadTransform",true, Vector(0,0))
        
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
                        --local points = {}
                        local off =  (hap1-worldToScreen(tail1[0][1])):Resized(player.SpriteScale.X*taildata.Scretch*.16) + game.ScreenShakeOffset
                        
                        cord:GetSprite().Color = playerCol

                        --cord:Add(hap1 + off, player.SpriteScale.X*.95*cordspr.Scale.X, 5 , playerCol)
                        cord:Add(hap1 + off, taildata.STH or 5,  player.SpriteScale.X*.95*cordspr.Scale.X , playerCol)
                        
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
                            
                            --cord:Add(pos,player.SpriteScale.X*cordspr.Scale.X,cur[3]+2 , playerCol)
                            cord:Add(pos,cur[3]+2 ,player.SpriteScale.X*cordspr.Scale.X, playerCol)
                        end
                        cord:Render()
                    end
                end
            end
    
            if mod.DR then
                local tail1 = cdat[7]
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
        local ptype = player:GetPlayerType()
        if not PlayerData[ptype]  then
            return
        end
        
        local Room = game:GetRoom()
        --Room = Room or game:GetRoom()
        local data = player:GetData()
        if data._BethsHairCord then -- and Room:GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
            data._BethsHairCord.RealHeadPos = offset -- Isaac.WorldToScreen(player.Position)
            data._BethsHairCord.HeadPosCheckFrame = player.FrameCount

            local cdat = data._BethsHairCord
            local spr = player:GetSprite()
            local playerCol = player:GetColor()
            local playerPos = offset
            local isreflect = Room:GetRenderMode() == RenderMode.RENDER_WATER_REFLECT

            ---@type Sprite
            local Back2Spr = cdat.Back2Spr
            if Back2Spr then
                --local spr =  player:GetSprite()
                Back2Spr.Scale = spr.Scale
                if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
                    local list = player:GetCostumeSpriteDescs()
                    local sec = false
                    for i=1, #list do
                        local costume = list[i]
                        if costume:GetItemConfig().ID == CollectibleType.COLLECTIBLE_BRIMSTONE then
                            if not sec then
                                sec = true
                            else 
                                Back2Spr.Scale = Back2Spr.Scale * costume:GetSprite():GetLayer(0):GetSize()
                                break
                            end
                        end
                    end
                end
                Back2Spr.Color = playerCol
                Back2Spr:SetFrame(spr:GetOverlayAnimation(), spr:GetOverlayFrame())
                if isreflect then
                    Back2Spr:Render(playerPos + offset)
                else
                    Back2Spr:Render(playerPos)
                end
            end


            if isreflect then return end


            if isbeth[ptype] and mod.OdangoMode then
                return
            end

            if not player:IsExtraAnimationFinished() then
                return
            end
            

            local hdir = player:GetHeadDirection()
            
            
    
            --local isreflect = Room:GetRenderMode() == RenderMode.RENDER_WATER_REFLECT
    
            --local playerPos = offset -- Isaac.WorldToScreen(player.Position) --Isaac.WorldToScreen(player.Position) + player:GetFlyingOffset()
            --local hairPos1 = player:GetCostumeNullPos("bethshair_cord1", true, Vector(0,0))
            --local hairPos2 = player:GetCostumeNullPos("bethshair_cord2", true, Vector(0,0))
    
            --local screenOffset =  playerPos - Isaac.WorldToScreen(player.Position)
    
            
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
    
            local scale = spr.Scale
            for tail = 1, #cdat do
                ---@type HairData
                local taildata = cdat[tail]

                if #taildata > 0 then
                    local cord = taildata.Cord
                    local cordSpr = cord:GetSprite()
                
                    local hairPos --= player:GetCostumeNullPos(taildata.Null, true, Vector(0,0))
                    --[[if cdat.NPRefSpr then
                        --local spr = player:GetSprite()
                        local hspr = cdat.NPRefSpr
                        --hspr:SetFrame(spr:GetOverlayAnimation(), spr:GetOverlayFrame())
                        local null = hspr:GetNullFrame(taildata.Null)
                        hairPos = (null and null:GetPos() or Vector(0,0)) * scale --+ Vector(0, -10)
                    else]]
                        hairPos = player:GetCostumeNullPos(taildata.Null, true, Vector(0,0)) --+ player:GetCostumeNullPos("HeadTransform",true, Vector(0,0)) --+ Vector(0, -10)
                    --end
                    hairPos = hairPos + player:GetCostumeNullPos("HeadTransform",true, Vector(0,0))
        
                    local rl = taildata.RL
                    local rlt = rl[hdir] --[tail] 
        
                    if rlt & 2 == 2 and rlt & 1 == 0 then
                        local tail1 = taildata
                        local hap1 = playerPos+hairPos
                        local off = Vector(0,0) -- (hap1-tail1[0][1]):Resized(player.SpriteScale.X*scretch*.3)
                        cord:Add(hap1+off, taildata.STH or 5, player.SpriteScale.X*.95*cordSpr.Scale.X, playerCol)
                        for i=0, #tail1 do
                            local cur = tail1[i]
                            local pos = worldToScreen(cur[1]) --+ hairPos1
                            
                            cord:Add(pos, cur[3]+2, player.SpriteScale.X*cordSpr.Scale.X, playerCol)
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
            local data = player:GetData()
            if PlayerData[player:GetPlayerType()] and data._BethsHairCord then
                local cdat = data._BethsHairCord
                cdat.RealHeadPos = worldToScreen(player.Position)
                cdat.CostumeReplaced = false
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, _HairCordData.PreRoomHairFix)



    function _HairCordData.EveheavyHairPhys(player, HairData, StartPos, scale, headpos)
        local cdat = HairData
        local tail1 = HairData
        local plpos1 = StartPos
        local scretch = cdat.Scretch
        local Mmass = 10 / cdat.Mass   --/ 10

        local headdir = player:GetHeadDirection()
        local headpospushpower = (headdir == 1 or headdir == 2) and .8 or 1.9
    
        for i=0, #tail1 do
            local mass = Mmass * i --(#tail1 - i)
            local prep, nextp
            local cur = tail1[i]
            local lpos = cur[1]

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
            local lerp = 1 - (.12 * mass )
    
            cur[2] = cur[2] + Vector(0,.8*scale * (scretch/defscretch) * ( cdat.Mass/10 * lerp))
            if prep then
                local bttdis = lpos:Distance(prep)
                
                if bttdis > scretch*3 then
                    cur[1] = prep-(prep-lpos):Resized(scretch*3*scale)
                    --lpos = cur[1]
                    --bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
                end
                
                local vel = (prep-lpos):Resized(math.max(-1,bttdis-scretch*lerp))
                
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
                headpos = headpos + Vector(0,-15)
                local lerp = (.3 * (#tail1 - i) )
                local bttdis = lpos:Distance(headpos)/scale
                
                local vel = (lpos - headpos):Resized(math.max(0,headsize*0.6-bttdis)*.25)
                cur[2] = cur[2] *.8 + vel* headpospushpower*lerp
            end
    
            cur[1] = cur[1] + cur[2]
    
            local bttdis = cur[1]:Distance(prep)
            if bttdis > scretch then
                cur[1] = prep-(prep-cur[1]):Resized(scretch*scale)
                --lpos = cur[1]
                bttdis = scretch*scale
            end
        end
    end 


    return _HairCordData
end