local mod = BethHair

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

function mod.SetHairStyleData(player, playerType, style_data)
    mod.HairLib.SetHairData(playerType,  style_data)
end

function mod.HairPreInit(_, player)
    local ptype = player:GetPlayerType()
    local pladat = HairStylesData.playerdata[ptype]
    if pladat then
        local data = player:GetData()
        if data._PhysHair_HairStyle then
            local stdata = HairStylesData.styles[data._PhysHair_HairStyle]
            if stdata then
                mod.SetHairStyleData(player,ptype, stdata.data)
                mod.HStyles.UpdateMainHairSprite(player, data, stdata)
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

function mod.HStyles.SetStyleToPlayer(player, style_name)
    if player and style_name then
        local stdata = HairStylesData.styles[style_name]
        if stdata then
            --mod.SetHairStyleData(ptype, stdata)
            local data = player:GetData()
            data._PhysHair_HairStyle = style_name
            mod.HairLib.InitHairData(player)
            
            mod.HStyles.UpdateMainHairSprite(player, data, stdata)
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
    print(stdata.data.NullposRefSpr)
    if sheep and tarcost then
        data._PhysHairExtra.DefCostumetSheetPath = {}
        local dcsp = data._PhysHairExtra.DefCostumetSheetPath

        local pos = 0
        for i, csd in pairs(player:GetCostumeSpriteDescs()) do
            local conf = csd:GetItemConfig()
            if tarcost.ID == conf.ID and (not tarcost.Type or tarcost.Type == conf.Type) then
                if not tarcost.pos or tarcost.pos == pos then
                    local cspr = csd:GetSprite()
                    print( sheep:GetFilename() )
                    cspr:Load(sheep:GetFilename(), true)

                    for i=0, cspr:GetLayerCount()-1 do
                        print(i, cspr:GetLayer(i):GetSpritesheetPath())
                    end

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
    local stdata = HairStylesData.styles[player:GetData()._PhysHair_HairStyle]
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
mod:AddCallback(mod.HairLib.Callbacks.PRE_COLOR_CHANGE, mod.HStyles.BodyColorTracker)







local Isaac = Isaac
local game = Game()
local Room 
local Wtr = 20/13

local maxcoord = 4
local scretch = math.ceil(5* Wtr)-- 30/(maxcoord+1)
local defscretch = scretch
local headsize = 20* Wtr

----------------- extra phys

mod.extraPhysFunc = {}
local epf = mod.extraPhysFunc



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
            
            local vel = (prep-lpos):Resized(math.max(-1,bttdis-scretch*lerp))
            
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