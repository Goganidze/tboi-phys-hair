return function (mod)
    ---@class hairlib
    ---@field SetHairData fun(playertype:PlayerType, data:PlayerHairDataIn)

    --local mod = BethHair
    local Isaac = Isaac
    local game = Game()
    local worldToScreen = Isaac.WorldToScreen
    local Wtr = 20/13

    local maxcoord = 4
    local scretch = math.ceil(5* Wtr)-- 30/(maxcoord+1)
    local defscretch = scretch
    local headsize = 20* Wtr
    local z = Vector(0,0)
    local function ScreenToWorld(vec)
        return  (vec-worldToScreen(z)) * Wtr
    end


    local ExampleRenderLayers = { -- first bit = visible, second bit = layer
        [3] = {3,3}, --HeadDown
        [0] = {2,3}, --HeadLeft
        [1] = {3,3}, --HeadUp
        [2] = {3,2}, --HeadRight
    }
    
    ---@class _HairCordData2
    ---@field Callbacks HairCordcallbacks
    local _HairCordData2 = {Callbacks = {}}

    local function addCallbackID(name)
        _HairCordData2.Callbacks[name] = setmetatable({},{__tostring = function(t,b) return "[Phys Hair] "..name end})
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

    local function TryDeleteColorFromPath(str)
        if str then
            for i=0, #bodycolor do
                local st, en = str:find(bodycolor[i])
                if st and en then
                    return str:sub(1, st-1) .. str:sub(en+1)
                end
            end
            return str
        end
    end

    ---@param beam Beam
    local copybeam = function(beam)
        return Beam(beam:GetSprite(), beam:GetLayer(), beam:GetUseOverlay(), beam:GetUnkBool())
    end


    local TabDeepCopy
    TabDeepCopy = function(t)
        local copy = {}
        for i,k in pairs(t) do
            if type(k) == "table" then
                copy[i] = TabDeepCopy(k)
            else
                copy[i] = k
            end
        end
        return copy
    end

    local function CheckPNGExists(path, cache)
        local havecolorver = false
        if cache[path] == nil then
            havecolorver = pcall(Renderer.LoadImage, path) and true or false
            cache[path] = havecolorver
            return havecolorver
        else
            return cache[path]
        end
    end



    local testspr = Sprite()
    testspr:Load("gfx/characters/costumes/judasFez_cord.anm2", true)
    testspr:Play("cord", true)




    local PlayerTypeToTargetCostume = {
    [PlayerType.PLAYER_MAGDALENE]=NullItemID.ID_MAGDALENE, [PlayerType.PLAYER_CAIN]=NullItemID.ID_CAIN, [PlayerType.PLAYER_JUDAS]=NullItemID.ID_JUDAS,
    [PlayerType.PLAYER_EVE]=NullItemID.ID_EVE, [PlayerType.PLAYER_AZAZEL]=NullItemID.ID_AZAZEL, [PlayerType.PLAYER_EDEN]=NullItemID.ID_EDEN,
    [PlayerType.PLAYER_SAMSON]=NullItemID.ID_SAMSON, [PlayerType.PLAYER_LAZARUS]=NullItemID.ID_LAZARUS, [PlayerType.PLAYER_LAZARUS2]=NullItemID.ID_LAZARUS2,
    [PlayerType.PLAYER_LILITH]=NullItemID.ID_LILITH, [PlayerType.PLAYER_APOLLYON]=NullItemID.ID_APOLLYON, [PlayerType.PLAYER_BETHANY]=NullItemID.ID_BETHANY,
    [PlayerType.PLAYER_KEEPER]= NullItemID.ID_KEEPER, [PlayerType.PLAYER_THEFORGOTTEN]=NullItemID.ID_FORGOTTEN,
    [PlayerType.PLAYER_JACOB]=NullItemID.ID_JACOB, [PlayerType.PLAYER_ESAU]=NullItemID.ID_ESAU, [PlayerType.PLAYER_ISAAC_B]=NullItemID.ID_ISAAC_B,
    [PlayerType.PLAYER_MAGDALENE_B]=NullItemID.ID_MAGDALENE_B, [PlayerType.PLAYER_CAIN_B]=NullItemID.ID_CAIN_B, [PlayerType.PLAYER_JUDAS_B]=NullItemID.ID_JUDAS_B,
    [PlayerType.PLAYER_BLUEBABY_B]=NullItemID.ID_BLUEBABY_B, [PlayerType.PLAYER_EVE_B]=NullItemID.ID_EVE_B, [PlayerType.PLAYER_SAMSON_B]=NullItemID.ID_SAMSON_B,
    [PlayerType.PLAYER_AZAZEL_B]=NullItemID.ID_AZAZEL_B, [PlayerType.PLAYER_LAZARUS_B]=NullItemID.ID_LAZARUS_B, [PlayerType.PLAYER_LAZARUS2_B]=NullItemID.ID_LAZARUS2_B,
    [PlayerType.PLAYER_EDEN_B]=NullItemID.ID_EDEN_B, [PlayerType.PLAYER_THELOST_B]=NullItemID.ID_LOST_B, [PlayerType.PLAYER_LILITH_B]=NullItemID.ID_LILITH_B,
    [PlayerType.PLAYER_KEEPER_B]=NullItemID.ID_KEEPER_B, [PlayerType.PLAYER_APOLLYON_B]=NullItemID.ID_APOLLYON_B, [PlayerType.PLAYER_THEFORGOTTEN_B]=NullItemID.ID_FORGOTTEN_B,
    [PlayerType.PLAYER_BETHANY_B]=NullItemID.ID_BETHANY_B, [PlayerType.PLAYER_JACOB2_B]=NullItemID.ID_JACOB2_B, [PlayerType.PLAYER_THESOUL]=NullItemID.ID_SOUL_FORGOTTEN,
    [PlayerType.PLAYER_THESOUL_B]=NullItemID.ID_SOUL_B,
}

    local PlayerTypeToTargetCostumePos = {
        [PlayerType.PLAYER_AZAZEL]=1,
    }
    local function formatCostumeMap(costumemap)
        local tab = {}
        for i = 1, #costumemap do
            local cost = costumemap[i]
            tab[cost.costumeIndex] = costumemap[i]
        end
        return tab
    end

    --function _HairCordData2.GetTargetCostume(playerType)
    --    if playerType then
    --        return {ID = PlayerTypeToTargetCostume[playerType], Type = ItemType.ITEM_NULL, pos = PlayerTypeToTargetCostumePos[playerType] or 0}
    --    end
