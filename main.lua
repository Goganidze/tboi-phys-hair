
--BethHair = RegisterMod("Vifaniia s fisikoi", 1)
local backparam = {}
if BethHair then
    if not BethHair.HStyles then
        Console.PrintWarning('DISABLE "Hair (and Fez) With Physics [RGON]"')
        ImGui.PushNotification('DISABLE "Hair (and Fez) With Physics [RGON]"', ImGuiNotificationType.WARNING, 8000)
        return
    end
    if BethHair.HStyles.salon.Entered then
        backparam.InstaTeleportInSalon = true
    end
end


local mod = RegisterMod("Vifaniia s fisikoi 2", 1) -- BethHair
BethHair = mod
local BethHair = BethHair
for i,k in pairs(backparam) do
    BethHair[i] = k
end
mod.BlockedChar = {}
local Isaac = Isaac
local game = Game()
local Wtr = 20/13

local maxcoord = 4
local scretch = math.ceil(5* Wtr)-- 30/(maxcoord+1)
local headsize = 20* Wtr
mod.maxcoord = maxcoord
mod.scretch = scretch
mod.headsize = headsize

if not REPENTOGON then
        
    local font = Font()
    font:Load("font/pftempestasevencondensed.fnt")

    mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
        local text = "REPENTOGON is missing"
        local text2 = "check repentogon.com"
        font:DrawStringScaledUTF8(text, Isaac.GetScreenWidth()/1.1 - font:GetStringWidthUTF8(text)/2, Isaac.GetScreenHeight()/1.2, 1, 1, KColor(2,.5,.5,1), 1, true )
        font:DrawStringScaledUTF8(text2, Isaac.GetScreenWidth()/1.1 - font:GetStringWidthUTF8(text2)/2, Isaac.GetScreenHeight()/1.2 + 8, 1, 1, KColor(2,.5,.5,1), 1, true )
    end)

    return
end

for i=0, XMLData.GetNumEntries(XMLNode.MOD) do
    local node = XMLData.GetEntryById(XMLNode.MOD, i)
    if node and node.name == "[RGON] Small Hairstyle Pack" then
        mod.Foldername = node.realdirectory or node.directory
        mod.FullPath = node.fulldirectory:gsub("\\Repentogon", "")
        
        local a = mod.FullPath:find("mods/")
        local lasta
        for b = 1, #mod.FullPath do
            local a = mod.FullPath:find("mods/", b)
            if a then
                b = a
                lasta = a
            end
        end

        mod.GamePath = mod.FullPath:sub(1, lasta-1)
        break
    end
end


mod.HairLib = include("physhair2")

---@type _HairCordData
mod.HairLib = mod.HairLib(mod)

mod.HStyles = {
    ---@param name string
    ---@param playerid PlayerType
    ---@param data SetHairDataParam
    ---@param extradata table?
    AddStyle = function(name, playerid, data, extradata) end
}

include("hair_styles")


mod.DR = false

mod.CordsSprites = {}

include("stylesVariants")


local function BeamR(anm2, anim, layername, bool1, bool2, points)
    local spr = Sprite()
    mod.CordsSprites[anm2..anim] = spr
    spr:Load(anm2, true)
    spr:PlayOverlay(anim)
    spr:Play(anim)
    return Beam(spr, layername, bool1, bool2, points)
end

local toreset = setmetatable({}, {__mode = "k"})

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
        toreset[spr] = true
        return spr
    end
end
function mod.clearsprites()
    for i,k in pairs(toreset) do
        ---@type Sprite
        local i = i
        i:Reset()
        i:Reload()
    end
    for i,k in pairs(mod.CordsSprites) do
        k:Reset()
        k:Reload()
    end
end

local function BeamR(anm2, anim, layername, bool1, bool2, points)
    local spr = Sprite()
    mod.CordsSprites[anm2..anim] = spr
    spr:Load(anm2, true)
    spr:PlayOverlay(anim)
    spr:Play(anim)
    return Beam(spr, layername, bool1, bool2, points)
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


mod.JudasFexCordSpr = Sprite()
local JudasFexCordSpr = mod.JudasFexCordSpr
--HairCordSpr:Load("gfx/893.000_ball and chain.anm2", true)
JudasFexCordSpr:Load("gfx/characters/costumes/judasFez_cord.anm2", true)
--JudasFexCordSpr:ReplaceSpritesheet(0, "gfx/characters/costumes/judas_cord.png")
JudasFexCordSpr:LoadGraphics()
JudasFexCordSpr:PlayOverlay("cord")
JudasFexCordSpr:Play("cord")
JudasFexCordSpr.Scale.X = 1.5
mod.JudasFexCord = Beam(JudasFexCordSpr, "body", false, false, 3)
local JudasFexCord = mod.JudasFexCord

mod.JudasFexCordSprB = Sprite()
local JudasFexCordSprB = mod.JudasFexCordSprB
--HairCordSpr:Load("gfx/893.000_ball and chain.anm2", true)
JudasFexCordSprB:Load("gfx/characters/costumes/judasFez_cord.anm2", true)
JudasFexCordSprB:ReplaceSpritesheet(0, "gfx/characters/costumes/judas_cord_shadow.png")
JudasFexCordSprB:LoadGraphics()
JudasFexCordSprB:PlayOverlay("cord")
JudasFexCordSprB:Play("cord")
JudasFexCordSprB.Scale.X = 1.5
mod.JudasFexCordB = Beam(JudasFexCordSprB, "body", false, false, 3)
local JudasFexCordB = mod.JudasFexCordB



--[[local sprite = Sprite()
sprite:Load("gfx/893.000_ball and chain.anm2", true)
local chain = Beam(sprite, "chain", true, false)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
    chain:GetSprite():PlayOverlay("Chain", false)
    local center = game:GetLevel():GetCurrentRoom():GetCenterPos()
    chain:Add(Isaac.WorldToScreen(center), 1)
    chain:Add(Isaac.WorldToScreen(player.Position), 40, 1)
    chain:Render()
end)]]


local headDirToRender = {
    [3] = {3,3}, -- 3 << 1,
    [0] = {2,3}, --2 << 1,
    [1] = {3,3}, --3 << 1,
    [2] = {3,2}, --1 << 1
}
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


--mod.HasPhysHair = {
--    [PlayerType.PLAYER_BETHANY] = {cordSpr, 2, headDirToRender, {"bethshair_cord1","bethshair_cord2"}, nil},
--    [PlayerType.PLAYER_BETHANY_B] = {cordSprB, 2, headDirToRender, {"bethshair_cord1","bethshair_cord2"}, BethBBackHair},
--}
--[1] = CordSprite, [2] = TailCount, [3] = RenderLayers, [4] = CotumeNullpos, [5] = BackSprite
--local HasPhysHair = mod.HasPhysHair

--mod.HairLib = include("physhair")
--mod.HairLib = mod.HairLib(mod)

--#endregion

--#region bethany hairs


local defaultmodfolder = mod.GamePath .. "mods/" .. mod.Foldername .. "/resources"
mod.defaultmodfolder = defaultmodfolder

mod.BethBackHair_def = GenSprite("gfx/characters/bethanyHair_back.anm2", "HeadDown")
mod.BethBackHair_def:ReplaceSpritesheet(0, "gfx/characters/costumes/Bethhair_back.png", true)
mod.BethHeadShadowMask = GenSprite("gfx/characters/bethanyHair_back.anm2", "HeadDown")
mod.BethHeadShadowMask:ReplaceSpritesheet(0, "gfx/characters/costumes/character_001x_bethshair_headmask.png", true)
mod.BethHeadShadowMask:Update()
mod.BethHeadShadowMask:SetCustomShader("shaders/PhysHairCuttingShadderReverse")
mod.BethShadowCord = BeamR("gfx/characters/costumes/bethhair_cord.anm2", 
    "cord", "body", false, false, 3)
