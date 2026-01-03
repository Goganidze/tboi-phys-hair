local mod = BethHair

local Wtr = 20/13
local defscretch = math.ceil(5* Wtr)
local headsize = 20* Wtr
local maxcoord = 4
local scretch = math.ceil(5* Wtr)-- 30/(maxcoord+1)

local defaultmodfolder = mod.GamePath .. "mods/" .. mod.Foldername .. "/resources"

local function BeamR(anm2, anim, layername, bool1, bool2, points)
    local spr = Sprite()
    mod.CordsSprites[anm2..anim] = spr
    spr:Load(anm2, true)
    spr:PlayOverlay(anim)
    spr:Play(anim)
    return Beam(spr, layername, bool1, bool2, points)
end

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










    function mod.HairLib.EveheavyHairPhys(player, TailData, HairData, StartPos, headpos, scale)
        local plpos1 = StartPos
        local scretch = TailData.Scretch
        local Mmass = 10 / TailData.Mass   --/ 10
        local Bounce = TailData.Bounce or 1

        local headdir = player:GetHeadDirection()
        local headpospushpower = (headdir == 1 or headdir == 2) and .8 or 1.9
    
        for i=0, #TailData do
            local mass = Mmass * i --(#tail1 - i)
            local prep, nextp
            local cur = TailData[i]
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
    
            cur[2] = cur[2] + Vector(0,.8*scale * (scretch/defscretch) * ( TailData.Mass/10 * lerp))
            if prep then
                local bttdis = lpos:Distance(prep)
                
                if bttdis > scretch*3 then
                    cur[1] = prep-(prep-lpos):Resized(scretch*3*scale)
                    --lpos = cur[1]
                    --bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
                end
                
                --local vel = (prep-lpos):Resized(math.max(-1, (bttdis+(math.max(0, bttdis-scretch) * Bounce)) - scretch*lerp))
                local vel = (prep-lpos):Resized(math.max(-1, bttdis * Bounce - scretch*lerp))
                
                cur[2] = (cur[2]* lerp + vel * (1-lerp))
                --cur[2] = cur[2] * 0.2 + vel * .8
            end
            if nextp then
                --local bttdis = lpos:Distance(nextp)
    
                --if bttdis > scretch*3 then
                    --cur[1] = nextp-(nextp-lpos):Resized(scretch*1*scale)
                    --lpos = cur[1]
                    --bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
                --end

                --local velic = Vector(1,0):Rotated( (nextpos - data._JudasFezFakeCord.pos[i]):GetAngleDegrees() ):Resized( math.max(0,(nextpos:Distance(data._JudasFezFakeCord.pos[i])-Stretch)*0.10) ) --0.07
                --local vel = (nextp-lpos):Resized(bttdis-cdat.scretch)
                --cur[2] = (cur[2] + vel)* .68
                --cur[2] = cur[2]  + vel * .1
            end
    
            if headpos then
                headpos = headpos + Vector(0,-15)
                local lerp = (.3 * (#TailData - i) )
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

    function mod.HairLib.SlightlyheavyHairPhys(player, TailData, HairData, StartPos, headpos, scale)
        local plpos1 = StartPos
        local scretch = TailData.Scretch
        local Mmass = 10 / TailData.Mass   --/ 10
        local Bounce = TailData.Bounce or 1

        local headdir = player:GetHeadDirection()
        local headpospushpower = (headdir == 1 or headdir == 2) and .8 or 1.9
    
        for i=0, #TailData do
            local mass = Mmass * (0.3 + i * 0.7) --(#tail1 - i)
            local prep, nextp
            local cur = TailData[i]
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
    
            cur[2] = cur[2] + Vector(0,.8*scale * (scretch/defscretch) * ( TailData.Mass/10 * lerp))
            if prep then
                local bttdis = lpos:Distance(prep)
                
                if bttdis > scretch*3 then
                    cur[1] = prep-(prep-lpos):Resized(scretch*3*scale)
                    --lpos = cur[1]
                    --bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
                end
                
                --local vel = (prep-lpos):Resized(math.max(-1, (bttdis+(math.max(0, bttdis-scretch) * Bounce)) - scretch*lerp))
                local vel = (prep-lpos):Resized(math.max(-1, bttdis * Bounce - scretch*lerp))
                
                cur[2] = (cur[2]* lerp + vel * (1-lerp))
                --cur[2] = cur[2] * 0.2 + vel * .8
            end
            if nextp then
                --local bttdis = lpos:Distance(nextp)
    
                --if bttdis > scretch*3 then
                    --cur[1] = nextp-(nextp-lpos):Resized(scretch*1*scale)
                    --lpos = cur[1]
                    --bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
                --end

                --local velic = Vector(1,0):Rotated( (nextpos - data._JudasFezFakeCord.pos[i]):GetAngleDegrees() ):Resized( math.max(0,(nextpos:Distance(data._JudasFezFakeCord.pos[i])-Stretch)*0.10) ) --0.07
                --local vel = (nextp-lpos):Resized(bttdis-cdat.scretch)
                --cur[2] = (cur[2] + vel)* .68
                --cur[2] = cur[2]  + vel * .1
            end
    
            if headpos then
                headpos = headpos + Vector(0,-15)
                local lerp = (.3 * (#TailData - i) )
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



--#region cords

mod.HairCordSpr = Sprite()
local HairCordSpr = mod.HairCordSpr
--HairCordSpr:Load("gfx/893.000_ball and chain.anm2", true)
HairCordSpr:Load("gfx/characters/costumes/bethhair_cord.anm2", true)
HairCordSpr:PlayOverlay("cord")
HairCordSpr:Play("cord")
mod.HairCord = Beam(HairCordSpr, "body", false, false, 3)
local cordSpr = mod.HairCord

mod.HairCordSprB = Sprite()
local HairCordSprB = mod.HairCordSprB
HairCordSprB:Load("gfx/characters/costumes/bethhair_cord.anm2", true)
HairCordSprB:PlayOverlay("cord")
HairCordSprB:Play("cord")
HairCordSprB:ReplaceSpritesheet(0, "gfx/characters/costumes/bethBhairs_cord.png", true)
mod.HairCordB = Beam(HairCordSprB, "body", true, false, 3)
local cordSprB = mod.HairCordB

mod.BethBBackHair = Sprite()
local BethBBackHair = mod.BethBBackHair
BethBBackHair:Load("gfx/characters/bethanyHair_back.anm2", true)
BethBBackHair:Play(BethBBackHair:GetDefaultAnimation())

mod.BethBackHair_def = GenSprite("gfx/characters/bethanyHair_back.anm2", "HeadDown")
mod.BethBackHair_def:ReplaceSpritesheet(0, "gfx/characters/costumes/Bethhair_back.png", true)
mod.BethHeadShadowMask = GenSprite("gfx/characters/bethanyHair_back.anm2", "HeadDown")
mod.BethHeadShadowMask:ReplaceSpritesheet(0, "gfx/characters/costumes/character_001x_bethshair_headmask.png", true)
mod.BethHeadShadowMask:Update()
mod.BethHeadShadowMask:SetCustomShader("shaders/PhysHairCuttingShadderReverse")
mod.BethShadowCord = BeamR("gfx/characters/costumes/bethhair_cord.anm2", 
    "cord", "body", false, false, 3)
mod.BethShadowCord:GetSprite():ReplaceSpritesheet(0, "gfx/characters/costumes/bethhairs_cordshadow.png", true)

--#endregion

local headDirToRender1 = {
    [3] = 2, -- 3 << 1,
    [0] = 2, --2 << 1,
    [1] = 3, --3 << 1,
    [2] = 3, --1 << 1
}
local headDirToRender2 = {
    [3] = 2, -- 3 << 1,
    [0] = 3, --2 << 1,
    [1] = 3, --3 << 1,
    [2] = 2, --1 << 1
}




--mod.HairLib.SetHairData(PlayerType.PLAYER_BETHANY, {
mod.HStyles.AddStyle("BethDef", PlayerType.PLAYER_BETHANY, {
        HeadBack2Spr = mod.BethBackHair_def,
        --CordSpr = cordSpr,
        --TailCount = 2,
        --RenderLayers = headDirToRender,
        --CostumeNullposes = {"bethshair_cord1","bethshair_cord2"},
        TargetCostume = {ID = NullItemID.ID_BETHANY, Type = ItemType.ITEM_NULL},
        --ReplaceCostumeSuffix = "_notails",    --"gfx/characters/costumes/character_001x_bethshair_notails.png",
        SkinFolderSuffics = "resources/gfx/characters/costumes/",
        ReplaceCostumeSheep = "gfx/characters/costumes/character_001x_bethshair_notails.png",
        TailCostumeSheep = "resources/gfx/characters/costumes/character_001x_bethshair.png",
        NullposRefSpr = GenSprite(mod.GamePath .. "mods/".. mod.Foldername ..  "/resources/gfx/characters/character_001x_bethanyhead.anm2"),
        HeadShadowLayer = {[1]=1,[2]=1, mask = mod.BethHeadShadowMask},
        [1] = {
            CordSpr = cordSpr,
            ShadowCordSpr = mod.BethShadowCord,
            ShadowRenderLayers = {[3]=2,[0]=0,[1]=0,[2]=0},
            RenderLayers = headDirToRender1,
            CostumeNullpos = "bethshair_cord1",
            Scretch = scretch * 0.7,
            Length = 28,
            CS = {[0]=12,17,23,28},
        },
        [2] = {
            CordSpr = cordSpr,
            ShadowCordSpr = mod.BethShadowCord,
            ShadowRenderLayers = {[3]=2,[0]=0,[1]=0,[2]=0},
            RenderLayers = headDirToRender2,
            CostumeNullpos = "bethshair_cord2",
            Scretch = scretch * 0.7,
            Length = 28,
            CS = {[0]=12,17,23,28},
        },
    }, {})

mod.BethPonyTailCord = BeamR("gfx/characters/costumes/beth_styles/ponytail/bethhair_ponytail_cord.anm2", "cord", "body", false, false, 3)
mod.BethPonyNullPos = Sprite()
mod.BethPonyNullPos:Load("gfx/characters/costumes/beth_styles/ponytail/bethanyhead_ponytail.anm2", true)

mod.HStyles.AddStyle("BethPonyTail", PlayerType.PLAYER_BETHANY, {
    --CordSpr = cordSpr,
    --TailCount = 2,
    --RenderLayers = headDirToRender,
    --CostumeNullposes = {"bethshair_cord1","bethshair_cord2"},
    TargetCostume = {ID = NullItemID.ID_BETHANY, Type = ItemType.ITEM_NULL},
    ReplaceCostumeSheep = "gfx/characters/costumes/beth_styles/ponytail/character_001x_bethshair_ponytail_notails.png",
    TailCostumeSheep = "gfx/characters/costumes/beth_styles/ponytail/character_001x_bethshair_ponytail.png",
    NullposRefSpr = mod.BethPonyNullPos,
    SkinFolderSuffics = "gfx/characters/costumes/beth_styles/ponytail/",
    [1] = {
        CordSpr = mod.BethPonyTailCord,
        RenderLayers = { [3] = 1, [0] = 3, [1] = 3, [2] = 3 },
        CostumeNullpos = "bethshair_cord1",
        Length = 30,
        Scretch = scretch * 1.2,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
       --- Mass = 12,
        CS = {[0]=10,17, 23, 30}
    },
}, {modfolder = defaultmodfolder,
    CustomCharPortrait = "gfx/characters/costumes/beth_styles/ponytail/charactermenu.png"
})

    -- lowtails

mod.BethLowTailsCord = BeamR("gfx/characters/costumes/beth_styles/lowtwotail/bethhair_lowtails_cord.anm2", "cord", "body", false, false, 3)
mod.BethLowTailsCord2 = BeamR("gfx/characters/costumes/beth_styles/lowtwotail/bethhair_lowtails_cord.anm2", "cord2", "body", false, false, 3)
mod.BethLowTailsNullPos = Sprite()
mod.BethLowTailsNullPos:Load("gfx/characters/costumes/beth_styles/lowtwotail/bethanyhead_lowtails.anm2", true)
do
    local l =  mod.BethLowTailsCord:GetSprite():GetLayer(0)
    l:SetCropOffset(Vector(1,l:GetCropOffset().Y))
end



mod.BethBackHair_lowtails = Sprite()
local BethBackHair_lowtails = mod.BethBackHair_lowtails  
BethBackHair_lowtails:Load("gfx/characters/bethanyHair_back.anm2", true)
BethBackHair_lowtails:Play(BethBackHair_lowtails:GetDefaultAnimation())
BethBackHair_lowtails:ReplaceSpritesheet(0, "gfx/characters/costumes/beth_styles/lowtwotail/lowtails_notails_back.png", true)


mod.HStyles.AddStyle("BethLowTails", PlayerType.PLAYER_BETHANY, {
    --CordSpr = cordSpr,
    --TailCount = 2,
    --RenderLayers = headDirToRender,
    --CostumeNullposes = {"bethshair_cord1","bethshair_cord2"},  
    HeadBackSpr = BethBackHair_lowtails,
    TargetCostume = {ID = NullItemID.ID_BETHANY, Type = ItemType.ITEM_NULL},
    ReplaceCostumeSheep = "gfx/characters/costumes/beth_styles/lowtwotail/character_001x_bethshair_lowtails_notails.png",
    TailCostumeSheep = "gfx/characters/costumes/beth_styles/lowtwotail/character_001x_bethshair_lowtails.png",
    NullposRefSpr = mod.BethLowTailsNullPos,
    SkinFolderSuffics = "gfx/characters/costumes/beth_styles/lowtwotail/",
    [1] = {
        CordSpr = mod.BethLowTailsCord,
        RenderLayers = { [3] = 3, [0] = 1, [1] = 3, [2] = 3 },
        CostumeNullpos = "bethshair_cord1",
        DotCount = 2,
       -- Length = 15,
        StartHeight = 1,
        Scretch = scretch * 0.95,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        Mass = 11,
        StartOffset = 2.5,
        CS = {[0]=7,15}
    },
    [2] = {
        CordSpr = mod.BethLowTailsCord2,
        RenderLayers = { [3] = 3, [0] = 3, [1] = 3, [2] = 1 },
        CostumeNullpos = "bethshair_cord2",
        Length = 15,
        DotCount = 2,
        Scretch = scretch * 0.95,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        Mass = 11,
        StartHeight = 1,
        StartOffset = 2.5,
        CS = {[0]=7,15}
    },
}, {modfolder = defaultmodfolder,
    CustomCharPortrait = "gfx/characters/costumes/beth_styles/lowtwotail/charactermenu.png"
    })


    --- oneside

mod.BethOneSideCord = BeamR("gfx/characters/costumes/beth_styles/oneside/bethhair_oneside_cord.anm2", "cord", "body", false, false, 3)
mod.BethOneSideNullPos = Sprite()
mod.BethOneSideNullPos:Load("gfx/characters/costumes/beth_styles/oneside/bethanyhead_oneside.anm2", true)

local BethBackHair_oneside = Sprite()
BethBackHair_oneside:Load("gfx/characters/bethanyHair_back.anm2", true)
BethBackHair_oneside:Play(BethBackHair_oneside:GetDefaultAnimation())
BethBackHair_oneside:ReplaceSpritesheet(0, "gfx/characters/costumes/beth_styles/oneside/oneside_notails_back.png", true)

mod.HStyles.AddStyle("BethOneSideTail", PlayerType.PLAYER_BETHANY, {
    --CordSpr = cordSpr,
    --TailCount = 2,
    --RenderLayers = headDirToRender,
    --CostumeNullposes = {"bethshair_cord1","bethshair_cord2"},
    HeadBack2Spr = BethBackHair_oneside,
    TargetCostume = {ID = NullItemID.ID_BETHANY, Type = ItemType.ITEM_NULL},
    ReplaceCostumeSheep = "gfx/characters/costumes/beth_styles/oneside/character_001x_bethshair_oneside_notails.png",
    TailCostumeSheep = "gfx/characters/costumes/beth_styles/oneside/character_001x_bethshair_oneside.png",
    NullposRefSpr = mod.BethOneSideNullPos,
    SkinFolderSuffics = "gfx/characters/costumes/beth_styles/oneside/",
    --ExtraAnimHairLayer = "gfx/characters/costumes/beth_styles/oneside/character_hair_layer.png",
    [1] = {
        CordSpr = mod.BethOneSideCord,
        RenderLayers = { [3] = 3, [0] = 2, [1] = 3, [2] = 3 },
        CostumeNullpos = "bethshair_cord1",
        Length = 24,
        Scretch = scretch * 1.1,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        Mass = 15.5,
        StartHeight = -1,
        --CS = {[0]=3,10,15}
    },
}, {
    modfolder = defaultmodfolder,
    CustomCharPortrait = "gfx/characters/costumes/beth_styles/oneside/charactermenu.png"
})


----                drill tail


mod.BethDrillTailCord = BeamR("gfx/characters/costumes/beth_styles/drilltail/bethhair_drilltail_cord.anm2", "cord", "body", false, false, 3)
mod.BethDrillTailCord2 = BeamR("gfx/characters/costumes/beth_styles/drilltail/bethhair_drilltail_cord.anm2", "cord2", "body", false, false, 3)
mod.BethDrillTailNullPos = Sprite()
mod.BethDrillTailNullPos:Load("gfx/characters/costumes/beth_styles/drilltail/bethanyhead_drilltail.anm2", true)

mod.HStyles.AddStyle("BethDrillTail", PlayerType.PLAYER_BETHANY, {
    --HeadBack2Spr = BethBackHair_oneside,
    TargetCostume = {ID = NullItemID.ID_BETHANY, Type = ItemType.ITEM_NULL},
    ReplaceCostumeSheep = "gfx/characters/costumes/beth_styles/drilltail/character_001x_bethshair_drilltail_notails.png",
    TailCostumeSheep = "gfx/characters/costumes/beth_styles/drilltail/character_001x_bethshair_drilltail.png",
    NullposRefSpr = mod.BethDrillTailNullPos,
    SkinFolderSuffics = "gfx/characters/costumes/beth_styles/drilltail/",
    --ExtraAnimHairLayer = "gfx/characters/costumes/beth_styles/drilltail/character_hair_layer.png",
    SyncWithCostumeBodyColor = true,
    [1] = {
        CordSpr = BeamR("gfx/characters/costumes/beth_styles/drilltail/bethhair_drilltail_cord.anm2", "cord", "body", false, false, 3), -- mod.BethDrillTailCord,
        RenderLayers = { [3] = 3, [0] = 1, [1] = 3, [2] = 3 },
        CostumeNullpos = "bethshair_cord1",
        --DotCount = 2,
        Length = 31,
        StartHeight = 1,
        Scretch = scretch * 1.35,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        Mass = 13,
        CS = {[0]=9,15,22, 31}
    },
    [2] = {
        CordSpr =  BeamR("gfx/characters/costumes/beth_styles/drilltail/bethhair_drilltail_cord.anm2", "cord2", "body", false, false, 3), --mod.BethDrillTailCord2,
        RenderLayers = { [3] = 3, [0] = 3, [1] = 3, [2] = 1 },
        CostumeNullpos = "bethshair_cord2",
        Length = 31,
        Scretch = scretch * 1.35,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        StartHeight = 1,
        Mass = 13,
        CS = {[0]=9,15,22, 31}
    },
}, {
    modfolder = defaultmodfolder,
    CustomCharPortrait = "gfx/characters/costumes/beth_styles/drilltail/charactermenu.png"
})



--                           спущенные волосы

mod.BethNoTailCords = {
    ["1"] = BeamR("gfx/characters/costumes/beth_styles/notail/bethhair_cord.anm2", 
    "cord", "body", false, false, 3),
    ["1b"] = BeamR("gfx/characters/costumes/beth_styles/notail/bethhair_cord.anm2", 
    "cordb", "body", false, false, 3),
    ["2"] = BeamR("gfx/characters/costumes/beth_styles/notail/bethhair_cord.anm2", 
    "cord2", "body", false, false, 3),
    ["2b"] = BeamR("gfx/characters/costumes/beth_styles/notail/bethhair_cord.anm2", 
    "cord2b", "body", false, false, 3),
    ["3"] = BeamR("gfx/characters/costumes/beth_styles/notail/bethhair_cord.anm2", 
    "cord3", "body", false, false, 3),
    ["4"] = BeamR("gfx/characters/costumes/beth_styles/notail/bethhair_cord.anm2", 
    "cord4", "body", false, false, 3),
    ["5"] = BeamR("gfx/characters/costumes/beth_styles/notail/bethhair_cord.anm2", 
    "cord5", "body", false, false, 3),
    ["6"] = BeamR("gfx/characters/costumes/beth_styles/notail/bethhair_cord.anm2", 
    "cord6", "body", false, false, 3),
    ["6b"] = BeamR("gfx/characters/costumes/beth_styles/notail/bethhair_cord.anm2", 
    "cord6b", "body", false, false, 3),
}

mod.BethNoTailNullPos = Sprite()
mod.BethNoTailNullPos:Load("gfx/characters/costumes/beth_styles/notail/bethanyhead.anm2", true)

mod.HStyles.AddStyle("BethNoTails", PlayerType.PLAYER_BETHANY, {
    --HeadBack2Spr = BethBackHair_oneside,
    TargetCostume = {ID = NullItemID.ID_BETHANY, Type = ItemType.ITEM_NULL},
    ReplaceCostumeSheep = "gfx/characters/costumes/beth_styles/notail/character_001x_bethshair_notail.png",
    TailCostumeSheep = "gfx/characters/costumes/beth_styles/notail/character_001x_bethshair.png",
    NullposRefSpr = mod.BethNoTailNullPos,
    SkinFolderSuffics = "gfx/characters/costumes/beth_styles/notail/",
    --ExtraAnimHairLayer = "gfx/characters/costumes/beth_styles/drilltail/character_hair_layer.png",

    {
        CordSpr = mod.BethNoTailCords["3"],
        RenderLayers = { [3] = 3, [0] = 3, [1] = 3, [2] = 3 },
        CostumeNullpos = "bethshair_cord_tail",
        DotCount = 3,
        Length = 18,
        StartHeight = 1,
        Scretch = scretch * 1.,
        PhysFunc = mod.extraPhysFunc.HoholockTailFunc,
        Mass = 6,
        CS = {[0]=6,10,13}
    },

    --[[{
        CordSpr = mod.BethNoTailCords["1b"],
        RenderLayers = { [3] = 2, [0] = 0, [1] = 0, [2] = 2 },
        CostumeNullpos = "bethshair_cord1",
        DotCount = 2,
        Length = 20,
        StartHeight = 1,
        Scretch = scretch * 1.5,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        Mass = 6,
        CS = {[0]=8,15}
    },]]
    {
        CordSpr = mod.BethNoTailCords["1"],
        RenderLayers = { [3] = 3, [0] = 0, [1] = 0, [2] = 3 },
        CostumeNullpos = "bethshair_cord1",
        DotCount = 2,
        Length = 20,
        StartHeight = 1,
        Scretch = scretch * 1.5,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        Mass = 6,
        CS = {[0]=10,17}
    },
    --[[{
        CordSpr = mod.BethNoTailCords["2b"],
        RenderLayers = { [3] = 2, [0] = 2, [1] = 0, [2] = 0 },
        CostumeNullpos = "bethshair_cord2",
        DotCount = 2,
        Length = 20,
        StartHeight = 1,
        Scretch = scretch * 1.5,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        Mass = 6,
        CS = {[0]=8,15}
    },]]
    {
        CordSpr = mod.BethNoTailCords["2"],
        RenderLayers = { [3] = 3, [0] = 3, [1] = 0, [2] = 0 },
        CostumeNullpos = "bethshair_cord2",
        DotCount = 2,
        Length = 16,
        StartHeight = 1,
        Scretch = scretch * 1.2,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        Mass = 6,
        CS = {[0]=9 ,14}
    },
    {
        CordSpr = mod.BethNoTailCords["4"],
        RenderLayers = { [3] = 0, [0] = 2, [1] = 0, [2] = 2 },
        CostumeNullpos = "bethshair_cord3",
        DotCount = 2,
        Length = 15,
        StartHeight = 1,
        Scretch = scretch * 0.7,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        Mass = 12,
        CS = {[0]=8,12, 17}
    },

    {
        CordSpr = mod.BethNoTailCords["5"],
        RenderLayers = { [3] = 0, [0] = 0, [1] = 3, [2] = 0 },
        CostumeNullpos = "bethshair_cord4",
        DotCount = 3,
        Length = 21,
        StartHeight = 1,
        Scretch = scretch * 1.0,
        PhysFunc = mod.extraPhysFunc.PonyTailFuncHard,
        Mass = 42,
        CS = {[0]=8,13,17}
    },
    --[[{
        CordSpr = mod.BethNoTailCords["6b"],
        RenderLayers = { [3] = 0, [0] = 0, [1] = 2, [2] = 0 },
        CostumeNullpos = "bethshair_cord5",
        DotCount = 4,
        Length = 21,
        StartHeight = 1,
        Scretch = scretch * 1.0,
        PhysFunc = mod.extraPhysFunc.PonyTailFuncHard,
        Mass = 30,
        CS = {[0]=3,9,16,21, 25}
    },]]
    {
        CordSpr = mod.BethNoTailCords["6"],
        RenderLayers = { [3] = 0, [0] = 0, [1] = 3, [2] = 0 },
        CostumeNullpos = "bethshair_cord5",
        DotCount = 4,
        Length = 24,
        StartHeight = 1,
        Scretch = scretch * 1.0,
        PhysFunc = mod.extraPhysFunc.PonyTailFuncHard,
        Mass = 30,
        --CS = {[0]=3,9,13,20}
    },

}, {
    modfolder = defaultmodfolder,
    CustomCharPortrait = "gfx/characters/costumes/beth_styles/notail/charactermenu.png"
})








function mod.extraPhysFunc.BethHairStyles_PreUpdate(_, player, hairInfo)
    local data = player:GetData()
    local spr = player:GetSprite()
    --local PHSdatas = data._PhysHair_HairStyle
    --if PHSdatas then
        local HairStyle = hairInfo.StyleName  --  PHSdatas[0] and PHSdatas[0].StyleName
        if HairStyle and hairInfo[1] then
            if HairStyle == "BethPonyTail" then
                local spranim = spr:GetOverlayAnimation()
                local cordspr = hairInfo[1].CordSpr:GetSprite()     -- mod.BethPonyTailCord:GetSprite()
                if spranim == "HeadRight" then
                    cordspr.FlipX = true
                else
                    cordspr.FlipX = false
                end
                cordspr:Play(spranim == "HeadLeft" and "cord3" or spranim == "HeadRight" and "cord2" or "cord", true)
            elseif HairStyle == "BethOneSideTail" then
                local spranim = spr:GetOverlayAnimation()
                local cordspr = hairInfo[1].CordSpr:GetSprite() -- mod.BethOneSideCord:GetSprite()
                if spranim == "HeadUp" or spranim == "HeadLeft" then
                    cordspr.FlipX = true
                else
                    cordspr.FlipX = false
                end
            elseif HairStyle == "BethDrillTail" then
                local spranim = spr:GetOverlayAnimation()
                --local cordspr = mod.BethDrillTailCord:GetSprite()
                --local cordspr2 = mod.BethDrillTailCord2:GetSprite()
                local cordspr = hairInfo[1].CordSpr:GetSprite()
                local cordspr2 = hairInfo[2].CordSpr:GetSprite()
                if spranim == "HeadUp" then
                    cordspr:Play("cordb")
                    cordspr2:Play("cordb2")
                else
                    cordspr:Play("cord")
                    cordspr2:Play("cord2")
                end
            elseif HairStyle == "BethNoTails" then
                local spranim = spr:GetOverlayAnimation()
                local cordspr = hairInfo[4].CordSpr:GetSprite()  -- mod.BethNoTailCords["4"]:GetSprite()
                if spranim == "HeadLeft" then
                    cordspr.FlipX = true
                else
                    cordspr.FlipX = false
                end
            end
        end
    --end
end
mod:AddCallback(mod.HairLib.Callbacks.HAIRPHYS_PRE_UPDATE, mod.extraPhysFunc.BethHairStyles_PreUpdate, PlayerType.PLAYER_BETHANY)

--#endregion

--mod.HairLib.SetHairData(PlayerType.PLAYER_BETHANY_B, {
mod.HStyles.AddStyle("BethBDef", PlayerType.PLAYER_BETHANY_B, {
        --CordSpr = cordSprB,
        --TailCount = 2,
        --RenderLayers = headDirToRender,
        --CostumeNullposes = {"bethshair_cord1","bethshair_cord2"},
        HeadBack2Spr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_BETHANY_B, Type = ItemType.ITEM_NULL},
        --ReplaceCostumeSuffix = "_notails",    --"gfx/characters/costumes/character_018b_bethshair_notails.png",
        SkinFolderSuffics = "gfx/characters/costumes/",
        ReplaceCostumeSheep = "gfx/characters/costumes/character_018b_bethshair_notails.png",
        TailCostumeSheep = "gfx/characters/costumes/character_018b_bethshair.png",
        NullposRefSpr = GenSprite(mod.GamePath .. "mods/".. mod.Foldername ..  "/resources/gfx/characters/character_b16_bethany.anm2"),
        [1] = {
            Scretch = scretch * 0.7,
            CordSpr = cordSprB,
            RenderLayers = headDirToRender1,
            CostumeNullpos = "bethshair_cord1",
        },
        [2] = {
            Scretch = scretch * 0.7,
            CordSpr = cordSprB,
            RenderLayers = headDirToRender2,
            CostumeNullpos = "bethshair_cord2",
        },
    }, {modfolder = "resources"} ) --{modfolder = "mods/" .. mod.Foldername .. "/resources"})


--#region EVE стили

    mod.EveCordSpr = Sprite()
    local EveCordSpr = mod.EveCordSpr
    EveCordSpr:Load("gfx/characters/costumes/evehair_cord.anm2", true)
    EveCordSpr:PlayOverlay("cord")
    EveCordSpr:Play("cord")
    mod.EveHairCord = Beam(EveCordSpr, "body", true, false, 3)
    local EveHairCord = mod.EveHairCord

    mod.EveCordSpr2 = Sprite()
    local EveCordSpr2 = mod.EveCordSpr2
    EveCordSpr2:Load("gfx/characters/costumes/evehair_cord.anm2", true)
    EveCordSpr2:PlayOverlay("cord2")
    EveCordSpr2:Play("cord2")
    mod.EveHairCord2 = Beam(EveCordSpr2, "body", true, false, 3)
    local EveHairCord2 = mod.EveHairCord2

    local EveheadDirToRender = {
        [3] = 3, -- 3 << 1,
        [0] = 2, --2 << 1,
        [1] = 3, --3 << 1,
        [2] = 3, --1 << 1
    }
    local EveheadDirToRender2 = {
        [3] = 3, -- 3 << 1,
        [0] = 3, --2 << 1,
        [1] = 1, --3 << 1,
        [2] = 3, --1 << 1
    }
    local EveheadDirToRender3 = {
        [3] = 3, -- 3 << 1,
        [0] = 2, --2 << 1,
        [1] = 3, --3 << 1,
        [2] = 3, --1 << 1
    }


--mod.HairLib.SetHairData(PlayerType.PLAYER_EVE, {
mod.HStyles.AddStyle("EveDef", PlayerType.PLAYER_EVE, {
        --CordSpr = cordSprB,
        --TailCount = 2,
        --RenderLayers = headDirToRender,
        --CostumeNullposes = {"bethshair_cord1","bethshair_cord2"},
        --HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_EVE, Type = ItemType.ITEM_NULL},
        --ReplaceCostumeSuffix = "_notails",    --"gfx/characters/costumes/character_005_evehead_notails.png",
        SyncWithCostumeBodyColor = true,

        SkinFolderSuffics = "resources/gfx/characters/costumes/",
        ReplaceCostumeSheep = "gfx/characters/costumes/character_005_evehead_notails.png",
        TailCostumeSheep = "resources/gfx/characters/costumes/character_005_evehead.png",
        NullposRefSpr = GenSprite(mod.GamePath .. "mods/".. mod.Foldername ..  "/resources/gfx/characters/character_005_evehead.anm2"),


        [2] = {
            Scretch = scretch * 1.4,
            DotCount = 3,
            CordSpr = EveHairCord,
            RenderLayers = EveheadDirToRender,
            CostumeNullpos = "evehair_cord1",
            Mass = 30,
            PhysFunc = mod.HairLib.EveheavyHairPhys,
            StartHeight = 5,
        },
        [3] = {
            Scretch = scretch * 0.4 ,
            CordSpr = EveHairCord2,
            RenderLayers = EveheadDirToRender2,
            CostumeNullpos = "evehair_cord2",
            DotCount = 1,
            Length = 12,
            StartHeight = 4,
            Mass = 25,
            CS = {[-1]=5,[0]=12,12}
        },
        [1] = {
            Scretch = scretch * 1.0,
            CordSpr = EveHairCord,
            RenderLayers = EveheadDirToRender3,
            CostumeNullpos = "evehair_cord3",
            Mass = 79,
            StartHeight = 3,
            PhysFunc = mod.HairLib.EveheavyHairPhys,
        },
    }, {modfolder = nil}) --resources

    mod.HStyles.AddStyle("EvePonyTail", PlayerType.PLAYER_EVE, {
        --HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_EVE, Type = ItemType.ITEM_NULL},
        SyncWithCostumeBodyColor = true,
        SkinFolderSuffics = "gfx/characters/costumes/eve_styles/ponytail/",
        ReplaceCostumeSheep = "gfx/characters/costumes/eve_styles/ponytail/character_005_evehead_notail.png",
        TailCostumeSheep = "gfx/characters/costumes/eve_styles/ponytail/character_005_evehead.png",
        NullposRefSpr = GenSprite("gfx/characters/costumes/eve_styles/ponytail/evehead_ponytail.anm2"),
        [1] = {
            Scretch = scretch * 1.2,
            DotCount = 3,
            CordSpr = BeamR("gfx/characters/costumes/eve_styles/ponytail/evehair_tail_cord.anm2", 
                "cord", "body", false, false, 3),
            RenderLayers = { [3] = 0, [0] = 3, [1] = 0, [2] = 3 },
            CostumeNullpos = "bethshair_cord1",
            StartHeight = 1,
            Length = 27,
            Mass = 13,
            PhysFunc = mod.HairLib.EveheavyHairPhys,
            PreUpdate = function(player, taildata)
                local spranim = player:GetSprite():GetOverlayAnimation()
                local cordspr = taildata.CordSpr:GetSprite()
                if spranim == "HeadLeft" then
                    cordspr.FlipX = true
                else
                    cordspr.FlipX = false
                end
                local curanim = cordspr:GetAnimation()
                if spranim == "HeadUp" and curanim ~= "cord2" then
                    cordspr:Play("cord2")
                elseif spranim ~= "HeadUp" and curanim == "cord2" then
                    cordspr:Play("cord")
                end
            end,
            Bounce = 0.5,
        },
        [2] = {
            Scretch = scretch * 1.3,
            DotCount = 4,
            CordSpr = BeamR("gfx/characters/costumes/eve_styles/ponytail/evehair_tail_cord.anm2", 
                "cord2", "body", false, false, 3),
            RenderLayers = { [3] = 0, [0] = 0, [1] = 3, [2] = 0 },
            CostumeNullpos = "bethshair_cord1",
            StartHeight = 1,
            Length = 31,
            Mass = 15,
            PhysFunc = mod.HairLib.EveheavyHairPhys,
            CS = {[0]=31/4*1, 31/4*2, 31/4*3}
        }
    },
    {modfolder = defaultmodfolder,
        CustomCharPortrait = "gfx/characters/costumes/eve_styles/ponytail/charactermenu.png"
    })

    mod.HStyles.AddStyle("EveICANTWRITEAGOODFEMALECHARACTER", PlayerType.PLAYER_EVE, {
        --HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_EVE, Type = ItemType.ITEM_NULL},
        SyncWithCostumeBodyColor = true,
        SkinFolderSuffics = "gfx/characters/costumes/eve_styles/icantwritegoodfemalecharacter/",
        ReplaceCostumeSheep = "gfx/characters/costumes/eve_styles/icantwritegoodfemalecharacter/character_005_evehead.png",
        TailCostumeSheep = "gfx/characters/costumes/eve_styles/icantwritegoodfemalecharacter/character_005_evehead.png",
    },
    {modfolder = defaultmodfolder,
    CustomCharPortrait = "gfx/characters/costumes/eve_styles/icantwritegoodfemalecharacter/charactermenu.png" })
    
    mod.HStyles.AddStyle("EveMiku", PlayerType.PLAYER_EVE, {
        HeadBack2Spr = GenSprite("gfx/characters/costumes/eve_styles/miku/backhair.anm2", "HeadDown"),
        TargetCostume = {ID = NullItemID.ID_EVE, Type = ItemType.ITEM_NULL},
        SyncWithCostumeBodyColor = true,
        SkinFolderSuffics = "gfx/characters/costumes/eve_styles/miku/",
        ReplaceCostumeSheep = "gfx/characters/costumes/eve_styles/miku/character_005_evehead_notail.png",
        TailCostumeSheep = "gfx/characters/costumes/eve_styles/miku/character_005_evehead.png",
        NullposRefSpr = GenSprite("gfx/characters/costumes/eve_styles/miku/evehead_mikutail.anm2"),
        [1] = {
            Scretch = scretch * 2,
            DotCount = 3,
            CordSpr = BeamR("gfx/characters/costumes/eve_styles/miku/evehair_tail_cord.anm2", 
                "cord", "body", false, false, 3),
            RenderLayers = { [3] = 2, [0] = 0, [1] = 3, [2] = 2 },
            CostumeNullpos = "bethshair_cord1",
            StartHeight = 2,
            Length = 31,
            Mass = 13,
            PhysFunc = mod.HairLib.EveheavyHairPhys,
            PreUpdate = function(player, taildata)
                local spranim = player:GetSprite():GetOverlayAnimation()
                local cordspr = taildata.CordSpr:GetSprite()

                local curanim = cordspr:GetAnimation()
                if (spranim == "HeadLeft" or spranim == "HeadRight") and curanim ~= "cord2" then
                    cordspr:Play("cord2")
                elseif spranim ~= "HeadLeft" and spranim ~= "HeadRight" and curanim == "cord2" then
                    cordspr:Play("cord")
                end
            end,
            Bounce = 0.5,
            CS = {[0]=31/3*1, 31/3*2, 31/3*3},
            --StartOffset = 2,
        },
        [2] = {
            Scretch = scretch * 2,
            DotCount = 3,
            CordSpr = BeamR("gfx/characters/costumes/eve_styles/miku/evehair_tail_cord.anm2", 
                "cordb", "body", false, false, 3),
            RenderLayers = { [3] = 2, [0] = 2, [1] = 3, [2] = 0 },
            CostumeNullpos = "bethshair_cord2",
            StartHeight = 2,
            Length = 31,
            Mass = 13,
            PhysFunc = mod.HairLib.EveheavyHairPhys,
            PreUpdate = function(player, taildata)
                local spranim = player:GetSprite():GetOverlayAnimation()
                local cordspr = taildata.CordSpr:GetSprite()
                
                local curanim = cordspr:GetAnimation()
                if (spranim == "HeadLeft" or spranim == "HeadRight") and curanim ~= "cord2b" then
                    cordspr:Play("cord2b")
                elseif spranim ~= "HeadLeft" and spranim ~= "HeadRight" and curanim == "cord2b" then
                    cordspr:Play("cordb")
                end
            end,
            Bounce = 0.5,
            CS = {[0]=31/3*1, 31/3*2, 31/3*3}
        },
    },
    {modfolder = defaultmodfolder,
    CustomCharPortrait = "gfx/characters/costumes/eve_styles/miku/charactermenu.png" })

--#endregion 



    ------------ САМСОН ----------------

    mod.HStyles.AddStyle("SamsonFlatTop", PlayerType.PLAYER_SAMSON, {
        --HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_SAMSON, Type = ItemType.ITEM_NULL},
        SyncWithCostumeBodyColor = true,
        SkinFolderSuffics = "gfx/characters/costumes/samson_styles/flattop/",
        ReplaceCostumeSheep = "gfx/characters/costumes/samson_styles/flattop/character_007_samsonshairandbandanna.png",
        TailCostumeSheep = "gfx/characters/costumes/samson_styles/flattop/character_007_samsonshairandbandanna.png",
        ItemCostumeAlts = {
            {ID = CollectibleType.COLLECTIBLE_BLOODY_LUST,
            gfx="gfx/characters/costumes/samson_styles/flattop/costume_081_bloodylust.png",
            anm2 = "gfx/characters/costumes/samson_styles/157_blood lust.anm2"},
        },
    },
    {modfolder = defaultmodfolder, 
        CustomCharPortrait = "gfx/characters/costumes/samson_styles/flattop/charactermenu.png"
    })

    mod.HStyles.AddStyle("SamsonStallone", PlayerType.PLAYER_SAMSON, {
        --HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_SAMSON, Type = ItemType.ITEM_NULL},
        SyncWithCostumeBodyColor = true,
        SkinFolderSuffics = "gfx/characters/costumes/samson_styles/stallone/",
        ReplaceCostumeSheep = "gfx/characters/costumes/samson_styles/stallone/character_007_samsonshairandbandanna.png",
        TailCostumeSheep = "gfx/characters/costumes/samson_styles/stallone/character_007_samsonshairandbandanna.png",
        ItemCostumeAlts = {
            {ID = CollectibleType.COLLECTIBLE_BLOODY_LUST, 
            gfx="gfx/characters/costumes/samson_styles/stallone/costume_081_bloodylust.png",
            anm2 = "gfx/characters/costumes/samson_styles/157_blood lust.anm2"},
        },
    },
    {modfolder = defaultmodfolder,
        CustomCharPortrait = "gfx/characters/costumes/samson_styles/stallone/charactermenu.png"
    })

    mod.HStyles.AddStyle("SamsonRazormiss", PlayerType.PLAYER_SAMSON, {
        --HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_SAMSON, Type = ItemType.ITEM_NULL},
        SyncWithCostumeBodyColor = true,
        SkinFolderSuffics = "gfx/characters/costumes/samson_styles/razormiss/",
        ReplaceCostumeSheep = "gfx/characters/costumes/samson_styles/razormiss/character_007_samsonshairandbandanna.png",
        TailCostumeSheep = "gfx/characters/costumes/samson_styles/razormiss/character_007_samsonshairandbandanna.png",
        ItemCostumeAlts = {
            {ID = CollectibleType.COLLECTIBLE_BLOODY_LUST, 
            gfx="gfx/characters/costumes/samson_styles/razormiss/costume_081_bloodylust.png",
            anm2 = "gfx/characters/costumes/samson_styles/157_blood lust.anm2"},
        },
    },
    {modfolder = defaultmodfolder, 
        CustomCharPortrait = "gfx/characters/costumes/samson_styles/razormiss/charactermenu.png"})

    mod.HStyles.AddStyle("SamsonRebirth", PlayerType.PLAYER_SAMSON, {
        --HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_SAMSON, Type = ItemType.ITEM_NULL},
        SyncWithCostumeBodyColor = true,
        SkinFolderSuffics = "gfx/characters/costumes/samson_styles/rebirth/",
        ReplaceCostumeSheep = "gfx/characters/costumes/samson_styles/rebirth/character_007_samsonshairandbandanna.png",
        TailCostumeSheep = "gfx/characters/costumes/samson_styles/rebirth/character_007_samsonshairandbandanna.png",
    },
    {modfolder = defaultmodfolder, })

    mod.HStyles.AddStyle("SamsonRonin", PlayerType.PLAYER_SAMSON, {
        --HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_SAMSON, Type = ItemType.ITEM_NULL},
        SyncWithCostumeBodyColor = true,
        SkinFolderSuffics = "gfx/characters/costumes/samson_styles/ronin/",
        ReplaceCostumeSheep = "gfx/characters/costumes/samson_styles/ronin/character_007_samsonshairandbandanna_notails.png",
        TailCostumeSheep = "gfx/characters/costumes/samson_styles/ronin/character_007_samsonshairandbandanna.png",
        ItemCostumeAlts = {
            {ID = CollectibleType.COLLECTIBLE_BLOODY_LUST, 
            gfx="gfx/characters/costumes/samson_styles/ronin/costume_081_bloodylust.png",
            anm2 = "gfx/characters/costumes/samson_styles/157_blood lust.anm2"}
        },

        NullposRefSpr = GenSprite("gfx/characters/costumes/samson_styles/ronin/samsonhead_ronin.anm2"),
        
        {
            Scretch = scretch * 1.4,
            DotCount = 4,
            CordSpr = BeamR("gfx/characters/costumes/samson_styles/ronin/samsonhair_ronin_cord.anm2", 
                "cord4", "body", false, false, 3),
            RenderLayers = { [3] = 0, [0] = 2, [1] = 3, [2] = 2 },
            CostumeNullpos = "bethshair_cord2",
            StartHeight = 5,
            Length = 36,
            Mass = 7,
            PhysFunc = mod.HairLib.EveheavyHairPhys,
            PreUpdate = function(player, taildata)
                local spranim = player:GetSprite():GetOverlayAnimation()
                local cordspr = taildata.CordSpr:GetSprite()

                cordspr.FlipX = spranim == "HeadRight"
                local hairvel = taildata[3][2] + Vector(0, -0.01)
                
                cordspr.PlaybackSpeed = math.min(1, hairvel:Length()/3)
                cordspr:Update()
            end,
            Bounce = 0.8,
            CS = {[0]=36/4*1.5, 36/4*2.5, 36/4*3.5, 36/4*4}
        },
        {
            Scretch = scretch * 1.55,
            DotCount = 3,
            CordSpr = BeamR("gfx/characters/costumes/samson_styles/ronin/samsonhair_ronin_cord.anm2", 
                "cord", "body", false, false, 3),
            RenderLayers = { [3] = 2, [0] = 3, [1] = 3, [2] = 3 },
            CostumeNullpos = "bethshair_cord1",
            StartHeight = 0,
            Length = 27,
            Mass = 23,
            PhysFunc = mod.HairLib.EveheavyHairPhys,
            PreUpdate = function(player, taildata)
                local spranim = player:GetSprite():GetOverlayAnimation()
                local cordspr = taildata.CordSpr:GetSprite()

                local curanim = cordspr:GetAnimation()
                if (spranim == "HeadLeft" or spranim == "HeadRight") then
                    if curanim ~= "cord2" then
                        cordspr:Play("cord2")
                    end
                    cordspr.FlipX = spranim == "HeadLeft"
                elseif spranim == "HeadDown" and curanim ~= "cord" then
                    cordspr:Play("cord")
                    cordspr.FlipX = false
                elseif spranim == "HeadUp" and curanim ~= "cord3" then
                    cordspr:Play("cord3")
                    cordspr.FlipX = false
                end
            end,
            Bounce = 0.4,
            --CS = {[0]=27/3*1, 27/3*2, 27/3*3}
        },


    },
    {modfolder = defaultmodfolder, 
        CustomCharPortrait = "gfx/characters/costumes/samson_styles/ronin/charactermenu.png"})






    ------------ АЗАЗЕЛЬ ----------------

    mod.HStyles.AddStyle("AzazelSlicked", PlayerType.PLAYER_AZAZEL, {
        --HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_AZAZEL, Type = ItemType.ITEM_NULL, pos = 1},
        SyncWithCostumeBodyColor = true,
        SkinFolderSuffics = "gfx/characters/costumes/azazel_styles/slicked/",
        ReplaceCostumeSheep = "gfx/characters/costumes/azazel_styles/slicked/character_008_azazelhead.png",
        TailCostumeSheep = "gfx/characters/costumes/azazel_styles/slicked/character_008_azazelhead.png",
    },
    {modfolder = defaultmodfolder,
    CustomCharPortrait = "gfx/characters/costumes/azazel_styles/slicked/charactermenu.png" })

    mod.HStyles.AddStyle("AzazelPunk", PlayerType.PLAYER_AZAZEL, {
        --HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_AZAZEL, Type = ItemType.ITEM_NULL, pos = 1},
        SyncWithCostumeBodyColor = true,
        SkinFolderSuffics = "gfx/characters/costumes/azazel_styles/punk/",
        ReplaceCostumeSheep = "gfx/characters/costumes/azazel_styles/punk/character_008_azazelhead.png",
        TailCostumeSheep = "gfx/characters/costumes/azazel_styles/punk/character_008_azazelhead.png",
    },
    {modfolder = defaultmodfolder,
    CustomCharPortrait = "gfx/characters/costumes/azazel_styles/punk/charactermenu.png" }) 




    ------------- ЛИЛИТ --------------

    do
        --local cordspr = GenSprite("gfx/characters/costumes/lilith_styles/smol imp/lilith_cord.anm2", "cord")
        --local cordspr2 = GenSprite("gfx/characters/costumes/lilith_styles/smol imp/lilith_cord.anm2", "cord")
        local cordspr = BeamR("gfx/characters/costumes/lilith_styles/smol imp/lilith_cord.anm2", "cord", "body", false, false, 2)
        local cordspr2 = BeamR("gfx/characters/costumes/lilith_styles/smol imp/lilith_cord.anm2", "cordb", "body", false, false, 2)
        --cordspr2:GetSprite().FlipX = true
        mod.HStyles.AddStyle("LilithSmolImp", PlayerType.PLAYER_LILITH, {
            TargetCostume = {ID = NullItemID.ID_LILITH, Type = ItemType.ITEM_NULL},
            --SyncWithCostumeBodyColor = true,
            SkinFolderSuffics = "gfx/characters/costumes/lilith_styles/smol imp/",
            ReplaceCostumeSheep = "gfx/characters/costumes/lilith_styles/smol imp/character_014_lilithhair_notails.png",
            TailCostumeSheep = "gfx/characters/costumes/lilith_styles/smol imp/character_014_lilithhair.png",
            NullposRefSpr = GenSprite("gfx/characters/costumes/lilith_styles/smol imp/lilithhead.anm2"),
            {
                CordSpr = cordspr,
                RenderLayers = { [3] = 2, [0] = 1, [1] = 3, [2] = 3 },
                CostumeNullpos = "bethshair_cord1",
                DotCount = 1,
                Length = 18,
                StartHeight = 0,
                Scretch = scretch * 1.15,
                --PhysFunc = mod.HairLib.SlightlyheavyHairPhys,
                Mass = 15,
                --CS = {[0]=8,18},
                StartOffset = 5,
                PreUpdate = function(player, taildata)
                    local spranim = player:GetSprite():GetOverlayAnimation()
                    local cordspr = taildata.CordSpr:GetSprite()    --taildata.Cord:GetSprite()
    
                    local curanim = cordspr:GetAnimation()
                    if (spranim == "HeadLeft" or spranim == "HeadRight") then
                        if curanim ~= "cord2" then    --if curanim:sub(0,-1) ~= "2" then
                            cordspr:Play("cord2")
                        end
                        --cordspr.FlipX = spranim == "HeadLeft"
                    elseif (spranim == "HeadDown" or spranim == "HeadUp") and curanim ~= "cord" then
                        cordspr:Play("cord")
                        --cordspr.FlipX = false
                    end
                end,
            },
            {
                CordSpr = cordspr2,
                RenderLayers = { [3] = 2, [0] = 3, [1] = 3, [2] = 1 },
                CostumeNullpos = "bethshair_cord2",
                DotCount = 1,
                Length = 18,
                Scretch = scretch * 1.15,
                --PhysFunc = mod.HairLib.SlightlyheavyHairPhys,
                StartHeight = 0,
                Mass = 15,
                --CS = {[0]=8,18},
                StartOffset = 5,
                PreUpdate = function(player, taildata)
                    local spranim = player:GetSprite():GetOverlayAnimation()
                    local cordspr = taildata.CordSpr:GetSprite()
    
                    local curanim = cordspr:GetAnimation()
                    if (spranim == "HeadLeft" or spranim == "HeadRight") then
                        if curanim ~= "cordb2" then    --if curanim:sub(0,-1) ~= "2" then
                            cordspr:Play("cordb2")
                        end
                        --cordspr.FlipX = spranim == "HeadLeft"
                    elseif (spranim == "HeadDown" or spranim == "HeadUp") and curanim ~= "cordb" then
                        cordspr:Play("cordb")
                        --cordspr.FlipX = false
                    end
                end,
            },
        },
        {modfolder = defaultmodfolder,
        CustomCharPortrait = "gfx/characters/costumes/lilith_styles/smol imp/charactermenu.png" })
    end
































