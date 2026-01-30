---@type BethHair
local mod = BethHair

local Isaac = Isaac
local game = Game()
local Room 
local Wtr = 20/13
local sfx = SFXManager()



local function GenSprite(gfx, anim, frame)
    if gfx then
        local spr
        spr = Sprite()
        spr:Load(gfx, true)
        if anim then
            spr:Play(anim)
        end
        if frame then
            spr:SetFrame(frame)
        end
        return spr
    end
end

mod.HStyles = {
    Sfx = {
        swing = Isaac.GetSoundIdByName("PhysHair_Swing"),
        doorbell = Isaac.GetSoundIdByName("PhysHair_Doorsbell"),
        Chr_appear = Isaac.GetSoundIdByName("PhysHair_Chr_appear"),
        scisors_swing = Isaac.GetSoundIdByName("PhysHair_Scisors_Swing"),
        chair_creaks = Isaac.GetSoundIdByName("PhysHair_Chair_creaks"),
    },
}

---@class InStyleData
---@field ID PlayerType
---@field data PlayerHairData
---@field extra table


mod.HairStylesData = {
    playerdata = {},
    ---@type InStyleData[]
    styles = {}, 
    favorites = {},
}
local HairStylesData = mod.HairStylesData

function mod.HStyles.AddStyle(name, playerid, data, extradata)
    if name and playerid and data then
        data.StyleName = name
        HairStylesData.styles[name] = {ID=playerid, data=data, extra=extradata}
        HairStylesData.playerdata[playerid] = HairStylesData.playerdata[playerid] or {}
        local tab = HairStylesData.playerdata[playerid]
        tab[#tab+1] = name
    end
end

---@class HairStyleData
---@field ID PlayerType
---@field data SetHairDataParam
---@field extra table

---@return HairStyleData
function BethHair.HStyles.GetStyleData(name)
    return HairStylesData.styles[name]
end

function mod.SetHairStyleData(player, playerType, style_data)
    --local copy
    if not style_data.TargetCostume then
        style_data.TargetCostume = mod.HStyles.GetTargetCostume(playerType)
        --playerType = player:GetPlayerType()
    end
    player:GetData()._PhysHair_HairStyle = {StyleName = style_data.StyleName, PlayerType = playerType}
    --mod.HairLib.SetHairData(playerType,  style_data)
    mod.HairLib.SetHairDataToPlayer(player, 
        {
            HairInfo = style_data
        })
end

function mod.HairPreInit(_, player)
    local ptype = player:GetPlayerType()
    local pladat = HairStylesData.playerdata[ptype]
    if pladat then
        local data = player:GetData()
        if data._PhysHair_HairStyle then
            local PHSdata = data._PhysHair_HairStyle
            if PHSdata.PlayerType and PHSdata.PlayerType ~= -1 and PHSdata.PlayerType ~= ptype then
                data._PhysHair_HairStyle = nil
            else
                local stdata = HairStylesData.styles[PHSdata.StyleName]
                if stdata then
                    if stdata.ID == ptype or stdata.ID == -1 then
                        mod.SetHairStyleData(player,ptype, stdata.data)
                        --mod.HStyles.UpdateMainHairSprite(player, data, stdata)
                    end
                end
            end
        else
            local favorites = HairStylesData.favorites[ptype] -- or pladat[1]
            if favorites then
                for layer = 0, #favorites do
                    local favData = favorites[layer]
                    if favData then
                        local stdata = HairStylesData.styles[favData.style]
                        if stdata then
                            --mod.SetHairStyleData(player,ptype, stdata.data)
                            mod.HStyles.SetStyleToPlayer(player, favData.style, layer, favData.mode)
                            --mod.HStyles.UpdateMainHairSprite(player, data, stdata)
                        end
                    end
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.HairPreInit)

function mod.PlayerTypeChecker(_, player)
    local data = player:GetData()
    local ptype = player:GetPlayerType()
    
    if data._PhysHair_HairStyle then
        local phdat = data._PhysHair_HairStyle
        
        if phdat.PrePlayerType and phdat.PrePlayerType ~= ptype then
            data.__PhysHair_HairSklad = nil
            data._PhysHair_HairStyle = nil
            return
        end

        phdat.PrePlayerType = ptype
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.PlayerTypeChecker)



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
local cacheNoHairColor = {}

--mode: 1 = no phys hair
function mod.HStyles.SetStyleToPlayer(player, style_name, layer, StyleMode)
    if player and style_name then
        local stdata = HairStylesData.styles[style_name]
        player = player:ToPlayer()
        local ptype = player:GetPlayerType()

        if stdata and (stdata.ID == ptype or stdata.ID == -1) then
            local data = player:GetData()

            data._PhysHair_HairStyle = data._PhysHair_HairStyle or {}
            layer = layer or 0
            data._PhysHair_HairStyle[layer] = {StyleName = style_name, PlayerType = ptype}

            
            local setdata = stdata.data
            if StyleMode == 1 then
                local temp = {}
                temp.TargetCostume = setdata.TargetCostume
                temp.SyncWithCostumeBodyColor = setdata.SyncWithCostumeBodyColor
                temp.SkinFolderSuffics = setdata.SkinFolderSuffics
                temp.ReplaceCostumeSheep = setdata.TailCostumeSheep
                temp.TailCostumeSheep = setdata.TailCostumeSheep
                temp.ItemCostumeAlts = setdata.ItemCostumeAlts
                temp.NullposRefSpr = setdata.NullposRefSpr
                temp.StyleName = setdata.StyleName

                setdata = temp
            end

            mod.HairLib.SetHairDataToPlayer(player, {
                HairInfo = setdata,
                layer = layer,
            })
        end
    end
end

local cacheSkinsColor = {}

function mod.HStyles.UpdatePlayerSkin(player, data, stdata)
    local skinsheet = stdata.data.SkinFolderSuffics
    local bodcol = player:GetBodyColor()
    data._PhysHairExtra = data._PhysHairExtra or {}
    if skinsheet then
        data._PhysHairExtra.SkinIsChanged = true
        local spr = player:GetSprite()
        ---@type string
        --local orig = spr:GetLayer(0):GetDefaultSpritesheetPath()
        --orig = orig:match(".+/(.-)%.png")
        local orig
        local pconf = EntityConfig.GetPlayer(stdata.ID)
        if pconf then
            orig = pconf:GetSkinPath()
        end

        if orig then
            orig = orig:match(".+/(.-)%.png")
            local path = skinsheet .. orig .. ( bodycolor[bodcol] or "") .. ".png"
            local havecolorver = false
            if not cacheSkinsColor[path] then
                havecolorver = pcall(Renderer.LoadImage, path)
                cacheSkinsColor[path] = havecolorver
            else
                havecolorver = cacheSkinsColor[path]
            end
            if not havecolorver then
                path = skinsheet .. orig .. ".png"
            end

            for i=0, spr:GetLayerCount()-1 do
                spr:ReplaceSpritesheet(i,path)
            end
            spr:LoadGraphics()
        end
    elseif data._PhysHairExtra.SkinIsChanged then
        data._PhysHairExtra.SkinIsChanged = nil

        local spr = player:GetSprite()
        local orig
        local pconf = EntityConfig.GetPlayer(stdata.ID)
        if pconf then
            orig = pconf:GetSkinPath()
        end

        if orig then
            local path = orig:sub(1,-5) .. ( bodycolor[bodcol] or "") .. ".png"
            local havecolorver = pcall(Renderer.LoadImage, path)
            if not havecolorver then
                path = orig .. ".png"
            end
            for i=0, spr:GetLayerCount()-1 do
                spr:ReplaceSpritesheet(i,path)
            end
            spr:LoadGraphics()
        end
    end
end
---@class PlayerDataContent
---@field _BethsHairCord PlayerHairData
---@field _PhysHairExtra table
---@field [string] any

---@deprecated
---@param data PlayerDataContent
function mod.HStyles.UpdateMainHairSprite(player, data, stdata)
    do 
        return
    end


    --[[local skinsheet = stdata.data.SkinFolderSuffics
    local bodcol = player:GetBodyColor()

    if skinsheet then
        local spr = player:GetSprite()
        ---@type string
        --local orig = spr:GetLayer(0):GetDefaultSpritesheetPath()
        --orig = orig:match(".+/(.-)%.png")
        local orig
        local pconf = EntityConfig.GetPlayer(stdata.ID)
        if pconf then
            orig = pconf:GetSkinPath()
        end

        if orig then
            orig = orig:match(".+/(.-)%.png")
            local path = skinsheet .. orig .. ( bodycolor[bodcol] or "") .. ".png"
            for i=0, spr:GetLayerCount()-1 do
                spr:ReplaceSpritesheet(i,path)
            end
            spr:LoadGraphics()
        end
    end]]
    mod.HStyles.UpdatePlayerSkin(player, data, stdata)
    local bodcol = player:GetBodyColor()

    local nullref = stdata.data.NullposRefSpr   --stdata.data.TailCostumeSheep
    local sheep = data._BethsHairCord and data._BethsHairCord.ReplaceCostumeSheep
    local sheepIsTable = type(sheep) == "table"
    local tarcost = stdata.data.TargetCostume
    data._PhysHairExtra = data._PhysHairExtra or {}


    -- восстановление костюмов и может быть прочего

    local Preoic = data._PhysHairExtra.OrigItemCostumes
    if Preoic then
        local itemaltpos = 0
        local preItemID = 0
        for i, csd in pairs(player:GetCostumeSpriteDescs()) do
            local conf = csd:GetItemConfig()

            local loic = Preoic[conf.ID]
            if loic then
                if preItemID ~= conf.ID then
                    itemaltpos = itemaltpos + 1
                else
                    itemaltpos = 0
                end
                preItemID = conf.ID

                local lloic = loic[itemaltpos]
                if lloic then
                    local cspr = csd:GetSprite()
                    cspr:Load(lloic.anm2, true)

                    for id, gfx in pairs(lloic.gfx) do
                        cspr:ReplaceSpritesheet(id-1, gfx)
                    end
                    cspr:LoadGraphics()

                end
            end
        end
    end


    
    if nullref and tarcost then
        data._PhysHairExtra.DefCostumetSheetPath = {}
        local dcsp = data._PhysHairExtra.DefCostumetSheetPath

        data._PhysHairExtra.ForceOrigCost = {}
        local foc = data._PhysHairExtra.ForceOrigCost

        local pos = 0
        for i, csd in pairs(player:GetCostumeSpriteDescs()) do
            local conf = csd:GetItemConfig()
            if tarcost.ID == conf.ID and (not tarcost.Type or tarcost.Type == conf.Type) then
                if not tarcost.pos or tarcost.pos == pos then
                    local cspr = csd:GetSprite()
                    local anim = cspr:GetAnimation()
                    cspr:Load(nullref:GetFilename(), true)
                    cspr:Play(anim)

                    for i=0, cspr:GetLayerCount()-1 do
                        local shpa = nullref:GetLayer(i) -- type(sheep) == "table" and sheep[i] or sheep   --sheep:GetLayer(i)
                        if shpa then
                            
                            --cspr:ReplaceSpritesheet(i, shpa:GetSpritesheetPath())
                            
                            local orig = sheep and (sheepIsTable and sheep[i] or sheep) or shpa:GetSpritesheetPath()
                            local refsting = orig:sub(0, orig:len()-4)

                            local colorsuf = bodycolor[bodcol] or ""
                            local finalpath = refsting .. colorsuf .. ".png"
                            
                            local havecolorver = false
                            if not cacheNoHairColor[finalpath] then
                                havecolorver = pcall(Renderer.LoadImage, finalpath)
                                cacheNoHairColor[finalpath] = havecolorver
                            else
                                havecolorver = cacheNoHairColor[finalpath]
                            end
                            if not havecolorver then
                                finalpath = refsting .. ".png"
                            end
                            
                            cspr:ReplaceSpritesheet(i, finalpath)

                            --foc[i] = shpa:GetSpritesheetPath()
                            dcsp[i] = orig:gsub("_notails", "") -- shpa:GetSpritesheetPath()
                        end
                    end
                    cspr:LoadGraphics()

                    --break

                    --cspr:ReplaceSpritesheet(id, finalpath)
                    --cspr:LoadGraphics()

                    --[[local refsting
                    if type(sheep) == "table" then
                        for id, gfx in pairs(sheep) do
                            local orig = sheep
                            refsting = orig:sub(0, orig:len()-4)

                            local colorsuf = bodycolor[bodcol]  or ""
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
                            local orig = sheep
                            refsting = orig:sub(0, orig:len()-4)

                            local colorsuf = bodycolor[bodcol] or ""
                            local finalpath = refsting .. colorsuf .. ".png"
                            
                            local havecolorver = false
                            if not cacheNoHairColor[finalpath] then
                                havecolorver = pcall(Renderer.LoadImage, finalpath)
                                cacheNoHairColor[finalpath] = havecolorver
                            else
                                havecolorver = cacheNoHairColor[finalpath]
                            end
                            if not havecolorver then
                                finalpath = refsting .. ".png"
                            end

                            cspr:ReplaceSpritesheet(id, finalpath) -- refsting .. (suffix or "") .. ".png")  -- rep)
                            dcsp[id] = finalpath
                        end
                        cspr:LoadGraphics()
                    end]] 
                else
                    pos = pos + 1
                end
            end
        end
    end

    --data._PhysHairExtra.OrigItemCostumes = {}
    data._PhysHairExtra.OrigItemCostumes = {}
    local oic = data._PhysHairExtra.OrigItemCostumes
    local ItemCostumeAlts = stdata.data.ItemCostumeAlts
    if ItemCostumeAlts then
        --local ItemCostumeAlts = ItemAlts -- data._BethsHairCord and data._BethsHairCord.ItemAlts
        local hasItemAlts = ItemCostumeAlts and #ItemCostumeAlts > 0
        ---@type ItemCostumeAlts_set[]
        local ItemCostumeAltsRevert = {}
        if hasItemAlts then
            for i=1, #ItemCostumeAlts do
                ItemCostumeAltsRevert[ItemCostumeAlts[i].ID] = ItemCostumeAlts[i]
            end
        end

        local pos = 0
        local itemaltpos = 0
        local preItemID = 0
        for i, csd in pairs(player:GetCostumeSpriteDescs()) do
            local conf = csd:GetItemConfig()
        
            if hasItemAlts then
                local altsData = ItemCostumeAltsRevert[conf.ID]
                
                if altsData then
                    if preItemID ~= conf.ID then
                        itemaltpos = itemaltpos + 1
                    else
                        itemaltpos = 0
                    end
                    preItemID = conf.ID

                    oic[conf.ID] = oic[conf.ID] or {}
                    local loic = oic[conf.ID]
                    if not altsData.pos or altsData.pos == itemaltpos then
                        loic[itemaltpos] = {}
                        local lloic = loic[itemaltpos]
                        local cspr = csd:GetSprite()
                        local anm2 = altsData.anm2

                        lloic.anm2 = cspr:GetFilename()
                        lloic.gfx = {}
                        for j, layer in pairs(cspr:GetAllLayers()) do
                            lloic.gfx[j] = layer:GetSpritesheetPath()
                        end

                        local anim = cspr:GetAnimation()
                        if anm2 then
                            cspr:Load(anm2, true)
                        end
                        cspr:Play(anim, true)
                        local adgfx = altsData.gfx
                        local gfxistab = type(adgfx) == "table"

                        for j, layer in pairs(cspr:GetAllLayers()) do
                            --lloic.gfx[j] = layer:GetSpritesheetPath()
                            if gfxistab then
                                cspr:ReplaceSpritesheet(j-1, adgfx[j])
                            else
                                cspr:ReplaceSpritesheet(j-1, adgfx)
                            end
                        end
                        cspr:LoadGraphics()
                        --[[if adgfx then
                            if type(adgfx) == "table" then
                                for id, gfx in pairs(adgfx) do
                                    cspr:ReplaceSpritesheet(id, gfx)
                                end
                            else
                                cspr:ReplaceSpritesheet(0, adgfx)
                            end
                        end]]
                    else
                        --itemaltpos = (itemaltpos + 1) % 2
                    end
                end
            end
        end
    end