mod.BethShadowCord:GetSprite():ReplaceSpritesheet(0, "gfx/characters/costumes/bethhairs_cordshadow.png", true)

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
    --CustomCharPortrait = "gfx/characters/costumes/beth_styles/drilltail/charactermenu.png"
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
    {modfolder = defaultmodfolder, })

    mod.HStyles.AddStyle("EveICANTWRITEAGOODFEMALECHARACTER", PlayerType.PLAYER_EVE, {
        --HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_EVE, Type = ItemType.ITEM_NULL},
        SyncWithCostumeBodyColor = true,
        SkinFolderSuffics = "gfx/characters/costumes/eve_styles/icantwritegoodfemalecharacter/",
        ReplaceCostumeSheep = "gfx/characters/costumes/eve_styles/icantwritegoodfemalecharacter/character_005_evehead.png",
        TailCostumeSheep = "gfx/characters/costumes/eve_styles/icantwritegoodfemalecharacter/character_005_evehead.png",
    },
    {modfolder = defaultmodfolder, })
    
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
    {modfolder = defaultmodfolder, })

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
    {modfolder = defaultmodfolder, })

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
    {modfolder = defaultmodfolder, })

    mod.HStyles.AddStyle("AzazelPunk", PlayerType.PLAYER_AZAZEL, {
        --HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_AZAZEL, Type = ItemType.ITEM_NULL, pos = 1},
        SyncWithCostumeBodyColor = true,
        SkinFolderSuffics = "gfx/characters/costumes/azazel_styles/punk/",
        ReplaceCostumeSheep = "gfx/characters/costumes/azazel_styles/punk/character_008_azazelhead.png",
        TailCostumeSheep = "gfx/characters/costumes/azazel_styles/punk/character_008_azazelhead.png",
    },
    {modfolder = defaultmodfolder, }) 




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
        {modfolder = defaultmodfolder, })
    end













    local JudasFezheadDirToRender = {
        [3] = 3, -- 3 << 1,
        [0] = 3, --2 << 1,
        [1] = 3, --3 << 1,
        [2] = 2, --1 << 1
    }

    --mod.HairLib.SetHairData(PlayerType.PLAYER_JUDAS, {
    mod.HStyles.AddStyle("JudasDef", PlayerType.PLAYER_JUDAS, {
        TargetCostume = {ID = NullItemID.ID_JUDAS, Type = ItemType.ITEM_NULL},
        --ReplaceCostumeSuffix = "_notails",    --"gfx/characters/costumes/character_004_judasfez_notails.png",
        ReplaceCostumeSheep = "gfx/characters/costumes/character_004_judasfez_notails.png",
        TailCostumeSheep = "resources/gfx/characters/costumes/character_004_judasfez.png",
        NullposRefSpr = GenSprite(mod.GamePath .. "mods/".. mod.Foldername ..  "/resources/gfx/characters/character_004_judasfez.anm2"),
        --[[[1] = {
            DotCount = 3,
            Scretch = scretch*.75,
            Length = 13,
            CordSpr = JudasFexCord,
            RenderLayers = JudasFezheadDirToRender,
            CostumeNullpos = "judasfez_cord",
            Mass = 6,
            --sprScale = Vector(1,2),
        },]]
        --[[[1] = {
            DotCount = 0,
            Scretch = 0,
            Length = 0,
            CordSpr = JudasFexCord,
            RenderLayers = JudasFezheadDirToRender,
            CostumeNullpos = "judasfez_cord",
            Mass = 0,
            --sprScale = Vector(1,2),
        },]]
    })
    --mod.HairLib.SetHairData(PlayerType.PLAYER_JUDAS_B, {
    mod.HStyles.AddStyle("JudasBDef", PlayerType.PLAYER_JUDAS_B, {
        TargetCostume = {ID = NullItemID.ID_JUDAS_B, Type = ItemType.ITEM_NULL},
        ReplaceCostumeSheep = "gfx/characters/costumes/character_004b_judasfez_notails.png",
        TailCostumeSheep = "resources/gfx/characters/costumes/character_004_judasfez.png",
        NullposRefSpr = GenSprite(mod.GamePath .. "mods/".. mod.Foldername ..  "/resources/gfx/characters/character_004_judasfez.anm2"),
        --[[[1] = {
            DotCount = 3,
            Scretch = scretch*.75,
            Length = 13,
            CordSpr = JudasFexCordB,
            RenderLayers = JudasFezheadDirToRender,
            CostumeNullpos = "judasfez_cord",
            Mass = 6,
            --sprScale = Vector(1,2),
        },]]
        --[[[1] = {
            DotCount = 0,
            Scretch = 0,
            Length = 0,
            CordSpr = JudasFexCordB,
            RenderLayers = JudasFezheadDirToRender,
            CostumeNullpos = "judasfez_cord",
            Mass = 0,
            --sprScale = Vector(1,2),
        },]]
    })



    for i=1, (REPENTANCE_PLUS and 54 or 40) do
        local tab = {
            TargetCostume = {ID = NullItemID.ID_EDEN, Type = ItemType.ITEM_NULL},
            TailCostumeSheep = "gfx/characters/costumes/character_009_edenhair" .. i .. ".png",
            ReplaceCostumeSheep = "gfx/characters/costumes/character_009_edenhair" .. i .. ".png",
            NullposRefSpr = GenSprite("gfx/characters/character_009_edenhair1.anm2")
        }
        tab.NullposRefSpr:ReplaceSpritesheet(0, tab.TailCostumeSheep)
        tab.NullposRefSpr:LoadGraphics()
        
        mod.HStyles.AddStyle("edenstandarthair_"..i, PlayerType.PLAYER_EDEN, tab)

    end




    local stupidShit = include("oldEvilAreBack")

    stupidShit = stupidShit()

    local judasFezSpr = {
        [PlayerType.PLAYER_JUDAS] = mod.JudasFexCordSpr,
        [PlayerType.PLAYER_JUDAS_B] = mod.JudasFexCordSprB,
    }
    local judasFezStyleName = {
        ["JudasDef"] = true,
        ["JudasBDef"] = true,
    }

    function mod.JudasJunkUpdate(_, player)
        local data = player:GetData()

        if not data._JudasFezFakeCord then
        else
            
            local cdat = data.__PhysHair_HairSklad
            local playerPos = cdat and cdat.RealHeadPos
            if playerPos then
                data._JudasFezFakeCord.targetOffset = playerPos   --- Isaac.WorldToScreen(player.Position )
                    + player:GetCostumeNullPos("judasfez_cord", true, Vector(0,0))    --+ Vector(0, -0 * (player:GetSprite().Scale.Y - 1))
                local headpos = playerPos + player:GetCostumeNullPos("BethHair_headref", true, Vector(0,0)) --/ Wtr + Vector(0, -10)

                stupidShit.cordUpdate(data, player, headpos, playerPos )
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.JudasJunkUpdate)

    function mod.JudasJunkPostRender(_, player, offset)
        local data = player:GetData()
        local ptype = player:GetPlayerType()
        if not judasFezSpr[ptype] or not player:IsExtraAnimationFinished() then
            return
        end
        local hsdat = data._PhysHair_HairStyle
        hsdat = hsdat and hsdat[0]

        if not data._JudasFezFakeCord or not judasFezStyleName[hsdat and hsdat.StyleName] then
        elseif JudasFezheadDirToRender[player:GetHeadDirection()] & 1 == 1 then
            if judasFezSpr[ptype] ~= data._JudasFezFakeCord.anm2 then
                data._JudasFezFakeCord.anm2 = judasFezSpr[ptype]
            end
            --stupidShit.MegaShitReflectFix()

            
            local sklad = data.__PhysHair_HairSklad
            local playerPos = sklad and sklad.RealHeadPos
            if playerPos then
                data._JudasFezFakeCord.targetOffset = playerPos   --- Isaac.WorldToScreen(player.Position )
                    + player:GetCostumeNullPos("judasfez_cord", true, Vector(0,0))    --+ Vector(0, -0 * (player:GetSprite().Scale.Y - 1))
                local headpos = playerPos + player:GetCostumeNullPos("BethHair_headref", true, Vector(0,0)) --/ Wtr + Vector(0, -10)

                stupidShit.cordrender2(data, player, offset, headpos, playerPos )
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.JudasJunkPostRender)

    function mod.JudasJunkPreRender(_, player, offset)
        local data = player:GetData()
        if not judasFezSpr[player:GetPlayerType()] or not player:IsExtraAnimationFinished() then
            return
        end
        local hsdat = data._PhysHair_HairStyle
        hsdat = hsdat and hsdat[0]
        if not judasFezStyleName[hsdat and hsdat.StyleName] then
            return
        end
        if not data._JudasFezFakeCord then
            data._JudasFezFakeCord = {
                ["anm"] = judasFezSpr[player:GetPlayerType()],
                ["baseOffset"] = Vector(0, -8),
                ["targetOffset"] = Vector(0, -20),
                ["Stretch"] = 1.8,
                ["CordFrame"] = 0,
                ["Unit"] = 4,
                ["length"] = 12,
                ["NoZ"] = true,
                ["NoShadow"] = true,
                Reflectpos = {},
            }
            
        elseif JudasFezheadDirToRender[player:GetHeadDirection()] & 1 ~= 1 then
            
            local cdat = data._BethsHairCord
            local playerPos = cdat and cdat.RealHeadPos
            if playerPos then
                data._JudasFezFakeCord.targetOffset = playerPos   --- Isaac.WorldToScreen(player.Position )
                    + player:GetCostumeNullPos("judasfez_cord", true, Vector(0,0))    --+ Vector(0, -0 * (player:GetSprite().Scale.Y - 1))
                local headpos = playerPos + player:GetCostumeNullPos("BethHair_headref", true, Vector(0,0)) --/ Wtr + Vector(0, -10)

                stupidShit.cordrender2(data, player, offset, headpos, playerPos )
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, mod.JudasJunkPreRender)


    local function PrintTab(tab, level)
        level = level or 0
        
        if type(tab) == "table" then
            for i,k in pairs(tab) do
                local offset = ""
                if level and level>0 then
                    for j = 0, level do
                        offset = offset .. " "
                    end
                end
                print(offset .. i,k)
                if type(k) == "table" then
                    PrintTab(k, level+1)
                end
            end
        end
    end
    local DeepPrint = function(...)
        for i,k in pairs({...}) do
            if type(k) == "table" then 
                print(k)
                PrintTab(k,1)
            else
                print(k)
            end
        end
    end


    --include("stylesVariants")
    local json = require("json")

    local ShortPath = function(str)
        return string.gsub(str, mod.GamePath, "!**game**!")
    end
    local UnShortPath = function(str)
        return string.gsub(str, "!%*%*game%*%*!", mod.GamePath)
    end


    local UserdataToTab
    UserdataToTab = function(t)
        if t.X then
            ---@cast t Vector
            return {__t="vec", X=t.X, Y=t.Y}
        else
            local T = getmetatable(t)
            local Tname = T and T.__type
            if Tname == "Sprite" then
                ---@cast t Sprite
                local tab = {__t="spr", 
                    layer = {},
                    gfx = ShortPath(t:GetFilename()),
                    anim = t:GetAnimation()}

                for layerID,layer in pairs(t:GetAllLayers()) do
                    tab.layer[layerID..""] = ShortPath(layer:GetSpritesheetPath())
                end

                return tab
            elseif Tname == "Beam" then
                ---@cast t Beam
                local tab = {__t="beam",
                    spr = UserdataToTab(t:GetSprite()),
                    layer = t:GetLayer(),
                    unkbool = t:GetUnkBool()
                    }

                return tab
            elseif Tname == "Point" then
                ---@cast t Point
                return {__t="point", pos = UserdataToTab(t:GetPosition()), width = t:GetWidth(), coord = t:GetSpritesheetCoordinate() }
            end
        end
    end

    local DecodeTabUserdata
    function DecodeTabUserdata(t)
        local __type = t.__t
        if __type == "vec" then
            return Vector(t.X, t.Y)
        elseif __type == "spr" then
            local spr = GenSprite(UnShortPath(t.gfx), t.anim)
            for layerID,layer in pairs(t.layer) do
                spr:ReplaceSpritesheet(tonumber(layerID), UnShortPath(layer))
            end
            spr:LoadGraphics()
            return spr
        elseif __type == "beam" then
            local spr = DecodeTabUserdata(t.spr)
            return Beam(spr, t.layer, false, t.unkbool)
        elseif __type == "point" then
            return Point(DecodeTabUserdata(t.pos), t.coord, t.width)
        end
    end



    local DeepCopyHairInfo
    DeepCopyHairInfo = function(t)
        local copy = {}
        for i,k in pairs(t) do
            local ii = type(i) == "number" and i.."" or i
            local ktype = type(k)
            if ktype == "table" then
                copy[ii] = DeepCopyHairInfo(k)
            elseif ktype == "userdata" then
                copy[ii] = UserdataToTab(k)
            elseif ktype == "string" then
                copy[ii] = ShortPath(k)
            else
                copy[ii] = k
            end
        end
        return copy
    end

    local DeepCopyHairInfoDecode
    DeepCopyHairInfoDecode = function(t)
        local copy = {}
        for i,k in pairs(t) do
            local ii = tonumber(i) or i
            copy[ii] = k
            local ktype = type(k)
            if ktype == "table" then
                if k.__t then
                    copy[ii] = DecodeTabUserdata(k)
                else
                    copy[ii] = DeepCopyHairInfoDecode(k)
                end
            elseif ktype == "string" then
                copy[ii] = UnShortPath(k)
            end
        end
        return copy
    end


    local function updateSaveData()
        local data = {
            --OdangoMode = mod.OdangoMode,
            --Beth = mod.BlockedChar[PlayerType.PLAYER_BETHANY] and 1 or 0,
            --BethB = mod.BlockedChar[PlayerType.PLAYER_BETHANY_B] and 1 or 0,
            --Judas = mod.BlockedChar[PlayerType.PLAYER_JUDAS] and 1 or 0,
            --JudasB = mod.BlockedChar[PlayerType.PLAYER_JUDAS_B] and 1 or 0,
            --Eve = mod.BlockedChar[PlayerType.PLAYER_EVE] and 1 or 0,
        }

        data.PlayerData = {}
        data.PlayerHairInfo = {}
        for i=0, game:GetNumPlayers()-1 do
            local player = Isaac.GetPlayer(i)
            local pdata = player:GetData()
            local unickyID = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SAD_ONION):GetSeed()
            unickyID = tostring(unickyID)

            data.PlayerHairInfo[unickyID] = {}
            local phi = data.PlayerHairInfo[unickyID]

            local PHSdatas = {}
            if pdata._PhysHair_HairStyle then
                for j,k in pairs(pdata._PhysHair_HairStyle) do
                    if type(j) == "number" then
                        PHSdatas[tostring(j)] = {StyleName = k.StyleName}
                    end
                end
            end
            if pdata.__PhysHair_HairSklad then
                for j,k in pairs(pdata.__PhysHair_HairSklad) do
                    if type(j) == "number" then
                        phi[tostring(j)] = DeepCopyHairInfo(k.HairInfo)
                    end
                end
            end

            data.PlayerData[unickyID] = PHSdatas
            --{HairStyle = pdata._PhysHair_HairStyle and pdata._PhysHair_HairStyle.StyleName, HairMode = pdata._PhysHair_HairMode}

            
            mod.MainMenuStuff.RenderCharPort = nil
            mod.CustomCharPortrait = nil
            if i == 0 then
                local hsdata = mod.HStyles.GetStyleData(pdata._PhysHair_HairStyle and pdata._PhysHair_HairStyle[0] and pdata._PhysHair_HairStyle[0].StyleName)
                if hsdata and hsdata.extra then
                    data.PlayerData.CustomCharPortrait = hsdata.extra.CustomCharPortrait
                    mod.CustomCharPortrait = hsdata.extra.CustomCharPortrait
                else
                    mod.CustomCharPortrait = nil
                end
            end
        end

        local favcoded = {}
        for k,v in pairs(mod.HairStylesData.favorites) do
            favcoded[tostring(k)] = v
        end

        data.favorites = favcoded
       
        mod:SaveData( json.encode(data) )
    end

    function mod.PlayerPostInit(_, player)
        local data = player:GetData()
        if not data._PHYSHAIR_SAVELOADED then -- and player.FrameCount > 1 then
            data._PHYSHAIR_SAVELOADED = true
            if mod.SavePlayerData then
                local ptype = player:GetPlayerType()
                local unickyID = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SAD_ONION):GetSeed()
                local savePlayerData = mod.SavePlayerData[tostring(unickyID)]
                
                if savePlayerData  then
                    --for i, PHSdata in pairs(savePlayerData) do
                    --    mod.HStyles.SetStyleToPlayer(player, PHSdata.HairStyle, PHSdata.HairMode)
                    --end

                    --player:GetData()._PhysHair_HairStyle = savePlayerData.HairStyle
                end
                local savedPlayerHairInfo = mod.SavePlayerHairInfo and mod.SavePlayerHairInfo[tostring(unickyID)]

                if savedPlayerHairInfo then
                    --player:GetData().__PhysHair_HairSklad = DeepCopyHairInfoDecode(savedPlayerHairInfo)
                    local hairinfoset = DeepCopyHairInfoDecode(savedPlayerHairInfo)
                    for layer, hairInfo in pairs(hairinfoset) do
                        if type(layer) == "number" then
                            data._PhysHair_HairStyle = data._PhysHair_HairStyle or {}
                            layer = layer or 0
                            data._PhysHair_HairStyle[layer] = {StyleName = hairInfo.StyleName, PlayerType = ptype}

                            local stdata = mod.HStyles.GetStyleData(hairInfo.StyleName)
                            if stdata then
                                for i = 1, #hairInfo do
                                    if hairInfo[i] then
                                        local tailstdata = stdata.data[i]
                                        if tailstdata then
                                            if tailstdata.PhysFunc then
                                                hairInfo[i].PhysFunc = tailstdata.PhysFunc
                                            end
                                            if tailstdata.PreUpdate then
                                                hairInfo[i].PreUpdate = tailstdata.PreUpdate
                                            end
                                        end
                                    end
                                end
                            end

                            mod.HairLib.SetHairDataToPlayer(player, {
                                HairInfo = hairInfo,
                                layer = layer,
                            })

                            mod.HStyles.UpdatePlayerSkin(player, data, stdata)
                        end
                    end
                end
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.PlayerPostInit)

    --[[====

    local strings = {
        ["Bethany Odango Mode"] = {en = "Bethany Odango Mode", ru = "Режим Оданго для Вифании"},
        ["physfor"] = {en = "Physics for", ru = "Физика для"},
    }
    local function GetStr(str)
        return strings[str] and (strings[str][Options.Language] or strings[str].en) or str
    end

    local upmenuid = "ModsSettingMenu"
    local menuID = "PhysHairMenu"
    if not ImGui.ElementExists(upmenuid) then
        ImGui.CreateMenu(upmenuid, "Mods Setting")
    --end
        if ImGui.ElementExists(menuID) then
            if BethHair_SecondLoad then
                ImGui.RemoveWindow(menuID)
            else
                BethHair_SecondLoad = true
            end
        end
        if ImGui.ElementExists("BethOdangoMode") then
            ImGui.RemoveElement("BethOdangoMode")
        end
        if ImGui.ElementExists("PhysHairMenuEntry") then
            ImGui.RemoveElement("PhysHairMenuEntry")
        end
        ImGui.AddElement(upmenuid, "PhysHairMenuEntry", ImGuiElement.MenuItem, "Hair With Physics")

        ImGui.CreateWindow(menuID, "Hair With Physics")
        ImGui.LinkWindowToElement(menuID, "PhysHairMenuEntry")
        ImGui.AddCheckbox (menuID, "BethOdangoMode", GetStr("Bethany Odango Mode"), function(a) mod.OdangoMode = a updateSaveData() end, false )
        ImGui.AddText(menuID, "")
        ImGui.AddText(menuID, GetStr("physfor"))
        ImGui.AddCheckbox (menuID, "PhysHair_BethPhys","Bethany", function(a) mod.BlockedChar[PlayerType.PLAYER_BETHANY] = not a updateSaveData() end, true )
        ImGui.AddCheckbox (menuID, "PhysHair_BethBPhys","T. Bethany", function(a) mod.BlockedChar[PlayerType.PLAYER_BETHANY_B] = not a  updateSaveData() end, true )
        ImGui.AddCheckbox (menuID, "PhysHair_JudasPhys","Judas", function(a) mod.BlockedChar[PlayerType.PLAYER_JUDAS] = not a  updateSaveData() end, true )
        ImGui.AddCheckbox (menuID, "PhysHair_JudasBPhys","T. Judas", function(a) mod.BlockedChar[PlayerType.PLAYER_JUDAS_B] = not a  updateSaveData() end, true )
        ImGui.AddCheckbox (menuID, "PhysHair_EveBPhys","Eve", function(a) mod.BlockedChar[PlayerType.PLAYER_EVE] = not a updateSaveData() end, true )
    end

    ====]]

    mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, function(_, saveslot, isslotselected, rawslot)
        mod.MainMenuStuff.RenderCharPort = nil
        if mod:HasData() then
            local savedata = json.decode(mod:LoadData())

            mod.SavePlayerData = savedata.PlayerData
            mod.SavePlayerHairInfo = savedata.PlayerHairInfo

            --[[====
            mod.OdangoMode = savedata.OdangoMode
            mod.BlockedChar[PlayerType.PLAYER_BETHANY] = savedata.Beth == 1
            mod.BlockedChar[PlayerType.PLAYER_BETHANY_B] = savedata.BethB == 1
            mod.BlockedChar[PlayerType.PLAYER_JUDAS] = savedata.Judas == 1
            mod.BlockedChar[PlayerType.PLAYER_JUDAS_B] = savedata.JudasB == 1
            mod.BlockedChar[PlayerType.PLAYER_EVE] = savedata.Eve == 1

            ImGui.UpdateData("PhysHair_BethPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_BETHANY])
            ImGui.UpdateData("PhysHair_BethBPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_BETHANY_B])
            ImGui.UpdateData("PhysHair_JudasPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_JUDAS])
            ImGui.UpdateData("PhysHair_JudasBPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_JUDAS_B])
            ImGui.UpdateData("PhysHair_EveBPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_EVE])
            ====]]

            mod.CustomCharPortrait = savedata.PlayerData.CustomCharPortrait
            if mod.CustomCharPortrait then
                mod.MainMenuStuff.RenderCharPort = true
                MainMenu.GetContinueWidgetSprite():ReplaceSpritesheet(0, mod.CustomCharPortrait, true)
            end

            local favuncoded = {}
            if savedata.favorites then
                for k,v in pairs(savedata.favorites) do
                    favuncoded[tonumber(k)] = v
                end
            end

            mod.HairStylesData.favorites = favuncoded or mod.HairStylesData.favorites
        
        else
            --[[mod.BlockedChar[PlayerType.PLAYER_BETHANY] = true
            mod.BlockedChar[PlayerType.PLAYER_BETHANY_B] = true
            mod.BlockedChar[PlayerType.PLAYER_JUDAS] = true
            mod.BlockedChar[PlayerType.PLAYER_JUDAS_B] = true
            mod.BlockedChar[PlayerType.PLAYER_EVE] = true]]

            --[[====
            ImGui.UpdateData("PhysHair_BethPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_BETHANY])
            ImGui.UpdateData("PhysHair_BethBPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_BETHANY_B])
            ImGui.UpdateData("PhysHair_JudasPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_JUDAS])
            ImGui.UpdateData("PhysHair_JudasBPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_JUDAS_B])
            ImGui.UpdateData("PhysHair_EveBPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_EVE])
            ====]]
        end
    end)

    function mod.PostExitGame(shouldSave)
        mod.MainMenuStuff.RenderCharPort = nil
        if shouldSave then
            updateSaveData()
        end
        mod.MainMenuStuff.frame = #mod.MainMenuStuff.WidgedMap

        --[[local menu = MainMenu
        local widgetSpr = menu.GetContinueWidgetSprite()
        local charlayer = widgetSpr:GetLayer(0)
        if mod.CustomCharPortrait and charlayer then
            if mod.CustomCharPortrait ~= charlayer:GetSpritesheetPath() then
                --widgetSpr:ReplaceSpritesheet(0, mod.CustomCharPortrait, true)
            end
        end]]
    end

    mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.PostExitGame)
    --end


if Isaac.GetPlayer() then
    for i=0, game:GetNumPlayers() do
        Isaac.GetPlayer(i):GetData()._BethsHairCord = nil
    end
end


----------------------------------------------------

mod.MainMenuStuff = {frame = 0, state = 0, WidgedCurPos = Vector(0,0)}
local MainMenuStuff = mod.MainMenuStuff
MainMenuStuff.CharacterWidgetSpr = GenSprite("gfx/characters/costumes/beth_styles/WidgedCharPort.anm2","Character")
MainMenuStuff.WidgetPos = Vector(8 + 24, 85 + 24)

MainMenuStuff.WidgedMap = {
    [0] = Vector(-150, 0), Vector(-150, 0), Vector(-150, 0), Vector(-150, 0), 
    Vector(-200, 0), Vector(-200, 0), Vector(-160, 0), Vector(-150, 0),
    Vector(-120, 0), Vector(-55, 0), Vector(-18, 0), Vector(-6, 0), 
    Vector(-0, 0), Vector(-0, 0), Vector(0, 0) , Vector(0, 0)
}
MainMenuStuff.WidgedMapScale = {
    [0] = Vector(1, 1), Vector(1, 1), Vector(-150, 0), Vector(-150, 0), 
    Vector(-200, 0), Vector(1, 1), Vector(1.37, 0.63), Vector(1.2, 0.8),
    Vector(1.15, 0.85), Vector(1.07, .93), Vector(1.0, 1.0), Vector(0.9,1.1), 
    Vector(.8, 1.2), Vector(1.0, 1.0), Vector(1.0, 1.0) , Vector(1, 1)
}

MainMenuStuff.WidgetBGCrop = {Vector(43, 34), Vector(50, 65)}

local widgetGuideSpr = GenSprite("gfx/ui/main menu/continueprogress_widget.anm2", "Idle")
local widgetBGSpr = GenSprite("gfx/ui/main menu/continueprogress_widget.anm2", "Character")
MainMenuStuff.widgetGuideSpr = widgetGuideSpr
MainMenuStuff.widgetBGSpr = widgetBGSpr

function mod.MainMenuRender()
    if MenuManager.GetActiveMenu() == MainMenuType.GAME then
        local menuPos = Isaac.WorldToMenuPosition(MainMenuType.GAME, Vector(0,0))

        local widgetSpr = MainMenu.GetContinueWidgetSprite()
        
        local charlayer = MainMenuStuff.CharacterWidgetSpr:GetLayer(0)
        if mod.CustomCharPortrait and charlayer then
            if mod.CustomCharPortrait ~= charlayer:GetSpritesheetPath() then

                --widgetSpr:ReplaceSpritesheet(0, mod.CustomCharPortrait, true)
                MainMenuStuff.RenderCharPort = true

                MainMenuStuff.CharacterWidgetSpr:ReplaceSpritesheet(0, mod.CustomCharPortrait, true)
                MainMenuStuff.CharacterWidgetSpr:LoadGraphics()
            end
        end

        if MainMenuStuff.RenderCharPort then

            if widgetGuideSpr:GetAnimation() ~= widgetSpr:GetAnimation() then
                widgetGuideSpr:Play(widgetSpr:GetAnimation())
                widgetGuideSpr:SetFrame(widgetSpr:GetFrame())
            else
                widgetGuideSpr:SetFrame(widgetSpr:GetFrame())
            end

            local null = widgetGuideSpr:GetNullFrame("Guide")

            MainMenuStuff.WidgedCurPos = null and null:GetPos() or Vector(0,0)

            MainMenuStuff.WidgedCurScale = null and null:GetScale() or Vector(1, 1)

            --[==[
            if MainMenu.GetSelectedElement() == 1 then
                if MainMenuStuff.frameoff then
                    MainMenuStuff.frameoff = nil
                    MainMenuStuff.frame = -1
                end
                MainMenuStuff.frame = math.min(#MainMenuStuff.WidgedMap, MainMenuStuff.frame + 1)
            else
                MainMenuStuff.frame = math.max(0, MainMenuStuff.frame - 1)
                if not MainMenuStuff.frameoff then
                    MainMenuStuff.frame = #MainMenuStuff.WidgedMap
                    MainMenuStuff.frameoff = true
                end
            end
            local widgetframe = widgetSpr:GetFrame() or MainMenuStuff.frame
            MainMenuStuff.WidgedCurPos = MainMenuStuff.WidgedMap[widgetframe] or MainMenuStuff.WidgedMap[0]
            MainMenuStuff.WidgedCurScale = MainMenuStuff.WidgedMapScale[widgetframe] or MainMenuStuff.WidgedMapScale[0]
            ]==]

            local wigdedOff = widgetSpr.Offset
            local renderpos = menuPos + MainMenuStuff.WidgetPos + MainMenuStuff.WidgedCurPos + wigdedOff
            local scale = widgetSpr.Scale * MainMenuStuff.WidgedCurScale
            local crop = MainMenuStuff.WidgetBGCrop
            
            MainMenuStuff.widgetBGSpr.Scale = scale
            MainMenuStuff.CharacterWidgetSpr.Scale = scale

            MainMenuStuff.widgetBGSpr:RenderLayer(1, renderpos, crop[1], crop[2])
            MainMenuStuff.CharacterWidgetSpr:Render(renderpos)
        end
    else
        MainMenuStuff.frame = #MainMenuStuff.WidgedMap
    end
end
mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, mod.MainMenuRender) --, MainMenuType.GAME)


-----------------------------------------------------
--[[
testvec = Vector(20, 20)
local ms
local spr1 = GenSprite("gfx/001.000_player.anm2", "WalkDown")
if MultiSprite then
    ms = MultiSprite()
    ms:AddSprite(0, spr1, testvec )
    for i=1,120 do
        ms:AddSprite(i, spr1, Vector(20+(i%30)*10-150, 20+math.floor(i/30)*20-40))
    end
    ms:SetColor(Color(2,.5,.5,1))
end
SpriteBuffer = ms
GenSprite1 = GenSprite
]]


---@type wga_menu
BethHair.WGA = include("worst gui api")
local wga = BethHair.WGA

BethHair.StyleMenu = {name = "physhair_styleEditorMenu", size = Vector(230,240), misc = {},
    submenus = { EntryMenu = "physhair_styleEditorMenu_entrys" },

    hairselectoffset = Vector(30,30), hairselectsize = Vector(150, 200),
    hairselectshadowoffset = Vector(-7,7),
    hairbtnsoffset = 0,
    hinttextoffset = Vector(0,240),

    charrotateBtnL_offset = Vector(-40, 20),
    charrotateBtnR_offset = Vector(40, 20),
}
local smenu = BethHair.StyleMenu
local preMousePos = Vector(0,0)

local TestSpr = Sprite()
--HairCordSpr:Load("gfx/893.000_ball and chain.anm2", true)
TestSpr:Load("gfx/characters/costumes/bethhair_cord.anm2", true)
TestSpr:PlayOverlay("cord")
TestSpr:Play("cord")
local testcord = Beam(TestSpr, "body", false, false, 3)

local halfAlpha = Color(1,1,1,0.15)


function BethHair.StyleMenu.HUDRender()
    --[[if ms and renderms then
        local t = Isaac.GetTime()
        local vec = Vector(Isaac.GetScreenWidth()/2,Isaac.GetScreenHeight()/2) --Vector(60,60)
        --for i=1,120*20 do
        --	spr1:Render(vec-Vector(60,60))
        --end
        spr1:Update()
        local t1 = Isaac.GetTime()
        for i=1,20 do
            ms:Render(vec)
        end
        ms:SetPosRotation((t / 30) % 360)
        ms:SetRotation((t / 30) % 360)
    end]]
    --testcord:Add(Vector(10,10),0)
    --testcord:Add(Vector(190,100),30)
    --testcord:Render()

    local notpaused = not game:IsPaused()
    if notpaused then
        --wga.DetectMenuButtons(smenu.name)
        wga.MousePos = Isaac.WorldToScreen(Input.GetMousePosition(true))-game.ScreenShakeOffset
    end
	--wga.RenderMenuButtons(smenu.name)

    if notpaused then

        local pos = Isaac.WorldToScreen(Input.GetMousePosition(true))-game.ScreenShakeOffset
        --[[if wga.ControlType == wga.enum.ControlType.CONTROLLER then
            if pos:Distance(preMousePos) > 3 then
                wga.ControlType = wga.enum.ControlType.MOUSE
            end
        else
            local move = wga.input.GetRefMoveVector()
            if move:Length() > .2 then
                wga.ControlType = wga.enum.ControlType.CONTROLLER
            end
        end]]
        --preMousePos = pos

        wga.HandleWindowControl()

        --window logic
        if smenu.wind then
            if smenu.TargetPlayer and not smenu.TargetPlayer.Ref then
                smenu.TargetPlayer = nil
                wga.CloseWindow(smenu.name)
                smenu.wind = nil
                return
            end

            if wga.ControlType == wga.enum.ControlType.CONTROLLER then
                if pos:Distance(preMousePos) > 3 then
                    --wga.ControlType = wga.enum.ControlType.MOUSE
                    wga.SetControlType(wga.enum.ControlType.MOUSE, smenu.TargetPlayer and smenu.TargetPlayer.Ref:ToPlayer() )
                end
            else
                local move = wga.input.GetRefMoveVector()
                if move:Length() > .2 then
                    --wga.ControlType = wga.enum.ControlType.CONTROLLER
                    wga.SetControlType(wga.enum.ControlType.CONTROLLER, smenu.TargetPlayer and smenu.TargetPlayer.Ref:ToPlayer() )
                end
            end
            preMousePos = pos

            local wind = smenu.wind
            local player = smenu.TargetPlayer and smenu.TargetPlayer.Ref and smenu.TargetPlayer.Ref:ToPlayer()
            local keeper = smenu.TargetHairKeeper and smenu.TargetHairKeeper.Ref

            if not wind.custinit then
                wind.custinit = true
                if game:GetRoom():IsMirrorWorld() then
                    wind.pos = wind.pos + Vector(-80, 400)
                else
                    wind.pos = wind.pos + Vector(80, 400)
                end
                if player then
                    player.Velocity = Vector(0, 0)
                    player.Position = keeper.Position + Vector(-70, 2)
                end
            else
                local xshift = game:GetRoom():IsMirrorWorld() and -80 or 80
                local targetpos = Vector(Isaac.GetScreenWidth()/2+xshift, Isaac.GetScreenHeight()/2) - smenu.size/2
                wind.pos = wind.pos * 0.9 + targetpos * 0.1

                if wga.ControlType == wga.enum.ControlType.CONTROLLER then
                    local mdata = wga.GetMenu(smenu.name)
                    local btn = wga.ManualSelectedButton[1]

                    if mdata.CurCollum == 1 and btn and btn.row and smenu.scrollbtn then
                        
                        wga.DraggerSetValue(smenu.scrollbtn, btn.row / (smenu.rowcount), true)
                    end
                end

                if player then
                    local tar = player.Position + Vector(Isaac.GetScreenWidth()/4 * Wtr,0)
                    
                    local salon = BethHair.HStyles.salon
                    salon.CameraFocusPos = salon.CameraFocusPos * 0.8 + (tar) * 0.2
                    game:GetRoom():GetCamera():SetFocusPosition(salon.CameraFocusPos)
                end
            end
            
            if player then
                --player.ControlsCooldown = math.max(player.ControlsCooldown, 3)
                --local brat = player:GetOtherTwin()
                for i = 0, game:GetNumPlayers()-1 do
                    local lplayer = Isaac.GetPlayer(i)
                    if lplayer.ControllerIndex == player.ControllerIndex then
                        lplayer.ControlsCooldown = math.max(lplayer.ControlsCooldown, 3)
                    end
                end

                if Isaac.GetFrameCount() % 10 == 0 then
                    local familList = Isaac.FindInRadius(player.Position, 60, EntityPartition.FAMILIAR)
                    local playerYpos = player.Position.Y - 10
                    for i = 1, #familList do
                        local fam = familList[i]
                        if fam.Position.Y > playerYpos then
                            fam:SetColor(halfAlpha, 10, 10, false, false)
                        end
                    end
                    if mod.HStyles.salon.FakeCollision then
                        local familList = Isaac.FindByType(EntityType.ENTITY_FAMILIAR)
                        for i = 1, #familList do
                            local fam = familList[i]
                            if fam.Position:Distance(player.Position) < 60 and fam.Position.Y > playerYpos then
                                fam:SetColor(halfAlpha, 10, 10, false, false)
                            end
                        end
                    end
                end
                local playerTwin = player:GetOtherTwin()
                if playerTwin then
                    if playerTwin.Position.Y > player.Position.Y then
                        playerTwin.Position = Vector(playerTwin.Position.X,
                            player.Position.Y - playerTwin.Size - player.Size - 1)
                    end
                end
            end
            

            if wind.Removed then
                smenu.wind = nil
            end

            --[[for i,k in pairs(wind.SubMenus) do
                print(i,k, k.visible)
                local list = wga.GetButtons(i)
                if list then
                    for j,h in pairs(list) do
                        print("|||", j,h)
                    end
                end
            end]]
        end

        wga.DetectSelectedButtonActuale()
    end
			
    wga.RenderWindows()

    if wga.MouseHintText then
        local pos = wga.MousePos
        wga.RenderButtonHintText(wga.MouseHintText, pos+Vector(8,8))
    end

    wga.LastOrderRender()
    --local mw = Input.GetMouseWheel and Input.GetMouseWheel() or 0
    --local mhw = Input.GetMouseWheel and Input.GetMouseWheel(true) or 0
    --wga.DrawText(0, "MouseWheel: "..mw, 70,40, nil,nil,nil,KColor(1,1,1,1))
    --wga.DrawText(0, "MouseHWheel: "..mhw, 70,60, nil,nil,nil,KColor(1,1,1,1))
end

do
    local ActionToButtonFrame = {
        [ButtonAction.ACTION_SHOOTUP] = 0,
        [ButtonAction.ACTION_MENUCONFIRM] = 1,
        [ButtonAction.ACTION_SHOOTDOWN] = 1,
        [ButtonAction.ACTION_SHOOTRIGHT] = 2,
        [ButtonAction.ACTION_SHOOTLEFT] = 3,
        [ButtonAction.ACTION_MENUEX or -1] = 3,
        [ButtonAction.ACTION_MENUBACK] = 2,

    }
    BethHair.StyleMenu.ControllerBtnRenderList = {}
    function BethHair.StyleMenu.AddControllerBtnRender(Action, pos, scale)
        local frame = ActionToButtonFrame[Action]
        if frame then
            smenu.ControllerBtnRenderList[frame] = smenu.ControllerBtnRenderList[frame] or {}
            table.insert(smenu.ControllerBtnRenderList[frame], {pos, scale})
        end
    end
    function BethHair.StyleMenu.ClearControllerBtnRenderList()
        smenu.ControllerBtnRenderList = {}
    end
end

---@type EditorButton
local CharRotateBtnL, CharRotateBtnR

function BethHair.StyleMenu.PreWindowRender(_,pos, wind)

    if smenu.misc.physPaper then
        local pp = smenu.misc.physPaper
        local startPos = pos + pp.start_offset
        if not game:IsPaused() then
            local mouseunderpaper = wga.MousePos.Y > (smenu.hairselectsize.Y + smenu.hairselectoffset.Y + pos.Y)
            BethHair.extraPhysFunc.MenuPaperSwing(pp, startPos, mouseunderpaper and wga.MousePos)
        end
        pp.cord:Add(startPos, 0)
        for i=1, #pp do
            local cdat = pp[i]
            pp.cord:Add(cdat[1], cdat[3])
        end
        pp.cord:Render()

        --[[for i=0, #pp do
            local cur = pp[i]
            local pos = cur[1] 
            Isaac.DrawLine(pos-Vector(.5,0),pos+Vector(.5,0),KColor(1,1,1,1),KColor(1,1,1,1),5)
            local vel = cur[1] + cur[2] * 5
            Isaac.DrawLine(pos, vel,KColor(2,.2,.2,1),KColor(2,.2,.2,1),1)
            Isaac.RenderScaledText(i, pos.X,pos.Y-5, .5, .5, 1,1,1,1)
        end]]
    end

    BethHair.StyleMenu.paperrender( pos+smenu.hairselectoffset, 
        smenu.hairselectsize, 
        Color.Default)

    if wga.ManualSelectedButton then
        local btn = wga.ManualSelectedButton[1]
        smenu.HintText = btn and btn.IsSelected and btn.HintText
    end

    if smenu.HintText then
        local htpos = pos+smenu.hinttextoffset
        htpos.Y = math.min(Isaac.GetScreenHeight()-26, htpos.Y)
        BethHair.StyleMenu.paperrender( htpos-Vector(0,5), 
            Vector(210, 40), 
            Color.Default)

        local text = smenu.HintText
        local x,y = htpos.X, htpos.Y
        local offset = #text == 1 and 10 or #text == 2 and 5 or 0
        wga.DrawMultilineText(1, text, x + 105,y + offset, 1,1, 2)
    end

    local player = smenu.TargetPlayer and smenu.TargetPlayer.Ref and smenu.TargetPlayer.Ref:ToPlayer()

    if player then

        player:SetHeadDirection(smenu.CharHeadDirection, 1, true)

        --[[if Input.IsButtonTriggered(Keyboard.KEY_Q, 0) then
            smenu.CharHeadDirection = (smenu.CharHeadDirection + 1) % 4
            --CharRotateBtnL.IsSelected = 1
            CharRotateBtnL.forceSel = 5
        elseif Input.IsButtonTriggered(Keyboard.KEY_E, 0) then
            smenu.CharHeadDirection = (smenu.CharHeadDirection - 1) % 4
            --CharRotateBtnR.IsSelected = 1
            CharRotateBtnR.forceSel = 5
        end]]


        local sw,sh = Isaac.GetScreenWidth() --, Isaac.GetScreenHeight()
        local sprs = smenu.spr

        local centerPos = Vector(sw/4, pos.Y + smenu.size.Y * 0.7 )
        if game:GetRoom():IsMirrorWorld() then
            centerPos.X = sw*3/4
        end
        
        local Xscale = sw/4 / 100
        local charrotateBtnL_offset = smenu.charrotateBtnL_offset/1
        charrotateBtnL_offset.X = charrotateBtnL_offset.X * Xscale
        local charrotateBtnR_offset = smenu.charrotateBtnR_offset/1
        charrotateBtnR_offset.X = charrotateBtnR_offset.X * Xscale

        local CharRotateL = sprs.CharRotateL
        local CharRotateR = sprs.CharRotateR

        CharRotateL:SetFrame((CharRotateBtnL.IsSelected or CharRotateBtnL.forceSel) and 1 or 0)
        CharRotateR:SetFrame((CharRotateBtnR.IsSelected or CharRotateBtnR.forceSel) and 1 or 0)

        CharRotateL:Render(centerPos + charrotateBtnL_offset)
        CharRotateR:Render(centerPos + charrotateBtnR_offset)

        if CharRotateBtnL.forceSel then
            CharRotateBtnL.forceSel = CharRotateBtnL.forceSel - 1
            if CharRotateBtnL.forceSel <= 0 then
                CharRotateBtnL.forceSel = nil
            end
        end
        if CharRotateBtnR.forceSel then
            CharRotateBtnR.forceSel = CharRotateBtnR.forceSel - 1
            if CharRotateBtnR.forceSel <= 0 then
                CharRotateBtnR.forceSel = nil
            end
        end

        CharRotateBtnL.ForcePos = centerPos + charrotateBtnL_offset - Vector(24,24)
        CharRotateBtnR.ForcePos = centerPos + charrotateBtnR_offset - Vector(24,24)

        local ControllerIndex = wga.input.TargetControllerIndex or player.ControllerIndex

        --local inputDeviceName 
        if ControllerIndex == 0 then

            if Input.IsButtonTriggered(Keyboard.KEY_Q, 0) then
                smenu.CharHeadDirection = (smenu.CharHeadDirection + 1) % 4
                --CharRotateBtnL.IsSelected = 1
                CharRotateBtnL.forceSel = 5
            elseif Input.IsButtonTriggered(Keyboard.KEY_E, 0) then
                smenu.CharHeadDirection = (smenu.CharHeadDirection - 1) % 4
                --CharRotateBtnR.IsSelected = 1
                CharRotateBtnR.forceSel = 5
            elseif Input.IsButtonTriggered(Keyboard.KEY_W, 0) then
                smenu.SetFavorite(wga.ManualSelectedButton[1])
            end


            --sprs.Buttons:Play("XboxOne", true)

            --sprs.Buttons:SetFrame()
            --sprs.VerySpecialKeyBoardLeftArrow.FlipX = false
            sprs.VerySpecialKeyBoardLeftArrow:SetFrame(1)
            sprs.VerySpecialKeyBoardLeftArrow:Render(centerPos + charrotateBtnL_offset + Vector(0, 30))
            sprs.VerySpecialKeyBoardLeftArrow:SetFrame(2)
            --sprs.VerySpecialKeyBoardLeftArrow.FlipX = true
            sprs.VerySpecialKeyBoardLeftArrow:Render(centerPos + charrotateBtnR_offset + Vector(0, 30))
            
            sprs.Buttons:GetLayer(0):SetVisible(false)
            BethHair.StyleMenu.ClearControllerBtnRenderList()
        else
            if Input.IsButtonTriggered(Keyboard.KEY_H, ControllerIndex) then
                smenu.CharHeadDirection = (smenu.CharHeadDirection + 1) % 4
                CharRotateBtnL.forceSel = 5
            elseif Input.IsButtonTriggered(Keyboard.KEY_KP_DIVIDE, ControllerIndex) then
                smenu.CharHeadDirection = (smenu.CharHeadDirection - 1) % 4
                CharRotateBtnR.forceSel = 5
            elseif Input.IsButtonTriggered(Keyboard.KEY_F4, ControllerIndex) then
                wga.DelayRender(function()
                    wga.GetButton(smenu.name, "disчё").func(1)
                end, wga.Callbacks.WINDOW_POST_RENDER)

            elseif Input.IsButtonPressed(Keyboard.KEY_H, ControllerIndex) then
                CharRotateBtnL.forceSel = math.max(CharRotateBtnL.forceSel or 0, 2)
            elseif Input.IsButtonPressed(Keyboard.KEY_KP_DIVIDE, ControllerIndex) then
                CharRotateBtnR.forceSel = math.max(CharRotateBtnR.forceSel or 0, 2)
            end

            if Input.IsButtonTriggered(Keyboard.KEY_G, ControllerIndex) then
                smenu.SetFavorite(wga.ManualSelectedButton[1])
            end

            local inputDeviceName = Input.GetDeviceNameByIdx and Input.GetDeviceNameByIdx(ControllerIndex) or "XboxOne"
            if inputDeviceName then
                if (inputDeviceName:find("XInput") or inputDeviceName:find"Xbox") then
                    inputDeviceName = "XboxOne"
                end
            end

            sprs.Buttons:GetLayer(0):SetVisible(true)
            sprs.Buttons:Play(inputDeviceName, true)
            sprs.Buttons:SetFrame(10)
            sprs.Buttons:Render(centerPos + charrotateBtnL_offset + Vector(0, 30))

            --sprs.Buttons:Play(inputDeviceName, true)
            sprs.Buttons:SetFrame(11)
            sprs.Buttons:Render(centerPos + charrotateBtnR_offset + Vector(0, 30))

            if wga.ControlType == wga.enum.ControlType.CONTROLLER and wga.ManualSelectedButton then
                local btn = wga.ManualSelectedButton[1]
                smenu.AddControllerBtnRender(ButtonAction.ACTION_MENUCONFIRM, btn.pos + Vector(btn.x, btn.y), Vector(.75,.75))
            end
        end
    end
end
BethHair:AddCallback(wga.Callbacks.WINDOW_PRE_RENDER, BethHair.StyleMenu.PreWindowRender, smenu.name)

local shadowColor = Color(0,0,0,.33)
function BethHair.StyleMenu.PreWindowBackRender(_,pos, wind)
    BethHair.StyleMenu.windowbackrender( pos+smenu.hairselectshadowoffset, 
        smenu.size, 
        shadowColor)
end
BethHair:AddCallback(wga.Callbacks.WINDOW_BACK_PRE_RENDER, BethHair.StyleMenu.PreWindowBackRender, smenu.name)

function BethHair.StyleMenu.PostWindowRender(_,pos, wind)
    local sprs = smenu.spr

    sprs.Scisors:Render(pos + Vector(40,0))

    --[[if smenu.FavoriteBtn then
        local favBtn = smenu.FavoriteBtn
        local Rpos = favBtn.pos + Vector(32, 3)
        sprs.isFav:Render(Rpos)
    end]]

    --if #smenu.ControllerBtnRenderList > 0 then
        for frame, k in pairs(smenu.ControllerBtnRenderList) do
            sprs.Buttons:SetFrame(frame)
            for i2, vec in ipairs(k) do
                sprs.Buttons.Scale = vec[2]
                sprs.Buttons:Render(vec[1])
            end
        end
        smenu.ControllerBtnRenderList = {}
        sprs.Buttons.Scale = Vector(1,1)
    --end
end
BethHair:AddCallback(wga.Callbacks.WINDOW_POST_RENDER, BethHair.StyleMenu.PostWindowRender, smenu.name)


smenu.spr = {scrollback = GenSprite("gfx/editor/hairstyle_menu.anm2","scrollbar"),
    gragger1 = GenSprite("gfx/editor/hairstyle_menu.anm2","scrollbar_gragger1"),
    gragger2 = GenSprite("gfx/editor/hairstyle_menu.anm2","scrollbar_gragger2"),
    gragger3 = GenSprite("gfx/editor/hairstyle_menu.anm2","scrollbar_gragger3"),

    CharRotateL = GenSprite("gfx/editor/hairstyle_menu.anm2", "char_rotate_l"),
    CharRotateR = GenSprite("gfx/editor/hairstyle_menu.anm2", "char_rotate_r"),
    Buttons = GenSprite("gfx/ui/buttons.anm2"),
    VerySpecialKeyBoardLeftArrow = GenSprite("gfx/editor/hairstyle_menu.anm2", "keyboard_arrow_left"),
    NotSoSpecialKeyBoardWKey = GenSprite("gfx/editor/hairstyle_menu.anm2", "keyboard_arrow_left", 3),
    Scisors = GenSprite("gfx/editor/hairstyle_menu.anm2","detail1"),

    Cursor = GenSprite("gfx/editor/hairstyle_menu.anm2","mousewhat"),
    HeadShadow = GenSprite("gfx/editor/hairstyle_menu.anm2","headshadow"),

    favorite = GenSprite("gfx/editor/hairstyle_menu.anm2","favorite"),
    isFav = GenSprite("gfx/editor/hairstyle_menu.anm2","isFav"),
}

smenu.spr.scrollback.Offset = Vector(-2,-2)
if Sprite().SetCustomShader then
    smenu.spr.Buttons:SetCustomShader("shaders/PhysHairWhiteOutline")
    smenu.spr.VerySpecialKeyBoardLeftArrow:SetCustomShader("shaders/PhysHairWhiteOutline")
end
smenu.spr.HeadShadow.Scale = Vector(0.85, 0.85)
smenu.spr.HeadShadow.Offset = Vector(3,3)
smenu.spr.NotSoSpecialKeyBoardWKey.Scale = Vector(.75,.75)

local greenbtnColor = Color(78/256, 1, 90/256, 1, 3/256, 30/256, 24/256)

greenbtnColor = Color(1,1,1,1, 18/256, 20/256, 7/256)
greenbtnColor:SetColorize(108/256, 1, 85/256, 1 )

local nilspr = Sprite()

-------------------------------------
do
    local CurrentStyleMenuData = {
        Entrys = {},
        SelectedEntrySklad = nil,
        navmapCopys = {},
        EntrysData = {},

        BtnMask = GenSprite("gfx/editor/hairstyle_menu.anm2","button_mask"),
        JustMask = GenSprite("gfx/editor/hairstyle_menu.anm2","justmask"),
        JustMask2 = GenSprite("gfx/editor/hairstyle_menu.anm2","justmask2"),
        PusherSpr = GenSprite("gfx/editor/hairstyle_menu.anm2","mousewhat"),
    }
    local BtnMask, JustMask, PusherSpr = CurrentStyleMenuData.BtnMask, CurrentStyleMenuData.JustMask, CurrentStyleMenuData.PusherSpr
    local JustMask2 = CurrentStyleMenuData.JustMask2
    BtnMask:SetCustomShader("shaders/PhysHairCuttingShadder")
    JustMask:SetCustomShader("shaders/PhysHairCuttingShadder")
    JustMask2:SetCustomShader("shaders/PhysHairCuttingShadder")

    BtnMask.Color.A = 0.5
    JustMask.Color.A = 0.5
    JustMask2.Color = Color(0,0,0, 0.1)
    JustMask.Scale = Vector(2.88, 10)
    JustMask2.Scale = Vector(2.88, 10)
    PusherSpr.Scale = Vector(0.01, 1)
    JustMask2.Offset = Vector(0, 40)
    JustMask.Offset = Vector(0, 224)

    BethHair.StyleMenu.CurrentStyleMenuData = CurrentStyleMenuData

    local navmap

    function BethHair.StyleMenu.ClearEntrys(EntrySklad)
        if CurrentStyleMenuData.Entrys[EntrySklad] then
            for i, entry in pairs(CurrentStyleMenuData.Entrys[EntrySklad]) do
                wga.RemoveButton("physhair_SubMenus"..EntrySklad, entry.data.ButtonName)
            end
        end
        CurrentStyleMenuData.Entrys[EntrySklad] = {}
        CurrentStyleMenuData.navmapCopys[EntrySklad] = { {},{},{} }
        local mdata = wga.GetMenu(smenu.name)
        if CurrentStyleMenuData.SelectedEntrySklad == EntrySklad then
            if mdata.navmap then
                mdata.navmap.collums[1] = {{},{},{}}
                navmap = mdata.navmap
            else
                mdata.navmap = {collums = { {{},{},{}} }}
            end
            --mdata.navmap = { {{},{},{}} }
            --navmap = mdata.navmap
        end
    end

    function BethHair.StyleMenu.CreateEntrySklad(EntrySklad)
        CurrentStyleMenuData.Entrys[EntrySklad] = {}
        CurrentStyleMenuData.navmapCopys[EntrySklad] = {{},{},{}}
        CurrentStyleMenuData.EntrysData[EntrySklad] = {}
    end

    function BethHair.StyleMenu.GetEntry(EntrySklad)
        return CurrentStyleMenuData.Entrys[EntrySklad]
    end

    ---@class BethHairStyleMenu.EntryData
    ---@field ImageCount integer
    ---@field EntrySklad string
    ---@field ButtonName string
    ---@field BtnBackSpr Sprite
    ---@field ButtonPressLogic fun(button:integer)
    ---@field ButtonRenderLogic fun(pos:Vector, visible:boolean)
    ---@field ButtonPreRenderLogic fun(pos:Vector, visible:boolean)
    ---@field HintText string
    ---@field GreenLightCondition fun(btn:EditorButton):boolean

    ---@param data BethHairStyleMenu.EntryData
    ---@return EditorButton
    function BethHair.StyleMenu.AddEntry(data)
        --navmap = navmap or wga.GetMenu(smenu.name).navmap
        local entry = {}
        entry.data = data
        entry.Selected = false

        local entrySklad = data.EntrySklad
        if not CurrentStyleMenuData.Entrys[entrySklad] then
            BethHair.StyleMenu.CreateEntrySklad(entrySklad)
        end
        local navmap = CurrentStyleMenuData.navmapCopys[entrySklad]
        
        local CurIndex = #CurrentStyleMenuData.Entrys[entrySklad] + 1
        CurrentStyleMenuData.Entrys[entrySklad][CurIndex] = entry
        local CurrentEntrySkladData = CurrentStyleMenuData.EntrysData[entrySklad]

        local ButtonName = data.ButtonName
        local SubMenu = "physhair_SubMenus"..data.EntrySklad
        local ButtonPressLogic = data.ButtonPressLogic
        local ButtonRenderLogic = data.ButtonRenderLogic
        local ButtonPreRenderLogic = data.ButtonPreRenderLogic
        local HintText = data.HintText
        local GreenLightCondition = data.GreenLightCondition


        local pos = Vector(((CurIndex-1)%3+1)*42,42 * math.floor((CurIndex-1)/3+1))
        local xyX,xyY = (CurIndex-1)%3+1, math.floor((CurIndex-1)/3)
        local BtnSpr = data.BtnBackSpr or GenSprite("gfx/editor/hairstyle_menu.anm2","button")
        local PusherV = Vector(0,0)

        local wind = smenu.wind
        --local UpCropPos = Vector(0, 20)

        local renderImagesCount = data.ImageCount

        local self
        self = wga.AddButton(SubMenu, ButtonName, pos,
            40, 40, nilspr,
            function(...)
                CurrentEntrySkladData.LastPressedBtn = self
                ButtonPressLogic(...)
            end,
            function(Rpos, visible)
                if visible then

                    local localRIC = renderImagesCount
                    if ButtonPreRenderLogic then
                        ButtonPreRenderLogic(Rpos, visible)
                    end
                    localRIC = localRIC + (self.ExtraImageCount or 0)

                    local JMcol = JustMask.Color
                    --JM2col.R = renderImagesCount + 5
                    JMcol:SetColorize((localRIC+3) * 0.91, 0, 0, 0)
                    JustMask:Render(wind.pos)


                    local JM2col = JustMask2.Color
                    --JM2col.R = renderImagesCount + 5
                    JM2col:SetColorize((localRIC+2) * 0.91, 0, 0, 0)
                    JustMask2:Render(wind.pos)

                    BtnSpr:SetFrame(self.IsSelected and 1 or 0)
                    BtnSpr:Render(Rpos)

                    local BMcol = BtnMask.Color
                    --BMcol.R = renderImagesCount    ---:SetTint(renderImagesCount, 1, 1, 1)
                    BMcol:SetColorize(localRIC, 0, 0, 0)
                    BtnMask:Render(Rpos)

                    ButtonRenderLogic(Rpos, visible)

                    PusherSpr:Render(PusherV)
                    PusherSpr:Render(PusherV)
                    PusherSpr:Render(PusherV)
                    PusherSpr:Render(PusherV)
                    PusherSpr:Render(PusherV)

                    self.ExtraImageCount = 0
                end
            end
        )
        
        self.IsHairStyleMenu = true
        self.EntrySklad = entrySklad
        self.navXY = {xyX, xyY}
        self.row = xyY
        self.HintText = HintText
        self.HairLayer = data.HairLayer
        self.posfunc = function ()
            self.posref = self.posref * 0.8 +  Vector(self.navXY[1] * 42, (self.navXY[2]+1) * 42 - smenu.hairbtnsoffset) * 0.2
            --self.posref.Y = pos.Y - smenu.hairbtnsoffset
            self.pos = smenu.wind.pos + self.posref
            self.scrollupcrop = -self.posref.Y+40
            self.scrolldwoncrop = self.posref.Y-180

            self.canPressed = self.scrollupcrop < 32 and self.scrolldwoncrop < 32
            self.visible = self.scrollupcrop < 38 and self.scrolldwoncrop < 46
            
            if smenu.TargetPlayer and smenu.TargetPlayer.Ref then
                if GreenLightCondition(self) then
                    if not self.DoGreen then
                        self.DoGreen = true
                        BtnSpr.Color = greenbtnColor
                    end
                elseif self.DoGreen then
                    self.DoGreen = nil
                    BtnSpr.Color = Color.Default
                end
            elseif self.DoGreen then
                self.DoGreen = nil
                BtnSpr.Color = Color.Default
            end
        end

        navmap[xyX][xyY] = self

        smenu.rowcount = math.max(smenu.rowcount or 0, xyY)

        entry.Btn = self

        return self
    end

    function BethHair.StyleMenu.SetCurrentEntrySklad(EntrySklad)
        --CurrentStyleMenuData.Entrys = {}
        CurrentStyleMenuData.SelectedEntrySklad = EntrySklad
        for SkladName, k in pairs(CurrentStyleMenuData.Entrys) do
			smenu.wind:SetSubMenuVisible("physhair_SubMenus"..SkladName, false)
		end
        smenu.wind:SetSubMenuVisible("physhair_SubMenus"..EntrySklad, true)
        wga.GetMenu(smenu.name).navmap.collums[1] = CurrentStyleMenuData.navmapCopys[EntrySklad]

        wga.GetMenu("physhair_SubMenus"..EntrySklad).NavigationFunc = wga.GetMenu(smenu.name).NavigationFunc

        if #CurrentStyleMenuData.Entrys[EntrySklad] > 12 then
            --navmap.collums[2] = {}

            local spr = smenu.spr
            local self
            self = wga.AddScrollBar(smenu.name, "hairs_scroooolbar", Vector(150+30,34), Vector(16,192),
            nilspr, nilspr,
                function(but, val)
                    if but == 0 then
                        smenu.hairbtnsoffset = val
                    end
                end, function (pos, visible)
                    spr.scrollback:SetFrame(self.IsSelected and 1 or 0)

                    spr.scrollback:Render(pos, nil, Vector(0,30))

                    spr.scrollback.Scale = Vector(1, self.y/22)
                    spr.scrollback:Render(pos+Vector(0,11 - self.y/22 *10), Vector(0,10), Vector(0,10))

                    spr.scrollback.Scale = Vector(1,1)
                    spr.scrollback:Render(pos + Vector(0,self.y-36), Vector(0,30))

                end, 0, 0, math.ceil(#CurrentStyleMenuData.Entrys[EntrySklad]/3)*43 + 2 )
            smenu.scrollbtn = self
            wga.SetMouseWheelZone(self, 
                Vector(38,35), -- Vector(150+30,34), 
                Vector(43*4 + 20,43*6 - 31) -- Vector(150+30,34),
            ) --function (btn,value)
            --    print(btn,value)
           -- end)

            self.dragsprRenderFunc = function (self, pos, value, barSize)
                local fr = self.dragSelected and 1 or 0
                spr.gragger1:SetFrame(fr)
                spr.gragger2:SetFrame(fr)
                spr.gragger3:SetFrame(fr)

                spr.gragger1:Render(pos)
                
                for i=1, barSize-1 do
                    spr.gragger2:Render(pos+Vector(0, i * 2 ))
                end
                spr.gragger3:Render(pos+Vector(0, barSize*2 - 2 ))
            end
            ---navmap.collums[2][1] = self
        else
            smenu.scrollbtn = nil
            wga.RemoveButton(smenu.name, "hairs_scroooolbar")
        end
    end


end
-------------------------------------

---@deprecated
function BethHair.StyleMenu.GenWindowBtns(ptype)
    local mdata = wga.GetMenu(smenu.name)
    local navmap = {}
    mdata.navmap = navmap
    navmap.collums = {}

    local playerdata = (smenu.TargetPlayer and smenu.TargetPlayer.Ref or Isaac.GetPlayer()):GetData()
    smenu.PrevStyleName = playerdata._PhysHair_HairStyle and playerdata._PhysHair_HairStyle.StyleName

    local hspd = BethHair.HairStylesData.playerdata
    local pstyles = hspd[ptype]
    local hairsprOffset = Vector(32,44-5)
    local v12 = Vector(-12,0)
    local cropup = Vector(15,13)
    local cropdown = Vector(15,17)
    if pstyles then

        local stylesdata = BethHair.HairStylesData.styles
        navmap.collums[1] = {{},{},{}}
        local cl1 = navmap.collums[1]
        --local nilspr = Sprite()
        local lastrow = 0

        if smenu.hairscount then
            for i=1, smenu.hairscount do
                wga.RemoveButton(smenu.name, "style" .. i)
            end
        end

        local style

        for i=1, #pstyles do
            local stylename = pstyles[i]
            
            local spr = GenSprite("gfx/editor/hairstyle_menu.anm2","button")
            local styledt = stylesdata[stylename]
            local styleexdt = styledt and styledt.extra
            local hairgfx = styledt and styledt.data and styledt.data.TailCostumeSheep
            local hintText-- = wga.stringMultiline(text)
            if styleexdt and styleexdt.menuHintText then
                hintText = wga.stringMultiline(styleexdt.menuHintText, 150)
            end
            
            local hairspr
            if hairgfx then
                if styleexdt then 
                    if styleexdt.modfolder then
                        hairgfx = styledt.extra.modfolder .. "/" .. hairgfx
                    --elseif styleexdt.useDirectTailCostumeSheepForIcon then
                        --hairgfx = hairgfx
                    end
                end

                hairspr = GenSprite("gfx/characters/character_001x_bethanyhead.anm2","HeadDown")
                for lr=0, hairspr:GetLayerCount()-1 do
                    hairspr:ReplaceSpritesheet(lr,hairgfx)
                end
                hairspr:LoadGraphics()
                hairspr.Offset = hairsprOffset
            end

            local pos = Vector(((i-1)%3+1)*42,42 * math.floor((i-1)/3+1))
            local xy = Vector( (i-1)%3+1, math.floor((i-1)/3) )

            local self
            self = wga.AddButton(smenu.name, "style" .. i, pos,
             40, 40, nilspr,
                function (button)
                    local player = smenu.TargetPlayer and smenu.TargetPlayer.Ref and smenu.TargetPlayer.Ref:ToPlayer() or Isaac.GetPlayer()
                    --BethHair.HStyles.SetStyleToPlayer(player, stylename, smenu.SetStyleMode)
                    mod.HStyles.salon.ChangeHairStyle(player, stylename, smenu.SetStyleMode)
                    --BethHair.DoChoopEffect = true
                    
                end, function (pos, visible)
                    spr:SetFrame(self.IsSelected and 1 or 0)
                    local scroolupcrop = self.scrollupcrop
                    local scrolldwoncrop = self.scrolldwoncrop

                    --if self.IsSelected then
                    --    smenu.HintText = hintText
                    --end

                    spr:Render(pos, Vector(0, math.max(0, scroolupcrop)), 
                        Vector(0,math.max(0, scrolldwoncrop) ) )

                    if hairspr then
                        hairspr:Render(pos+v12,Vector(cropup.X, math.max(cropup.X-2, cropup.X+scroolupcrop-4)),
                        Vector(cropdown.X, math.max(cropdown.X+2, cropdown.X+scrolldwoncrop-2)) )    --cropdown)
                    else
                         wga.DrawText(1,stylename, pos.X, pos.Y, .5, .5)
                    end
                        --wga.RenderCustomButton2(pos, self)
                end)
            
            self.IsHairStyleMenu = true
            self.row = xy.Y
            self.HintText = hintText
            self.posfunc = function ()
                self.posref.Y = pos.Y - smenu.hairbtnsoffset
                self.pos = smenu.wind.pos + self.posref
                self.scrollupcrop = -self.posref.Y+40
                self.scrolldwoncrop = self.posref.Y-180

                self.canPressed = self.scrollupcrop < 32 and self.scrolldwoncrop < 40
                
                if smenu.TargetPlayer and smenu.TargetPlayer.Ref then
                    local playerdata = smenu.TargetPlayer.Ref:GetData()
                    if playerdata._PhysHair_HairStyle and playerdata._PhysHair_HairStyle.StyleName == stylename then
                        if not self.DoGreen then
                            self.DoGreen = true
                            spr.Color = greenbtnColor
                        end
                    elseif self.DoGreen then
                        self.DoGreen = nil
                        spr.Color = Color.Default
                    end
                elseif self.DoGreen then
                    self.DoGreen = nil
                    spr.Color = Color.Default
                end

                --if wga.ControlType ==  self.IsSelected then
                --    wga.DraggerSetValue(smenu.scrollbtn, xy.Y / #pstyles)
                --end
            end
            
            cl1[xy.X][xy.Y] = self
            lastrow = xy.Y
        end
        smenu.rowcount = lastrow
        smenu.hairbtnsoffset = 0

        if #pstyles > 12 then
            --navmap.collums[2] = {}

            local spr = smenu.spr
            local self
            self = wga.AddScrollBar(smenu.name, "hairs_scroooolbar", Vector(150+30,34), Vector(16,192),
            nilspr, nilspr,
                function(but, val)
                    if but == 0 then
                        smenu.hairbtnsoffset = val
                    end
                end, function (pos, visible)
                    --print(self.dragCurPos)
                    spr.scrollback:SetFrame(self.IsSelected and 1 or 0)

                    spr.scrollback:Render(pos, nil, Vector(0,30))

                    spr.scrollback.Scale = Vector(1, self.y/22)
                    spr.scrollback:Render(pos+Vector(0,11 - self.y/22 *10), Vector(0,10), Vector(0,10))

                    spr.scrollback.Scale = Vector(1,1)
                    spr.scrollback:Render(pos + Vector(0,self.y-36), Vector(0,30))

                end, 0, 0, math.ceil(#pstyles/3)*43 + 2 )
            smenu.scrollbtn = self
            wga.SetMouseWheelZone(self, 
                Vector(38,35), -- Vector(150+30,34), 
                Vector(43*4 + 20,43*6 - 31) -- Vector(150+30,34),
            ) --function (btn,value)
            --    print(btn,value)
           -- end)

            self.dragsprRenderFunc = function (self, pos, value, barSize)
                local fr = self.dragSelected and 1 or 0
                spr.gragger1:SetFrame(fr)
                spr.gragger2:SetFrame(fr)
                spr.gragger3:SetFrame(fr)

                spr.gragger1:Render(pos)
                
                for i=1, barSize-1 do
                    spr.gragger2:Render(pos+Vector(0, i * 2 ))
                end
                spr.gragger3:Render(pos+Vector(0, barSize*2 - 2 ))
            end
            ---navmap.collums[2][1] = self
        else
            smenu.scrollbtn = nil
            wga.RemoveButton(smenu.name, "hairs_scroooolbar")
        end
    end
    smenu.hairscount = #pstyles

    navmap.collums[2] = {}

    BethHair.StyleMenu.closespr = GenSprite("gfx/editor/hairstyle_menu.anm2", "disчёта-там")
    BethHair.StyleMenu.acceptspr = GenSprite("gfx/editor/hairstyle_menu.anm2", "accept")
    BethHair.StyleMenu.setphysspr = GenSprite("gfx/editor/hairstyle_menu.anm2", "phys")

    local usephys
    usephys = wga.AddButton(smenu.name, "usephys", Vector(200,148),
    24, 24, GenSprite("gfx/editor/hairstyle_menu.anm2", "button16"),
        function (button)
            if smenu.SetStyleMode then
                smenu.SetStyleMode = nil
                BethHair.StyleMenu.setphysspr:SetFrame(0)
            else
                smenu.SetStyleMode = 1
                BethHair.StyleMenu.setphysspr:SetFrame(1)
            end

            local player = smenu.TargetPlayer and smenu.TargetPlayer.Ref or Isaac.GetPlayer()
            local _PhysHair_HairStyle = player:GetData()._PhysHair_HairStyle
            BethHair.HStyles.SetStyleToPlayer(player, _PhysHair_HairStyle and _PhysHair_HairStyle.StyleName, smenu.SetStyleMode)
        end, function (pos, visible)
            BethHair.StyleMenu.setphysspr:Render(pos)
        end)

    local accept
    accept = wga.AddButton(smenu.name, "accept", Vector(200,174),
    24, 24, GenSprite("gfx/editor/hairstyle_menu.anm2", "button16"),
        function (button)
            BethHair.StyleMenu.CloseWindow()
        end, function (pos, visible)
            BethHair.StyleMenu.acceptspr:Render(pos)
        end)

    local close
    close = wga.AddButton(smenu.name, "disчё", Vector(200,200),
    24, 24, GenSprite("gfx/editor/hairstyle_menu.anm2", "button16"),
        function (button)
            BethHair.StyleMenu.CloseWindow()

            local player = smenu.TargetPlayer and smenu.TargetPlayer.Ref and smenu.TargetPlayer.Ref:ToPlayer() or Isaac.GetPlayer()
            if smenu.PrevStyleName then
                BethHair.HStyles.SetStyleToPlayer(player, smenu.PrevStyleName, smenu.SetStyleMode)
            else

            end

        end, function (pos, visible)
            BethHair.StyleMenu.closespr:Render(pos)
        end)
    wga.ManualSelectedButton = { close, smenu.name }
    mdata.CurCollum = 2
    mdata.HairSelPos = Vector(3,2)

    navmap.collums[2][1] = accept
    navmap.collums[2][2] = close
    navmap.collums[2][0] = usephys

    ---navigation

    --local mdata = wga.GetMenu(smenu.name)
    mdata.NavigationFunc = function (btn, vec)
        local curbtn = btn[1]
        local menu = btn[2]
        
        local x,y = vec.X, vec.Y

        local ismove = vec:Length() > 0.1
        local ishori = math.abs(x) > math.abs(y)

        if ismove then
            if mdata.CurCollum == 1 then
                local navcol1 = navmap.collums[mdata.CurCollum]
                if ishori then
                    local add = x > 0 and 1 or -1
                    local next = mdata.HairSelPos.X + add
                    
                    if next > 0 and next < 4 then
                        if navcol1[mdata.HairSelPos.X + add] 
                        and navcol1[mdata.HairSelPos.X + add][mdata.HairSelPos.Y] then
                            mdata.HairSelPos.X = mdata.HairSelPos.X + add
                            btn[1] = navcol1[mdata.HairSelPos.X][mdata.HairSelPos.Y]
                        else
                            if navmap.collums[mdata.CurCollum+add] then
                                mdata.CurCollum = mdata.CurCollum+add
                                btn[1] = navmap.collums[mdata.CurCollum][1]
                                mdata.PreHairSelPos = mdata.HairSelPos
                                mdata.HairSelPos = Vector(mdata.CurCollum, 1)
                            end
                        end
                    else
                        if navmap.collums[mdata.CurCollum+add] then
                            mdata.CurCollum = mdata.CurCollum+add
                            btn[1] = navmap.collums[mdata.CurCollum][1]
                            mdata.PreHairSelPos = mdata.HairSelPos
                            mdata.HairSelPos = Vector(mdata.CurCollum, 1)
                        end
                    end
                else
                    local add = y > 0 and 1 or -1
                    local next = mdata.HairSelPos.Y + add
                    if navcol1[mdata.HairSelPos.X][next] then
                        mdata.HairSelPos.Y = mdata.HairSelPos.Y + add
                        btn[1] = navcol1[mdata.HairSelPos.X][mdata.HairSelPos.Y]
                    elseif navcol1[mdata.HairSelPos.X-1] and navcol1[mdata.HairSelPos.X-1][next] then
                        mdata.HairSelPos.X = mdata.HairSelPos.X - 1
                        mdata.HairSelPos.Y = mdata.HairSelPos.Y + add
                        btn[1] = navcol1[mdata.HairSelPos.X][mdata.HairSelPos.Y]
                    elseif navcol1[mdata.HairSelPos.X-2] and navcol1[mdata.HairSelPos.X-2][next] then
                        mdata.HairSelPos.X = mdata.HairSelPos.X - 2
                        mdata.HairSelPos.Y = mdata.HairSelPos.Y + add
                        btn[1] = navcol1[mdata.HairSelPos.X][mdata.HairSelPos.Y]
                    end
                end


            else
                if ishori then
                    local add = x > 0 and 1 or -1
                    if navmap.collums[mdata.CurCollum+add] then
                        mdata.CurCollum = mdata.CurCollum+add
                        if mdata.CurCollum == 1 then
                            if mdata.PreHairSelPos then
                                mdata.HairSelPos = mdata.PreHairSelPos
                            end
                            btn[1] = navmap.collums[mdata.CurCollum][mdata.HairSelPos.X][mdata.HairSelPos.Y]
                            if not btn[1] then
                                btn[1] = navmap.collums[mdata.CurCollum][1][0]
                                mdata.HairSelPos = Vector(1, 0)
                            end
                            --mdata.HairSelPos = Vector(3,2)
                        else
                            btn[1] = navmap.collums[mdata.CurCollum][1]
                        end
                    end
                else
                    local add = y > 0 and 1 or -1
                    local next = mdata.HairSelPos.Y + add
                    if navmap.collums[mdata.CurCollum][next] then
                        mdata.HairSelPos.Y = mdata.HairSelPos.Y + add
                        btn[1] = navmap.collums[mdata.CurCollum][mdata.HairSelPos.Y]
                    else
                        btn[1] = navmap.collums[mdata.CurCollum][mdata.HairSelPos.Y]
                    end
                end
            end
        end
    end


    smenu.CharHeadDirection = Direction.DOWN

    --local CharRotateL
    CharRotateBtnL = wga.AddButton(smenu.name, "CharRotateL", Vector(200,200),
    48, 48, nilspr,
        function (button)
            smenu.CharHeadDirection = (smenu.CharHeadDirection + 1) % 4
        end, function (pos, visible)
            --wga.RenderCustomButton2(pos, CharRotateBtnL, Color(1,1,1,.25))
        end)
    CharRotateBtnL.posfunc = function()
        CharRotateBtnL.pos = CharRotateBtnL.ForcePos or CharRotateBtnL.pos
    end

    CharRotateBtnR = wga.AddButton(smenu.name, "CharRotateR", Vector(200,200),
        48, 48, nilspr,
            function (button)
                smenu.CharHeadDirection = (smenu.CharHeadDirection - 1) % 4
            end, function (pos, visible)
                --wga.RenderCustomButton2(pos, CharRotateBtnR, Color(1,1,1,.25))
            end)
    CharRotateBtnR.posfunc = function()
        CharRotateBtnR.pos = CharRotateBtnR.ForcePos or CharRotateBtnR.pos
    end


end

function BethHair.StyleMenu.NavigationIsValid(btn)
    return btn and btn.canPressed and btn.visible
end

function BethHair.StyleMenu.GenWindowBtns2(ptype)
    local mdata = wga.GetMenu(smenu.name)
    local smenuspr = smenu.spr

    local navmap = {}
    mdata.navmap = navmap
    navmap.collums = {}

    local NavigationIsValid = BethHair.StyleMenu.NavigationIsValid

    mdata.NavigationFunc = function (btn, vec)  
        local x,y = vec.X, vec.Y

        local ismove = vec:Length() > 0.1
        local ishori = math.abs(x) > math.abs(y)

        if ismove then
            if mdata.CurCollum == 1 then
                local navcol1 = navmap.collums[mdata.CurCollum]
                if ishori then
                    local add = x > 0 and 1 or -1
                    local next = mdata.HairSelPos.X + add
                    
                    if next > 0 and next < 4 then
                        if navcol1[mdata.HairSelPos.X + add] 
                        and navcol1[mdata.HairSelPos.X + add][mdata.HairSelPos.Y] then
                            mdata.HairSelPos.X = mdata.HairSelPos.X + add
                            btn[1] = navcol1[mdata.HairSelPos.X][mdata.HairSelPos.Y]
                        else
                            if navmap.collums[mdata.CurCollum+add] then
                                mdata.CurCollum = mdata.CurCollum+add
                                btn[1] = navmap.collums[mdata.CurCollum][1]
                                mdata.PreHairSelPos = mdata.HairSelPos
                                mdata.HairSelPos = Vector(mdata.CurCollum, 1)
                            end
                        end
                    else
                        if navmap.collums[mdata.CurCollum+add] then
                            mdata.CurCollum = mdata.CurCollum+add
                            btn[1] = navmap.collums[mdata.CurCollum][1]
                            mdata.PreHairSelPos = mdata.HairSelPos
                            mdata.HairSelPos = Vector(mdata.CurCollum, 1)
                        end
                    end
                else
                    local add = y > 0 and 1 or -1
                    local next = mdata.HairSelPos.Y + add
                    if navcol1[mdata.HairSelPos.X][next] then
                        mdata.HairSelPos.Y = mdata.HairSelPos.Y + add
                        btn[1] = navcol1[mdata.HairSelPos.X][mdata.HairSelPos.Y]
                    elseif navcol1[mdata.HairSelPos.X-1] and navcol1[mdata.HairSelPos.X-1][next] then
                        mdata.HairSelPos.X = mdata.HairSelPos.X - 1
                        mdata.HairSelPos.Y = mdata.HairSelPos.Y + add
                        btn[1] = navcol1[mdata.HairSelPos.X][mdata.HairSelPos.Y]
                    elseif navcol1[mdata.HairSelPos.X-2] and navcol1[mdata.HairSelPos.X-2][next] then
                        mdata.HairSelPos.X = mdata.HairSelPos.X - 2
                        mdata.HairSelPos.Y = mdata.HairSelPos.Y + add
                        btn[1] = navcol1[mdata.HairSelPos.X][mdata.HairSelPos.Y]
                    end
                end


            else
                if ishori then
                    local add = x > 0 and 1 or -1
                    if navmap.collums[mdata.CurCollum+add] then
                        mdata.CurCollum = mdata.CurCollum+add
                        if mdata.CurCollum == 1 then
                            if mdata.PreHairSelPos then
                                mdata.HairSelPos = mdata.PreHairSelPos
                            end
                            btn[1] = navmap.collums[mdata.CurCollum][mdata.HairSelPos.X][mdata.HairSelPos.Y]
                            if not btn[1] then
                                btn[1] = navmap.collums[mdata.CurCollum][1][0]
                                mdata.HairSelPos = Vector(1, 0)
                            end
                            --mdata.HairSelPos = Vector(3,2)
                        else
                            btn[1] = navmap.collums[mdata.CurCollum][1]
                        end
                    end
                else
                    local add = y > 0 and 1 or -1
                    local next = mdata.HairSelPos.Y + add
                    if NavigationIsValid(navmap.collums[mdata.CurCollum][next]) then
                        mdata.HairSelPos.Y = next
                        btn[1] = navmap.collums[mdata.CurCollum][mdata.HairSelPos.Y]
                    else
                        btn[1] = navmap.collums[mdata.CurCollum][mdata.HairSelPos.Y]
                    end
                end
            end
        end
    end




    local playerdata = (smenu.TargetPlayer and smenu.TargetPlayer.Ref or Isaac.GetPlayer()):GetData()
    smenu.PrevStyleName = playerdata._PhysHair_HairStyle and playerdata._PhysHair_HairStyle.StyleName

    local hspd = BethHair.HairStylesData.playerdata
    local pstyles = hspd[ptype]
    local hairsprOffset = Vector(32,44-5)
    local v12 = Vector(-12,-2)
    local cropup = Vector(15,13)
    local cropdown = Vector(15,17)
    if pstyles then

        smenu.FavoriteBtn = nil

        local stylesdata = BethHair.HairStylesData.styles

        local EntrySklad = "Def_HairStyles"
        BethHair.StyleMenu.ClearEntrys(EntrySklad)
        BethHair.StyleMenu.CreateEntrySklad(EntrySklad)
        
        smenu.HairLayer = 0

        local favorited = mod.HStyles.GetFavoriteStyle(ptype)

        for i=1, #pstyles do
            local stylename = pstyles[i]
            
            local spr = GenSprite("gfx/editor/hairstyle_menu.anm2","button")
            local styledt = stylesdata[stylename]
            local styleexdt = styledt and styledt.extra
            local hairgfx = styledt and styledt.data and styledt.data.TailCostumeSheep
            local hairanm2 = styledt and styledt.data and styledt.data.NullposRefSpr and styledt.data.NullposRefSpr:GetFilename()
            local hintText-- = wga.stringMultiline(text)
            if styleexdt and styleexdt.menuHintText then
                hintText = wga.stringMultiline(styleexdt.menuHintText, 150)
            end
            
            local hairspr
            if hairgfx then
                if styleexdt then 
                    if styleexdt.modfolder then
                        hairgfx = styledt.extra.modfolder .. "/" .. hairgfx
                    --elseif styleexdt.useDirectTailCostumeSheepForIcon then
                        --hairgfx = hairgfx
                    end
                end

                if not hairanm2 then
                    hairanm2 = mod.HStyles.GetHairAnm2ByPlayerType(ptype)
                end

                hairspr = GenSprite(hairanm2 or "gfx/characters/character_001x_bethanyhead.anm2","HeadDown")
                for lr=0, hairspr:GetLayerCount()-1 do
                    hairspr:ReplaceSpritesheet(lr,hairgfx)
                end
                hairspr:LoadGraphics()
                hairspr.Offset = hairsprOffset
                hairspr.Scale = Vector(0.85, .85)
            end

            
            local self
            self = BethHair.StyleMenu.AddEntry{
                ButtonName = "style" .. i,
                ImageCount = 3,
                HairLayer = styleexdt and styleexdt.HairLayer or 0,
                EntrySklad = EntrySklad,
                BtnBackSpr = spr,
                ButtonPressLogic = function (button)
                    local player = smenu.TargetPlayer and smenu.TargetPlayer.Ref and smenu.TargetPlayer.Ref:ToPlayer() or Isaac.GetPlayer()
                    mod.HStyles.salon.ChangeHairStyle(player, stylename, smenu.SetStyleMode, self.HairLayer)
                    
                end,
                ButtonRenderLogic = function (pos, visible)
                    --spr:SetFrame(self.IsSelected and 1 or 0)
                    --spr:Render(pos)

                    if hairspr then
                        smenuspr.HeadShadow:Render(pos)
                        hairspr:Render(pos+v12)
                    else
                        wga.DrawText(1,stylename, pos.X, pos.Y, .5, .5)
                    end
                    if smenu.FavoriteBtn == self then
                        local Rpos = pos + Vector(32, 3)
                        smenu.spr.isFav:Render(Rpos)
                    end
                        --wga.RenderCustomButton2(pos, self)
                end,
                ButtonPreRenderLogic = function (pos, visible)
                    if smenu.FavoriteBtn == self then
                        self.ExtraImageCount = (self.ExtraImageCount or 0) + 1
                    end
                end,
                HintText = hintText,
                GreenLightCondition = function(btn)
                    local targetPlayer = smenu.TargetPlayer
                    if targetPlayer and targetPlayer.Ref then
                        local playerdata = targetPlayer.Ref:GetData()
                        local PSH = playerdata._PhysHair_HairStyle
                        return PSH and PSH[self.HairLayer] and PSH[self.HairLayer].StyleName == stylename
                    end
                end,
            }

            self.StyleName = stylename

            if favorited and favorited[self.HairLayer] and favorited[self.HairLayer].style == stylename then
                smenu.FavoriteBtn = self
            end

            wga.SetPressDetectArea(self, Vector(38,40), Vector(43*4 + 20,43*6 - 33))

            --[[self = wga.AddButton(smenu.name, "style" .. i, pos,
             40, 40, nilspr,
                function (button)
                    local player = smenu.TargetPlayer and smenu.TargetPlayer.Ref and smenu.TargetPlayer.Ref:ToPlayer() or Isaac.GetPlayer()
                    --BethHair.HStyles.SetStyleToPlayer(player, stylename, smenu.SetStyleMode)
                    mod.HStyles.salon.ChangeHairStyle(player, stylename, smenu.SetStyleMode)
                    --BethHair.DoChoopEffect = true
                    
                end, function (pos, visible)
                    spr:SetFrame(self.IsSelected and 1 or 0)
                    local scroolupcrop = self.scrollupcrop
                    local scrolldwoncrop = self.scrolldwoncrop

                    --if self.IsSelected then
                    --    smenu.HintText = hintText
                    --end

                    spr:Render(pos, Vector(0, math.max(0, scroolupcrop)), 
                        Vector(0,math.max(0, scrolldwoncrop) ) )

                    if hairspr then
                        hairspr:Render(pos+v12,Vector(cropup.X, math.max(cropup.X-2, cropup.X+scroolupcrop-4)),
                        Vector(cropdown.X, math.max(cropdown.X+2, cropdown.X+scrolldwoncrop-2)) )    --cropdown)
                    else
                         wga.DrawText(1,stylename, pos.X, pos.Y, .5, .5)
                    end
                        --wga.RenderCustomButton2(pos, self)
                end)]]
            
        end
        --smenu.rowcount = lastrow
        smenu.hairbtnsoffset = 0

        BethHair.StyleMenu.SetCurrentEntrySklad(EntrySklad)
    end
    smenu.hairscount = #pstyles

    navmap.collums[2] = {}

    BethHair.StyleMenu.closespr = GenSprite("gfx/editor/hairstyle_menu.anm2", "disчёта-там")
    BethHair.StyleMenu.acceptspr = GenSprite("gfx/editor/hairstyle_menu.anm2", "accept")
    BethHair.StyleMenu.setphysspr = GenSprite("gfx/editor/hairstyle_menu.anm2", "phys", smenu.SetStyleMode and 1 or 0)
    BethHair.StyleMenu.favoritespr = GenSprite("gfx/editor/hairstyle_menu.anm2", "favorite")

    local usephys
    usephys = wga.AddButton(smenu.name, "usephys", Vector(200,148),
    24, 24, GenSprite("gfx/editor/hairstyle_menu.anm2", "button16"),
        function (button)
            if smenu.SetStyleMode then
                smenu.SetStyleMode = nil
                BethHair.StyleMenu.setphysspr:SetFrame(0)
            else
                smenu.SetStyleMode = 1
                BethHair.StyleMenu.setphysspr:SetFrame(1)
            end

            local player = smenu.TargetPlayer and smenu.TargetPlayer.Ref or Isaac.GetPlayer()
            --local _PhysHair_HairStyle = player:GetData()._PhysHair_HairStyle
            --BethHair.HStyles.SetStyleToPlayer(player, _PhysHair_HairStyle and _PhysHair_HairStyle.StyleName, smenu.SetStyleMode)

            local CurrentEntrySkladData = BethHair.StyleMenu.CurrentStyleMenuData.EntrysData["Def_HairStyles"]
            local LastPressedBtn = CurrentEntrySkladData.LastPressedBtn
            ---@cast LastPressedBtn EditorButton
            if CurrentEntrySkladData.LastPressedBtn then
                LastPressedBtn.func(0)
            elseif player then
                local hairContainer = player:GetData().__PhysHair_HairSklad
                if hairContainer and hairContainer[smenu.HairLayer] then
                    local stylename = hairContainer[smenu.HairLayer].HairInfo.StyleName
                    if stylename then
                        BethHair.HStyles.SetStyleToPlayer(player, stylename, smenu.HairLayer, smenu.SetStyleMode)
                    end
                end
            end
        end, function (pos, visible)
            if visible then
                BethHair.StyleMenu.setphysspr:Render(pos)
            end
        end)
    usephys.posfunc = function()
        usephys.visible = true
        usephys.canPressed = true

        local currentPlayerStyle
        local CurrentEntrySkladData = BethHair.StyleMenu.CurrentStyleMenuData.EntrysData["Def_HairStyles"]
        if CurrentEntrySkladData then
            currentPlayerStyle = CurrentEntrySkladData.LastPressedBtn and CurrentEntrySkladData.LastPressedBtn.StyleName
        end
        if not currentPlayerStyle then
            local player = smenu.TargetPlayer and smenu.TargetPlayer.Ref or Isaac.GetPlayer()
            if player then
                local hairContainer = player:GetData().__PhysHair_HairSklad
                if hairContainer and hairContainer[smenu.HairLayer] then
                    currentPlayerStyle = hairContainer[smenu.HairLayer].HairInfo.StyleName
                end
            end
        end
        if currentPlayerStyle then
            local HSData = BethHair.HStyles.GetStyleData(currentPlayerStyle)
            if HSData then
                if HSData.data.ReplaceCostumeSheep == HSData.data.TailCostumeSheep then
                    usephys.visible = false
                    usephys.canPressed = false
                end
            end
        end
    end

    local accept
    accept = wga.AddButton(smenu.name, "accept", Vector(200,174),
    24, 24, GenSprite("gfx/editor/hairstyle_menu.anm2", "button16"),
        function (button)
            BethHair.StyleMenu.CloseWindow()
        end, function (pos, visible)
            BethHair.StyleMenu.acceptspr:Render(pos)
        end)

    local close
    close = wga.AddButton(smenu.name, "disчё", Vector(200,200),
    24, 24, GenSprite("gfx/editor/hairstyle_menu.anm2", "button16"),
        function (button)
            BethHair.StyleMenu.CloseWindow()

            local player = smenu.TargetPlayer and smenu.TargetPlayer.Ref and smenu.TargetPlayer.Ref:ToPlayer() or Isaac.GetPlayer()
            if smenu.PrevStyleName then
                BethHair.HStyles.SetStyleToPlayer(player, smenu.PrevStyleName, smenu.SetStyleMode)
            else

            end

        end, function (pos, visible)
            BethHair.StyleMenu.closespr:Render(pos)
            if not close.IsSelected and wga.ControlType == wga.enum.ControlType.CONTROLLER then
                BethHair.StyleMenu.AddControllerBtnRender(ButtonAction.ACTION_MENUBACK, pos + Vector(close.x, close.y), Vector(.75,.75))
            end
        end)

    function smenu.SetFavorite(btn)
        if not btn or not btn.IsHairStyleMenu then return end
        local targetPlayer = smenu.TargetPlayer
        if targetPlayer and targetPlayer.Ref then
            local style =  btn.StyleName
            local Ptype = targetPlayer.Ref:ToPlayer():GetPlayerType()

            local isAlreadyFavorite = BethHair.HStyles.GetFavoriteStyle(Ptype) == style
            
            if not isAlreadyFavorite then
                smenu.FavoriteBtn = btn
                mod.HStyles.SetFavoriteStyle(Ptype, style, btn.HairLayer, smenu.SetStyleMode)
            else
                smenu.FavoriteBtn = nil
                mod.HStyles.RemoveFavoriteStyle(Ptype, btn.HairLayer)
            end

        end
    end


    local favorite
    favorite = wga.AddButton(smenu.name, "favorite", Vector(200,114),
    24, 24, GenSprite("gfx/editor/hairstyle_menu.anm2", "button16"),
    function (button)
        local targetPlayer = smenu.TargetPlayer
        if targetPlayer and targetPlayer.Ref then
            local pdata = smenu.TargetPlayer.Ref:GetData()
            local curStyle = pdata._PhysHair_HairStyle and pdata._PhysHair_HairStyle[smenu.HairLayer] and pdata._PhysHair_HairStyle[smenu.HairLayer].StyleName
            if curStyle then
                local menustyledata = BethHair.StyleMenu.CurrentStyleMenuData
                for SkladName, entry in pairs(menustyledata.Entrys[menustyledata.SelectedEntrySklad]) do
                    local btn = entry.Btn
                    if btn.StyleName == curStyle then
                        smenu.SetFavorite(btn)
                        break
                    end
                end
            end
        end
    end, function (pos, visible)
        BethHair.StyleMenu.favoritespr:Render(pos)

        if wga.ControlType == wga.enum.ControlType.CONTROLLER then
            local player = smenu.TargetPlayer and smenu.TargetPlayer.Ref and smenu.TargetPlayer.Ref:ToPlayer()
            if player and player.ControllerIndex == 0 then
                smenu.spr.NotSoSpecialKeyBoardWKey:Render(pos + Vector(favorite.x, favorite.y))
            else
                BethHair.StyleMenu.AddControllerBtnRender(ButtonAction.ACTION_SHOOTUP, pos + Vector(favorite.x, favorite.y), Vector(.75,.75))
            end
        end
    end)



    wga.ManualSelectedButton = { close, smenu.name }
    mdata.CurCollum = 2
    mdata.HairSelPos = Vector(3,2)

    navmap.collums[2][1] = accept
    navmap.collums[2][2] = close
    navmap.collums[2][0] = usephys

    ---navigation

    --local mdata = wga.GetMenu(smenu.name)
    --[[
    mdata.NavigationFunc = function (btn, vec)
        local curbtn = btn[1]
        local menu = btn[2]
        
        local x,y = vec.X, vec.Y

        local ismove = vec:Length() > 0.1
        local ishori = math.abs(x) > math.abs(y)

        if ismove then
            if mdata.CurCollum == 1 then
                local navcol1 = navmap.collums[mdata.CurCollum]
                if ishori then
                    local add = x > 0 and 1 or -1
                    local next = mdata.HairSelPos.X + add
                    
                    if next > 0 and next < 4 then
                        if navcol1[mdata.HairSelPos.X + add] 
                        and navcol1[mdata.HairSelPos.X + add][mdata.HairSelPos.Y] then
                            mdata.HairSelPos.X = mdata.HairSelPos.X + add
                            btn[1] = navcol1[mdata.HairSelPos.X][mdata.HairSelPos.Y]
                        else
                            if navmap.collums[mdata.CurCollum+add] then
                                mdata.CurCollum = mdata.CurCollum+add
                                btn[1] = navmap.collums[mdata.CurCollum][1]
                                mdata.PreHairSelPos = mdata.HairSelPos
                                mdata.HairSelPos = Vector(mdata.CurCollum, 1)
                            end
                        end
                    else
                        if navmap.collums[mdata.CurCollum+add] then
                            mdata.CurCollum = mdata.CurCollum+add
                            btn[1] = navmap.collums[mdata.CurCollum][1]
                            mdata.PreHairSelPos = mdata.HairSelPos
                            mdata.HairSelPos = Vector(mdata.CurCollum, 1)
                        end
                    end
                else
                    local add = y > 0 and 1 or -1
                    local next = mdata.HairSelPos.Y + add
                    if navcol1[mdata.HairSelPos.X][next] then
                        mdata.HairSelPos.Y = mdata.HairSelPos.Y + add
                        btn[1] = navcol1[mdata.HairSelPos.X][mdata.HairSelPos.Y]
                    elseif navcol1[mdata.HairSelPos.X-1] and navcol1[mdata.HairSelPos.X-1][next] then
                        mdata.HairSelPos.X = mdata.HairSelPos.X - 1
                        mdata.HairSelPos.Y = mdata.HairSelPos.Y + add
                        btn[1] = navcol1[mdata.HairSelPos.X][mdata.HairSelPos.Y]
                    elseif navcol1[mdata.HairSelPos.X-2] and navcol1[mdata.HairSelPos.X-2][next] then
                        mdata.HairSelPos.X = mdata.HairSelPos.X - 2
                        mdata.HairSelPos.Y = mdata.HairSelPos.Y + add
                        btn[1] = navcol1[mdata.HairSelPos.X][mdata.HairSelPos.Y]
                    end
                end


            else
                if ishori then
                    local add = x > 0 and 1 or -1
                    if navmap.collums[mdata.CurCollum+add] then
                        mdata.CurCollum = mdata.CurCollum+add
                        if mdata.CurCollum == 1 then
                            if mdata.PreHairSelPos then
                                mdata.HairSelPos = mdata.PreHairSelPos
                            end
                            btn[1] = navmap.collums[mdata.CurCollum][mdata.HairSelPos.X][mdata.HairSelPos.Y]
                            if not btn[1] then
                                btn[1] = navmap.collums[mdata.CurCollum][1][0]
                                mdata.HairSelPos = Vector(1, 0)
                            end
                            --mdata.HairSelPos = Vector(3,2)
                        else
                            btn[1] = navmap.collums[mdata.CurCollum][1]
                        end
                    end
                else
                    local add = y > 0 and 1 or -1
                    local next = mdata.HairSelPos.Y + add
                    if navmap.collums[mdata.CurCollum][next] then
                        mdata.HairSelPos.Y = mdata.HairSelPos.Y + add
                        btn[1] = navmap.collums[mdata.CurCollum][mdata.HairSelPos.Y]
                    else
                        btn[1] = navmap.collums[mdata.CurCollum][mdata.HairSelPos.Y]
                    end
                end
            end
        end
    end
    ]]

    smenu.CharHeadDirection = Direction.DOWN

    --local CharRotateL
    CharRotateBtnL = wga.AddButton(smenu.name, "CharRotateL", Vector(200,200),
    48, 48, nilspr,
        function (button)
            smenu.CharHeadDirection = (smenu.CharHeadDirection + 1) % 4
        end, function (pos, visible)
            --wga.RenderCustomButton2(pos, CharRotateBtnL, Color(1,1,1,.25))
        end)
    CharRotateBtnL.posfunc = function()
        CharRotateBtnL.pos = CharRotateBtnL.ForcePos or CharRotateBtnL.pos
    end

    CharRotateBtnR = wga.AddButton(smenu.name, "CharRotateR", Vector(200,200),
        48, 48, nilspr,
            function (button)
                smenu.CharHeadDirection = (smenu.CharHeadDirection - 1) % 4
            end, function (pos, visible)
                --wga.RenderCustomButton2(pos, CharRotateBtnR, Color(1,1,1,.25))
            end)
    CharRotateBtnR.posfunc = function()
        CharRotateBtnR.pos = CharRotateBtnR.ForcePos or CharRotateBtnR.pos
    end


end

--[[
local self
self = wga.AddButton(smenu.name, "nil", Vector(40,40), 30, 30, Sprite(),
    function (button)
        smenu = wga.ShowWindow(smenu.name)
        BethHair.StyleMenu.GenWindowBtns(ptype)
    end, function (pos, visible)
        wga.RenderCustomButton2(pos, self)
    end)
]]

BethHair.StyleMenu.windowbackrender = wga.CreateCustomMenuBackRenderFunc("HairStyleMenu", {
    tilesize = Vector(32,32),
    scaling = false,
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","back1")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","back2")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","back3")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","back4")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","back5")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","back6")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","back7")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","back8")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","back9")},
})

BethHair.StyleMenu.paperrender = wga.CreateCustomMenuBackRenderFunc("HairStyleMenu_paper", {
    tilesize = Vector(32,32),
    scaling = false,
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","paper1")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","paper2")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","paper3")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","paper4")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","paper5")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","paper6")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","paper7")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","paper8")},
    {spr = GenSprite("gfx/editor/hairstyle_menu.anm2","paper9")},
})

