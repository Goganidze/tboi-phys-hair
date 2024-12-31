local mod = BethHair

local  Wtr = 20/13
local defscretch = math.ceil(5* Wtr)


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

