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

--mod.HairLib.SetHairData(PlayerType.PLAYER_BETHANY, {
mod.HStyles.AddStyle("BethDef", PlayerType.PLAYER_BETHANY, {
        --CordSpr = cordSpr,
        --TailCount = 2,
        --RenderLayers = headDirToRender,
        --CostumeNullposes = {"bethshair_cord1","bethshair_cord2"},
        TargetCostume = {ID = NullItemID.ID_BETHANY, Type = ItemType.ITEM_NULL},
        --ReplaceCostumeSuffix = "_notails",    --"gfx/characters/costumes/character_001x_bethshair_notails.png",
        SkinFolderSuffics = "gfx/characters/costumes/",
        ReplaceCostumeSheep = "gfx/characters/costumes/character_001x_bethshair_notails.png",
        TailCostumeSheep = "gfx/characters/costumes/character_001x_bethshair.png",
        NullposRefSpr = GenSprite("mods/physhair/resources/gfx/characters/character_001x_bethanyhead.anm2"),
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
    })

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
})

mod.BethLowTailsCord = BeamR("gfx/characters/costumes/beth_styles/lowtwotail/bethhair_lowtails_cord.anm2", "cord", "body", false, false, 3)
mod.BethLowTailsCord2 = BeamR("gfx/characters/costumes/beth_styles/lowtwotail/bethhair_lowtails_cord.anm2", "cord2", "body", false, false, 3)
mod.BethLowTailsNullPos = Sprite()
mod.BethLowTailsNullPos:Load("gfx/characters/costumes/beth_styles/lowtwotail/bethanyhead_lowtails.anm2", true)
do
    local l =  mod.BethLowTailsCord:GetSprite():GetLayer(0)
    l:SetCropOffset(Vector(1,l:GetCropOffset().Y))
end



mod.BethBackHair_lowtails = Sprite()
BethBackHair_lowtails = mod.BethBackHair_lowtails
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
        end
    end
end
mod:AddCallback(mod.HairLib.Callbacks.HAIRPHYS_PRE_UPDATE, mod.extraPhysFunc.BethHairStyles_PreUpdate, PlayerType.PLAYER_BETHANY)

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
    })


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
       
        mod:SaveData( json.encode(data) )
    end

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
    end
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

    mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, function(_, saveslot, isslotselected, rawslot)
        if mod:HasData() then
            local savedata = json.decode(mod:LoadData())
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


if Isaac.GetPlayer() then
    for i=0, game:GetNumPlayers() do
        Isaac.GetPlayer(i):GetData()._BethsHairCord = nil
    end
end


-----------------------------------------------------
testvec = Vector(20, 20)
local ms
local spr1 = GenSprite("gfx/001.000_player.anm2", "WalkDown")
if MultiSprite then
    ms = MultiSprite()
    ms:AddSprite(0, spr1, testvec )
    --for i=1,120 do
    --    ms:AddSprite(i, spr1, Vector(20+(i%30)*10-150, 20+math.floor(i/30)*20-40))
    --end
end
SpriteBuffer = ms
GenSprite1 = GenSprite



---@type wga_menu
BethHair.WGA = include("worst gui api")
local wga = BethHair.WGA

BethHair.StyleMenu = {name = "physhair_styleEditorMenu", size = Vector(230,240),
    hairselectoffset = Vector(30,30), hairselectsize = Vector(150, 200),
    hairbtnsoffset = 0
}
local smenu = BethHair.StyleMenu
local preMousePos = Vector(0,0)

function BethHair.StyleMenu.HUDRender()
    if ms and renderms then
        local t = Isaac.GetTime()
        local vec = Vector(Isaac.GetScreenWidth()/2,Isaac.GetScreenHeight()/2) Vector(60,60)
        --for i=1,120*20 do
        --	spr1:Render(vec)
        --end
        --print("fir", Isaac.GetTime()-t)
        spr1:Update()
        local t1 = Isaac.GetTime()
        --for i=1,20 do
            ms:Render(vec)
        --end
        print("sec", Isaac.GetTime()-t1)
    end

    local notpaused = not game:IsPaused()
    if notpaused then
        --wga.DetectMenuButtons(smenu.name)
        wga.MousePos = Isaac.WorldToScreen(Input.GetMousePosition(true))-game.ScreenShakeOffset
    end
	--wga.RenderMenuButtons(smenu.name)

    if notpaused then

        local pos = Isaac.WorldToScreen(Input.GetMousePosition(true))-Isaac_Tower.game.ScreenShakeOffset
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

        wga.HandleWindowControl()

        --window logic
        if smenu.wind then
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
end

function BethHair.StyleMenu.PreWindowRender(_,pos, wind)
    BethHair.StyleMenu.paperrender( pos+smenu.hairselectoffset, 
        smenu.hairselectsize, 
        Color.Default)
end
BethHair:AddCallback(wga.Callbacks.WINDOW_PRE_RENDER, BethHair.StyleMenu.PreWindowRender, smenu.name)


smenu.spr = {scrollback = GenSprite("gfx/editor/hairstyle_menu.anm2","scrollbar"),
    gragger1 = GenSprite("gfx/editor/hairstyle_menu.anm2","scrollbar_gragger1"),
    gragger2 = GenSprite("gfx/editor/hairstyle_menu.anm2","scrollbar_gragger2"),
    gragger3 = GenSprite("gfx/editor/hairstyle_menu.anm2","scrollbar_gragger3")}

smenu.spr.scrollback.Offset = Vector(-2,-2)

function BethHair.StyleMenu.GenWindowBtns(ptype)
    local mdata = wga.GetMenu(smenu.name)
    local navmap = {}
    mdata.navmap = navmap
    navmap.collums = {}

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
        local nilspr = Sprite()
        local lastrow = 0

        if smenu.hairscount then
            for i=1, smenu.hairscount do
                wga.RemoveButton(smenu.name, "style" .. i)
            end
        end

        for i=1, #pstyles do
            local stylename = pstyles[i]
            
            local spr = GenSprite("gfx/editor/hairstyle_menu.anm2","button")
            local hairgfx = stylesdata[stylename] and stylesdata[stylename].data and stylesdata[stylename].data.TailCostumeSheep
            
            local hairspr
            if hairgfx then
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
                    BethHair.HStyles.SetStyleToPlayer(player, stylename)
                end, function (pos, visible)
                    spr:SetFrame(self.IsSelected and 1 or 0)
                    local scroolupcrop = self.scrollupcrop
                    local scrolldwoncrop = self.scrolldwoncrop

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
                Sprite(), Sprite(),
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

    local close
    close = wga.AddButton(smenu.name, "disчё", Vector(200,200),
    24, 24, GenSprite("gfx/editor/hairstyle_menu.anm2", "button16"),
        function (button)
            BethHair.StyleMenu.CloseWindow()
        end, function (pos, visible)
            BethHair.StyleMenu.closespr:Render(pos)
        end)
    wga.ManualSelectedButton = { close, smenu.name }
    mdata.CurCollum = 2
    mdata.HairSelPos = Vector(3,2)

    navmap.collums[2][1] = close

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
                end
            end

        end
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




