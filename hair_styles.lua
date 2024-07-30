local mod = BethHair

local Isaac = Isaac
local game = Game()
local Room 
local Wtr = 20/13

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

mod.HStyles = {}

mod.HairStylesData = {
    playerdata = {}, styles = {}
}
local HairStylesData = mod.HairStylesData

function mod.HStyles.AddStyle(name, playerid, data, extradata)
    if name and playerid and data then
        HairStylesData.styles[name] = {ID=playerid, data=data, extra=extradata}
        HairStylesData.playerdata[playerid] = HairStylesData.playerdata[playerid] or {}
        local tab = HairStylesData.playerdata[playerid]
        tab[#tab+1] = name
    end
end

---@class HairStyleData
---@field ID PlayerType
---@field data PlayerHairData
---@field extra table

---@return HairStyleData
function BethHair.HStyles.GetStyleData(name)
    return HairStylesData.styles[name]
end

function mod.SetHairStyleData(player, playerType, style_data)
    mod.HairLib.SetHairData(playerType,  style_data)
end

function mod.HairPreInit(_, player)
    local ptype = player:GetPlayerType()
    local pladat = HairStylesData.playerdata[ptype]
    if pladat then
        local data = player:GetData()
        if data._PhysHair_HairStyle then
            local PHSdata = data._PhysHair_HairStyle
            if PHSdata.PlayerType and PHSdata.PlayerType ~= ptype then
                data._PhysHair_HairStyle = nil
            else
                local stdata = HairStylesData.styles[PHSdata.StyleName]
                if stdata then
                    if stdata.ID == ptype then
                        mod.SetHairStyleData(player,ptype, stdata.data)
                        mod.HStyles.UpdateMainHairSprite(player, data, stdata)
                    end
                end
            end
        else
            local firstname = pladat[1]
            if firstname then
                local stdata = HairStylesData.styles[firstname]
                if stdata then
                    mod.SetHairStyleData(player,ptype, stdata.data)
                    mod.HStyles.UpdateMainHairSprite(player, data, stdata)
                end
            end 
        end
    end
end
mod:AddCallback(mod.HairLib.Callbacks.HAIR_PRE_INIT, mod.HairPreInit)

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
function mod.HStyles.SetStyleToPlayer(player, style_name, mode)
    if player and style_name then
        local stdata = HairStylesData.styles[style_name]
        local ptype = player:GetPlayerType()
        if stdata and stdata.ID == ptype then
            --mod.SetHairStyleData(ptype, stdata)
            local data = player:GetData()
            --data._PhysHair_HairStyle = style_name
            data._PhysHair_HairStyle = {StyleName = style_name, PlayerType = ptype}
            mod.HairLib.InitHairData(player, nil, nil, mode)
            
            --mod.HStyles.UpdateMainHairSprite(player, data, stdata)
        end
    end
end

function mod.HStyles.UpdateMainHairSprite(player, data, stdata)
    local skinsheet = stdata.data.SkinFolderSuffics
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
            --print(path)
            for i=0, spr:GetLayerCount()-1 do
                spr:ReplaceSpritesheet(i,path)
            end
            spr:LoadGraphics()
        end
    end

    local sheep = stdata.data.NullposRefSpr   --stdata.data.TailCostumeSheep
    local tarcost = stdata.data.TargetCostume
    data._PhysHairExtra = data._PhysHairExtra or {}

    --print(stdata.data.NullposRefSpr)
    if sheep and tarcost then
        print(player:GetPlayerType(), sheep, tarcost.ID)
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
                    --print( sheep:GetFilename() )
                    local anim = cspr:GetAnimation()
                    cspr:Load(sheep:GetFilename(), true)
                    cspr:Play(anim)

                    for i=0, cspr:GetLayerCount()-1 do
                        --print(i, cspr:GetLayer(i):GetSpritesheetPath())
                        local shpa = sheep:GetLayer(i)
                        if shpa then
                            print(i, shpa:GetSpritesheetPath())
                            cspr:ReplaceSpritesheet(i, shpa:GetSpritesheetPath())
                            --print("layer", shpa:GetSpritesheetPath())
                            --foc[i] = shpa:GetSpritesheetPath()
                            dcsp[i] = shpa:GetSpritesheetPath()
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
                end
            end
        end
    end
end

function mod.HStyles.BodyColorTracker(_, player, bodcol, refstring)
    local PHSdata = player:GetData()._PhysHair_HairStyle
    if PHSdata then
        local stdata = HairStylesData.styles[PHSdata.StyleName]
        if stdata then
            local skinsheet = stdata.data.SkinFolderSuffics
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
                    local path = skinsheet .. orig .. ( refstring or "") .. ".png"
                    --print(path)
                    for i=0, spr:GetLayerCount()-1 do
                        spr:ReplaceSpritesheet(i,path)
                    end
                    spr:LoadGraphics()
                end
            end
        end
    end
end
mod:AddCallback(mod.HairLib.Callbacks.PRE_COLOR_CHANGE, mod.HStyles.BodyColorTracker)












----храня

mod.HStyles.HairKeeper = {ID = Isaac.GetEntityTypeByName("Парихранитель"), VAR = Isaac.GetEntityVariantByName("Парихранитель")}

---@param ent EntitySlot
function mod.HStyles.HairKeeper.update(_, ent)
    local data = ent:GetData()
    if ent.FrameCount < 2 then
        ent.TargetPosition = ent.Position
    end

    if ent.Target then
        data.room = data.room or game:GetRoom()

        if not data.removedwall then
            data.removedwall = true
            data.level = data.level or game:GetLevel()
            local crds = data.level:GetCurrentRoomDesc()
            --if crds.Flags & RoomDescriptor.FLAG_NO_WALLS == 0 then
            --    crds.Flags = crds.Flags | RoomDescriptor.FLAG_NO_WALLS
            --    data.removeFLAG_NO_WALLS = true
            --end
        end
        
        local camera = data.room:GetCamera()
        --camera:SetFocusPosition(ent.Target.Position + Vector(Isaac.GetScreenWidth()/4 * Wtr,0))
        if not mod.StyleMenu.wind then
            ent.Target = nil
            data.removedwall = nil
            --if data.removeFLAG_NO_WALLS then
            --    local crds = data.level:GetCurrentRoomDesc()
            --    crds.Flags = crds.Flags - RoomDescriptor.FLAG_NO_WALLS
            --end
        end
    end

    ent.Velocity = (ent.TargetPosition - ent.Position) / 5
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.HStyles.HairKeeper.update, mod.HStyles.HairKeeper.VAR)