function BethHair.StyleMenu.ShowWindow()
    local center = Vector(Isaac.GetScreenWidth()/2, Isaac.GetScreenHeight()/2)
    smenu.wind = wga.ShowWindow(smenu.name, center-smenu.size/2, smenu.size)
    smenu.wind.RenderCustomMenuBack = BethHair.StyleMenu.windowbackrender
    --smenu.wind.unuser = true
    smenu.wind.backcolor = Color(1,1,1,1)
    smenu.wind.backcolornfocus = Color(1,1,1,1)

    BethHair.StyleMenu.TargetPlayer = smenu.TargetPlayer or EntityPtr(Isaac.GetPlayer())

    wga.SetControlType(wga.enum.ControlType.CONTROLLER, smenu.TargetPlayer and smenu.TargetPlayer.Ref:ToPlayer() )

    local ptype = smenu.TargetPlayer and smenu.TargetPlayer.Ref:ToPlayer():GetPlayerType()
        or Isaac.GetPlayer():GetPlayerType()
    BethHair.StyleMenu.GenWindowBtns2(ptype)

    smenu.misc.physPaper = {
        cord = BeamR("gfx/editor/hairstyle_menu.anm2", "physpaper", 0, false, false, 3), start_offset = Vector(80,210),
        Scretch = 11, [0]={ Vector(0,0),Vector(0,0),21}, { Vector(0,0),Vector(0,0),43}, { Vector(0,0),Vector(0,0),64},
    }
    local pp = smenu.misc.physPaper
    local dotnum = 11
    for i=0, dotnum-1 do
        pp[i] = {Vector(0,0),Vector(0,0),(64/dotnum)*(i+1) }
    end
    pp.Scretch = 64/dotnum / 2