--
    --end

    ---@param player EntityPlayer
    function _HairCordData2.GetHairCostumeSpr(player)
        local data = player:GetData()._PhysHair_HairStyle
        local tarcost = mod.HStyles.GetTargetCostume(player:GetPlayerType(), data and data.StyleName)
        local isBody = tarcost.isBody

        local pos = 0
        local costumemap = formatCostumeMap(player:GetCostumeLayerMap())
        for i, csd in pairs(player:GetCostumeSpriteDescs()) do
            local conf = csd:GetItemConfig()
            if tarcost.ID == conf.ID and (not tarcost.Type or tarcost.Type == conf.Type) then
                if isBody == costumemap[i].isBodyLayer then
                    return csd:GetSprite()
                end
                --if (not tarcost.pos or tarcost.pos == pos) then
                --    return csd:GetSprite()
                --else
                --    pos = pos + 1
                --end

            end
        end
        -- пиздец случился 
        pos = 0
        for i, csd in pairs(player:GetCostumeSpriteDescs()) do
            local conf = csd:GetItemConfig()
            if conf.Type == ItemType.ITEM_NULL 
            and conf.Costume.Priority >= 99
            and csd:GetSprite():GetLayer("head0") then
                return csd:GetSprite()
            end
        end
    end

    ---@class TargetCostume
    ---@field ID integer
    ---@field Type ItemType?
    ---@field CostumeLayer? 0|1|2 -- 0=both, 1=head, 2=body
    

    ---@class SetHairDataParam
    ---@field HeadBackSpr Sprite?
    ---@field HeadBack2Spr Sprite?
    ---@field TargetCostume TargetCostume?
    ---@field ReplaceCostumeSheep string|string[]?
    ---@field TailCostumeSheep string|string[]?
    ---@field ReplaceCostumeSuffix string|string[]?
    ---@field SyncWithCostumeBodyColor boolean?
    ---@field [integer] HairDataIn
    ---@field NullposRefSpr Sprite?
    ---@field SkinFolderSuffics string?
    ---@field ItemCostumeAlts ItemCostumeAlts_set[]?

    ---@class SethairDataIn
    ---@field layer? number
    ---@field HairInfo SetHairDataParam

    ---@class HairInfo
    ---@field SkinFolderSuffics string
    ---@field TargetCostume TargetCostume
    ---@field NullposRefSpr Sprite
    ---@field ReplaceCostumeSheep string|string[]
    ---@field TailCostumeSheep string|string[]
    ---@field HeadShadowLayer? {mask:Sprite}
    ---@field [1] TailData2
    ---@field [2]? TailData2
    ---@field [3]? TailData2
    ---@field [4]? TailData2
    ---@field [5]? TailData2

    ---@class TailData2
    ---@field CordSpr Beam
    ---@field RenderLayers integer[]
    ---@field CostumeNullpos string
    ---@field HeadBackSpr? Sprite
    ---@field HeadBack2Spr? Sprite
    ---@field Scretch? number
    ---@field DotCount? integer
    ---@field Length? integer
    ---@field Mass? number
    ---@field STH? number
    ---@field CS? number[]
    ---@field PhysFunc? fun(player, TailData, HairData, StartPos, Headpos, scale)
    ---@field SO? number
    ---@field ZeroPoint Point
    ---@field [1] TailPointData2
    ---@field [2]? TailPointData2
    ---@field [3]? TailPointData2
    ---@field [4]? TailPointData2
    ---@field [5]? TailPointData2
    ---@field ShadowCordSpr? Beam
    ---@field ShadowRenderLayers? integer[]



    ---@param player EntityPlayer
    ---@param hairData SethairDataIn
    function _HairCordData2.SetHairDataToPlayer(player, hairData)
        if player then
            local data = player:GetData()
            local ptype = player:GetPlayerType()
            local playerColor = player:GetSprite().Color
            
            data.__PhysHair_HairSklad = data.__PhysHair_HairSklad or {}
            local sklad = data.__PhysHair_HairSklad

            Isaac.RunCallbackWithParam(_HairCordData2.Callbacks.HAIR_PRE_INIT, ptype, player)

            sklad[hairData.layer or 0] = {

            }
            local hairContainer = sklad[hairData.layer or 0]

            hairContainer.HairInfo = TabDeepCopy(hairData.HairInfo)
            local hairInfo = hairContainer.HairInfo
            --for i,k in pairs(hairContainer.HairInfo) do
            --    print(i,k)
            --end

            local playerPos = player.Position
            for i = 1, #hairInfo do
                ---@type TailData2
                local tailData = hairInfo[i]
                local cordspr = tailData.CordSpr:GetSprite()
                tailData.CordSpr = copybeam(tailData.CordSpr)
                tailData.PhysFunc = tailData.PhysFunc or _HairCordData2.DefaultHairPhys
                tailData.Scretch = tailData.Scretch or scretch
                tailData.DotCount = tailData.DotCount or maxcoord
                tailData.Length = tailData.Length or 32
                tailData.Mass = tailData.Mass or 10
                tailData.STH = tailData.StartHeight or 5.0
                tailData.SO = tailData.StartOffset or (tailData.Scretch * 0.16)
                tailData.ZeroPoint = Point(playerPos, 
                tailData.STH or 5, 
                player.SpriteScale.X*cordspr.Scale.X, playerColor, true)

                local cs = tailData.CS
                --local cordspr = tailData.CordSpr:GetSprite()
                for i=0, tailData.DotCount-1 do
                    ---@class TailPointData2
                    ---@field p Point
                    ---@field [1] Vector pos
                    ---@field [2] Vector velocity
                    ---@field [3] number length
                                        --pos                         velocity,     длина
                   -- tailData[i] = {playerPos + Vector(0,tailData.Length/tailData.DotCount*i), Vector(0,0), tailData.Length/tailData.DotCount*i+(12)-i*2}
                    
                    local pos = playerPos + Vector(0,tailData.Length/tailData.DotCount*i)
                    local sprCoord = (tailData.Length-tailData.STH)/(tailData.DotCount)*(i+1)      --tailData.Length/(tailData.DotCount-1)*(i+1)
                    tailData[i] = {
                        p = Point(
                            pos,
                            sprCoord,
                            player.SpriteScale.X*cordspr.Scale.X,
                            playerColor, true),
                        pos,
                        Vector(0,0),
                        cs and cs[i] or sprCoord
                    }
                    tailData[i].p:SetIsWorldSpace(true)
                end
                --local cs = tailData.CS
                if cs then
                    for i=0, tailData.DotCount-1 do
                        if cs[i] then
                            tailData[i][3] = cs[i]
                            tailData[i].p:SetSpritesheetCoordinate(cs[i])
                        end
                    end
                end
            end

            --- смена костюма

            local costumedescs = player:GetCostumeSpriteDescs()
            if hairInfo.TargetCostume then
                _HairCordData2.UpdateTargetCostume(player, hairContainer.HairInfo, costumedescs)
            end

            if hairInfo.ItemCostumeAlts then
                _HairCordData2.UpdateItemCostumeAlts(player, hairContainer.HairInfo, costumedescs)
            end

            _HairCordData2.UpdateTailsCordColor(player, sklad, player:GetBodyColor())



            Isaac.RunCallbackWithParam(_HairCordData2.Callbacks.HAIR_POST_INIT, ptype, player, hairContainer)
        end
    end

    ---@param player EntityPlayer
    function _HairCordData2.DefaultHairPhys(player, TailData, HairData, StartPos, Headpos, scale)
        local scretch = TailData.Scretch
        local mass = TailData.Mass   --/ 10
        local lerp = 0.8  -- 1 - (.12 * mass )
        --for i,k in pairs(TailData) do
        --            print(i,k)
        --        end

        for i = 0, #TailData do
            ---@type TailPointData2
            local P = TailData[i]

            local thisPos = P[1]
            local prePos, nextPos
            if i == 0 then
                prePos = StartPos
            else
                prePos = TailData[i-1][1]
            end
            nextPos = TailData[i+1]
            nextPos = nextPos and nextPos[1]

            if prePos then
                local dist = thisPos:Distance(prePos)

                if dist > scretch * 1.5 then
                    dist = scretch * 1.5 -- scretch + (dist - scretch) * (20 / mass)
                    P[1] = prePos + (thisPos - prePos):Resized(scretch * 1.5)
                elseif dist > scretch * 1 then
                    dist = scretch + (dist - scretch) * (20 / mass)
                end
                if dist < scretch * 3 then
                    --local rot = thisPos.X - prePos.X
                    --if rot == 0 then
                    --    rot = thisPos.X - Headpos.X
                    --end
                    --P[2].X = P[2].X + rot * (scretch - dist) * 5
                    --P[2].Y = P[2].Y + (scretch - dist) * 0.5

                    local dp = (thisPos - StartPos)
                    dp.X = dp.X * 2.0
                    P[2] = P[2] + dp:Resized(math.max(0, (scretch * 1.5 - dist) * 0.6))

                end
                local vel = (prePos-thisPos):Resized(math.max(-1, (dist * 10 / mass) - scretch))
                P[2] = P[2] * (lerp) + vel * (1 - lerp)
            end
            --print(i, prePos.Y > thisPos.Y)
            --if prePos.Y > thisPos.Y then
            --    P[2].Y = P[2].Y - (thisPos.Y - prePos.Y) * 0.6
            --end
            if nextPos then
                local dist = thisPos:Distance(nextPos) * 0.5
                if dist > scretch * 1.5 then
                    dist = scretch * 1.5 -- scretch + (dist - scretch) * (20 / mass)
                    P[1] = prePos + (thisPos - prePos):Resized(scretch * 1.5)
                elseif dist > scretch then
                    dist = scretch + (dist - scretch) * (20 / mass)
                end
                local vel = (nextPos-thisPos):Resized(math.max(-1, (dist * 10 / mass) - scretch))
                P[2] = P[2] * (lerp) + vel * (1 - lerp)
            end



            if Headpos then
                local bttdis = thisPos:Distance(Headpos)/scale
                
                local vel = (thisPos - Headpos):Resized(math.max(0,headsize-bttdis)*.08)
                P[2] = P[2] *.8 + vel* .2
            end

            P[2].Y = P[2].Y + .8*scale*(mass/10)

            P[1] = P[1] + P[2]

            P.p:SetPosition(thisPos)
        end
    end

    ---@param player EntityPlayer
    function _HairCordData2.PostPlayerUpdate(_, player)
        local data = player:GetData()

        if not data.__PhysHair_HairSklad then
            return
        end
        ---@type {HairInfo:HairInfo}[]
        local sklad = data.__PhysHair_HairSklad

        if not game:IsPaused() then
            local playerPos = sklad.RealHeadPos and ScreenToWorld(sklad.RealHeadPos + player.Velocity/2) or player.Position

            --local headTransform = player:GetCostumeNullPos("HeadTransform",true, Vector(0,0))
            --local headpos 
            --local headrefpos = player:GetCostumeNullPos("BethHair_headref", true, Vector(0,0))
            --if headrefpos.Y ~= 0 then
            --    headpos = playerPos + headrefpos / Wtr + Vector(0, -10)
            --else
            --    headpos = false
            --end

            --[[if sklad.PrePlayerPosUpdate then
                local dist = playerPos:Distance(sklad.PrePlayerPosUpdate)
                if dist > 10 and dist > player.Velocity:Length() * 1 then
                    print("TELEPORT UPDATE")
                    local diff = player.Position - sklad.PrePlayerPosUpdate
                    for hairLayer = 0, #sklad do
                        local hairContainer = sklad[hairLayer]
                        local hairInfo = hairContainer.HairInfo
                        for tailID = 1, #hairInfo do
                            local tailData = hairInfo[tailID]
                            for i = 0, #tailData do
                                local P = tailData[i]
                                P[1] = P[1] + diff
                            end
                        end
                    end
                    playerPos = playerPos
                end
            end
            sklad.PrePlayerPosUpdate = playerPos/1]]

            local headTransform = player:GetCostumeNullPos("HeadTransform",true, Vector(0,0))
            local headpos 
            local headrefpos = player:GetCostumeNullPos("BethHair_headref", true, Vector(0,0))
            if headrefpos.Y ~= 0 then
                headpos = playerPos + headrefpos / Wtr + Vector(0, -10)
            else
                headpos = false
            end

            for hairLayer = 0, #sklad do
                local hairContainer = sklad[hairLayer]
                local hairInfo = hairContainer.HairInfo
                Isaac.RunCallbackWithParam(_HairCordData2.Callbacks.HAIRPHYS_PRE_UPDATE, player:GetPlayerType(), player, hairInfo)
                for tailID = 1, #hairInfo do
                    local tailData = hairInfo[tailID]
                    local hairStartPos = playerPos + 
                        (headTransform + player:GetCostumeNullPos(tailData.CostumeNullpos, true, Vector(0,0))) * Wtr

                    --_HairCordData2.DefaultHairPhys(player, tailData, hairInfo, hairStartPos, headpos, player.SpriteScale.Y)
                    
                    if tailData.PhysFunc then
                        tailData.PhysFunc(player, tailData, hairInfo, hairStartPos, headpos, player.SpriteScale.Y)
                    end
                end
            end
        end

        local bodyColor = player:GetBodyColor()

        local colorchanged = sklad.PreBodyColor and sklad.PreBodyColor ~= bodyColor
        sklad.PreBodyColor = bodyColor

        if colorchanged then
            _HairCordData2.UpdateTailsCordColor(player, sklad, bodyColor)
        --[[    sklad.cacheNoHairColor = sklad.cacheNoHairColor or {}
            local cacheNoHairColor = sklad.cacheNoHairColor
            --Isaac.RunCallbackWithParam(_HairCordData2.Callbacks.PRE_COLOR_CHANGE, player:GetPlayerType(), player, bodyColor, refsting)
            local costumeDescs = player:GetCostumeSpriteDescs()
            for hairLayer = 0, #sklad do
                local hairContainer = sklad[hairLayer]
                local hairInfo = hairContainer.HairInfo
                if hairInfo.SyncWithCostumeBodyColor then
                    _HairCordData2.UpdateTargetCostume(player, hairInfo, costumeDescs)

                    for tailID = 1, #hairInfo do
                        local tailData = hairInfo[tailID]
                        local cordspr = tailData.CordSpr:GetSprite()

                        for layerId, layer in pairs(cordspr:GetAllLayers()) do
                            local sprpath = layer:GetSpritesheetPath()
                            sprpath = TryDeleteColorFromPath(sprpath)
                            local finalpath = sprpath:sub(0, sprpath:len()-4) .. bodyColorSuffix .. ".png"
                            local havecolorver = false
                            if not cacheNoHairColor[finalpath] then
                                havecolorver = pcall(Renderer.LoadImage, finalpath)
                                cacheNoHairColor[finalpath] = havecolorver
                            else
                                havecolorver = cacheNoHairColor[finalpath]
                            end
                            if not havecolorver then
                                finalpath = sprpath:sub(0, sprpath:len()-4) .. ".png"
                            end
                            cordspr:ReplaceSpritesheet(layer:GetLayerID(), finalpath)
                        end
                        cordspr:LoadGraphics()
                    end
                end
            end]]

            _HairCordData2.UpdateHairsCordPoses(player, sklad)
        end

    end
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, _HairCordData2.PostPlayerUpdate)

    function _HairCordData2.HairPreUpdate(_,player, haildata)
        for i = 1, #haildata do
            local taildata = haildata[i]
            if taildata then
                if taildata.PreUpdate then
                    taildata.PreUpdate(player, taildata)
                end
            end
        end
    end
    mod:AddCallback(_HairCordData2.Callbacks.HAIRPHYS_PRE_UPDATE, _HairCordData2.HairPreUpdate)

    function _HairCordData2.UpdateHairsCordPoses(player, sklad)
        local playerPos = sklad.RealHeadPos and ScreenToWorld(sklad.RealHeadPos + player.Velocity/2) or player.Position

        local headTransform = player:GetCostumeNullPos("HeadTransform",true, Vector(0,0))
        local headpos
        local headrefpos = player:GetCostumeNullPos("BethHair_headref", true, Vector(0,0))
        if headrefpos.Y ~= 0 then
            headpos = playerPos + headrefpos / Wtr + Vector(0, -10)
        else
            headpos = false
        end

        for hairLayer = 0, #sklad do
            local hairContainer = sklad[hairLayer]
            local hairInfo = hairContainer.HairInfo
            for tailID = 1, #hairInfo do
                local tailData = hairInfo[tailID]
                local hairStartPos = playerPos + 
                    (headTransform + player:GetCostumeNullPos(tailData.CostumeNullpos, true, Vector(0,0))) * Wtr

                --_HairCordData2.DefaultHairPhys(player, tailData, hairInfo, hairStartPos, headpos, player.SpriteScale.Y)
                
                if tailData.PhysFunc then
                    tailData.PhysFunc(player, tailData, hairInfo, hairStartPos, headpos, player.SpriteScale.Y)
                end
            end
        end

    end




    local ignoreHeadless = false
    ---@param player EntityPlayer
    function _HairCordData2.PostPlayerRender(_, player, offset)
        local data, spr = player:GetData(), player:GetSprite()

        if not data.__PhysHair_HairSklad then
            return
        end

        if not player:IsExtraAnimationFinished() or (not ignoreHeadless and player:IsHeadless()) then
            return
        end

        local Room = game:GetRoom()
        local rendermode = Room:GetRenderMode()

        local sklad = data.__PhysHair_HairSklad

        local isrerender = false
        local currentFrame = Isaac.GetFrameCount()
        if sklad.PostRenderModeCheck == rendermode and sklad.PostFrameCheck == currentFrame then
            sklad.PostFrameCheck = currentFrame
            --testspr:Render(offset)
            --return
            isrerender = true
        end
        sklad.PostRenderModeCheck = rendermode
        sklad.PostFrameCheck = currentFrame

        local realplayerPos, rerenderoffset
        local headpos = sklad.RealHeadPos or worldToScreen(player.Position)
        if isrerender then
            if not sklad.RealHeadPosRerender then
                return
            end
            rerenderoffset = headpos - sklad.RealHeadPosRerender
        end

        local hdir = player:GetHeadDirection()
        local playerCol = player:GetColor()

        local isreflect = rendermode == RenderMode.RENDER_WATER_REFLECT
        if rendermode == RenderMode.RENDER_WATER_ABOVE then
            sklad.reflectOffset = offset
        elseif  isreflect then
            sklad.reflectOffset2 = offset
        end

        if isreflect then
            if player:IsHeadless() then
                return
            end
            if not sklad.reflectOffset or not sklad.reflectOffset2 then
                return
            end
            
            if RoomTransition:GetTransitionMode() == 3 then
                sklad.PostRoomTransitionRenderDiscard = 6
            end
            if sklad.PostRoomTransitionRenderDiscard then
                sklad.PostRoomTransitionRenderDiscard = sklad.PostRoomTransitionRenderDiscard - 1
                if sklad.PostRoomTransitionRenderDiscard <= 0 then
                    sklad.PostRoomTransitionRenderDiscard = nil
                end
                return
            end

            realplayerPos = (worldToScreen(player.Position) + player:GetFlyingOffset())  -- offset
            local copyc = Color.Lerp(playerCol, playerCol, 0)
            copyc.A = playerCol.A-.5
            playerCol = copyc
        end

        --local NeedCacheRender = player:IsHeadless()

        for hairLayer = 0, #sklad do
            local hairContainer = sklad[hairLayer]
            local hairInfo = hairContainer.HairInfo
            --for i,k in pairs(hairContainer.HairInfo) do
            --    print(i,k)
            --end
            --if NeedCacheRender then
                --hairContainer.RenderCache = {pre = {}, post = {}}
            --end

            local BackSpr = hairInfo.HeadBackSpr
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
                    BackSpr:Render(headpos )
                else
                    BackSpr:Render(headpos)
                end
            end


            for tailID = 1, #hairInfo do
                local tailData = hairInfo[tailID]

                local cord = tailData.CordSpr
                local cordSpr = cord:GetSprite()
                
                local hairPos = player:GetCostumeNullPos(tailData.CostumeNullpos, true, Vector(0,0)) --+ player:GetCostumeNullPos("HeadTransform",true, Vector(0,0)) --+ Vector(0, -10)
                    
                hairPos = hairPos + player:GetCostumeNullPos("HeadTransform",true, Vector(0,0))

                local rl = tailData.RenderLayers
                local rlt = rl[hdir] --[tail] 
    
                if rlt & 2 == 2 and rlt & 1 == 1 then
                    --local hap1 = headpos+hairPos
                    --local startoffset = tailData.SO or (tailData.Scretch*.16)
                    --local off = (hap1-worldToScreen(tailData[0][1])):Resized(player.SpriteScale.X*startoffset) + game.ScreenShakeOffset  -- Vector(0,0) -- (hap1-tail1[0][1]):Resized(player.SpriteScale.X*scretch*.3)
                    --cord:Add(hap1+off, tailData.STH or 5, player.SpriteScale.X*.95*cordSpr.Scale.X, playerCol)
                    --for i=0, #tailData do
                    --    local cur = tailData[i]
                    --    local pos = worldToScreen(cur[1]) --+ hairPos1
                    --    
                    --    cord:Add(pos, cur[3]+2, player.SpriteScale.X*cordSpr.Scale.X, playerCol)
                    --end
                    local zeroPoint = tailData.ZeroPoint
                    local zeroPointPos --= headpos + hairPos
                    local reflectOffset
                    if isreflect then
                        reflectOffset = sklad.reflectOffset2 - sklad.reflectOffset
                        zeroPointPos = headpos + Vector(hairPos.X,-hairPos.Y)
                    else
                        zeroPointPos = headpos + hairPos
                    end

                    local firstpoint = worldToScreen(tailData[0][1])
                    if rerenderoffset then
                        firstpoint = firstpoint + rerenderoffset
                    end
                    local off = (zeroPointPos - firstpoint):Resized( tailData.SO or 0.15 )
                    zeroPoint:SetPosition(zeroPointPos + off)
                    cord:Add(zeroPoint)
                    for i=0, #tailData do
                        local P = tailData[i]
                        local pos = worldToScreen(P[1])
                        if rerenderoffset then
                            pos = pos + rerenderoffset
                        end
                        if isreflect then
                            local yof = realplayerPos.Y-pos.Y
                            pos.Y = pos.Y + yof*2
                            pos = pos + reflectOffset -- offset
                            --local yof = realplayerPos.Y-pos.Y
                            --local zof = worldToScreen(z) 
                            --pos = pos - Vector(zof.X - 13,0) --+ offset
                            --pos.Y = pos.Y + yof*1.8
                            --if sklad.reflectOffset then
                            --    pos = pos - sklad.reflectOffset
                            --end
                        end
                        P.p:SetColor(playerCol)
                        P.p:SetPosition(pos)
                        
                        cord:Add(tailData[i].p)

                        --local f1,f2 = i==0 and zeroPointPos + off or tailData[i-1].p:GetPosition(), pos

                        --Isaac.DrawLine(f1,f2 , KColor(1,1,1,1), KColor(1,1,1,1), 1)
                    end
                    cord:Render()
                end
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, _HairCordData2.PostPlayerRender)

    function _HairCordData2.PrePlayerHeadRender(_, player, offset)
        local data, spr = player:GetData(), player:GetSprite()

        if not data.__PhysHair_HairSklad then
            return
        end
        local Room = game:GetRoom()
        local rendermode = Room:GetRenderMode()
        local sklad = data.__PhysHair_HairSklad
        
        local isrerender = false
        local currentFrame = Isaac.GetFrameCount()

        if sklad.RenderModeCheck == rendermode and sklad.FrameCheck == currentFrame then
            --sklad.RenderCallCount = sklad.RenderCallCount + 1
        --end
        --if sklad.RenderCallCount > 1 then
            --testspr:Render(offset)
            isrerender = true

        end
        sklad.FrameCheck = currentFrame
        sklad.RenderModeCheck = rendermode

        local realplayerPos, rerenderoffset
        local headpos = offset

        local hdir = player:GetHeadDirection()
        local playerCol = player:GetColor()

        local Room = game:GetRoom()
        local isreflect = Room:GetRenderMode() == RenderMode.RENDER_WATER_REFLECT

        if isrerender then
            if RoomTransition:GetTransitionMode() ~= 3 then
                --if isreflect then
                --    return
                --end
                rerenderoffset = headpos - sklad.RealHeadPos
            end
        else
            sklad.RealHeadPos = headpos
        end

        if isreflect then
            if player:IsHeadless() then
                return
            end
            if RoomTransition:GetTransitionMode() == 3 then
                return
            end
            if not sklad.reflectOffset or not sklad.reflectOffset2 then
                return
            end
            --if RoomTransition:GetTransitionMode() == 3 then
            --    sklad.PostRoomTransitionRenderDiscard = 1
            --end
            --if sklad.PostRoomTransitionRenderDiscard then
                --sklad.PostRoomTransitionRenderDiscard = sklad.PostRoomTransitionRenderDiscard - 1
                --if sklad.PostRoomTransitionRenderDiscard <= 0 then
                --    sklad.PostRoomTransitionRenderDiscard = nil
                --end
                --return
            --end
        end

        if not isrerender then
            local worldheadpos = ScreenToWorld(headpos)
            
            if isreflect then
                if not sklad.PostRoomTransitionRenderDiscard and sklad.PrePlayerPosReflect then
                    local dist = worldheadpos:Distance(sklad.PrePlayerPosReflect)
                    if dist > 10 and dist > player.Velocity:Length() * 1 then
                        local diff = worldheadpos - sklad.PrePlayerPosReflect
                        for hairLayer = 0, #sklad do
                            local hairContainer = sklad[hairLayer]
                            local hairInfo = hairContainer.HairInfo
                            for tailID = 1, #hairInfo do
                                local tailData = hairInfo[tailID]
                                for i = 0, #tailData do
                                    local P = tailData[i]
                                    P[1] = P[1] + diff
                                end
                            end
                        end
                        --sklad.PrePlayerPos = worldheadpos -- worldToScreen(z)*Wtr
                    end
                end
                sklad.PrePlayerPosReflect = worldheadpos/1
            else
                if sklad.PrePlayerPos then
                    local dist = worldheadpos:Distance(sklad.PrePlayerPos)
                    --print(worldheadpos, sklad.PrePlayerPos)
                    if dist > 10 and dist > player.Velocity:Length() * 1 then
                        --local isroomtransition = RoomTransition:GetTransitionMode() == 3
                        sklad.PrePlayerPosReflect = nil
                        local diff = worldheadpos - sklad.PrePlayerPos
                        for hairLayer = 0, #sklad do
                            local hairContainer = sklad[hairLayer]
                            local hairInfo = hairContainer.HairInfo
                            for tailID = 1, #hairInfo do
                                local tailData = hairInfo[tailID]
                                for i = 0, #tailData do
                                    local P = tailData[i]
                                    P[1] = P[1] + diff
                                end
                            end
                        end
                    end
                end
                sklad.PrePlayerPos = worldheadpos/1
            end
            --print(sklad.PrePlayerPosReflect, sklad.PrePlayerPos, sklad.PrePlayerPos - sklad.PrePlayerPosReflect, worldToScreen(z) + Vector(9.2653, 40.076), "|", 
            --    sklad.PrePlayerPos - sklad.PrePlayerPosReflect - worldToScreen(z)*Wtr)
        end

        local NeedCacheRender = player:IsHeadless()

        for hairLayer = 0, #sklad do
            local hairContainer = sklad[hairLayer]
            local hairInfo = hairContainer.HairInfo
            --for i,k in pairs(hairContainer.HairInfo) do
            --    print(i,k)
            --end

            if NeedCacheRender then
                hairContainer.RenderCache = {pre = {}, post = {}}
            end


            local Back2Spr = hairInfo.HeadBack2Spr
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
                local headTransform = player:GetCostumeNullPos("HeadTransform",true, Vector(0,0))
                if isreflect then
                    Back2Spr:Render(headpos )
                else
                    Back2Spr:Render(headpos + headTransform)
                end
            end

            --if isreflect then return end
            if isreflect then
                realplayerPos = (worldToScreen(player.Position) + player:GetFlyingOffset()) -- offset
                --    + sklad.reflectOffset2 - sklad.reflectOffset
                local copyc = Color.Lerp(playerCol, playerCol, 0)
                copyc.A = playerCol.A-.5
                playerCol = copyc
            end

            local HeadShadowLayer = hairInfo.HeadShadowLayer
            local shadowmask = HeadShadowLayer and HeadShadowLayer.mask
            
            for tailID = 1, #hairInfo do
                ---@type TailData2
                local tailData = hairInfo[tailID]

                local cord = tailData.CordSpr
                local cordSpr = cord:GetSprite()
                
                local hairPos = player:GetCostumeNullPos(tailData.CostumeNullpos, true, Vector(0,0)) --+ player:GetCostumeNullPos("HeadTransform",true, Vector(0,0)) --+ Vector(0, -10)
                    
                hairPos = hairPos + player:GetCostumeNullPos("HeadTransform",true, Vector(0,0))

                local rl = tailData.RenderLayers
                local rlt = rl[hdir] --[tail] 

                if rlt & 2 == 2 and rlt & 1 == 0 then
                    local zeroPoint = tailData.ZeroPoint
                    local zeroPointPos --= headpos + hairPos
                    --local zeroPointRaf
                    local reflectOffset
                    if isreflect then
                        reflectOffset = sklad.reflectOffset2 - sklad.reflectOffset
                        zeroPointPos = headpos + Vector(hairPos.X,-hairPos.Y)
                        --zeroPointRaf = headpos + hairPos
                    else
                        zeroPointPos = headpos + hairPos
                    end

                    local firstpoint = worldToScreen(tailData[0][1])
                    if rerenderoffset then
                        firstpoint = firstpoint + rerenderoffset
                    end
                    local off = (zeroPointPos - firstpoint):Resized( tailData.SO or 0 )

                    zeroPoint:SetPosition(zeroPointPos + off)
                    zeroPoint:SetColor(playerCol)
                    cord:Add(zeroPoint)
                    for i=0, #tailData do
                        local P = tailData[i]
                        local Pp = P.p
                        local pos = worldToScreen(P[1])
                        if rerenderoffset then
                            pos = pos + rerenderoffset
                        end
                        if isreflect then
                            local yof = realplayerPos.Y-pos.Y
                            pos.Y = pos.Y + yof*2
                            pos = pos + reflectOffset
                            
                            --[[local yof = realplayerPos.Y-pos.Y
                            local yof2 = zeroPointRaf - pos
                            local zof = worldToScreen(z)
                            pos = yof2 + zeroPointPos + zof 
                            --pos = pos -- sklad.reflectOffset2 -- Vector(zof.X - 13,0) --+ offset
                            pos.Y = pos.Y + yof*2
                            if sklad.reflectOffset then
                                --pos = pos - sklad.reflectOffset
                            end]]

                        end

                        Pp:SetPosition(pos)
                        Pp:SetColor(playerCol)
                        
                        cord:Add(Pp)
                    end
                    --Isaac.DrawLine(worldToScreen(player.Position), (tailData[0].p:GetPosition()),
                    --    KColor(1,1,1,1), KColor(1,1,1,1), 2)
                    cord:Render()
                end

                local shadowCord = tailData.ShadowCordSpr
                if not isreflect and shadowCord then
                    local srl = tailData.ShadowRenderLayers
                    local srlt = srl[hdir] --[tail] 
                    
                    if srlt & 2 == 2 and srlt & 1 == 0 then
                        if HeadShadowLayer and HeadShadowLayer[tailID] then
                            shadowmask:SetFrame(spr:GetOverlayAnimation(), spr:GetOverlayFrame())
                            shadowmask.Color = Color(1,1,1,1, 0,0,0, tailData.DotCount)
                            shadowmask:Render(headpos)
                        end


                        shadowCord:Add(tailData.ZeroPoint)
                        for i=0, #tailData do
                            shadowCord:Add(tailData[i].p)
                        end
                        shadowCord:Render()
                    end
                end
            end
        end
    end

    mod:AddPriorityCallback(ModCallbacks.MC_PRE_RENDER_PLAYER_HEAD, 10, _HairCordData2.PrePlayerHeadRender)

    mod:AddCallback(ModCallbacks.MC_PRE_BACKDROP_RENDER_FLOOR, function()
        local roomtrasMode = RoomTransition:GetTransitionMode()
        if roomtrasMode == 3 then
            for i = 0, game:GetNumPlayers()-1 do
                local player = game:GetPlayer(i)
                local data = player:GetData()
                local sklad = data.__PhysHair_HairSklad
                if sklad then
                    --sklad.RenderCallCount = 0
                    sklad.FrameCheck = 0
                    sklad.PostFrameCheck = 0
                end
            end
        end
    end)

    function _HairCordData2.PostFamiliarRenderHead(_, fam, offset)
        local famVar = fam.Variant
        ignoreHeadless = true
        local isdecap = Isaac.CountEntities(nil, EntityType.ENTITY_FAMILIAR, FamiliarVariant.DECAP_ATTACK) > 0

        if famVar == FamiliarVariant.GUILLOTINE then
            if isdecap then
                return
            end
            local player = fam.Player
            local data = player:GetData()
            local sklad = data.__PhysHair_HairSklad
            if sklad then
                local RealHeadPos = sklad.RealHeadPos
                sklad.RealHeadPosRerender = sklad.RealHeadPos
                sklad.RealHeadPos = worldToScreen(fam.Position + fam.PositionOffset)
                _HairCordData2.PostPlayerRender(_, fam.Player, offset)
                sklad.RealHeadPos = RealHeadPos
            end
        elseif famVar == FamiliarVariant.DECAP_ATTACK then
            local player = fam.Player
            local data = player:GetData()
            local sklad = data.__PhysHair_HairSklad
            if sklad then
                local RealHeadPos = sklad.RealHeadPos
                sklad.RealHeadPosRerender = sklad.RealHeadPos
                sklad.RealHeadPos = worldToScreen(fam.Position + fam.PositionOffset) + fam.SpriteOffset + Vector(0, 9)
                _HairCordData2.PostPlayerRender(_, fam.Player, offset)
                sklad.RealHeadPos = RealHeadPos
            end
        elseif famVar == FamiliarVariant.SCISSORS then
            if isdecap then
                return
            end
            local player = fam.Player
            local data = player:GetData()
            local sklad = data.__PhysHair_HairSklad
            if sklad then
                local RealHeadPos = sklad.RealHeadPos
                sklad.RealHeadPosRerender = sklad.RealHeadPos
                sklad.RealHeadPos = worldToScreen(fam.Position + fam.PositionOffset)
                _HairCordData2.PostPlayerRender(_, fam.Player, offset)
                sklad.RealHeadPos = RealHeadPos
            end
        end
        ignoreHeadless = false
    end
    mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, _HairCordData2.PostFamiliarRenderHead)



    ---@param player EntityPlayer
    ---@param costumeDescs CostumeSpriteDesc[]
    function _HairCordData2.UpdateTargetCostume(player, hairdata, costumeDescs)
        if hairdata.TargetCostume then
            local tarcost = hairdata.TargetCostume
            local sklad = player:GetData().__PhysHair_HairSklad
            
            hairdata.FinalCostumePath = {}
            sklad.cacheNoHairColor = sklad.cacheNoHairColor or {}
            local cacheNoHairColor = sklad.cacheNoHairColor

            local nullref = hairdata.NullposRefSpr
            local bodyColor = player:GetBodyColor()
            local bodyColorSuffix = bodycolor[bodyColor] or ""
            --Isaac.RunCallbackWithParam(_HairCordData2.Callbacks.PRE_COLOR_CHANGE, player:GetPlayerType(), player, bodyColor, bodyColorSuffix)

            local pos = 0
            local TargetCostumelayer = tarcost.CostumeLayer or 1
            local costumemap = formatCostumeMap(player:GetCostumeLayerMap())
            for icost, csd in pairs(costumeDescs) do
                local conf = csd:GetItemConfig()
                if tarcost.ID == conf.ID and (not tarcost.Type or tarcost.Type == conf.Type) then
                    local isBodyLayer = costumemap[icost-1].isBodyLayer

                    if TargetCostumelayer == 0 
                    or TargetCostumelayer == 1 and not isBodyLayer
                    or TargetCostumelayer == 2 and isBodyLayer then
                    --if not tarcost.pos or tarcost.pos == pos then
                        
                        local cspr = csd:GetSprite()
                        if nullref then
                            cspr:Load(nullref:GetFilename(), true)
                        end
                        
                        if not hairdata.OrigCostume or hairdata.OrigCostume.path ~= cspr:GetFilename() then
                            hairdata.OrigCostume = {
                                path = cspr:GetFilename(),
                            }
                            for layerId, layer in pairs(cspr:GetAllLayers()) do
                                hairdata.OrigCostume[layerId] = layer:GetDefaultSpritesheetPath()
                            end
                        end
                        
                        local replacestr = hairdata.ReplaceCostumeSheep

                        if type(replacestr) == "table" then
                            for i, str in ipairs(replacestr) do
                                local finalstr = str:sub(0, -5) .. bodyColorSuffix .. ".png"
                                if not CheckPNGExists(finalstr, cacheNoHairColor) then
                                    finalstr = str:sub(0, -5) .. ".png"
                                end
                                cspr:ReplaceSpritesheet(i, finalstr)
                                hairdata.FinalCostumePath[i] = finalstr
                            end
                        else
                            local finalstr = replacestr:sub(0, -5) .. bodyColorSuffix .. ".png"
                            if not CheckPNGExists(finalstr, cacheNoHairColor) then
                                finalstr = replacestr:sub(0, -5) .. ".png"
                            end
                            for layerId = 0, cspr:GetLayerCount() do
                                cspr:ReplaceSpritesheet(layerId, finalstr)
                                hairdata.FinalCostumePath[layerId] = finalstr
                            end
                        end
                        cspr:LoadGraphics()

                        --hairdata.FinalCostumePath

                    else
                        pos = pos + 1
                    end
                end
            end

        end
    end

    function _HairCordData2.UpdateItemCostumeAlts(player, hairdata, costumeDescs)
        local ItemCostumeAlts = hairdata.ItemCostumeAlts
        for i, csd in pairs(costumeDescs) do
            local conf = csd:GetItemConfig()
            for itemAltsId = 1, #ItemCostumeAlts do
                local itemAlt = ItemCostumeAlts[itemAltsId]
                if conf.ID == itemAlt.ID and (not itemAlt.Type or itemAlt.Type == conf.Type) then
                    local cspr = csd:GetSprite()
                    if itemAlt.anm2 then
                        cspr:Load(itemAlt.anm2, true)
                    end
                    if itemAlt.gfx then
                        if type(itemAlt.gfx) == "table" then
                            for layerid, gfx in pairs(itemAlt.gfx) do
                                cspr:ReplaceSpritesheet(layerid, gfx)
                            end
                        else 
                            local gfx = itemAlt.gfx
                            for layerId = 0, cspr:GetLayerCount() do
                                cspr:ReplaceSpritesheet(layerId, gfx)
                            end
                        end
                        cspr:LoadGraphics()
                    end
                end
            end
        end
    end

    function _HairCordData2.UpdateTailsCordColor(player, sklad, bodyColor)
        local bodyColorSuffix = bodycolor[bodyColor] or ""

        sklad.cacheNoHairColor = sklad.cacheNoHairColor or {}
        local cacheNoHairColor = sklad.cacheNoHairColor
        Isaac.RunCallbackWithParam(_HairCordData2.Callbacks.PRE_COLOR_CHANGE, player:GetPlayerType(), player, bodyColor, bodyColorSuffix)
        
        local costumeDescs = player:GetCostumeSpriteDescs()
        for hairLayer = 0, #sklad do
            local hairContainer = sklad[hairLayer]
            local hairInfo = hairContainer.HairInfo
            if hairInfo.SyncWithCostumeBodyColor then
                _HairCordData2.UpdateTargetCostume(player, hairInfo, costumeDescs)

                if hairInfo.HeadBack2Spr then
                    local spr = hairInfo.HeadBack2Spr
                    for layerId, layer in pairs(spr:GetAllLayers()) do
                        local sprpath = layer:GetSpritesheetPath()
                        sprpath = TryDeleteColorFromPath(sprpath)
                        local finalpath = sprpath:sub(0, sprpath:len()-4) .. bodyColorSuffix .. ".png"

                        if not CheckPNGExists(finalpath, cacheNoHairColor) then
                            finalpath = sprpath:sub(0, sprpath:len()-4) .. ".png"
                        end

                        spr:ReplaceSpritesheet(layer:GetLayerID(), finalpath)
                    end
                    spr:LoadGraphics()
                end

                for tailID = 1, #hairInfo do
                    local tailData = hairInfo[tailID]
                    local cordspr = tailData.CordSpr:GetSprite()

                    for layerId, layer in pairs(cordspr:GetAllLayers()) do
                        local sprpath = layer:GetSpritesheetPath()
                        sprpath = TryDeleteColorFromPath(sprpath)
                        local finalpath = sprpath:sub(0, sprpath:len()-4) .. bodyColorSuffix .. ".png"

                        --[[local havecolorver = false
                        if not cacheNoHairColor[finalpath] then
                            havecolorver = pcall(Renderer.LoadImage, finalpath)
                            cacheNoHairColor[finalpath] = havecolorver
                        else
                            havecolorver = cacheNoHairColor[finalpath]
                        end
                        if not havecolorver then
                            finalpath = sprpath:sub(0, sprpath:len()-4) .. ".png"
                        end)]]

                        if not CheckPNGExists(finalpath, cacheNoHairColor) then
                            finalpath = sprpath:sub(0, sprpath:len()-4) .. ".png"
                        end

                        cordspr:ReplaceSpritesheet(layer:GetLayerID(), finalpath)
                    end
                    cordspr:LoadGraphics()
                end
            end
        end

        --_HairCordData2.UpdateHairsCordPoses(player, sklad)
    end



    return _HairCordData2
end