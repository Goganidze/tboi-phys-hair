BethHair = RegisterMod("Vifaniia s fisikoi", 1)


local mod = BethHair
mod.BlockedChar = {}
local Isaac = Isaac
local game = Game()
local Room 
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
    if node and node.id == "3127377427" then
        mod.Foldername = node.realdirectory or node.directory
        break
    end
end


mod.HairLib = include("physhair")
---@type _HairCordData
mod.HairLib = mod.HairLib(mod)

include("hair_styles")

mod.DR = false

mod.CordsSprites = {}
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
    [3] = 3, -- 3 << 1,
    [0] = 2, --2 << 1,
    [1] = 3, --3 << 1,
    [2] = 3, --1 << 1
}
local headDirToRender2 = {
    [3] = 3, -- 3 << 1,
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


local defaultmodfolder = "mods/" .. mod.Foldername .. "/resources"

--mod.HairLib.SetHairData(PlayerType.PLAYER_BETHANY, {
mod.HStyles.AddStyle("BethDef", PlayerType.PLAYER_BETHANY, {
        --CordSpr = cordSpr,
        --TailCount = 2,
        --RenderLayers = headDirToRender,
        --CostumeNullposes = {"bethshair_cord1","bethshair_cord2"},
        TargetCostume = {ID = NullItemID.ID_BETHANY, Type = ItemType.ITEM_NULL},
        --ReplaceCostumeSuffix = "_notails",    --"gfx/characters/costumes/character_001x_bethshair_notails.png",
        SkinFolderSuffics = "resources-dlc3/gfx/characters/costumes/",
        ReplaceCostumeSheep = "gfx/characters/costumes/character_001x_bethshair_notails.png",
        TailCostumeSheep = "gfx/characters/costumes/character_001x_bethshair.png",
        NullposRefSpr = GenSprite("mods/".. mod.Foldername ..  "/resources/gfx/characters/character_001x_bethanyhead.anm2"),
        [1] = {
            CordSpr = cordSpr,
            RenderLayers = headDirToRender1,
            CostumeNullpos = "bethshair_cord1",
            Length = 30,
        },
        [2] = {
            CordSpr = cordSpr,
            RenderLayers = headDirToRender2,
            CostumeNullpos = "bethshair_cord2",
            Length = 30,
        },
    }, {modfolder = "resources-dlc3"})

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
        StartHeight = 5,
        Scretch = scretch * 1.2,
        --PhysFunc = mod.extraPhysFunc.PonyTailFunc,
       --- Mass = 12,
        CS = {[0]=7,15}
    },
    [2] = {
        CordSpr = mod.BethLowTailsCord2,
        RenderLayers = { [3] = 3, [0] = 3, [1] = 3, [2] = 1 },
        CostumeNullpos = "bethshair_cord2",
        Length = 30,
        Scretch = scretch * 1.2,
        --PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        StartHeight = 5,
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
        Length = 20,
        Scretch = scretch * 1.0,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        --= Mass = 12,
        StartHeight = 0,
        CS = {[0]=3,10,15}
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
    [1] = {
        CordSpr = mod.BethDrillTailCord,
        RenderLayers = { [3] = 3, [0] = 1, [1] = 3, [2] = 3 },
        CostumeNullpos = "bethshair_cord1",
        --DotCount = 2,
        Length = 31,
        StartHeight = 3,
        Scretch = scretch * 1.35,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        Mass = 13,
        CS = {[0]=8,15,22}
    },
    [2] = {
        CordSpr = mod.BethDrillTailCord2,
        RenderLayers = { [3] = 3, [0] = 3, [1] = 3, [2] = 1 },
        CostumeNullpos = "bethshair_cord2",
        Length = 31,
        Scretch = scretch * 1.35,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        StartHeight = 3,
        Mass = 13,
        CS = {[0]=8,15,22}
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
        Length = 16,
        StartHeight = 1,
        Scretch = scretch * 1.,
        PhysFunc = mod.extraPhysFunc.HoholockTailFunc,
        Mass = 6,
        CS = {[0]=4,8,12}
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
        CS = {[0]=8,15}
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
        CS = {[0]=7 ,12}
    },
    {
        CordSpr = mod.BethNoTailCords["4"],
        RenderLayers = { [3] = 0, [0] = 2, [1] = 0, [2] = 2 },
        CostumeNullpos = "bethshair_cord3",
        DotCount = 2,
        Length = 14,
        StartHeight = 1,
        Scretch = scretch * 0.7,
        PhysFunc = mod.extraPhysFunc.PonyTailFunc,
        Mass = 12,
        CS = {[0]=5,10,}
    },

    {
        CordSpr = mod.BethNoTailCords["5"],
        RenderLayers = { [3] = 0, [0] = 0, [1] = 3, [2] = 0 },
        CostumeNullpos = "bethshair_cord4",
        DotCount = 3,
        Length = 16,
        StartHeight = 1,
        Scretch = scretch * 1.0,
        PhysFunc = mod.extraPhysFunc.PonyTailFuncHard,
        Mass = 42,
        CS = {[0]=5,10,15}
    },
    {
        CordSpr = mod.BethNoTailCords["6b"],
        RenderLayers = { [3] = 0, [0] = 0, [1] = 2, [2] = 0 },
        CostumeNullpos = "bethshair_cord5",
        DotCount = 4,
        Length = 21,
        StartHeight = 1,
        Scretch = scretch * 1.0,
        PhysFunc = mod.extraPhysFunc.PonyTailFuncHard,
        Mass = 30,
        CS = {[0]=3,9,13,17}
    },
    {
        CordSpr = mod.BethNoTailCords["6"],
        RenderLayers = { [3] = 0, [0] = 0, [1] = 3, [2] = 0 },
        CostumeNullpos = "bethshair_cord5",
        DotCount = 4,
        Length = 21,
        StartHeight = 1,
        Scretch = scretch * 1.0,
        PhysFunc = mod.extraPhysFunc.PonyTailFuncHard,
        Mass = 30,
        CS = {[0]=3,9,13,17}
    },

}, {
    modfolder = defaultmodfolder,
    --CustomCharPortrait = "gfx/characters/costumes/beth_styles/drilltail/charactermenu.png"
})








function mod.extraPhysFunc.BethHairStyles_PreUpdate(_, player, taildata)
    local data = player:GetData()
    local spr = player:GetSprite()
    local HairStyle = data._PhysHair_HairStyle
    if HairStyle then
        if HairStyle == "BethPonyTail" then
            local spranim = spr:GetOverlayAnimation()
            local cordspr = mod.BethPonyTailCord:GetSprite()
            if spranim == "HeadRight" then
                cordspr.FlipX = true
            else
                cordspr.FlipX = false
            end
            cordspr:Play(spranim == "HeadLeft" and "cord3" or spranim == "HeadRight" and "cord2" or "cord")
        elseif HairStyle == "BethOneSideTail" then
            local spranim = spr:GetOverlayAnimation()
            local cordspr = mod.BethOneSideCord:GetSprite()
            if spranim == "HeadUp" then
                cordspr.FlipX = true
            else
                cordspr.FlipX = false
            end
        elseif HairStyle == "BethDrillTail" then
            local spranim = spr:GetOverlayAnimation()
            local cordspr = mod.BethDrillTailCord:GetSprite()
            local cordspr2 = mod.BethDrillTailCord2:GetSprite()
            if spranim == "HeadUp" then
                cordspr:Play("cordb")
                cordspr2:Play("cordb2")
            else
                cordspr:Play("cord")
                cordspr2:Play("cord2")
            end
        elseif HairStyle == "BethNoTails" then
            local spranim = spr:GetOverlayAnimation()
            local cordspr = mod.BethNoTailCords["4"]:GetSprite()
            if spranim == "HeadLeft" then
                cordspr.FlipX = true
            else
                cordspr.FlipX = false
            end
        end
    end
end
mod:AddCallback(mod.HairLib.Callbacks.HAIRPHYS_PRE_UPDATE, mod.extraPhysFunc.BethHairStyles_PreUpdate, PlayerType.PLAYER_BETHANY)

--#endregion

--mod.HairLib.SetHairData(PlayerType.PLAYER_BETHANY_B, {
mod.HStyles.AddStyle("BethBDef", PlayerType.PLAYER_BETHANY_B, {
        --CordSpr = cordSprB,
        --TailCount = 2,
        --RenderLayers = headDirToRender,
        --CostumeNullposes = {"bethshair_cord1","bethshair_cord2"},
        HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_BETHANY_B, Type = ItemType.ITEM_NULL},
        ReplaceCostumeSuffix = "_notails",    --"gfx/characters/costumes/character_018b_bethshair_notails.png",
        [1] = {
            Scretch = scretch * 1.2,
            CordSpr = cordSprB,
            RenderLayers = headDirToRender1,
            CostumeNullpos = "bethshair_cord1",
        },
        [2] = {
            Scretch = scretch * 1.2,
            CordSpr = cordSprB,
            RenderLayers = headDirToRender2,
            CostumeNullpos = "bethshair_cord2",
        },
    }, {modfolder = "mods/" .. mod.Foldername .. "/resources"})


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

mod.HairLib.SetHairData(PlayerType.PLAYER_EVE, {
        --CordSpr = cordSprB,
        --TailCount = 2,
        --RenderLayers = headDirToRender,
        --CostumeNullposes = {"bethshair_cord1","bethshair_cord2"},
        --HeadBackSpr = BethBBackHair,
        TargetCostume = {ID = NullItemID.ID_EVE, Type = ItemType.ITEM_NULL},
        ReplaceCostumeSuffix = "_notails",    --"gfx/characters/costumes/character_005_evehead_notails.png",
        SyncWithCostumeBodyColor = true,
        [2] = {
            Scretch = scretch * 1.5,
            DotCount = 4,
            CordSpr = EveHairCord,
            RenderLayers = EveheadDirToRender,
            CostumeNullpos = "evehair_cord1",
            Mass = 10,
            PhysFunc = mod.HairLib.EveheavyHairPhys,
        },
        [3] = {
            Scretch = scretch * 0.8 ,
            CordSpr = EveHairCord2,
            RenderLayers = EveheadDirToRender2,
            CostumeNullpos = "evehair_cord2",
            DotCount = 2,
            Length = 7,
            StartHeight = 3,
            Mass = 25,
        },
        [1] = {
            Scretch = scretch * 1.2,
            CordSpr = EveHairCord,
            RenderLayers = EveheadDirToRender3,
            CostumeNullpos = "evehair_cord3",
            Mass = 20,
            PhysFunc = mod.HairLib.EveheavyHairPhys,
        },
    })

    mod:AddCallback(mod.HairLib.Callbacks.HAIR_POST_INIT, function (_, player, hairdata)
        local plaType = player:GetPlayerType()
        if plaType == PlayerType.PLAYER_EVE then
            --for tail = 1, #hairdata do
                local taildata = hairdata[2]
                --for i=0, taildata.DotCount-1 do --pos                         velocity,     длина
                --    local k = i+1
                --    hairdata[2][i][3] = taildata.Length/taildata.DotCount*k-k*2+5
                --end
                hairdata[1][0][3] = 11

                hairdata[3][1][3] = 13
                hairdata[3][0][3] = 8
                hairdata[3][1][3] = 13
            --end
        end
    end)








    local JudasFezheadDirToRender = {
        [3] = 3, -- 3 << 1,
        [0] = 3, --2 << 1,
        [1] = 3, --3 << 1,
        [2] = 2, --1 << 1
    }

    mod.HairLib.SetHairData(PlayerType.PLAYER_JUDAS, {
        TargetCostume = {ID = NullItemID.ID_JUDAS, Type = ItemType.ITEM_NULL},
        ReplaceCostumeSuffix = "_notails",    --"gfx/characters/costumes/character_004_judasfez_notails.png",
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
        [1] = {
            DotCount = 0,
            Scretch = 0,
            Length = 0,
            CordSpr = JudasFexCord,
            RenderLayers = JudasFezheadDirToRender,
            CostumeNullpos = "judasfez_cord",
            Mass = 0,
            --sprScale = Vector(1,2),
        },
    })
    mod.HairLib.SetHairData(PlayerType.PLAYER_JUDAS_B, {
        TargetCostume = {ID = NullItemID.ID_JUDAS_B, Type = ItemType.ITEM_NULL},
        ReplaceCostumeSheep = "gfx/characters/costumes/character_004b_judasfez_notails.png",
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
        [1] = {
            DotCount = 0,
            Scretch = 0,
            Length = 0,
            CordSpr = JudasFexCordB,
            RenderLayers = JudasFezheadDirToRender,
            CostumeNullpos = "judasfez_cord",
            Mass = 0,
            --sprScale = Vector(1,2),
        },
    })


    --[[mod:AddCallback(mod.HairLib.Callbacks.HAIR_POST_INIT, function (_, player, hairdata)
        local plaType = player:GetPlayerType()
        if plaType == PlayerType.PLAYER_JUDAS or plaType == PlayerType.PLAYER_JUDAS_B then
            for tail = 1, #hairdata do
                local taildata = hairdata[tail]
                for i=0, taildata.DotCount-1 do --pos                         velocity,     длина
                    local k = i+1
                    hairdata[tail][i][3] = taildata.Length/taildata.DotCount*k-k*2+5
                end
                hairdata[1][taildata.DotCount-2][3] = 10
                hairdata[1][taildata.DotCount-1][3] = 13
            end
        end
    end)]]


    for i=1, 40 do
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

    function mod.JudasJunkUpdate(_, player)
        local data = player:GetData()
        if not data._JudasFezFakeCord then
        else
            
            local cdat = data._BethsHairCord
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

        if not data._JudasFezFakeCord then
        elseif JudasFezheadDirToRender[player:GetHeadDirection()] & 1 == 1 then
            if judasFezSpr[ptype] ~= data._JudasFezFakeCord.anm2 then
                data._JudasFezFakeCord.anm2 = judasFezSpr[ptype]
            end
            stupidShit.MegaShitReflectFix()


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
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.JudasJunkPostRender)

    function mod.JudasJunkPreRender(_, player, offset)
        local data = player:GetData()
        if not judasFezSpr[player:GetPlayerType()] or not player:IsExtraAnimationFinished() then
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

    local json = require("json")
    local function updateSaveData()
        local data = {
            OdangoMode = mod.OdangoMode,
            Beth = mod.BlockedChar[PlayerType.PLAYER_BETHANY] and 1 or 0,
            BethB = mod.BlockedChar[PlayerType.PLAYER_BETHANY_B] and 1 or 0,
            Judas = mod.BlockedChar[PlayerType.PLAYER_JUDAS] and 1 or 0,
            JudasB = mod.BlockedChar[PlayerType.PLAYER_JUDAS_B] and 1 or 0,
            Eve = mod.BlockedChar[PlayerType.PLAYER_EVE] and 1 or 0,
        }

        data.PlayerData = {}
        for i=0, game:GetNumPlayers()-1 do
            local player = Isaac.GetPlayer(i)
            local pdata = player:GetData()
            local unickyID = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SAD_ONION):GetSeed()
           
            data.PlayerData[tostring(unickyID)] = {HairStyle = pdata._PhysHair_HairStyle, 
                HairMode = pdata._PhysHair_HairMode}

            mod.MainMenuStuff.RenderCharPort = nil
            mod.CustomCharPortrait = nil
            if i == 0 then
                local hsdata = mod.HStyles.GetStyleData(pdata._PhysHair_HairStyle)
                if hsdata and hsdata.extra then
                    data.PlayerData.CustomCharPortrait = hsdata.extra.CustomCharPortrait
                    mod.CustomCharPortrait = hsdata.extra.CustomCharPortrait
                else
                    mod.CustomCharPortrait = nil
                end
            end
        end
       
        mod:SaveData( json.encode(data) )
    end

    function mod.PlayerPostInit(_, player)
        local data = player:GetData()
        if not data._PHYSHAIR_SAVELOADED then -- and player.FrameCount > 1 then
            data._PHYSHAIR_SAVELOADED = true
            if mod.SavePlayerData then
                local unickyID = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SAD_ONION):GetSeed()
                local savePlayerData = mod.SavePlayerData[tostring(unickyID)]
                
                if savePlayerData and savePlayerData.HairStyle then
                    mod.HStyles.SetStyleToPlayer(player, savePlayerData.HairStyle, savePlayerData.HairMode)
                    --player:GetData()._PhysHair_HairStyle = savePlayerData.HairStyle
                end
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.PlayerPostInit)

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
        mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, function(_, saveslot, isslotselected, rawslot)
            mod.MainMenuStuff.RenderCharPort = nil
            if mod:HasData() then
                local savedata = json.decode(mod:LoadData())

                mod.SavePlayerData = savedata.PlayerData

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
                
                mod.CustomCharPortrait = savedata.PlayerData.CustomCharPortrait
                if mod.CustomCharPortrait then
                    mod.MainMenuStuff.RenderCharPort = true
                    MainMenu.GetContinueWidgetSprite():ReplaceSpritesheet(0, mod.CustomCharPortrait, true)
                end
            
            else
                --[[mod.BlockedChar[PlayerType.PLAYER_BETHANY] = true
                mod.BlockedChar[PlayerType.PLAYER_BETHANY_B] = true
                mod.BlockedChar[PlayerType.PLAYER_JUDAS] = true
                mod.BlockedChar[PlayerType.PLAYER_JUDAS_B] = true
                mod.BlockedChar[PlayerType.PLAYER_EVE] = true]]

                ImGui.UpdateData("PhysHair_BethPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_BETHANY])
                ImGui.UpdateData("PhysHair_BethBPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_BETHANY_B])
                ImGui.UpdateData("PhysHair_JudasPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_JUDAS])
                ImGui.UpdateData("PhysHair_JudasBPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_JUDAS_B])
                ImGui.UpdateData("PhysHair_EveBPhys", ImGuiData.Value, not mod.BlockedChar[PlayerType.PLAYER_EVE])
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
            --print(charlayer:GetSpritesheetPath(), mod.CustomCharPortrait, mod.CustomCharPortrait == charlayer:GetSpritesheetPath())
            if mod.CustomCharPortrait and charlayer then
                print(charlayer:GetSpritesheetPath(), mod.CustomCharPortrait ~= charlayer:GetSpritesheetPath())
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

function mod.MainMenuRender()
    if MenuManager.GetActiveMenu() == MainMenuType.GAME then
        local menuPos = Isaac.WorldToMenuPosition(MainMenuType.GAME, Vector(0,0))

        local widgetSpr = MainMenu.GetContinueWidgetSprite()
        
        local charlayer = widgetSpr:GetLayer(0)
        --print(charlayer:GetSpritesheetPath(), mod.CustomCharPortrait, mod.CustomCharPortrait == charlayer:GetSpritesheetPath())
        if mod.CustomCharPortrait and charlayer then
            --print(charlayer:GetSpritesheetPath(), mod.CustomCharPortrait ~= charlayer:GetSpritesheetPath())
            if mod.CustomCharPortrait ~= charlayer:GetSpritesheetPath() then

                widgetSpr:ReplaceSpritesheet(0, mod.CustomCharPortrait, true)
                MainMenuStuff.RenderCharPort = true

                MainMenuStuff.CharacterWidgetSpr:ReplaceSpritesheet(0, mod.CustomCharPortrait, true)
                MainMenuStuff.CharacterWidgetSpr:LoadGraphics()
            end
        end

        if MainMenuStuff.RenderCharPort then

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
            MainMenuStuff.WidgedCurPos = MainMenuStuff.WidgedMap[MainMenuStuff.frame] or MainMenuStuff.WidgedMap[0]
            MainMenuStuff.WidgedCurScale = MainMenuStuff.WidgedMapScale[MainMenuStuff.frame] or MainMenuStuff.WidgedMapScale[0]

            local wigdedOff = widgetSpr.Offset
            local renderpos = menuPos + MainMenuStuff.WidgetPos + MainMenuStuff.WidgedCurPos + wigdedOff
            MainMenuStuff.CharacterWidgetSpr:Render(renderpos)
            MainMenuStuff.CharacterWidgetSpr.Scale = widgetSpr.Scale * MainMenuStuff.WidgedCurScale
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

BethHair.StyleMenu = {name = "physhair_styleEditorMenu", size = Vector(230,240),
    hairselectoffset = Vector(30,30), hairselectsize = Vector(150, 200),
    hairbtnsoffset = 0,
    hinttextoffset = Vector(0,240),

    charrotateBtnL_offset = Vector(-50, 30),
    charrotateBtnR_offset = Vector(50, 30),
}
local smenu = BethHair.StyleMenu
local preMousePos = Vector(0,0)

local TestSpr = Sprite()
--HairCordSpr:Load("gfx/893.000_ball and chain.anm2", true)
TestSpr:Load("gfx/characters/costumes/bethhair_cord.anm2", true)
TestSpr:PlayOverlay("cord")
TestSpr:Play("cord")
local testcord = Beam(TestSpr, "body", false, false, 3)

--[[
local testimage = Renderer.LoadImage("gfx/characters/costumes/bethhairs_cord.png")
local v1,v2,v3,v4 = Vector(0,0), Vector(32,0), Vector(0,32), Vector(32,32)
local sq = SourceQuad(v1,v2,v3,v4)
local dq = DestinationQuad(v1+Vector(102,102),v2+Vector(102,102),v3+Vector(102,152),v4+Vector(102,152))
local kc1 = KColor(1,1,1,1)
]]

function BethHair.StyleMenu.HUDRender()
    --[[if ms and renderms then
        local t = Isaac.GetTime()
        local vec = Vector(Isaac.GetScreenWidth()/2,Isaac.GetScreenHeight()/2) --Vector(60,60)
        --for i=1,120*20 do
        --	spr1:Render(vec-Vector(60,60))
        --end
        --print("fir", Isaac.GetTime()-t)
        spr1:Update()
        local t1 = Isaac.GetTime()
        for i=1,20 do
            ms:Render(vec)
        end
        --print("sec", Isaac.GetTime()-t1)
        ms:SetPosRotation((t / 30) % 360)
        ms:SetRotation((t / 30) % 360)
    end]]
    --testcord:Add(Vector(10,10),0)
    --testcord:Add(Vector(190,100),30)
    --testcord:Render()

    --print(v1,v2,v3,v4, sq, dq, kc1)
--[[
    local fl = Game():GetRoom():GetBackdrop():GetFloorImage()
    local trans = Renderer.StartTransformation(fl)
    --local sq = SourceQuad(Vector(0,0), Vector(32,0), Vector(0,32), Vector(32,32))
    --local dq = DestinationQuad(Vector(0,0), Vector(32,0), Vector(0,32), Vector(32,32))
    --trans:Render(testimage, sq, dq, kc1)
    trans:Render(testimage, 
        SourceQuad(Vector(0,0), Vector(32,0), Vector(0,32), Vector(32,32)), 
        DestinationQuad(Vector(0,0), Vector(32,0), Vector(0,32), Vector(32,32)), 
        KColor(1,1,1,1))
    --print(trans:IsValid ())
    trans:Apply ()
]]
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
            if wga.ControlType == wga.enum.ControlType.CONTROLLER then
                if pos:Distance(preMousePos) > 3 then
                    wga.ControlType = wga.enum.ControlType.MOUSE
                end
            else
                local move = wga.input.GetRefMoveVector()
                if move:Length() > .2 then
                    wga.ControlType = wga.enum.ControlType.CONTROLLER
                end
            end
            preMousePos = pos

            local wind = smenu.wind
            local player = BethHair.StyleMenu.TargetPlayer and BethHair.StyleMenu.TargetPlayer:ToPlayer()
            local keeper = BethHair.StyleMenu.TargetHairKeeper

            if not wind.custinit then
                wind.custinit = true
                wind.pos = wind.pos + Vector(80, 400)
                if player then
                    player.Velocity = Vector(0, 0)
                    player.Position = keeper.Position + Vector(-70, 0)
                end
            else
                local targetpos = Vector(Isaac.GetScreenWidth()/2+80, Isaac.GetScreenHeight()/2) - smenu.size/2
                wind.pos = wind.pos * 0.9 + targetpos * 0.1

                if wga.ControlType == wga.enum.ControlType.CONTROLLER then
                    local mdata = wga.GetMenu(smenu.name)
                    local btn = wga.ManualSelectedButton[1]

                    if mdata.CurCollum == 1 and btn and smenu.scrollbtn then
                        
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
                player.ControlsCooldown = math.max(player.ControlsCooldown, 3)
            end
            

            if wind.Removed then
                smenu.wind = nil
            end
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

---@type EditorButton
local CharRotateBtnL, CharRotateBtnR

function BethHair.StyleMenu.PreWindowRender(_,pos, wind)
    BethHair.StyleMenu.paperrender( pos+smenu.hairselectoffset, 
        smenu.hairselectsize, 
        Color.Default)

    if smenu.HintText then
        local htpos = pos+smenu.hinttextoffset
        BethHair.StyleMenu.paperrender( htpos-Vector(0,5), 
            Vector(210, 40), 
            Color.Default)

        local text = smenu.HintText
        local x,y = htpos.X, htpos.Y
        local offset = #text == 1 and 10 or #text == 2 and 5 or 0
        wga.DrawMultilineText(1, text, x + 105,y + offset, 1,1, 2)
    end

    local player = BethHair.StyleMenu.TargetPlayer and BethHair.StyleMenu.TargetPlayer:ToPlayer()

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
            end


            --sprs.Buttons:Play("XboxOne", true)

            --sprs.Buttons:SetFrame()
            --sprs.VerySpecialKeyBoardLeftArrow.FlipX = false
            sprs.VerySpecialKeyBoardLeftArrow:SetFrame(1)
            sprs.VerySpecialKeyBoardLeftArrow:Render(centerPos + charrotateBtnL_offset + Vector(0, 30))
            sprs.VerySpecialKeyBoardLeftArrow:SetFrame(2)
            --sprs.VerySpecialKeyBoardLeftArrow.FlipX = true
            sprs.VerySpecialKeyBoardLeftArrow:Render(centerPos + charrotateBtnR_offset + Vector(0, 30))

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

            end

            local inputDeviceName = Input.GetDeviceNameByIdx and Input.GetDeviceNameByIdx(ControllerIndex) or "XboxOne"
            if inputDeviceName and inputDeviceName:find("XInput") then
                inputDeviceName = "XboxOne"
            end

            sprs.Buttons:Play(inputDeviceName, true)
            sprs.Buttons:SetFrame(10)
            sprs.Buttons:Render(centerPos + charrotateBtnL_offset + Vector(0, 30))

            --sprs.Buttons:Play(inputDeviceName, true)
            sprs.Buttons:SetFrame(11)
            sprs.Buttons:Render(centerPos + charrotateBtnR_offset + Vector(0, 30))
        end
    end
end
BethHair:AddCallback(wga.Callbacks.WINDOW_PRE_RENDER, BethHair.StyleMenu.PreWindowRender, smenu.name)


smenu.spr = {scrollback = GenSprite("gfx/editor/hairstyle_menu.anm2","scrollbar"),
    gragger1 = GenSprite("gfx/editor/hairstyle_menu.anm2","scrollbar_gragger1"),
    gragger2 = GenSprite("gfx/editor/hairstyle_menu.anm2","scrollbar_gragger2"),
    gragger3 = GenSprite("gfx/editor/hairstyle_menu.anm2","scrollbar_gragger3"),

    CharRotateL = GenSprite("gfx/editor/hairstyle_menu.anm2", "char_rotate_l"),
    CharRotateR = GenSprite("gfx/editor/hairstyle_menu.anm2", "char_rotate_r"),
    Buttons = GenSprite("gfx/ui/buttons.anm2"),
    VerySpecialKeyBoardLeftArrow = GenSprite("gfx/editor/hairstyle_menu.anm2", "keyboard_arrow_left"),
}

smenu.spr.scrollback.Offset = Vector(-2,-2)
if Sprite().SetCustomShader then
    smenu.spr.Buttons:SetCustomShader("shaders/PhysHairWhiteOutline")
    smenu.spr.VerySpecialKeyBoardLeftArrow:SetCustomShader("shaders/PhysHairWhiteOutline")
end

local greenbtnColor = Color(78/256, 1, 90/256, 1, 3/256, 30/256, 24/256)

greenbtnColor = Color(1,1,1,1, 18/256, 20/256, 7/256)
greenbtnColor:SetColorize(108/256, 1, 85/256, 1 )

local nilspr = Sprite()

function BethHair.StyleMenu.GenWindowBtns(ptype)
    local mdata = wga.GetMenu(smenu.name)
    local navmap = {}
    mdata.navmap = navmap
    navmap.collums = {}

    smenu.PrevStyleName = (BethHair.StyleMenu.TargetPlayer or Isaac.GetPlayer()):GetData()._PhysHair_HairStyle

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
                hintText = wga.stringMultiline(styleexdt.menuHintText, 200)
            end
            
            local hairspr
            if hairgfx then
                if styleexdt and styleexdt.modfolder then
                    hairgfx = styledt.extra.modfolder .. "/" .. hairgfx
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
                    local player = BethHair.StyleMenu.TargetPlayer or Isaac.GetPlayer()
                    BethHair.HStyles.SetStyleToPlayer(player, stylename, smenu.SetStyleMode)
                    
                end, function (pos, visible)
                    spr:SetFrame(self.IsSelected and 1 or 0)
                    local scroolupcrop = self.scrollupcrop
                    local scrolldwoncrop = self.scrolldwoncrop

                    if self.IsSelected then
                        smenu.HintText = hintText
                    end

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
            
            self.row = xy.Y
            self.posfunc = function ()
                self.posref.Y = pos.Y - smenu.hairbtnsoffset
                self.pos = smenu.wind.pos + self.posref
                self.scrollupcrop = -self.posref.Y+40
                self.scrolldwoncrop = self.posref.Y-180

                self.canPressed = self.scrollupcrop < 32 and self.scrolldwoncrop < 40
                
                if smenu.TargetPlayer then
                    if smenu.TargetPlayer:GetData()._PhysHair_HairStyle == stylename then
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
                --    print(xy.Y , #pstyles, xy.Y / #pstyles)
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

    local usephys
    usephys = wga.AddButton(smenu.name, "usephys", Vector(200,148),
    24, 24, GenSprite("gfx/editor/hairstyle_menu.anm2", "button16"),
        function (button)
            if smenu.SetStyleMode then
                smenu.SetStyleMode = nil
            else
                smenu.SetStyleMode = 1
            end

            local player = BethHair.StyleMenu.TargetPlayer or Isaac.GetPlayer()
            BethHair.HStyles.SetStyleToPlayer(player, player:GetData()._PhysHair_HairStyle, smenu.SetStyleMode)
        end, function (pos, visible)
            --BethHair.StyleMenu.acceptspr:Render(pos)
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

            local player = BethHair.StyleMenu.TargetPlayer or Isaac.GetPlayer()
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
        --print(mdata.CurCollum, btn[1].name)
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
    smenu.wind.unuser = true
    smenu.wind.backcolor = Color(1,1,1,1)
    smenu.wind.backcolornfocus = Color(1,1,1,1)

    BethHair.StyleMenu.TargetPlayer = BethHair.StyleMenu.TargetPlayer or Isaac.GetPlayer()

    wga.SetControlType(wga.enum.ControlType.CONTROLLER, BethHair.StyleMenu.TargetPlayer )

    local ptype = BethHair.StyleMenu.TargetPlayer and BethHair.StyleMenu.TargetPlayer:GetPlayerType()
        or Isaac.GetPlayer():GetPlayerType()
    BethHair.StyleMenu.GenWindowBtns(ptype)
end

function BethHair.StyleMenu.CloseWindow()
    wga.CloseWindow(smenu.name)
    smenu.wind = nil
    BethHair.StyleMenu.TargetPlayer = nil
    BethHair.StyleMenu.TargetHairKeeper = nil
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