end

function mod.HStyles.PostRoomUpdateHair(_)
    Isaac.CreateTimer(function ()
        for i = 0, game:GetNumPlayers()-1 do
            local player = Isaac.GetPlayer(i)

            local ptype = player:GetPlayerType()
            local data = player:GetData()
            local PHSdata = data._PhysHair_HairStyle
            if not PHSdata.PlayerType or PHSdata.PlayerType == ptype then
                local stdata = HairStylesData.styles[PHSdata.StyleName]
                --mod.HStyles.UpdateMainHairSprite(player, data, stdata)
               -- mod.HStyles.UpdatePlayerSkin(player, data, stdata)
            end
        end
    end, 1, 1, false)
end
--mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.HStyles.PostRoomUpdateHair)

function mod.HStyles.PostUpdateHairChecker()
    if Isaac.GetFrameCount() % 60 == 0 then
        for _ = 0, game:GetNumPlayers()-1 do
            local player = Isaac.GetPlayer(_)

            local ptype = player:GetPlayerType()
            local data = player:GetData()
            local PHSdata = data._PhysHair_HairStyle
            if PHSdata then
                if not PHSdata.PlayerType or PHSdata.PlayerType == ptype then
                    local stdata = HairStylesData.styles[PHSdata.StyleName]

                    local sheep = stdata.data.NullposRefSpr   --stdata.data.TailCostumeSheep
                    local tarcost = stdata.data.TargetCostume
                    if sheep and tarcost then
                        local pos = 0
                        for i, csd in pairs(player:GetCostumeSpriteDescs()) do
                            local conf = csd:GetItemConfig()
                            if tarcost.ID == conf.ID and (not tarcost.Type or tarcost.Type == conf.Type) then
                                if not tarcost.pos or tarcost.pos == pos then
                                    local cspr = csd:GetSprite()
                                    if cspr:GetFilename() ~= sheep:GetFilename() then
                                        mod.HStyles.UpdateMainHairSprite(player, data, stdata)
                                        return
                                    end
                                end
                            else
                                pos = pos + 1
                            end
                        end
                    end
                end
            end
        end
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.HStyles.PostUpdateHairChecker)

function mod.HStyles.BodyColorTracker(_, player, bodcol, refstring)
    local PHSdatas = player:GetData()._PhysHair_HairStyle
    for i, PHSdata in pairs(PHSdatas) do
        if type(i) == "number" then
            local stdata = HairStylesData.styles[PHSdata.StyleName]
            if stdata then
                local skinsheet = stdata.data.SkinFolderSuffics
                if skinsheet then
                    --[[local spr = player:GetSprite()
                    ---@type string
                    --local orig = spr:GetLayer(0):GetDefaultSpritesheetPath()
                    --orig = orig:match(".+/(.-)%.png")
                    local orig
                    local pconf = EntityConfig.GetPlayer(stdata.ID)
                    if pconf then
                        orig = pconf:GetSkinPath()
                    end
                    
                    if orig then
                        orig = orig:match(".+/(.-)%.png")
                        local path = skinsheet .. orig .. ( refstring or "") .. ".png"
                        for i=0, spr:GetLayerCount()-1 do
                            spr:ReplaceSpritesheet(i,path)
                        end
                        spr:LoadGraphics()
                    end]]
                    mod.HStyles.UpdatePlayerSkin(player, player:GetData(), stdata)
                end
            end
        end
    end
end
mod:AddCallback(mod.HairLib.Callbacks.PRE_COLOR_CHANGE, mod.HStyles.BodyColorTracker)


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

function mod.HStyles.GetTargetCostume(playerType, style_name)
    if style_name and HairStylesData.styles[style_name] then
        local stdata = HairStylesData.styles[style_name]
        local tarcost = stdata.data.TargetCostume
        return tarcost
    elseif playerType then
        return {ID = PlayerTypeToTargetCostume[playerType], Type = ItemType.ITEM_NULL,   --pos = PlayerTypeToTargetCostumePos[playerType] or 0}
            CostumeLayer = PlayerTypeToTargetCostumePos[playerType] or 0 }   -- 0=both, 1=head, 2=body
    end

end

---@param player EntityPlayer
function mod.HStyles.GetHairCostumeSpr(player)
    
    local data = player:GetData()._PhysHair_HairStyle
    data = data and data[0]
    local tarcost = mod.HStyles.GetTargetCostume(player:GetPlayerType(), data and data.StyleName)
    local TargetCostumeLayer = tarcost.CostumeLayer or 1
    --local pos = 0
    local costumemap = formatCostumeMap(player:GetCostumeLayerMap())

    for i, csd in pairs(player:GetCostumeSpriteDescs()) do
        local conf = csd:GetItemConfig()
        if tarcost.ID == conf.ID and (not tarcost.Type or tarcost.Type == conf.Type) then
            --if not tarcost.pos or tarcost.pos == pos then
            --    return csd:GetSprite()
            --else
            --    pos = pos + 1
            --end
            local isBodyLayer = costumemap[i-1].isBodyLayer
            if TargetCostumeLayer == 0 
            or TargetCostumeLayer == 1 and not isBodyLayer
            or TargetCostumeLayer == 2 and isBodyLayer then
                return csd:GetSprite()
            end
        end
    end

    -- пиздец случился 

    for i, csd in pairs(player:GetCostumeSpriteDescs()) do
        local conf = csd:GetItemConfig()
        if conf.Type == ItemType.ITEM_NULL 
        and conf.Costume.Priority >= 99
        and csd:GetSprite():GetLayer("head0") then
            return csd:GetSprite()
        end
    end
end

--[[
function mod.HStyles.RemoveAndAddNullCostume(_, player, hairData)
    
end
mod:AddCallback(mod.HairLib.Callbacks.HAIR_PRE_INIT, mod.HStyles.RemoveAndAddNullCostume)
]]



function mod.HStyles.SetFavoriteStyle(Ptype, style_name, hairLayer, styleMode)
    if Ptype and style_name then
        local stdata = HairStylesData.styles[style_name]
        if stdata then
            if stdata.ID == Ptype then
                HairStylesData.favorites[Ptype] = HairStylesData.favorites[Ptype] or {}
                HairStylesData.favorites[Ptype][hairLayer] = {style=style_name, mode=styleMode}
            end
        end
    end
end

function mod.HStyles.GetFavoriteStyle(Ptype)
    return HairStylesData.favorites[Ptype]
end

function mod.HStyles.RemoveFavoriteStyle(Ptype, hairLayer)
    if Ptype and HairStylesData.favorites[Ptype] then
        HairStylesData.favorites[Ptype][hairLayer] = nil
    end
end












----храня

mod.HStyles.HairKeeper = {ID = Isaac.GetEntityTypeByName("Парихранитель"), VAR = Isaac.GetEntityVariantByName("Парихранитель")}

mod.HStyles.salon = {
    CameraFocusPos = Vector(0,0),
    EnterIndex = 131,
    EnterIndexLongRoom = 236,
    TopLeftRefIndex = 128,
    TopLeftRefIndexLongRoom = 233,
    BGEntVar = Isaac.GetEntityVariantByName("Фон парихмазерской"),
    Alpha = 0,
    JustMask = GenSprite("gfx/editor/hairstyle_menu.anm2","justmask3")
}
local salon = mod.HStyles.salon

--salon.JustMask.FlipX = true
salon.JustMask.Scale = Vector(4,4)
salon.JustMask:SetCustomShader("shaders/PhysHairCuttingShadder")