end

function BethHair.StyleMenu.CloseWindow()
    wga.CloseWindow(smenu.name)
    smenu.wind = nil
    BethHair.StyleMenu.TargetPlayer = nil
    BethHair.StyleMenu.TargetHairKeeper = nil
    if BethHair.HStyles.salon.Chranya.Ref then
        BethHair.HStyles.salon.Chranya.Ref:GetSprite():Play("scisor_end", true)
    end
    BethHair.HStyles.Chooping = nil
    --BethHair.HStyles.Chooping = nil
end



BethHair:AddCallback(ModCallbacks.MC_HUD_RENDER, BethHair.StyleMenu.HUDRender)




local debugmultiplayer = false

if debugmultiplayer and WORSTDEBUGMENU then
    local menu = WORSTDEBUGMENU.wma
    local winset = {name = "physhair_debugmultiplayer", size=Vector(40,40), pos = Vector(10,10)}

    BethHair.showwindow = function()
        BethHair.dmp_wind = WORSTDEBUGMENU.wma.ShowWindow(winset.name, winset.pos, winset.size)
    end

    local self
	self = menu.AddButton(winset.name, "test", Vector(12,12), 16, 16, WORSTDEBUGMENU.UIs.EmptyBtn(), function(button) 
		if button ~= 0 then return end
		
	end, function (pos,vis)
        if Input.IsMouseBtnPressed(0) then
            local mousepos = Input.GetMousePosition(true)
            local pl = game:GetNearestPlayer(mousepos)

            local poof = Isaac.Spawn(1000,16,0,pl.Position,Vector(0,0), nil)
            poof:GetSprite().Scale = Vector(.5, .5)
            poof:GetSprite().PlaybackSpeed = 4
            poof.DepthOffset = 100

            for i=0, game:GetNumPlayers()-1 do
                local player = Isaac.GetPlayer(i)
                player:SetControllerIndex(1)
            end
            pl:SetControllerIndex(0)
        end
    end)
end