---@param ent EntitySlot
function mod.HStyles.HairKeeper.coll(_, ent, col)
    if not ent.Target and col.Type == EntityType.ENTITY_PLAYER then
        local player = col:ToPlayer()
        local ptype = player:GetPlayerType()
        local bhpd = BethHair.HairStylesData.playerdata
        if bhpd[ptype] then
            ent.Target = player
            BethHair.StyleMenu.TargetPlayer = player
            BethHair.StyleMenu.TargetHairKeeper = ent
            BethHair.StyleMenu.ShowWindow()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.HStyles.HairKeeper.coll, mod.HStyles.HairKeeper.VAR)


mod.HStyles.salon = {
    CameraFocusPos = Vector(0,0),
    EnterIndex = 131,
    TopLeftRefIndex = 128,
    BGEntVar = Isaac.GetEntityVariantByName("Фон парихмазерской")
}
local salon = mod.HStyles.salon


function mod.HStyles.salon.NewRoom()
    salon.IsRoom = false
    local level = game:GetLevel()
    
    if level and level:GetStartingRoomIndex() == level:GetCurrentRoomIndex() then
        local room = game:GetRoom()

        salon.IsRoom = true
        salon.bg = GenSprite("gfx/backdrop/hairsalon_backdrop.anm2", "New Animation")

        salon.EnterPos = room:GetGridPosition(salon.EnterIndex)
        salon.TopLeftPos = room:GetGridPosition(salon.TopLeftRefIndex) + Vector(-20, 20 + 60)

        local ef = Isaac.Spawn(1000,6,0, 
        salon.EnterPos - Vector(0,42), Vector(0,0), nil)
        local spr = ef:GetSprite()
        spr:Load("gfx/grid/door_01_normaldoor.anm2", true) 
        spr:Play("Opened", true)
        spr.FlipY = true
        ef:AddEntityFlags(EntityFlag.FLAG_RENDER_WALL)
        ef:Update()

        local grid = room:GetGridEntityFromPos(salon.EnterPos)
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

            keep:GetSprite():Play("idle", true)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.HStyles.salon.NewRoom)

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
            NoWall = level:GetCurrentRoomDesc().Flags & RoomDescriptor.FLAG_NO_WALLS
        }
        local crds = level:GetCurrentRoomDesc()
        crds.Flags = crds.Flags | RoomDescriptor.FLAG_NO_WALLS

        salon.Entered = true
        for i = 0, game:GetNumPlayers()-1 do
            local player = Isaac.GetPlayer(i)

            player.GridCollisionClass = 0
            player.Position = salon.TopLeftPos + Vector(40 * 3 + 20 , 40 * 2 - 10 )
            player.ControlsCooldown = math.max(16, player.ControlsCooldown)
        end

        salon.Alpha = 0

        if not salon.BGentPtr or not salon.BGentPtr.Ref then
            local bg = Isaac.Spawn(1000,salon.BGEntVar,0, Vector(0,-100), Vector(0,0), nil)
            bg.SortingLayer = SortingLayer.SORTING_DOOR
            bg.Color = Color(1,1,1,0)

            salon.BGentPtr = EntityPtr(bg)
        end
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
        end
        --salon.Alpha = 0
        Options.CameraStyle = salon.ReturnSettings.CameraStyle
        if salon.ReturnSettings.NoWall then
            local crds = game:GetLevel():GetCurrentRoomDesc()
            crds.Flags = crds.Flags - RoomDescriptor.FLAG_NO_WALLS
        end

        salon.Entered = false

        salon.ReturnSettings = {}
    end