---@param ent EntitySlot
function mod.HStyles.HairKeeper.update(_, ent)
    local data = ent:GetData()
    local spr = ent:GetSprite()
    if ent.FrameCount < 2 then
        ent.TargetPosition = ent.Position
    end

    if salon.Alpha then
        local col = ent:GetColor()
        col.A = salon.Alpha
        ent.Color = col

        if salon.Alpha < .8 then
            ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        else
            ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
    end

    if salon.FakeCollision and salon.Entered then
        local nearP = game:GetNearestPlayer(ent.Position)
        if nearP.Position:Distance(ent.Position) < nearP.Size+ent.Size then
            if nearP.EntityCollisionClass == EntityCollisionClass.ENTCOLL_ALL then
                --ent:ForceCollide(nearP, true)
                mod.HStyles.HairKeeper.coll(nil, ent, nearP)
            end
        end
    end

    local sprIsFinished = spr:IsFinished()
    local isAnim = spr:GetAnimation()

    if sprIsFinished then
        if isAnim == "Appear" then
            spr:Play("idle", true)
        elseif isAnim == "scisor_start" then
            spr:Play("scisor_loop", true)
        elseif isAnim == "scisor_end" then
            spr:Play("idle", true)
            data.ShowCantHeadless = nil
            data.faceAngle = nil
        elseif isAnim == "scisor2_start" then
            spr:Play("scisor2_loop", true)
            data.scisor2_delay = 5
        elseif isAnim == "scisor2_end" then
            spr:Play("scisor_loop", true)
        elseif isAnim == "scisor2_чик" then
            spr:Play("scisor2_loop", true)
            --sfx:Play(mod.HStyles.Sfx.chair_creaks, Options.SFXVolume * 3.3, 0, false, 2.1)
        elseif isAnim == "cant_nohead" then
            data.ShowCantHeadless = nil
            spr:Play("idle", true)
        end
    else
        if salon.Entered then
            if isAnim == "Appear" then
                if spr:IsEventTriggered("sound") and spr:GetFrame() < 10 then
                    sfx:Play(mod.HStyles.Sfx.Chr_appear, Options.SFXVolume * 2.4, 5, false, 1.0)
                end
            elseif isAnim == "idle" then
                if spr:IsEventTriggered("sound") and ent:GetDropRNG():RandomFloat() < 0.3 then
                    sfx:Play(mod.HStyles.Sfx.chair_creaks, Options.SFXVolume , 0, false, 2.2)
                end
            elseif isAnim == "scisor2_start" then
                if spr:GetFrame() == 2 then
                    sfx:Play(SoundEffect.SOUND_COIN_SLOT, Options.SFXVolume * 0.15, 5, false, 2.5)
                end
            elseif isAnim == "scisor_start" then
                if spr:IsEventTriggered("sound") then
                    sfx:Play(SoundEffect.SOUND_ANGEL_WING, Options.SFXVolume * 0.3, 0, false, 0.8) 
                    --sfx:Play(SoundEffect.SOUND_BIRD_FLAP, Options.SFXVolume * 0.4, 0, false, 1.2)
                elseif spr:IsEventTriggered("sound2") then
                    sfx:Play(SoundEffect.SOUND_FETUS_JUMP, Options.SFXVolume * 0.5, 5, false, 1.1)
                end
            elseif isAnim == "scisor_end" then
                if spr:IsEventTriggered("sound") then
                    sfx:Play(SoundEffect.SOUND_FETUS_JUMP, Options.SFXVolume * 0.2, 0, false, 0.5)
                end
            elseif isAnim == "scisor2_чик" then
                if spr:GetFrame() == 7  then --or spr:GetFrame() == 19
                    sfx:Play(mod.HStyles.Sfx.chair_creaks, Options.SFXVolume * 3.3, 0, false, 2.1)
                end
            end
        end
    end

    local overName = spr:GetOverlayAnimation()
    if not spr:IsPlaying("scisor_loop") 
    and (overName == "scisor_прямо" or overName == "scisor_вниз") then
        spr:RemoveOverlay()
    end

    if ent.Target then
        if not salon.Chranya or not salon.Chranya.Ref then
            salon.Chranya = EntityPtr(ent)
        end

        

        data.room = data.room or game:GetRoom()
        local SelBtn = mod.WGA and mod.WGA.ManualSelectedButton

        if spr:IsPlaying("scisor_loop") then
            local prefaceAngle = data.faceAngle
            data.faceAngle = ent.Target:GetSprite().Scale.Y > 1.4 and 1 or 0
            if data.faceAngle ~= prefaceAngle then
                spr:PlayOverlay(data.faceAngle == 1 and "scisor_прямо" or "scisor_вниз")
            end
            spr:SetOverlayFrame(spr:GetFrame())
            --data.faceAngle = ent.Target:GetSprite().Scale.Y > 1.2 and 1 or 0

            if SelBtn then
                ---@type EditorButton
                local btn = SelBtn[1]
                if btn and btn.IsHairStyleMenu and btn.IsSelected then
                    spr:Play("scisor2_start")
                    data.faceAngle = nil
                    spr:RemoveOverlay()
                    sfx:Play(mod.HStyles.Sfx.swing, Options.SFXVolume * 0.8, 5, false, 1.3)
                    sfx:Play(mod.HStyles.Sfx.chair_creaks, Options.SFXVolume * 3, 0, false, 2.1)
                    --sfx:Play(SoundEffect.SOUND_COIN_SLOT, Options.SFXVolume * 0.3, 5, false, 2.5)
                end
            end
        elseif spr:IsPlaying("scisor2_loop") or spr:IsPlaying("scisor2_start") then
            if not SelBtn or not SelBtn[1] or not SelBtn[1].IsHairStyleMenu or not SelBtn[1].IsSelected then
                if data.scisor2_delay then
                    data.scisor2_delay = data.scisor2_delay - 1
                    if data.scisor2_delay <= 0 then
                        data.scisor2_delay = nil
                        spr:Play("scisor2_end", true)
                    end
                else
                    if spr:IsPlaying("scisor2_start") then
                        local lastframe = spr:GetAnimationData("scisor2_end"):GetLength()
                        local setfraem = lastframe - spr:GetFrame() - 3
                        spr:Play("scisor2_end", true)
                        spr:SetFrame(setfraem)
                    else
                        spr:Play("scisor2_end", true)
                    end
                end
            elseif spr:IsPlaying("scisor2_loop") then
                data.scisor2_delay = 5
            end
        end

        if not data.removedwall then
            data.removedwall = true
            --data.level = data.level or game:GetLevel()
            --local crds = data.level:GetCurrentRoomDesc()
            --if crds.Flags & RoomDescriptor.FLAG_NO_WALLS == 0 then
            --    crds.Flags = crds.Flags | RoomDescriptor.FLAG_NO_WALLS
            --    data.removeFLAG_NO_WALLS = true
            --end
        end
        
        --local camera = data.room:GetCamera()
        --camera:SetFocusPosition(ent.Target.Position + Vector(Isaac.GetScreenWidth()/4 * Wtr,0))
        if not mod.StyleMenu.wind then
            ent.Target = nil
            data.removedwall = nil
            --if data.removeFLAG_NO_WALLS then
            --    local crds = data.level:GetCurrentRoomDesc()
            --    crds.Flags = crds.Flags - RoomDescriptor.FLAG_NO_WALLS
            --end
        end
        
        if data.SillyBounce then
            local t = math.sin(data.SillyBounce) * math.min(1, data.SillyBounce / 80)
            spr:GetLayer(1):SetSize( Vector.One + Vector(t < -0.6 and (-0.6+t*0.1) or (t), -t ) )

            data.SillyBounce = data.SillyBounce - 1
            if data.SillyBounce <= 0 then
                data.SillyBounce = nil
                --spr.Scale = Vector.One
                spr:GetLayer(1):SetSize(Vector.One)
            end
        end
    else
        if data.HintAnimCooldown then
            data.HintAnimCooldown = data.HintAnimCooldown - 1
            if data.HintAnimCooldown <= 0 then
                data.HintAnimCooldown = nil
                data.ShowCantHeadless = nil
            end
        end
        if isAnim == "idle" then
            if not data.HintAnimCooldown and data.ShowCantHeadless then
                local sprFrame = spr:GetFrame()
                if sprFrame < 5 or sprFrame > 22 and sprFrame < 28 then
                    data.ShowCantHeadless = nil
                    data.HintAnimCooldown = 90
                    spr:Play("cant_nohead", true)
                end
            end

        end
    end

    ent.Velocity = (ent.TargetPosition - ent.Position) / 5
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.HStyles.HairKeeper.update, mod.HStyles.HairKeeper.VAR)

function mod.HStyles.HairKeeper.render(_, ent)
    local data = ent:GetData()
    local spr = ent:GetSprite()

    if ent.Target then
        if mod.WGA.IsMouseBtnTriggered(0) 
        and Input.GetMousePosition(true):Distance(ent.Position + Vector(0,-40)) < 50 then
            data.SillyBounce = not data.SillyBounce and (10) or data.SillyBounce + 10
            sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 0.5, nil, nil, 1 + data.SillyBounce * 0.01)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_RENDER, mod.HStyles.HairKeeper.render, mod.HStyles.HairKeeper.VAR)


---@param ent EntitySlot
function mod.HStyles.HairKeeper.preupdate(_, ent)
    --mod.HStyles.HairKeeper.update(_, ent)
    ent:SetState(0)
    ent.GridCollisionClass = 0
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.HStyles.HairKeeper.preupdate, mod.HStyles.HairKeeper.VAR)

---@param ent EntitySlot
function mod.HStyles.HairKeeper.coll(_, ent, col)
    if not ent.Target and col.Type == EntityType.ENTITY_PLAYER then
        local player = col:ToPlayer()
        if player:IsHeadless() then
            local sklad = player:GetData().__PhysHair_HairSklad
            local HeadPos = sklad and sklad.RealHeadPos
            if HeadPos and sklad.FrameCheck == Isaac.GetFrameCount() then
                local screenCenter = Vector(Isaac.GetScreenWidth()/2, Isaac.GetScreenHeight()/2)
                local roomEdge = Isaac.WorldToScreen(salon.TopLeftPos)
                local centerToEgde = screenCenter - roomEdge
                local headDiff = screenCenter - HeadPos
                if math.abs(headDiff.X) < centerToEgde.X and math.abs(headDiff.Y) < centerToEgde.Y then
                    local ptype = player:GetPlayerType()
                    local bhpd = BethHair.HairStylesData.playerdata
                    if bhpd[ptype] then
                        ent.Target = player
                        BethHair.StyleMenu.TargetPlayer = EntityPtr(player)
                        BethHair.StyleMenu.TargetHairKeeper = EntityPtr(ent)
                        BethHair.StyleMenu.ShowWindow()

                        ent:GetSprite():Play("scisor_start", true)
                    end
                else
                    ent:GetData().ShowCantHeadless = true
                end
            else
                ent:GetData().ShowCantHeadless = true
            end
        else
            local ptype = player:GetPlayerType()
            local bhpd = BethHair.HairStylesData.playerdata
            if bhpd[ptype] then
                ent.Target = player
                BethHair.StyleMenu.TargetPlayer = EntityPtr(player)
                BethHair.StyleMenu.TargetHairKeeper = EntityPtr(ent)
                BethHair.StyleMenu.ShowWindow()

                ent:GetSprite():Play("scisor_start", true)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.HStyles.HairKeeper.coll, mod.HStyles.HairKeeper.VAR)





function mod.HStyles.salon.NewRoom()
    salon.IsRoom = false
    local level = game:GetLevel()
    
    if level and level:GetStartingRoomIndex() == level:GetCurrentRoomIndex() then
        local room = game:GetRoom()

        local useIndex = salon.EnterIndex
        local TopLeftRefIndex = salon.TopLeftRefIndex
        local roomshape = room:GetRoomShape()
        salon.FakeCollision = nil
        if roomshape == RoomShape.ROOMSHAPE_1x1 then
            --useIndex = salon.EnterIndex
        elseif roomshape == RoomShape.ROOMSHAPE_1x2 then
            useIndex = salon.EnterIndexLongRoom
            TopLeftRefIndex = salon.TopLeftRefIndexLongRoom
            salon.FakeCollision = true
        else
            --Console.PrintWarning("[HairPhys] inappropriate shape of the room for Salon")
            return
        end

        salon.IsRoom = true
        
        salon.HasWater = room:HasWater()
        if salon.HasWater then
            salon.bg = GenSprite("gfx/backdrop/hairsalon_backdrop.anm2", "flooded")
            salon.bgFloor = GenSprite("gfx/backdrop/hairsalon_backdrop.anm2", "flooded")
            salon.bgFloor:SetCustomShader("shaders/water_v2_hairsalon")
            --salon.bg:GetLayer(1):SetCustomShader("shaders/water_v2_hairsalon")
            salon.bgFloor.Color:SetOffset(.2,0,0)
            salon.bgFloor.Color:SetColorize(0.3,0.3,0.8,.1)
            salon.HasWater = true
        else
            salon.bg = GenSprite("gfx/backdrop/hairsalon_backdrop.anm2", "New Animation")
            salon.bgFloor = nil
        end

        
        salon.EnterPos = room:GetGridPosition(useIndex)
        salon.TopLeftPos = room:GetGridPosition(TopLeftRefIndex) + Vector(-20, 20 + 60)

        local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BACKDROP_DECORATION,0, 
        salon.EnterPos - Vector(0,20), Vector(0,0), nil)
        local spr = ef:GetSprite()
        spr:Load("gfx/backdrop/hairsalon_backdrop.anm2", true) 
        spr:Play("door", true)
        spr.FlipY = true
        --ef:AddEntityFlags(EntityFlag.FLAG_RENDER_WALL)
        ef.SortingLayer = SortingLayer.SORTING_DOOR
        ef:Update()

        local grid = room:GetGridEntityFromPos(salon.EnterPos)
        --if not grid then
        --    grid = room:GetGridEntityFromPos(salon.EnterPos)
        --end
        grid.CollisionClass = GridCollisionClass.COLLISION_NONE

        salon.CameraFocusPos = room:GetCenterPos()

        for i, keep in pairs(Isaac.FindByType(mod.HStyles.HairKeeper.ID, mod.HStyles.HairKeeper.VAR)) do
            if i==1 then
                salon.Chranya = EntityPtr(keep)
            else
                keep:Remove()
            end
        end

        if not salon.Chranya or not salon.Chranya.Ref then
            local keep = Isaac.Spawn(mod.HStyles.HairKeeper.ID, mod.HStyles.HairKeeper.VAR, 0,
                salon.TopLeftPos + Vector(40*7, 40*4-0), Vector(0,0), nil )

            salon.Chranya = EntityPtr(keep)

            --keep:GetSprite():Play("sleep", true)
        end
        salon.Chranya.Ref:GetSprite():Play("sleep", true)

        --[[if room:HasWater() then
            salon.bg:SetCustomShader("shaders/water_v2_hairsalon")
            salon.bg.Color:SetColorize(1,1,1,.1)
        end]]
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.HStyles.salon.NewRoom)
if Isaac.GetPlayer() then
    mod.HStyles.salon.NewRoom()
    if BethHair.InstaTeleportInSalon then
        Isaac.CreateTimer(function ()
            mod.HStyles.salon.EnterSalon()
        end, 1, 1, false)
        BethHair.InstaTeleportInSalon = nil
    end
end



---@param player EntityPlayer
function mod.HStyles.salon.playerUpdate(_, player)
    if salon.IsRoom then
        local nextpos = player.Position + Vector(0,-20) --+ player.Velocity:Resized(6)

        if salon.EnterPos and player.Velocity:Length()>0.1 then
            if nextpos:Distance(salon.EnterPos) < 20 then
                mod.HStyles.salon.EnterSalon()
            end
        end
        if salon.Entered then
            salon.CheckColl(player)
            local corpos = player.Position - salon.TopLeftPos
            --local index = corpos.X // 40 + corpos.Y // 40 * 11
            if corpos.Y < 60 and not mod.StyleMenu.TargetPlayer then
                mod.HStyles.salon.ExitSalon()
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.HStyles.salon.playerUpdate)