-------------------------------

local getsmkcrd = function(tailData, sprCoord)
    sprCoord = sprCoord or tailData[1][3]
    --[[if tailData[1].cstRot then
        local next = sprCoord + 16
        --if next >= 64 then
        --    tailData[0].cstRot = nil
        --end
        return next, next >= 48
    else
        local next = sprCoord - 16
        --if next <= 0 then
        --    tailData[0].cstRot = true
        --end
        return next, next <= 0
    end]]
    return (sprCoord+16) % 64, false
end


mod.HairLib.SmokePhys = function(player, HairData, StartPos, scale, headpos)
    local cdat = HairData
    local tail1 = HairData
    local plpos1 = StartPos
    local scretch = cdat.Scretch
    local Mmass = 10 / cdat.Mass   --/ 10
    local Bounce = cdat.Bounce or 1

    --local headdir = player:GetHeadDirection()
    --local headpospushpower = (headdir == 1 or headdir == 2) and .8 or 1.9

    if not HairData.CustomInit then
        HairData.CustomInit = true
        local rng = RNG(Isaac.GetFrameCount(), 35)
        HairData.rng = rng
        for i=0, 1 do
            tail1[i] = { 
                StartPos, Vector(rng:RandomFloat()*2-1,-1), 64/2 * i,
                c = Color(1,1,1,1 + (4-i)*0.1),
                cmulti = 1,
                sc = HairData.StartWidth,
                init = true,
            }
        end
    end

    for i=0, #tail1 do
    --for i,k in pairs(tail1) do
        local mass = Mmass * i --(#tail1 - i)
        local prep, nextp
        ---@type TailData
        local cur = tail1[i]
        local lpos = cur[1]

        if not cur.init then
            local rng = HairData.rng
            cur[2] = Vector(rng:RandomFloat()*.8-0.9,-0.86)
            cur.c = Color(1,1,1,1)
            cur.cmulti = 1
            cur.sc = HairData.StartWidth
            cur.init = true
        end

        local Ldis = StartPos:Distance(lpos)
        if i > 0 then
            cur.c.A = math.max(0,  cur.c.A - 0.02 * (1+Ldis/30) ) --* i
        end
        --print(i, cur.alpha)

        cur[1] = cur[1] + Vector(cur[2].X * math.min(1.5, Ldis / 30), cur[2].Y )

        --[[local bttdis = cur[1]:Distance(prep)
        if bttdis > scretch then
            cur[1] = prep-(prep-cur[1]):Resized(scretch*scale)
            --lpos = cur[1]
            bttdis = scretch*scale
        end]]
        --print(i,Ldis, cur.sc)
        if i == 0 then
            cur.sc = cur.sc + 0.03
            if Ldis > 30 then
                for j = #tail1, 0, -1 do
                    --print("move", j, #tail1)
                    tail1[j+1] = tail1[j]
                end
                --local sprCoord = tail1[1][3]
                local sprCoord, cstRot = getsmkcrd(tail1)
                tail1[0] = {StartPos+Vector(0,-0), Vector(0,0), sprCoord}
                if cstRot then
                    tail1[0].cstRot = not tail1[1].cstRot
                else
                    tail1[0].cstRot = tail1[1].cstRot
                end
                tail1[0].sc = HairData.StartWidth  --* 2
                HairData.StartHeight = getsmkcrd(tail1, sprCoord) -- (tail1[0][3]-16) % 64
            end
        else
            cur.sc = cur.sc + cur.c.A / 30
        end

        if cur.c.A <= .4 then
            --cur[2].X = cur[2].X * 1.05
        end

        if i == #tail1 and cur.c.A <= 0 and tail1[i-1].c.A <= 0 then
            tail1[i] = nil
            --print("Del", i, #tail1)
            --table.insert(tail1, 0, {StartPos, Vector(0,0), 0})
            if #tail1 < 2 then
                for j = #tail1, 0, -1 do
                    --print("move", j, #tail1)
                    tail1[j+1] = tail1[j]
                end
                --local sprCoord = tail1[1][3]
                local sprCoord, cstRot = getsmkcrd(tail1)
                tail1[0] = {StartPos+Vector(0,-0), Vector(0,0), sprCoord} --(sprCoord-16) % 64
                if cstRot then
                    tail1[0].cstRot = not tail1[1].cstRot
                else
                    tail1[0].cstRot = tail1[1].cstRot
                end
                HairData.StartHeight = getsmkcrd( tail1, sprCoord) -- (tail1[0][3]-16) % 64
                tail1[0].sc = HairData.StartWidth --* 2
                --print(tail1[0][3], tail1[1][3], tail1[0].cstRot)
            end
        end
    end
end





------------    MGE    ----------------

local MGECORD = BeamR("gfx/characters/costumes/extra_styles/mge/mge_cord.anm2", 
            "cord", "body", false, false, 3)
--print(MGECORD:GetSprite():GetLayer(0):GetWrapSMode(), MGECORD:GetSprite():GetLayer(0):GetWrapTMode() )
MGECORD:GetSprite():GetLayer(0):SetWrapSMode(2)
MGECORD:GetSprite():GetLayer(0):SetWrapTMode(2)


mod.HStyles.AddStyle("MGE", -1, {
    --HeadBackSpr = BethBBackHair,
    --TargetCostume = {ID = NullItemID.ID_SAMSON, Type = ItemType.ITEM_NULL},
    --SyncWithCostumeBodyColor = true,
    --SkinFolderSuffics = "gfx/characters/costumes/extra_styles/mge/",
    ReplaceCostumeSheep = "gfx/characters/costumes/extra_styles/mge/character_001_isaachair.png",
    TailCostumeSheep = "gfx/characters/costumes/extra_styles/mge/character_001_isaachair.png",
    NullposRefSpr = GenSprite("gfx/characters/costumes/extra_styles/mge/head_mge.anm2"),
    {
        Scretch = defscretch * 2,
        DotCount = 2,
        CordSpr = MGECORD,
        RenderLayers = { [3] = 3, [0] = 0, [1] = 3, [2] = 2 },
        CostumeNullpos = "bethshair_cord1",
        StartHeight = 0,
        PhysFunc = mod.HairLib.SmokePhys,
        PreUpdate = nil,
        StartWidth = 0.3,
        --Bounce = 0.5,
        CS = {[0]=31/3*1}
    },
},
{modfolder = mod.defaultmodfolder, })