end

do
    local framecheck
    function mod.HStyles.salon.RenderRoom(_, ent)
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
                    if mod.StyleMenu.TargetPlayer then
                        --tar = mod.StyleMenu.TargetPlayer.Position + Vector(Isaac.GetScreenWidth()/4 * Wtr,0)
                    else
                        tar = salon.TopLeftPos+Vector(40*6+0,40*4+0)
                        salon.CameraFocusPos = salon.CameraFocusPos * 0.8 + (tar) * 0.2
                        room:GetCamera():SetFocusPosition(salon.CameraFocusPos)
                    end
                    --salon.CameraFocusPos = salon.CameraFocusPos * 0.8 + (tar) * 0.2
                    --room:GetCamera():SetFocusPosition(salon.CameraFocusPos)
                end

                salon.bg:Render( Isaac.WorldToScreen(salon.TopLeftPos) )

                local corpos = Isaac.GetPlayer().Position - salon.TopLeftPos
                local index = corpos.X // 40 + corpos.Y // 40 * 11
                Isaac.RenderText(tostring(index),50,50,1,1,1,1)
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
                    end
                else
                    pushVec = pushVec - angleVecP[i]:Resized(pushpower)
                    topush = true
                end
            end
        end

        if topush then
            local vec = player.Velocity
            local angle = pushVec:GetAngleDegrees()
            local rotvec = vec:Rotated(-angle)

            player.Position = ps +  pushVec 
       
            local lenght = vl:Length()
           
            player.Velocity = Vector( math.max(0, rotvec.X ), rotvec.Y ):Rotated(angle)
        end
    end
end











------------       поиск респрайтов       -------------

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

local function FindResprites(modfoldername, resources, path, costumepath, playerid, nullid, CostumeSheep, anm2, modd)
    local hairpath = "mods/" .. modfoldername .. path
    local res = pcall(Renderer.LoadImage, hairpath)
    if res then
        local fullCostumeSheep = "mods/" .. modfoldername .. "/" .. resources .. "/" .. CostumeSheep
        local tab = {
            TargetCostume = {ID = nullid, Type = ItemType.ITEM_NULL},
            TailCostumeSheep = fullCostumeSheep,
            ReplaceCostumeSheep = fullCostumeSheep,
            NullposRefSpr = GenSprite(anm2),
            SkinFolderSuffics = "mods/" .. modfoldername  .. costumepath,
        }
        --print(modfoldername, "|", "mods/" .. modfoldername .. "/" .. resources .. tab.TailCostumeSheep)
        tab.NullposRefSpr:ReplaceSpritesheet(0, 
            "mods/" .. modfoldername .. "/" .. resources .. "/" .. tab.TailCostumeSheep)
        tab.NullposRefSpr:LoadGraphics()
        
        mod.HStyles.AddStyle(modfoldername .. "-" .. playerid .. "-" .. CostumeSheep, playerid, tab,
            {
                --modfolder = "", -- "mods/" .. modfoldername .. "/" .. resources,
                --useDirectTailCostumeSheepForIcon = true,
                menuHintText = GetStr("frommod") .. modd.name -- .. " sggsgssggssg sggssggsgsgsgs",
            })
    end
end


CachedModXMLData = CachedModXMLData or {}