function mod.HStyles.salon.EnterSalon()
    if Isaac.GetPlayer() then
        local room = game:GetRoom()
        local level = game:GetLevel()
        salon.ReturnSettings = {
            CameraStyle = Options.CameraStyle,
            --NoWall = level:GetCurrentRoomDesc().Flags & RoomDescriptor.FLAG_NO_WALLS,
            MusicVolume = Options.MusicVolume,
            WasClampEnabled = room:GetCamera():IsClampEnabled()
        }
        room:GetCamera():SetClampEnabled(false)
        Options.CameraStyle = CameraStyle.ACTIVE_CAM_OFF
        MusicManager():VolumeSlide(0.5 , 0.08)
        
        --local crds = level:GetCurrentRoomDesc()
        --crds.Flags = crds.Flags | RoomDescriptor.FLAG_NO_WALLS

        salon.Entered = true
        for i = 0, game:GetNumPlayers()-1 do
            local player = Isaac.GetPlayer(i)

            player.GridCollisionClass = 0
            player.Position = salon.TopLeftPos + Vector(40 * 3 + 20 , 40 * 2 - 10 )
            player.ControlsCooldown = math.max(16, player.ControlsCooldown)

            local ptype = player:GetPlayerType()
            if ptype == PlayerType.PLAYER_THESOUL then
                local hash = GetPtrHash(player)
                for j, body in pairs(Isaac.FindByType(3, FamiliarVariant.FORGOTTEN_BODY)) do
                    if GetPtrHash(body:ToFamiliar().Player) == hash then
                        body.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                        body.TargetPosition = player.Position/1
                        break
                    end
                end
            end
        end

        salon.Alpha = 0

        if not salon.BGentPtr or not salon.BGentPtr.Ref then
            local bg = Isaac.Spawn(1000,salon.BGEntVar,0, Vector(0,-100), Vector(0,0), nil)
            bg.SortingLayer = SortingLayer.SORTING_DOOR
            bg.Color = Color(1,1,1,0)

            salon.BGentPtr = EntityPtr(bg)

            if room:HasWater() then
                bg.SortingLayer = SortingLayer.SORTING_NORMAL
            end
        end

        if salon.Chranya and salon.Chranya.Ref then
            Isaac.CreateTimer(function ()
                if salon.Chranya.Ref then
                    local spr = salon.Chranya.Ref:GetSprite()
                    if spr:GetAnimation() == "sleep" then
                        spr:Play("Appear")
                    end
                end
            end, 13, 1)
        end
        
        sfx:Play(mod.HStyles.Sfx.doorbell, Options.SFXVolume * 1.0, 5, false, 1.3)
    end
end

function mod.HStyles.salon.ExitSalon()
    if Isaac.GetPlayer() then
        for i = 0, game:GetNumPlayers()-1 do
            local player = Isaac.GetPlayer(i)

            if player.Position.Y > salon.TopLeftPos.Y and player.Position.X > salon.TopLeftPos.X then
                player.Position = salon.EnterPos + Vector(0 , -10)
                player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
                --player:SetColor(Color(.0,.0,.0,.5), 10, 100, true, true)
                player.ControlsCooldown = math.max(16, player.ControlsCooldown)
            end
            local ptype = player:GetPlayerType()
            if ptype == PlayerType.PLAYER_THESOUL then
                local hash = GetPtrHash(player)
                for j, body in pairs(Isaac.FindByType(3, FamiliarVariant.FORGOTTEN_BODY)) do
                    if GetPtrHash(body:ToFamiliar().Player) == hash then
                        body.TargetPosition = player.Position
                        break
                    end
                end
            end
        end
        --salon.Alpha = 0
        --Options.CameraStyle = salon.ReturnSettings.CameraStyle

        local returnCameraStyle = salon.ReturnSettings.CameraStyle
        Isaac.CreateTimer(function ()
            Options.CameraStyle = returnCameraStyle
        end, 15, 1, true)

        --if salon.ReturnSettings.NoWall then
        --    local crds = game:GetLevel():GetCurrentRoomDesc()
        --    crds.Flags = crds.Flags - RoomDescriptor.FLAG_NO_WALLS
        --end
        if salon.ReturnSettings.WasClampEnabled then
            local room = game:GetRoom()
            room:GetCamera():SetClampEnabled(true)
        end

        MusicManager():VolumeSlide(1, 0.08)
        MusicManager():UpdateVolume()

        salon.Entered = false

        salon.ReturnSettings = {}

        sfx:Play(mod.HStyles.Sfx.doorbell, Options.SFXVolume * 1.0, 5, false, 1.28)
    end
end

