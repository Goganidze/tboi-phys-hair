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

mod.DR = false

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
BethBBackHair = mod.BethBBackHair
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

mod.HairLib = include("physhair")
---@type _HairCordData
mod.HairLib = mod.HairLib(mod)
mod.HairLib.SetHairData(PlayerType.PLAYER_BETHANY, {
        --CordSpr = cordSpr,
        --TailCount = 2,
        --RenderLayers = headDirToRender,
        --CostumeNullposes = {"bethshair_cord1","bethshair_cord2"},
        TargetCostume = {ID = NullItemID.ID_BETHANY, Type = ItemType.ITEM_NULL},
        ReplaceCostumeSuffix = "_notails",    --"gfx/characters/costumes/character_001x_bethshair_notails.png",
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
mod.HairLib.SetHairData(PlayerType.PLAYER_BETHANY_B, {
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
        ImGui.RemoveWindow(menuID)
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