for i=0, XMLData.GetNumEntries(XMLNode.MOD) do
    local mod = XMLData.GetEntryById(XMLNode.MOD, i)
    if mod then
        if not CachedModXMLData[i] then
            CachedModXMLData[i] = {}
            local cache = CachedModXMLData[i]
            for i,k in pairs(mod) do
                if i ~= "description" then
                    --print(i,k)
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


function epf.PonyTailFunc(player, HairData, StartPos, scale, headpos)
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
        local precur = tail1[i-1]
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
        cur[2] = cur[2] + Vector(0,.8*scale * (scretch/defscretch) * ( cdat.Mass/10 ))
        if precur then
            --print(i, lerp, cur[2] , precur[2]*lerp*.2*scale * (scretch/defscretch) * ( cdat.Mass/10 ) )
            --cur[2] = cur[2] * .8 + precur[2]*lerp*.2*scale * (scretch/defscretch) * ( cdat.Mass/10 )
            local prepust = precur[2]*lerp*scale * (scretch/defscretch) * ( cdat.Mass/10 )
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
            --print(i, (1-lerp), "|", vel)
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


function epf.HoholockTailFunc(player, HairData, StartPos, scale, headpos)
    local cdat = HairData
    local tail1 = HairData
    local plpos1 = StartPos
    local scretch = cdat.Scretch
    local Mmass = 10 / cdat.Mass   --/ 10

    local headdir = player:GetHeadDirection()
    local headpospushpower = headdir == 0 and -115 or headdir == 2 and -65 or headdir == 1 and -105 or -75

    for i=0, #tail1 do
        local mass = Mmass * i --(#tail1 - i)
        local prep, nextp
        local cur = tail1[i]
        local precur = tail1[i-1]
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

            cur[2] = cur[2] + Vector(0,.8*scale * (scretch/defscretch) * ( cdat.Mass/10 ))

            local preangle
            if i == 0 then
                preangle = headpospushpower
            elseif i == 1 then
                preangle = (prep - plpos1 ):GetAngleDegrees()
            else
                preangle = (prep - tail1[i-2][1]):GetAngleDegrees()
            end


            local curangle = (lpos - prep):GetAngleDegrees()

            local addvec = Vector.FromAngle(preangle):Resized(i == 0 and 5 or i==1 and 1 or 1) * scale
            if i==0 then
                cur[2] = cur[2] * .5 + addvec * .5
            else
                cur[2] = cur[2] + addvec
            end
            
            if i == 2 then
                cdat.Cord:GetSprite().FlipX = curangle < -100 or curangle > 100
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
            --print(i, (1-lerp), "|", vel)
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
    end
end 

function epf.PonyTailFuncHard(player, HairData, StartPos, scale, headpos)
    local cdat = HairData
    local tail1 = HairData
    local plpos1 = StartPos
    local scretch = cdat.Scretch
    local Mmass = 10 / cdat.Mass   --/ 10

    local headdir = player:GetHeadDirection()
    local headpospushpower = .8

    local dotnum = #tail1

    for i=0, dotnum do
        local mass = Mmass * (dotnum-i+1)*5 --(#tail1 - i)
        local prep, nextp
        local cur = tail1[i]
        local precur = tail1[i-1]
        local lpos = cur[1]

        local srch = cur[3]
        if i == 0 then
            prep = plpos1 --+(plpos1-lpos):Resized(scretch*.7)
            --scretch = 0
        else
            prep = tail1[i-1][1]
        end
        
        local lerp =  i==0 and .98 or i==1 and .7 or i==2 and 0.5 or 0.4     --1 - ((i+1)/dotnum)   --1 - (.12 * mass )
        
        cur[2] = cur[2] + Vector(0,.8*scale * (scretch/defscretch) * ( mass ))
        if precur then
            
            --cur[2] = cur[2] * .8 + precur[2]*lerp*.2*scale * (scretch/defscretch) * ( cdat.Mass/10 )
            local prepust = precur[2]*lerp*scale * (scretch/defscretch) * ( cdat.Mass/10 )
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

        if headpos then
            headpos = headpos + Vector(0,-5)
            local lerp = (.3 * (#tail1 - i) )
            local bttdis = lpos:Distance(headpos)/scale
            
            local vel = (lpos - headpos):Resized(math.max(0,headsize*0.8-bttdis)*.25)
           
            cur[2] = cur[2] *.8 + vel* headpospushpower* ((i+1)/dotnum) * mass/10 --lerp
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