do
    local framecheck
    function mod.HStyles.salon.RenderRoom(_, ent)
        if game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then return end
        local frmae = Isaac.GetFrameCount()
        if framecheck == frmae then return end
        framecheck = frmae

        local paused = game:IsPaused()
        if salon.IsRoom then
            if salon.Entered then
                local room = game:GetRoom()
                salon.bg.Color.A = salon.Alpha
                if not paused then
                    salon.Alpha = salon.Alpha * 0.9 + 0.1
                    local tar
                    if mod.StyleMenu.TargetPlayer and mod.StyleMenu.TargetPlayer.Ref then
                        --tar = mod.StyleMenu.TargetPlayer.Position + Vector(Isaac.GetScreenWidth()/4 * Wtr,0)
                    else
                        tar = salon.TopLeftPos+Vector(40*6+0,40*4+0)
                        salon.CameraFocusPos = salon.CameraFocusPos * 0.9 + (tar) * 0.1
                        room:GetCamera():SetFocusPosition(salon.CameraFocusPos)
                        --room:GetCamera():SnapToPosition(salon.CameraFocusPos)
                    end
                    --salon.CameraFocusPos = salon.CameraFocusPos * 0.8 + (tar) * 0.2
                    --room:GetCamera():SetFocusPosition(salon.CameraFocusPos)
                end

                if salon.HasWater then
                    --[[local col = salon.bg:GetLayer("b1"):GetColor()
                    col:SetColorize(0,0,0, game:GetFrameCount() % 10000)
                    salon.bg:GetLayer("b1"):SetColor( col )
                    salon.bg:GetLayer("b2"):SetColor( col )]]
                    local watercolor = room:GetFXParams().WaterColorMultiplier
                    salon.bgFloor.Color:SetColorize(watercolor.Red*0.8,watercolor.Green*0.8,watercolor.Blue*0.8, game:GetFrameCount() * 1.5 % 10000)
                    
                    local renderpos = Isaac.WorldToScreen(salon.TopLeftPos)
                    --salon.bg:RenderLayer(2, renderpos)
                    salon.bgFloor:RenderLayer(1,renderpos)
                    --salon.bg.Color:SetColorize(0,0,0, 0)
                    salon.bg:RenderLayer(2, renderpos)

                    --salon.bg:Render( Isaac.WorldToScreen(salon.TopLeftPos) )
                else
                    salon.bg:Render( Isaac.WorldToScreen(salon.TopLeftPos) )
                end
                

                --local corpos = Isaac.GetPlayer().Position - salon.TopLeftPos
                --local index = corpos.X // 40 + corpos.Y // 40 * 11
                --Isaac.RenderText(tostring(index),50,50,1,1,1,1)
            else
                if not paused then
                    salon.Alpha = salon.Alpha * 0.90
                    if salon.Alpha > 0.05 then
                        local room = game:GetRoom()
                        salon.CameraFocusPos = salon.CameraFocusPos * 0.95 + room:GetCenterPos() * 0.05
                        room:GetCamera():SetFocusPosition(salon.CameraFocusPos)
                    end
                end
                salon.bg.Color.A = salon.Alpha
                salon.bg:Render( Isaac.WorldToScreen(salon.TopLeftPos) )
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.HStyles.salon.RenderRoom, mod.HStyles.salon.BGEntVar)

    local ScreenToWorld = function(x)
        return (-Isaac.WorldToScreen(Vector.Zero) + x)/(1/Wtr)
    end

    function mod.HStyles.salon.ChangeHairStyle(player, stylename, StyleMode, hairlayer)
        salon.DoChoopEffect = true
        --mod.StyleMenu.TargetHairKeeper
        local data = player:GetData()
        salon.CachedPlayerHairData = data.__PhysHair_HairSklad    --data._BethsHairCord
        local sklad = data.__PhysHair_HairSklad

        --[[
        local stdata = HairStylesData.styles[data._PhysHair_HairStyle.StyleName]

        local tarcost = stdata.data.TargetCostume

        if tarcost then
            local pos = 0
            for i, csd in pairs(player:GetCostumeSpriteDescs()) do
                local conf = csd:GetItemConfig()
                if tarcost.ID == conf.ID and (not tarcost.Type or tarcost.Type == conf.Type) then
                    if not tarcost.pos or tarcost.pos == pos then
                        ---@type Sprite
                        local cspr = csd:GetSprite()
                        salon.CachedPhayerHairSpr = GenSprite(cspr:GetFilename(), cspr:GetAnimation())
                        local CachedSpr = salon.CachedPhayerHairSpr
                        for j, layer in pairs(cspr:GetAllLayers()) do
                            CachedSpr:ReplaceSpritesheet(j, layer:GetSpritesheetPath())
                        end
                        CachedSpr:LoadGraphics()
                        CachedSpr.Color = cspr.Color
                    end
                end
            end
        end
        ]]

        local PHSdata = data._PhysHair_HairStyle
        PHSdata = PHSdata and PHSdata[hairlayer or 0]

        if not PHSdata or not PHSdata.StyleName 
        or not HairStylesData.styles[PHSdata.StyleName] then
            salon.CachedPhayerHairSpr = mod.HStyles.GetHairCostumeSpr(player)
        else
            local stdata = HairStylesData.styles[PHSdata.StyleName]

            local cspr = mod.HStyles.GetHairCostumeSpr(player)
            salon.CachedPhayerHairSpr = GenSprite(cspr:GetFilename(), cspr:GetAnimation())
            local CachedSpr = salon.CachedPhayerHairSpr
            for j, layer in pairs(cspr:GetAllLayers()) do
                CachedSpr:ReplaceSpritesheet(j, layer:GetSpritesheetPath())
            end
            CachedSpr:LoadGraphics()
            CachedSpr.Color = cspr.Color
            CachedSpr.Scale = cspr.Scale

            local sheep = stdata.data.NullposRefSpr

            local finalPath = sklad[hairlayer].HairInfo.FinalCostumePath    --data._BethsHairCord.FinalCostumePath
            if not finalPath then
                
            end
            --do
            --    return
            --end

            if sheep and finalPath then
                --local cspr2 = salon.CachedPhayerHairSpr
                local anim = cspr:GetAnimation()
                CachedSpr:Load(sheep:GetFilename(), true)
                CachedSpr:Play(anim, true)
                for i=0, CachedSpr:GetLayerCount()-1 do
                    local shpa = sheep:GetLayer(i)
                    local str = finalPath[i]
                    if shpa and str then
                        CachedSpr:ReplaceSpritesheet(i, finalPath[i])
                    end
                end
                CachedSpr:LoadGraphics()
            elseif finalPath then
                --local cspr2 = salon.CachedPhayerHairSpr
                for i=0, CachedSpr:GetLayerCount()-1 do
                    --local shpa = cspr:GetLayer(i)
                    --if shpa then
                    local str = finalPath[i]
                    if str then
                         CachedSpr:ReplaceSpritesheet(i, finalPath[i])
                    end
                    --end
                end
                CachedSpr:LoadGraphics()
            end
        end


        if salon.Chranya and salon.Chranya.Ref then
            salon.Chranya.Ref:GetSprite():Play("scisor2_чик", true)
            sfx:Play(mod.HStyles.Sfx.scisors_swing, Options.SFXVolume * 2, 0, false, 1.0)
        end

        if salon.CachedPhayerHairSpr then

            if salon.CachedPhayerHairSpr:GetAnimation() == "" then
                salon.CachedPhayerHairSpr:Play("HeadDown", true)
            end
            
            --local renderPos = salon.CachedPlayerHairData and salon.CachedPlayerHairData.RealHeadPos 
            --    or (Isaac.WorldToScreen(player.Position) + player:GetFlyingOffset())
            local renderPos = salon.CachedPlayerHairData and salon.CachedPlayerHairData.RealHeadPos and (ScreenToWorld(salon.CachedPlayerHairData.RealHeadPos))
                or (player.Position + player:GetFlyingOffset()/(1/Wtr))
            
            local rng = RNG(Isaac.GetFrameCount(), 35)
            local prelist = mod.HStyles.Chooping and mod.HStyles.Chooping.list or {}
            mod.HStyles.Chooping = {rng = rng, list = prelist, extralist = {}, RenderPos = renderPos, FloorYpos = Isaac.WorldToScreen(player.Position).Y,
                RefSpr = salon.CachedPhayerHairSpr,
                HPS = GenSprite("gfx/editor/parechmacher.anm2", "hair_piece"),
                CHIK = GenSprite("gfx/editor/parechmacher.anm2", "чик"),
                SWIG = GenSprite("gfx/editor/parechmacher.anm2", "свиг")
            }
            mod.HStyles.Chooping.SWIG.Scale = Vector(1.5, 1.5)

        else
            salon.DoChoopEffect = false
        end
        
        mod.HStyles.SetStyleToPlayer(player, stylename, hairlayer, StyleMode)
    end


    ---@param rng RNG
    local trowHairpiecy = function(rng, pos, col)
        local vec = rng:RandomVector()
        vec.X = vec.X * 1.2
        vec.Y = (vec.Y - .5) * 1.4
        --[[local spr = GenSprite("gfx/editor/parechmacher.anm2", "hair_piece")
        spr:SetFrame(rng:RandomInt(4))
        spr.Color = col
        spr.Rotation = rng:RandomInt(360)]]
        local spr = {Color = col, Rotation = rng:RandomInt(360), Frame = rng:RandomInt(4), Scale = Vector(1,1)}

        return {pos, vec, spr, 40, (rng:RandomFloat()-.5)*45}
    end

    local mrandom = function (rng, a, b)
        return a + rng:RandomInt(b-a)
    end

    local hasChik = false
    local chikx = 0
    local hasSwig = false
    local swigx = 0

    function mod.HStyles.salon.RenderHairChoop(_, player, renderPos)
        if game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
            return
        end

        local isSamePlayer = mod.StyleMenu.TargetPlayer and mod.StyleMenu.TargetPlayer.Ref
            and GetPtrHash(mod.StyleMenu.TargetPlayer.Ref) == GetPtrHash(player)

        if salon.DoChoopEffect and isSamePlayer then

            --[[
            --BethHair.DoChoopEffect = false
            local data = player:GetData()
            local stdata = HairStylesData.styles[data._PhysHair_HairStyle.StyleName]

            local tarcost = stdata.data.TargetCostume

            if tarcost then
                local pos = 0
                for i, csd in pairs(player:GetCostumeSpriteDescs()) do
                    local conf = csd:GetItemConfig()
                    if tarcost.ID == conf.ID and (not tarcost.Type or tarcost.Type == conf.Type) then
                        if not tarcost.pos or tarcost.pos == pos then
                            ---@type Sprite
                            local cspr = csd:GetSprite()

                            local renderPos = data._BethsHairCord.RealHeadPos
                            cspr:Render(renderPos)

                            local rng = RNG(Isaac.GetFrameCount(), 35)
                            mod.HStyles.Chooping = {rng = rng, list = {}, RenderPos = renderPos, FloorYpos = Isaac.WorldToScreen(player.Position).Y}
                            local Chooping = mod.HStyles.Chooping

                            --for i = 1, 20 do
                            for x = 1, 15 do
                                for y = 1, 15 do
                                    local layerID = rng:RandomInt(cspr:GetLayerCount())
                                    local layer = cspr:GetCurrentAnimationData():GetLayer(layerID):GetFrame(cspr:GetFrame()) 

                                    if layer then
                                        local pos = Vector(
                                            --mrandom(rng, layer:GetPos().X - layer:GetPivot().X, layer:GetPos().X - layer:GetPivot().X +layer:GetWidth()), 
                                            --mrandom(rng, layer:GetPos().Y - layer:GetPivot().Y, layer:GetPos().Y - layer:GetPivot().Y +layer:GetHeight())
                                            layer:GetPos().X - layer:GetPivot().X + x/15 * layer:GetWidth() + mrandom(rng, -1,1),
                                            layer:GetPos().Y - layer:GetPivot().Y + y/15 * layer:GetHeight() + mrandom(rng, -1,1)
                                        )

                                         ---@type KColor
                                        local tex = cspr:GetTexel(pos, Vector.Zero, 0.5, layerID)
                                        local r,g,b = tex.Red, tex.Green, tex.Blue
                                        if tex and tex.Alpha > 0 and r+g+b > 0.1 then

                                            local midR, midG, midB = 1,1,1
                                            local isHasColor = false
                                            for xi = -2, 2 do
                                                for yi = -2, 2 do
                                                    ---@type KColor
                                                    local tex = cspr:GetTexel(pos+Vector(xi,yi), Vector.Zero, 0.5, layerID)
                                                    if tex and tex.Alpha > 0 then
                                                        local r,g,b = tex.Red, tex.Green, tex.Blue
                                                        if r+g+b > 0.1 then
                                                            midR = (midR + r) / 2
                                                            midG = (midG + g) / 2
                                                            midB = (midB + b) / 2
                                                        end
                                                    end
                                                    isHasColor = true
                                                end
                                            end
                                            if isHasColor then
                                                ----@type KColor
                                                --local tex = cspr:GetTexel(pos, Vector.Zero, 0.5, layerID)
                                                --if tex and tex.Alpha > 0 then
                                                    local refColor = Color(1,1,1,1,0,0,0, midR, midG, midB, 1)
                                                -- refColor:SetColorize()
                                                    Chooping.list[#Chooping.list+1] = trowHairpiecy(rng, pos, refColor)
                                                --end
                                            end
                                        end
                                    end
                                    --if #Chooping.list > 10 then
                                    --    break
                                    --end
                                end
                            end
                            salon.DoChoopEffect = nil

                        elseif tarcost.pos > pos then
                            pos = pos + 1
                        end
                    end
                end
            end]]

            local Chooping = mod.HStyles.Chooping
            local rng = Chooping.rng
            local cspr = Chooping.RefSpr
            local procent = (salon.Chranya.Ref:GetSprite():GetFrame()-1) / 10

            local visibleLayerNum = 0
            local layer 
            for i = 0, cspr:GetLayerCount()-1 do
                local justlayer = cspr:GetCurrentAnimationData():GetLayer(i)
                local frame = justlayer and justlayer:GetFrame(cspr:GetFrame())
                if not layer then
                    layer = frame
                    --if layer then
                    --    break
                    --end
                end
                if frame and frame:IsVisible() then
                    visibleLayerNum = visibleLayerNum + 1
                end
            end
            
            local RenderPos = Isaac.WorldToScreen(Chooping.RenderPos)

            
            salon.JustMask.Color:SetColorize(visibleLayerNum,0,0,0)
            salon.JustMask:Render(RenderPos + Vector(layer:GetPos().X - layer:GetPivot().X + procent * layer:GetWidth(),0))

            cspr:Render(RenderPos)   --, Vector((layer and layer:GetWidth() or 0) * procent, 0))

            if procent > 1 then
                salon.DoChoopEffect = nil
                sfx:Play(mod.HStyles.Sfx.swing, 1, 0, false, 1.5)
            elseif procent > 0 and not game:IsPaused() and Isaac.GetFrameCount()%2 == 0 then

                
                for x = 1 + math.floor(procent*14), 15 - math.floor((1-procent)*14) do
                    for y = 1, 15 do
                        if rng:RandomInt(3) > 0 then
                            local layerID = rng:RandomInt(cspr:GetLayerCount())
                            
                            local animdata = cspr:GetCurrentAnimationData()
                            local layer = (animdata:GetLayer(layerID) or animdata:GetLayer(0) or animdata:GetLayer(1)):GetFrame(cspr:GetFrame()) 

                            if layer then
                                local pos = Vector(
                                    --mrandom(rng, layer:GetPos().X - layer:GetPivot().X, layer:GetPos().X - layer:GetPivot().X +layer:GetWidth()), 
                                    --mrandom(rng, layer:GetPos().Y - layer:GetPivot().Y, layer:GetPos().Y - layer:GetPivot().Y +layer:GetHeight())
                                    layer:GetPos().X - layer:GetPivot().X + x/15 * layer:GetWidth() + mrandom(rng, -1,1),
                                    layer:GetPos().Y - layer:GetPivot().Y + y/15 * layer:GetHeight() + mrandom(rng, -1,1)
                                )

                                ---@type KColor
                                local tex = cspr:GetTexel(pos, Vector.Zero, 0.5, -1) --layerID
                                local r,g,b = tex.Red, tex.Green, tex.Blue
                                if tex and tex.Alpha > 0 and r+g+b > 0.1 then

                                    local midR, midG, midB = 1,1,1
                                    local isHasColor = false
                                    for xi = -2, 2 do
                                        for yi = -2, 2 do
                                            ---@type KColor
                                            local tex = cspr:GetTexel(pos+Vector(xi,yi), Vector.Zero, 0.5, -1)
                                            if tex and tex.Alpha > 0 then
                                                local r,g,b = tex.Red, tex.Green, tex.Blue
                                                if r+g+b > 0.1 then
                                                    midR = (midR + r) / 2
                                                    midG = (midG + g) / 2
                                                    midB = (midB + b) / 2
                                                end
                                            end
                                            isHasColor = true
                                        end
                                    end
                                    if isHasColor then
                                        ----@type KColor
                                        --local tex = cspr:GetTexel(pos, Vector.Zero, 0.5, layerID)
                                        --if tex and tex.Alpha > 0 then
                                            local refColor = Color(1,1,1,1,0,0,0, midR, midG, midB, 1)
                                        -- refColor:SetColorize()
                                            Chooping.list[#Chooping.list+1] = trowHairpiecy(rng, pos, refColor)
                                        --end
                                        
                                        if hasChik then
                                            if chikx ~= x then
                                                hasChik = hasChik - 1
                                                if hasChik <= 0 then
                                                    hasChik = false
                                                end
                                            end
                                        elseif not hasSwig then
                                            hasChik = 3
                                            chikx = x
                                            Chooping.extralist[#Chooping.extralist+1] = {Chooping.CHIK, 0, rng:RandomInt(360), pos}

                                            sfx:Play(mod.HStyles.Sfx.scisors_swing, Options.SFXVolume * 1.4, 0, false, 1.0)
                                        end

                                        if hasSwig then
                                            if swigx ~= x then
                                                hasSwig = hasSwig - 1
                                                if hasSwig <= 0 then
                                                    hasSwig = false
                                                end
                                            end
                                        elseif not hasChik then
                                            hasSwig = 3
                                            swigx = x
                                            Chooping.extralist[#Chooping.extralist+1] = {Chooping.SWIG, 0, rng:RandomInt(360), pos}
                                            sfx:Play(mod.HStyles.Sfx.swing, 1, 0, false, 1.7)
                                        end
                                    end
                                end
                            end
                            --if #Chooping.list > 10 then
                            --    break
                            --end
                        end
                    end
                end
            end
        end
        if isSamePlayer and mod.HStyles.Chooping then
            local Chooping = mod.HStyles.Chooping
            local hairPieceSpr = Chooping.HPS
            local RenderPos = Isaac.WorldToScreen(Chooping.RenderPos)
            if Chooping.list and #Chooping.list > 0 then
                if game:IsPaused() then
                    for i = #Chooping.list, 1, -1 do
                        local tab = Chooping.list[i]
                        local spr = tab[3]
                        hairPieceSpr:SetFrame(spr.Frame)
                        hairPieceSpr.Rotation = spr.Rotation
                        hairPieceSpr.Color = spr.Color
                        hairPieceSpr.Scale = spr.Scale
                        hairPieceSpr:Render(RenderPos + tab[1])
                    end
                    for i = #Chooping.extralist, 1, -1 do
                        local tab = Chooping.extralist[i]
                        local spr = tab[1]
                        spr.Rotation = tab[3]
                        spr:SetFrame(tab[2])
                        spr:Render(RenderPos + tab[4])
                    end
                else
                    --if #Chooping.list == 0 then
                    --    mod.HStyles.Chooping = nil
                    --end
                    for i = #Chooping.list, 1, -1 do
                        local tab = Chooping.list[i]
                        local spr = tab[3]

                        tab[1] = tab[1] + tab[2]
                        tab[2].X = tab[2].X * 0.99
                        spr.Rotation = spr.Rotation + tab[5]
                        hairPieceSpr.Rotation = spr.Rotation
                        tab[2].Y = tab[2].Y + 0.1
                        local sc = math.min(40,tab[4])/40
                        spr.Scale = Vector.One/(1/sc)  -- spr.Scale * 0.95
                        hairPieceSpr.Scale = spr.Scale
                        if RenderPos.Y + tab[1].Y > Chooping.FloorYpos then
                            --tab[1].Y = Chooping.RenderPos.Y + Chooping.FloorYpos
                            tab[2] = Vector(0,0)
                            tab[5] = 0
                            tab[4] = tab[4] - 1
                        end

                        hairPieceSpr.Color = spr.Color
                        hairPieceSpr:SetFrame(spr.Frame)
                        hairPieceSpr:Render(RenderPos + tab[1])

                        --tab[4] = tab[4] - 1
                        if tab[4] <= 0 then
                            table.remove(Chooping.list, i)
                        end
                    end
                    for i = #Chooping.extralist, 1, -1 do
                        local tab = Chooping.extralist[i]
                        local spr = tab[1]
                        spr.Rotation = tab[3]
                        spr:SetFrame(tab[2])
                        spr:Render(RenderPos + tab[4])
                        if spr:GetCurrentAnimationData():GetLength() == tab[2] then
                            table.remove(Chooping.extralist, i)
                        end
                        tab[2] = tab[2] + 1
                    end
                end
                --Isaac.DrawLine(Vector(Chooping.RenderPos.X - 55, Chooping.FloorYpos), Vector(Chooping.RenderPos.X + 55, Chooping.FloorYpos),
                --    KColor(2,1,1,1), KColor(2,1,1,1), 2 )
            end
        end
    end
    mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_RENDER, 100, mod.HStyles.salon.RenderHairChoop, 0)
end



local angleVecP = {}
local pointsCount = 16
do
    local num = 1
    for i = 0, 360-(360/pointsCount), (360/pointsCount) do
        angleVecP[num] = Vector.FromAngle(i)
        num = num + 1
    end
end



mod.HStyles.salon.CollisionMap = {
    [0]=true,true,true,true,true,true,true,true,true,true,true,true,
    true,true,true,false,true,true,true,true,true,true,true,
    true,true,false,false,false,1,1,1,true,true,true,
    true,true,false,false,false,false,false,false,true,true,true,
    true,true,false,false,false,false,false,false,true,true,true,
    true,true,true,true,true,true,true,true,true,true,true,
    true,true,true,true,true,true,true,true,true,true,true,
}

function mod.HStyles.salon.CheckColl(player)
    if player and salon.TopLeftPos then
        local ps,vl = player.Position, player.Velocity
        local entsize = player.Size
        local corpos = ps - salon.TopLeftPos
        corpos.X = corpos.X + 40
        --local index = corpos.X // 40 + corpos.Y // 40 * 11

        local pushVec = Vector(0,0)
        local vecLength = vl:Length()/4+.01
        local pushpower = math.max(0.01, vecLength-.2)
        local map = salon.CollisionMap
        local topush = false
        local dottoched = 0

        for i=1, pointsCount do
            local rotpoint = angleVecP[i]:Resized(entsize)
            local gridcollpoint = corpos + rotpoint
            local index = gridcollpoint.X // 40 + gridcollpoint.Y // 40 * 11

            local grid = map[index]
            if grid then
                if grid == 1 then
                    if gridcollpoint.Y < 90 then
                        pushVec = pushVec - angleVecP[i]:Resized(pushpower)
                        topush = true
                        dottoched = dottoched + 1
                    end
                else
                    pushVec = pushVec - angleVecP[i]:Resized(pushpower)
                    topush = true
                    dottoched = dottoched + 1
                end
            end
        end

        if topush then
            local vec = player.Velocity
            local angle = pushVec:GetAngleDegrees()
            local rotvec = vec:Rotated(-angle)

            player.Position = ps + pushVec
       
            --local lenght = vl:Length()
           
            player.Velocity = Vector( math.max(0, rotvec.X ), rotvec.Y ):Rotated(angle)
            if dottoched > 4 and vecLength < 1 then
                player.Position = player.Position + pushVec:Resized(1.5)
            end

        end
    end
end










------------       поиск респрайтов       -------------
local PlayerTypeToHairPos = {
    [PlayerType.PLAYER_AZAZEL]=1,
    [PlayerType.PLAYER_APOLLYON]=1,
    [PlayerType.PLAYER_APOLLYON_B]=1,
    [PlayerType.PLAYER_LAZARUS_B]=1,
    [PlayerType.PLAYER_LAZARUS2_B]=1,
    [PlayerType.PLAYER_BLUEBABY_B]=1,
}


local strings = {
    frommod = {
        en = "from mod: ", ru = "из мода: ",
    }
}
local function GetStr(str)
    if strings[str] then
        return strings[str][Options.Language] or strings[str].en
    end
end

local function FindOriginal(resources, path, costumepath, playerid, nullid, CostumeSheep, anm2)
    local hairpath = resources .. "/" .. path

    local res = pcall(Renderer.LoadImage, hairpath)

    if res then
        local fullCostumeSheep =  resources .. "/" .. CostumeSheep   --mod.GamePath ..
        local tab = {
            TargetCostume = {ID = nullid, Type = ItemType.ITEM_NULL},
            TailCostumeSheep = fullCostumeSheep,
            ReplaceCostumeSheep = fullCostumeSheep,
            NullposRefSpr = GenSprite(resources .. "/" .. anm2),
            --SkinFolderSuffics = costumepath,
            
        }
        --if EntityConfig.GetPlayer(playerid):GetSkinColor() == -1 then
            tab.SkinFolderSuffics = costumepath
        --end
        if PlayerTypeToHairPos[playerid] then
            tab.TargetCostume.pos = PlayerTypeToHairPos[playerid]
        end
        
        tab.NullposRefSpr:ReplaceSpritesheet(0, 
            tab.TailCostumeSheep)
        tab.NullposRefSpr:LoadGraphics()
        tab.NullposRefSpr:ReplaceSpritesheet(1, 
            tab.TailCostumeSheep)

        mod.HStyles.AddStyle(playerid.."_original", playerid, tab)
        
        return true
    end
    
end

local function FindResprites(modfoldername, resources, path, costumepath, playerid, nullid, CostumeSheep, anm2, modd)
    local hairpath = mod.GamePath .. "mods/" .. modfoldername .. path
    local res = pcall(Renderer.LoadImage, hairpath)
    if res then
        local fullCostumeSheep = mod.GamePath .. "mods/" .. modfoldername .. "/" .. resources .. "/" .. CostumeSheep
        --if playerid == 36 then

        --end
        local nullRef = GenSprite(mod.GamePath .. "mods/" .. modfoldername .. "/" .. resources .. "/" .. anm2)
        if nullRef:GetDefaultAnimation() == "" then
            nullRef = GenSprite("resources/" .. anm2)
        end
        local tab = {
            TargetCostume = {ID = nullid, Type = ItemType.ITEM_NULL},
            TailCostumeSheep = fullCostumeSheep,
            ReplaceCostumeSheep = fullCostumeSheep,
            NullposRefSpr = nullRef,
            --SkinFolderSuffics = "mods/" .. modfoldername  .. costumepath,
            SyncWithCostumeBodyColor = true,
        }

        --if EntityConfig.GetPlayer(playerid):GetSkinColor() == -1 then
            tab.SkinFolderSuffics = mod.GamePath .. "mods/" .. modfoldername  .. costumepath
        --end
        if PlayerTypeToHairPos[playerid] then
            tab.TargetCostume.pos = PlayerTypeToHairPos[playerid]
        end
        
        tab.NullposRefSpr:ReplaceSpritesheet(0, 
            mod.GamePath .. "mods/" .. modfoldername .. "/" .. resources .. "/" .. tab.TailCostumeSheep)
        tab.NullposRefSpr:LoadGraphics()
        
        mod.HStyles.AddStyle(modfoldername .. "-" .. playerid .. "-" .. CostumeSheep, playerid, tab,
            {
                --modfolder = "", -- "mods/" .. modfoldername .. "/" .. resources,
                --useDirectTailCostumeSheepForIcon = true,
                menuHintText = GetStr("frommod") .. modd.name -- .. " sggsgssggssg sggssggsgsgsgs",
            })
    end
end


local PlayeeTypeToHairAnm2 = {
    [PlayerType.PLAYER_MAGDALENE]="gfx/characters/character_002_magdalenehead.anm2",
    [PlayerType.PLAYER_CAIN]="gfx/characters/character_003_cainseyepatch.anm2", 
    [PlayerType.PLAYER_JUDAS]="gfx/characters/character_004_judasfez.anm2",
    --[PlayerType.PLAYER_EVE]="gfx/characters/character_005_evehead.anm2",
    [PlayerType.PLAYER_AZAZEL]="gfx/characters/character_008_azazelhead.anm2",
    --[PlayerType.PLAYER_EDEN]="gfx/characters/character_003_cainseyepatch",
    [PlayerType.PLAYER_SAMSON]="gfx/characters/character_007_samsonhead.anm2",
    [PlayerType.PLAYER_KEEPER]="gfx/characters/character_014_keepernoose.anm2",
    [PlayerType.PLAYER_LAZARUS]="gfx/characters/character_lazarushair1.anm2", 
    [PlayerType.PLAYER_LAZARUS2]="gfx/characters/character_lazarushair2.anm2",
    [PlayerType.PLAYER_LILITH]="gfx/characters/character_lilithhair.anm2", 
    [PlayerType.PLAYER_APOLLYON]="gfx/characters/character_015_apollyonbody.anm2", 
    --[PlayerType.PLAYER_THEFORGOTTEN]="gfx/characters/character_016_theforgottenbody.anm2",
    --[PlayerType.PLAYER_BETHANY]="gfx/characters/character_001x_bethanyhead.anm2",
    [PlayerType.PLAYER_JACOB]="gfx/characters/character_002x_jacobhead.anm2", 
    [PlayerType.PLAYER_ESAU]="gfx/characters/character_003x_esauhead.anm2", 
    [PlayerType.PLAYER_ISAAC_B]="gfx/characters/character_b01_isaac.anm2",
    [PlayerType.PLAYER_MAGDALENE_B]="gfx/characters/character_b02_magdalene.anm2", 
    [PlayerType.PLAYER_CAIN_B]="gfx/characters/character_b03_cain.anm2", 
    [PlayerType.PLAYER_JUDAS_B]="gfx/characters/character_b04_judas.anm2",
    [PlayerType.PLAYER_BLUEBABY_B]="gfx/characters/character_b05_bluebaby.anm2", 
    [PlayerType.PLAYER_EVE_B]="gfx/characters/character_b06_eve.anm2", 
    [PlayerType.PLAYER_SAMSON_B]="gfx/characters/character_b07_samson.anm2",
    --[PlayerType.PLAYER_AZAZEL_B]="/gfx/characters/", 
    [PlayerType.PLAYER_LAZARUS_B]="gfx/characters/character_b09_lazarus.anm2", 
    [PlayerType.PLAYER_LAZARUS2_B]="gfx/characters/character_b09_lazarus2.anm2",
    --[PlayerType.PLAYER_EDEN_B]="/gfx/characters/", 
    [PlayerType.PLAYER_THELOST_B]="gfx/characters/character_b11_thelost.anm2", 
    [PlayerType.PLAYER_LILITH_B]="gfx/characters/character_b12_lilith.anm2",
    [PlayerType.PLAYER_KEEPER_B]="gfx/characters/character_b13_keeper.anm2", 
    --[PlayerType.PLAYER_APOLLYON_B]="gfx/characters/character_b14_apollyon.anm2", 
    [PlayerType.PLAYER_THEFORGOTTEN_B]="gfx/characters/character_b15_theforgotten.anm2",
    --[PlayerType.PLAYER_BETHANY_B]="gfx/characters/character_b16_bethany.anm2",
    [PlayerType.PLAYER_JACOB_B]="gfx/characters/character_b17_jacob2.png", 
    [PlayerType.PLAYER_JACOB2_B]="gfx/characters/character_b17_jacob2.anm2", 
    [PlayerType.PLAYER_THESOUL]="gfx/characters/character_b15_thesoul.anm2",
    [PlayerType.PLAYER_THESOUL_B]="gfx/characters/character_b17_jacob2.anm2",
}

local PlayeeTypeToHairPath = {
    [PlayerType.PLAYER_MAGDALENE]="gfx/characters/costumes/character_002_maggiesbeautifulgoldenlocks.png",
    [PlayerType.PLAYER_CAIN]="gfx/characters/costumes/character_003_cainseyepatch.png", 
    --[PlayerType.PLAYER_JUDAS]="gfx/characters/costumes/character_004_judasfez.png",
    --[PlayerType.PLAYER_EVE]="gfx/characters/costumes/character_005_evehead.png",
    [PlayerType.PLAYER_AZAZEL]="gfx/characters/costumes/character_008_azazelhead.png",
    --[PlayerType.PLAYER_EDEN]="gfx/characters/costumes/character_003_cainseyepatch",
    [PlayerType.PLAYER_SAMSON]="gfx/characters/costumes/character_007_samsonshairandbandanna.png",
    [PlayerType.PLAYER_KEEPER]="gfx/characters/costumes/character_015_keepernoose.png",
    [PlayerType.PLAYER_LAZARUS]="gfx/characters/costumes/character_009_lazarushair.png", 
    [PlayerType.PLAYER_LAZARUS2]="gfx/characters/costumes/character_009_lazarushair2.png",
    [PlayerType.PLAYER_LILITH]="gfx/characters/costumes/character_014_lilithhair.png", 
    [PlayerType.PLAYER_APOLLYON]="gfx/characters/costumes/character_016_apollyonhorns.png", 
    --[PlayerType.PLAYER_THEFORGOTTEN]="gfx/characters/costumes/character_016_theforgottenbody.anm2",
    --[PlayerType.PLAYER_BETHANY]="gfx/characters/costumes/character_001x_bethshair.png",
    [PlayerType.PLAYER_JACOB]="gfx/characters/costumes/character_002x_jacobhair.png", 
    [PlayerType.PLAYER_ESAU]="gfx/characters/costumes/character_003x_esauhair.png", 
    [PlayerType.PLAYER_ISAAC_B]="gfx/characters/costumes/character_001b_isaacsscars.png",
    [PlayerType.PLAYER_MAGDALENE_B]="gfx/characters/costumes/character_002b_maggiesnotsobeautifulgoldenlocks.png", 
    [PlayerType.PLAYER_CAIN_B]="gfx/characters/costumes/character_003b_cainsbloodyeyepatch.png", 
    --[PlayerType.PLAYER_JUDAS_B]="gfx/characters/costumes/character_004b_judasfez.png",
    [PlayerType.PLAYER_BLUEBABY_B]="gfx/characters/costumes/character_005b_bluebabyhead.png", 
    [PlayerType.PLAYER_EVE_B]="gfx/characters/costumes/character_006b_evehead.png", 
    [PlayerType.PLAYER_SAMSON_B]="gfx/characters/costumes/character_007b_samsonshair.png",
    --[PlayerType.PLAYER_AZAZEL_B]="gfx/characters/costumes/", 
    [PlayerType.PLAYER_LAZARUS_B]="gfx/characters/costumes/character_009b_lazarushair.png", 
    [PlayerType.PLAYER_LAZARUS2_B]="gfx/characters/costumes/character_009b_lazarus2hair.png",
    --[PlayerType.PLAYER_EDEN_B]="gfx/characters/costumes/", 
    [PlayerType.PLAYER_THELOST_B]="gfx/characters/costumes/character_012b_lostcobwebs.png", 
    [PlayerType.PLAYER_LILITH_B]="gfx/characters/costumes/character_014b_lilithhair.png",
    [PlayerType.PLAYER_KEEPER_B]="gfx/characters/costumes/character_015b_keeperisgreedier.png", 
    --[PlayerType.PLAYER_APOLLYON_B]="gfx/characters/costumes/character_016b_apollyonvoid.png", 
    [PlayerType.PLAYER_THEFORGOTTEN_B]="gfx/characters/costumes/character_016b_theforgottencracks.png",
    --[PlayerType.PLAYER_BETHANY_B]="gfx/characters/costumes/character_018b_bethshair.png", 
    [PlayerType.PLAYER_JACOB_B]="gfx/characters/costumes/character_019b_jacobhair.png", 
    [PlayerType.PLAYER_JACOB2_B]="gfx/characters/costumes/character_019b_jacob2hair.png", 
    --[PlayerType.PLAYER_THESOUL]="gfx/characters/costumes/character_017b_thesoulshood.png",
    [PlayerType.PLAYER_THESOUL_B]="gfx/characters/costumes/character_017b_thesoulshood.png",
}

function mod.HStyles.GetHairAnm2ByPlayerType(ptype)
    return PlayeeTypeToHairAnm2[ptype]
end

CachedModXMLData = CachedModXMLData or {}

for ptype, _ in pairs(PlayeeTypeToHairPath) do
    --if PlayeeTypeToHairPath[ptype] then
        local hairpath = PlayeeTypeToHairPath[ptype]
        --local fixedBodyColor = EntityConfig.GetPlayer(ptype):GetSkinColor() ~= -1
        if not FindOriginal("resources-dlc3",
            hairpath, 
            "resources-dlc3/gfx/characters/costumes/", 
            ptype,PlayerTypeToTargetCostume[ptype], 
            hairpath, PlayeeTypeToHairAnm2[ptype]) 
        then

            FindOriginal("resources", 
                hairpath, 
                "resources/gfx/characters/costumes/", 
                ptype,PlayerTypeToTargetCostume[ptype], 
                hairpath, PlayeeTypeToHairAnm2[ptype])
        end
    --end
end

--#region extracompat
mod.ExtraModCompat = {}
local ExtraModCompat = mod.ExtraModCompat

function ExtraModCompat.ExtraHair()
    for i, k in pairs(Isaac.GetCallbacks(ModCallbacks.MC_POST_PLAYER_INIT)) do
        if k.Mod.Name == "Extra Hair" then
            k.Mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_INIT, k.Mod.ChangeHair)
        end
    end
    local hairList = {
        {"3402926130_beth", PlayerType.PLAYER_BETHANY, {ID = NullItemID.ID_BETHANY, Type = ItemType.ITEM_NULL}, 
            "gfx/characters/costumes/extrahair_bethany_01.png"},
        {"3402926130_eve", PlayerType.PLAYER_EVE, {ID = NullItemID.ID_EVE, Type = ItemType.ITEM_NULL}, 
            "gfx/characters/costumes/extrahair_eve_01.png"},
        {"3402926130_eve2", PlayerType.PLAYER_EVE, {ID = NullItemID.ID_EVE, Type = ItemType.ITEM_NULL}, 
            "gfx/characters/costumes/extrahair_eve_02.png"},
        --{"3402926130_isaac_1", PlayerType.PLAYER_ISAAC, {ID = NullItemID., Type = ItemType.ITEM_NULL}, 
        --    "gfx/characters/costumes/extrahair_isaac_01.png"},
        {"3402926130_judas", PlayerType.PLAYER_JUDAS, {ID = NullItemID.ID_JUDAS, Type = ItemType.ITEM_NULL}, 
            "gfx/characters/costumes/extrahair_judas_01.png", "gfx/characters/extrahair_judas_01.anm2"},
        {"3402926130_lararus", PlayerType.PLAYER_LAZARUS, {ID = NullItemID.ID_LAZARUS, Type = ItemType.ITEM_NULL}, 
            "gfx/characters/costumes/extrahair_lazarus_01.png"},
        {"3402926130_lararus2", PlayerType.PLAYER_LAZARUS2, {ID = NullItemID.ID_LAZARUS2, Type = ItemType.ITEM_NULL}, 
            "gfx/characters/costumes/extrahair_lazarus_02.png"},
        {"3402926130_maggy", PlayerType.PLAYER_MAGDALENE, {ID = NullItemID.ID_MAGDALENE, Type = ItemType.ITEM_NULL},
            "gfx/characters/costumes/extrahair_maggy_01.png"},
        
        {"3402926130_isaac", PlayerType.PLAYER_ISAAC, {ID = mod.BaldHairCostumeID, Type = ItemType.ITEM_NULL, AddIfNot = true}, 
            "gfx/characters/costumes/extrahair_isaac_01.png", "gfx/characters/extrahair_isaac_01.anm2"},
        {"3402926130_isaac2", PlayerType.PLAYER_ISAAC, {ID = mod.BaldHairCostumeID, Type = ItemType.ITEM_NULL, AddIfNot = true}, 
            "gfx/characters/costumes/extrahair_isaac_02.png", "gfx/characters/extrahair_isaac_02.anm2"},
        {"3402926130_isaacb", PlayerType.PLAYER_ISAAC_B, {ID = NullItemID.ID_ISAAC_B, Type = ItemType.ITEM_NULL}, 
            "gfx/characters/costumes/extrahair_tainted_isaac_01.png", "gfx/characters/extrahair_t_isaac_01.anm2"},

    }
    for i, k in pairs(hairList) do
        local name = k[1]
        local playerT = k[2]
        local targetCostume = k[3]
        local path = k[4]
        local nullref = k[5]

        mod.HStyles.AddStyle(name, playerT, {
            TargetCostume = targetCostume,
            SyncWithCostumeBodyColor = true,
            --SkinFolderSuffics = "gfx/characters/costumes/lilith_styles/smol imp/",
            ReplaceCostumeSheep = path,
            TailCostumeSheep = path,
            NullposRefSpr = nullref and GenSprite(nullref),
        },
        {menuHintText = GetStr("frommod") .. "Extra Hair", })
    end
end
--#endregion extracompat


for i=0, XMLData.GetNumEntries(XMLNode.MOD) do
    local mod = XMLData.GetEntryById(XMLNode.MOD, i)
    if mod then
        if not CachedModXMLData[i] then
            CachedModXMLData[i] = {}
            local cache = CachedModXMLData[i]
            for i,k in pairs(mod) do
                if i ~= "description" then
                    cache[i] = k
                end
            end
        end
        local mod = CachedModXMLData[i]
        
        local dir = mod.realdirectory or mod.directory

        if dir and (not mod.enabled or mod.enabled == "true") then
            
            --[[local hairpath1 = "mods/" .. dir .. "/resources/gfx/characters/costumes/character_001x_bethshair.png"
            local res, ff = pcall(Renderer.LoadImage, hairpath1)
            
            if res then
                print(dir)
            end

            local hairpath2 = "mods/" .. dir .. "/resources-dlc3/gfx/characters/costumes/character_001x_bethshair.png"
            local res = pcall(Renderer.LoadImage, hairpath2)
            if res then
                print(dir)

                local tab = {
                    TargetCostume = {ID = NullItemID.ID_EDEN, Type = ItemType.ITEM_NULL},
                    TailCostumeSheep = "gfx/characters/costumes/character_009_edenhair" .. i .. ".png",
                    ReplaceCostumeSheep = "gfx/characters/costumes/character_009_edenhair" .. i .. ".png",
                    NullposRefSpr = GenSprite("gfx/characters/character_009_edenhair1.anm2")
                }
                tab.NullposRefSpr:ReplaceSpritesheet(0, tab.TailCostumeSheep)
                tab.NullposRefSpr:LoadGraphics()
                
                mod.HStyles.AddStyle("edenstandarthair_"..i, PlayerType.PLAYER_EDEN, tab)
            end]]

            -- бетон
            FindResprites(dir, "resources-dlc3",
                "/resources-dlc3/gfx/characters/costumes/character_001x_bethshair.png",
                "/resources-dlc3/gfx/characters/costumes/",
                PlayerType.PLAYER_BETHANY,  NullItemID.ID_BETHANY, 
                "gfx/characters/costumes/character_001x_bethshair.png", "gfx/characters/character_001x_bethanyhead.anm2",
                mod
            )
            FindResprites(dir, "resources",
                "/resources/gfx/characters/costumes/character_001x_bethshair.png",
                "/resources/gfx/characters/costumes/",
                PlayerType.PLAYER_BETHANY,  NullItemID.ID_BETHANY, 
                "gfx/characters/costumes/character_001x_bethshair.png", "gfx/characters/character_001x_bethanyhead.anm2",
                mod
            )

            --ева
            FindResprites(dir, "resources-dlc3",
                "/resources-dlc3/gfx/characters/costumes/character_005_evehead.png",
                "/resources-dlc3/gfx/characters/costumes/",
                PlayerType.PLAYER_EVE,  NullItemID.ID_EVE, 
                "gfx/characters/costumes/character_005_evehead.png", "gfx/characters/character_005_evehead.anm2",
                mod
            )
            FindResprites(dir, "resources",
                "/resources/gfx/characters/costumes/character_005_evehead.png",
                "/resources/gfx/characters/costumes/",
                PlayerType.PLAYER_EVE,  NullItemID.ID_EVE, 
                "gfx/characters/costumes/character_005_evehead.png", "gfx/characters/character_005_evehead.anm2",
                mod
            )


            FindResprites(dir, "resources",
                "/resources/gfx/characters/costumes/character_018b_bethshair.png",
                "/resources/gfx/characters/costumes/",
                PlayerType.PLAYER_BETHANY_B,  NullItemID.ID_BETHANY_B, 
                "gfx/characters/costumes/character_018b_bethshair.png", "gfx/characters/character_b16_bethany.anm2",
                mod
            )
            FindResprites(dir, "resources-dlc3",
                "/resources-dlc3/gfx/characters/costumes/character_018b_bethshair.png",
                "/resources/gfx/characters/costumes/",
                PlayerType.PLAYER_BETHANY_B,  NullItemID.ID_BETHANY_B, 
                "gfx/characters/costumes/character_018b_bethshair.png", "gfx/characters/character_b16_bethany.anm2",
                mod
            )
            

            FindResprites(dir, "resources",
                "/resources/gfx/characters/costumes/character_004_judasfez.png",
                "/resources/gfx/characters/costumes/",
                PlayerType.PLAYER_JUDAS,  NullItemID.ID_JUDAS, 
                "gfx/characters/costumes/character_004_judasfez.png", "gfx/characters/character_004_judasfez.anm2",
                mod
            )
            FindResprites(dir, "resources-dlc3",
                "/resources-dlc3/gfx/characters/costumes/character_004_judasfez.png",
                "/resources/gfx/characters/costumes/",
                PlayerType.PLAYER_JUDAS,  NullItemID.ID_JUDAS, 
                "gfx/characters/costumes/character_004_judasfez.png", "gfx/characters/character_004_judasfez.anm2",
                mod
            )

            FindResprites(dir, "resources",
                "/resources/gfx/characters/costumes/character_004b_judasfez.png",
                "/resources/gfx/characters/costumes/",
                PlayerType.PLAYER_JUDAS_B,  NullItemID.ID_JUDAS_B, 
                "gfx/characters/costumes/character_004b_judasfez.png", "gfx/characters/character_b04_judas.anm2",
                mod
            )
            FindResprites(dir, "resources-dlc3",
                "/resources-dlc3/gfx/characters/costumes/character_004b_judasfez.png",
                "/resources/gfx/characters/costumes/",
                PlayerType.PLAYER_JUDAS_B,  NullItemID.ID_JUDAS_B, 
                "gfx/characters/costumes/character_004b_judasfez.png", "gfx/characters/character_b04_judas.anm2",
                mod
            )


            
            for ptype in pairs(PlayeeTypeToHairPath) do
                --if PlayeeTypeToHairPath[ptype] then
                    local hairpath = PlayeeTypeToHairPath[ptype]

                    FindResprites(dir, "resources-dlc3",
                        "/resources-dlc3/" .. hairpath,
                        "/resources-dlc3/gfx/characters/costumes/",
                        ptype,  PlayerTypeToTargetCostume[ptype], 
                        hairpath, PlayeeTypeToHairAnm2[ptype],
                        mod
                    )

                    FindResprites(dir, "resources",
                        "/resources/" .. hairpath,
                        "/resources/gfx/characters/costumes/",
                        ptype,  PlayerTypeToTargetCostume[ptype], 
                        hairpath, PlayeeTypeToHairAnm2[ptype],
                        mod
                    )
                --end
            end

            if mod.id == "3402926130" then
                ExtraModCompat.ExtraHair()
            end

        end
    end
end


































local maxcoord = 4
local scretch = math.ceil(5* Wtr)-- 30/(maxcoord+1)
local defscretch = scretch
local headsize = 20* Wtr

----------------- extra phys

mod.extraPhysFunc = {}
local epf = mod.extraPhysFunc

local getAngleDiv = function(a,b)
    local r1,r2
    if a > b then
        r1,r2 = a-b, b-a+360
    else
        r1,r2 = b-a, a-b+360
    end
    return r1>r2 and r2 or r1
end

local lerpAngle = function(a, b, t)
    return (a - (((a+180)-b)%360-180)*t) % 360
end


function epf.PonyTailFunc(player, TailData, HairData, StartPos, Headpos, scale)
    --local cdat = HairData
    --local tail1 = HairData
    local plpos1 = StartPos
    local scretch = TailData.Scretch
    local Mmass = 10 / TailData.Mass   --/ 10

    local headdir = player:GetHeadDirection()
    local headpospushpower = (headdir == 1 or headdir == 2) and .8 or 1.9

    for i=0, #TailData do
        local mass = Mmass * i --(#tail1 - i)
        local prep, nextp
        local cur = TailData[i]
        local precur = TailData[i-1]
        local lpos = cur[1]

        local srch = cur[3]
        if i == 0 then
            prep = plpos1 --+(plpos1-lpos):Resized(scretch*.7)
            --scretch = 0
        else
            prep = TailData[i-1][1]
        end
        --if i < maxcoord-1 then
        --    nextp = tail1[i+1][1]
        --end
        local lerp = 1 - (.12 * mass )
        cur[2] = cur[2] + Vector(0,.8*scale * (scretch/defscretch) * ( TailData.Mass/10 ))
        if precur then
            --cur[2] = cur[2] * .8 + precur[2]*lerp*.2*scale * (scretch/defscretch) * ( cdat.Mass/10 )
            local prepust = precur[2]*lerp*scale * (scretch/defscretch) * ( TailData.Mass/10 )
            local leng = cur[2]:Length()
            --cur[2] = (cur[2] + prepust):Resized(leng)
        end
        if prep then
            local bttdis = lpos:Distance(prep)
            
            if bttdis > scretch*2 then
                cur[1] = prep-(prep-lpos):Resized(scretch*2*scale)
                --lpos = cur[1]
                bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
            elseif bttdis < scretch*1 then
                cur[1] = prep-(prep-lpos):Resized(scretch*1*scale)
            end
            
            local vel = (prep-lpos):Resized(math.max(-1,bttdis-scretch*lerp*scale))
            
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

        if Headpos then
            Headpos = Headpos + Vector(0,-15)
            local lerp = (.3 * (#TailData - i) )
            local bttdis = lpos:Distance(Headpos)/scale
            
            local vel = (lpos - Headpos):Resized(math.max(0,headsize*0.6-bttdis)*.25)
            cur[2] = cur[2] *.8 + vel* headpospushpower*lerp
        end

        cur[1] = cur[1] + cur[2]

        local bttdis = cur[1]:Distance(prep)
        if bttdis > scretch then
            cur[1] = prep-(prep-cur[1]):Resized(scretch*scale)
            --lpos = cur[1]
            bttdis = scretch*scale
        end
        cur.p:SetPosition(cur[1])
    end
end 


function epf.HoholockTailFunc(player, TailData, HairData, StartPos, Headpos, scale)
    local plpos1 = StartPos
    local scretch = TailData.Scretch
    local Mmass = 10 / TailData.Mass   --/ 10

    local headdir = player:GetHeadDirection()
    local headpospushpower = headdir == 0 and -115 or headdir == 2 and -65 or headdir == 1 and -105 or -75

    for i=0, #TailData do
        local mass = Mmass * i --(#tail1 - i)
        local prep, nextp
        local cur = TailData[i]
        local precur = TailData[i-1]
        local lpos = cur[1]

        local srch = cur[3]
        if i == 0 then
            prep = plpos1 --+(plpos1-lpos):Resized(scretch*.7)
            --scretch = 0
        else
            prep = TailData[i-1][1]
        end
        --if i < maxcoord-1 then
        --    nextp = tail1[i+1][1]
        --end
        local lerp = 1 - (.12 * mass )

            cur[2] = cur[2] + Vector(0,.8*scale * (scretch/defscretch) * ( TailData.Mass/10 ))

            local preangle
            if i == 0 then
                preangle = headpospushpower
            elseif i == 1 then
                preangle = (prep - plpos1 ):GetAngleDegrees()
            else
                preangle = (prep - TailData[i-2][1]):GetAngleDegrees()
            end


            local curangle = (lpos - prep):GetAngleDegrees()

            local addvec = Vector.FromAngle(preangle):Resized(i == 0 and 5 or i==1 and 1 or 1) * scale
            if i==0 then
                cur[2] = cur[2] * .5 + addvec * .5
            else
                cur[2] = cur[2] + addvec
            end
            
            if i == 2 then
                TailData.CordSpr:GetSprite().FlipX = curangle < -100 or curangle > 100
            end
        --end
        
        if prep then
            local bttdis = lpos:Distance(prep)
            
            if bttdis > scretch*2 then
                cur[1] = prep-(prep-lpos):Resized(scretch*2*scale)
                --lpos = cur[1]
                bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
            elseif bttdis < scretch*1 then
                cur[1] = prep-(prep-lpos):Resized(scretch*1*scale)
            end
            
            local vel = (prep-lpos):Resized(math.max(-1,bttdis-scretch*lerp*scale))
            
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

        --[[if headpos then
            headpos = headpos + Vector(0,-15)
            local lerp = (.3 * (#tail1 - i) )
            local bttdis = lpos:Distance(headpos)/scale
            
            local vel = (lpos - headpos):Resized(math.max(0,headsize*0.6-bttdis)*.25)
            cur[2] = cur[2] *.8 + vel* headpospushpower*lerp
        end]]

        cur[1] = cur[1] + cur[2]

        local bttdis = cur[1]:Distance(prep)
        if bttdis > scretch then
            cur[1] = prep-(prep-cur[1]):Resized(scretch*scale)
            --lpos = cur[1]
            bttdis = scretch*scale
        end
        cur.p:SetPosition(cur[1])
    end
end 

function epf.PonyTailFuncHard(player, TailData, HairData, StartPos, Headpos, scale)
    --local cdat = HairData
    --local tail1 = HairData
    local plpos1 = StartPos
    local scretch = TailData.Scretch
    local Mmass = 10 / TailData.Mass   --/ 10

    local headdir = player:GetHeadDirection()
    local headpospushpower = .8

    local dotnum = #TailData

    for i=0, dotnum do
        local mass = Mmass * (dotnum-i+1)*5 --(#tail1 - i)
        local prep, nextp
        local cur = TailData[i]
        local precur = TailData[i-1]
        local lpos = cur[1]

        local srch = cur[3]
        if i == 0 then
            prep = plpos1 --+(plpos1-lpos):Resized(scretch*.7)
            --scretch = 0
        else
            prep = TailData[i-1][1]
        end
        
        local lerp =  i==0 and .98 or i==1 and .7 or i==2 and 0.5 or 0.4     --1 - ((i+1)/dotnum)   --1 - (.12 * mass )
        
        cur[2] = cur[2] + Vector(0,.8*scale * (scretch/defscretch) * ( mass ))
        if precur then
            
            --cur[2] = cur[2] * .8 + precur[2]*lerp*.2*scale * (scretch/defscretch) * ( cdat.Mass/10 )
            local prepust = precur[2]*lerp*scale * (scretch/defscretch) * ( TailData.Mass/10 )
            local leng = cur[2]:Length()
            --cur[2] = (cur[2] + prepust):Resized(leng)
        end
        if prep then
            local bttdis = lpos:Distance(prep)
            
            if bttdis > scretch*2 then
                cur[1] = prep-(prep-lpos):Resized(scretch*2*scale)
                --lpos = cur[1]
                bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
            elseif bttdis < scretch*1 then
                cur[1] = prep-(prep-lpos):Resized(scretch*1*scale)
            end
            
            local vel = (prep-lpos):Resized(math.max(-1,bttdis-scretch*lerp*scale))
            
            cur[2] = (cur[2]* lerp + vel * (1-lerp))
            
            --cur[2] = cur[2] * 0.2 + vel * .8
        end
        --if nextp then
            --local bttdis = lpos:Distance(nextp)

            --local velic = Vector(1,0):Rotated( (nextpos - data._JudasFezFakeCord.pos[i]):GetAngleDegrees() ):Resized( math.max(0,(nextpos:Distance(data._JudasFezFakeCord.pos[i])-Stretch)*0.10) ) --0.07
            --local vel = (nextp-lpos):Resized(bttdis-cdat.scretch)
            --cur[2] = (cur[2] + vel)* .68
            --cur[2] = cur[2]  + vel * .1
        --end

        if Headpos then
            Headpos = Headpos + Vector(0,-5)
            local lerp = (.3 * (#TailData - i) )
            local bttdis = lpos:Distance(Headpos)/scale
            
            local vel = (lpos - Headpos):Resized(math.max(0,headsize*0.8-bttdis)*.25)
           
            cur[2] = cur[2] *.8 + vel* headpospushpower* ((i+1)/dotnum) * mass/10 --lerp
        end

        cur[1] = cur[1] + cur[2]

        local bttdis = cur[1]:Distance(prep)
        if bttdis > scretch then
            cur[1] = prep-(prep-cur[1]):Resized(scretch*scale)
            --lpos = cur[1]
            bttdis = scretch*scale
        end

        cur.p:SetPosition(cur[1])
    end
end


function epf.MenuPaperSwing(tab, start_pos, headpos)
    local scretch = tab.Scretch
    local dotnum = #tab

    for i = 0, dotnum do
        local cur = tab[i]
        local prep, nextp
        local lpos = cur[1]

        if i == 0 then
            prep = start_pos
            
        else
            prep = tab[i-1][1]
        end
        if i ~= dotnum then
            nextp = tab[i+1][1]
            cur[2] = cur[2] + Vector(0,.05 * (scretch))
        else
            cur[2] = cur[2] + Vector(0,.1 * (scretch))
        end

        --cur[2] = cur[2] + Vector(0,.3 * (scretch))
        
        local squeezevel = Vector(0,0)
        if nextp then
            local bttdis = lpos:Distance(nextp)
            
            if bttdis > scretch*2 then
                cur[1] = nextp-(nextp-lpos):Resized(scretch*2)
            end

            local vel = (nextp-lpos):Resized( math.max(0, (bttdis*2.2-scretch)) )    --(nextp-lpos):Resized(  math.min(scretch*3, math.max(0, bttdis-scretch*.5)*0.2) )
            squeezevel = (squeezevel + vel * .39 ) -- (cur[2] * .5 + vel * .5)
        end

        if prep then
            local bttdis = lpos:Distance(prep)
            
            if bttdis > scretch*2 then
                cur[1] = prep-(prep-lpos):Resized(scretch*2)
            end

            local vel = (prep-lpos):Resized( math.max(0, (bttdis*2.2-scretch)) )
            
            squeezevel = (squeezevel + vel * .39 ) -- (cur[2] * .5 + vel * .5)
        end
        --[[if nextp then
            local bttdis = lpos:Distance(nextp)
            
            if bttdis > scretch*3 then
                cur[1] = nextp-(nextp-lpos):Resized(scretch*3)
            end

            local vel = (nextp-nextp):Resized(math.max(-1,bttdis-scretch))
            
            cur[2] = (cur[2] * .5 + vel * .5)
        end]]
        --if i ~= dotnum then
        --    cur[2] = cur[2] + squeezevel
        --else
            cur[2] = cur[2] * .9 + squeezevel * .1
        --end

        if headpos then
            local collisionsize = i == dotnum and 5 or 12 
            headpos = headpos + Vector(0,0)
            local bttdis = lpos:Distance(headpos)
            
            local vel = (lpos - headpos):Resized( math.max(0, collisionsize-bttdis) ) --math.max(0,13-bttdis)*.25)
            
            cur[2] = cur[2] + vel* .1  --* ((i+1)/dotnum)
        end

        cur[1] = cur[1] + cur[2]
    end
end