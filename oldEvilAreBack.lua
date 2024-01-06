return function()
    local tab = {}
    local game = Game()
    local worldToScreen = Isaac.WorldToScreen

    local function GenSprite(gfx, anim, frame)
        if gfx then
            local spr = Sprite()
            spr:Load(gfx, true)
            if anim then
                spr:Play(anim)
            else
                spr:Play(spr:GetDefaultAnimation())
            end
            if frame then
                spr:SetFrame(frame)
            end
            return spr
        end
    end

    local Wtr = 20/13
    local z = Vector(0,0)
    local worldToScreen1 = Isaac.WorldToScreen
    local function worldToScreen(vec)
        return worldToScreen1(vec) -- worldToScreen1(z) + vec/Wtr
    end
    
    local function ScreenToWorld(vec)
        return  (vec-worldToScreen1(Vector(0,0))) * Wtr
    end

    function tab.cordUpdate(data, ent, headPos, playerPos)
        local _JFFC = data._JudasFezFakeCord
        local room = game:GetRoom()
        local spr = _JFFC.SavedSpr 

        local Stretch = _JFFC.Stretch or 0
        
        --local Dis = ent.Position:Distance(LastPos)
        local CountPos = _JFFC.Unit or 10

        spr.Color = ent:GetSprite().Color

        --if then --физика
            if not _JFFC["CordFrame"] and Isaac.GetFrameCount() % 2 == 0 then
                spr:Update()
                --frame = spr:GetFrame()
            elseif _JFFC["CordFrame"] then
                spr:SetFrame(_JFFC["CordFrame"])
            end
            local headWorldPos =  ScreenToWorld(headPos)

            for i = 1, CountPos - 1 do
                --if not Game():IsPaused() and i ~= CountPos and Isaac.GetFrameCount()%2 == 0 then

                if not _JFFC.vel or (_JFFC.vel and _JFFC.vel[i] == nil) then
                    _JFFC.vel = {}
                    for j = 1, #_JFFC.pos do
                        _JFFC.vel[j] = Vector(0, 0)
                    end
                end

                local nextpos
                if _JFFC.pos[i + 1] then
                    nextpos = _JFFC.pos[i + 1]
                end
                --if i + 1 == CountPos and LastPos then
                    --nextpos = _JFFC.target.Position + _JFFC["baseOffset"] * 1.54 
                --end

                local prepos
                if _JFFC.pos[i - 1] then
                    prepos = _JFFC.pos[i - 1]
                end
                if i - 1 == 0 then
                    prepos = ScreenToWorld(_JFFC["targetOffset"] ) --+ ent.Position
                end

                if prepos then
                    ---@type Vector
                    local scale = ent:GetSprite().Scale.Y
                    local lpos = _JFFC.pos[i]
                    local height = _JFFC.Height[i] or 0

                    local bttdis = lpos:Distance(prepos)
            

                    --local bttdis = prepos:Distance(nextpos)
                    local velic = Vector(0,0)
                    if nextpos then
                        velic = (nextpos - lpos):Resized( math.min(Stretch*3, math.max(0, (nextpos:Distance(lpos) - Stretch*(scale)*0.8 ) * 0.10)) ) --0.07
                        velic = velic + Vector(0, (.05)*scale)
                    else
                        velic = velic + Vector(0, (.25)*scale)
                    end

                    local bttdis = lpos:Distance(prepos)
            
                    if bttdis > Stretch*3*scale then
                        _JFFC.pos[i] = prepos-(prepos-lpos):Resized(Stretch*3*scale)
                        lpos = _JFFC.pos[i]
                        --bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
                    end

                    velic = velic +
                        (prepos - lpos):Resized(
                        math.max(0, (prepos:Distance(lpos) - Stretch*(scale)) * 0.1))
                    --velic = Dungeon and (velic + Vector(0, 0.1)) or velic
                    --velic = velic + Vector(0, ((i)*.05+.2)*scale)

                    if headPos then
                        local headPos = headWorldPos
                        local bttdis = lpos:Distance(headPos)/scale
                        local vel = (lpos - headPos):Resized(math.max(0, (27)-bttdis)*.06)
                        --_JFFC.pos[i] = _JFFC.pos[i] *.8 + vel* .2
                        _JFFC.vel[i] = _JFFC.vel[i] + vel*.1
                    end

                    lpos = _JFFC.pos[i]

                    _JFFC.vel[i] = _JFFC.vel[i] + velic  
                    _JFFC.pos[i] = lpos + _JFFC.vel[i]
                    _JFFC.vel[i] = _JFFC.vel[i] * 0.87

                    local ScreenPos = worldToScreen(lpos)
                    --local ScreenPos = Isaac.WorldToRenderPosition(_JFFC.pos[i])

                    _JFFC.Renderpos[i] = ScreenPos --+ Vector(0,height)
                    --_JFFC.shadowpos[i] = ScreenPos - Vector(0, height)

                    --if rendermode == RenderMode.RENDER_WATER_ABOVE then
                        local yof =  playerPos.Y - ScreenPos.Y   --ScreenToWorld(playerPos).Y - lpos.Y 
                        _JFFC.Reflectpos[i] = ScreenPos + Vector(0,  yof*2)    --worldToScreen( Vector(lpos.X,lpos.Y - yof*2 )   )    --- ScreenPos + Vector(0, height.Y*2)  
                        
                    --end

                    
                end
                --end
            end
        --end
    end


    function tab.cordrender2(data, ent, offset, headPos, playerPos)
        --local Edata = ent:GetData()

        if data._JudasFezFakeCord  and not data._JudasFezFakeCord.ignoreFrame then
            local _JFFC = data._JudasFezFakeCord
            local room = game:GetRoom()
            local rendermode = room:GetRenderMode()
            --local LastPos = worldToScreen(_JFFC.target.Position)
            --local LastPos = Isaac.WorldToScreen( _JFFC.target.Position )
            --local LastTarget = _JFFC.target

            if not _JFFC.SavedSpr or _JFFC.SavedSpr and not _JFFC.SavedSpr:GetFilename() then
                _JFFC.SavedSpr = Sprite()
                local anm = _JFFC.anm or "gfx/SWforgotten_chain.anm2"
                _JFFC.SavedSpr = anm --:Load(anm, true)
                --if _JFFC.Sprite then
                --    _JFFC.SavedSpr:ReplaceSpritesheet(0, _JFFC["Sprite"])
                --    _JFFC.SavedSpr:LoadGraphics()
                --end
                --_JFFC.SavedSpr:Play("cord", true)
                if not _JFFC["NoShadow"] then
                    _JFFC.SavedShadowSpr = Sprite()
                    _JFFC.SavedShadowSpr:Load(anm, true)
                    _JFFC.SavedShadowSpr:Play("shadow", false)
                    _JFFC.SavedShadowSpr.Color = Color.Default
                end
            end

            local spr = _JFFC.SavedSpr or Sprite():Load("gfx/SWforgotten_chain.anm2", true)
            spr.Color = ent:GetSprite().Color -- _JFFC.target:GetColor()
            --local Shadowspr = not _JFFC["NoShadow"] and _JFFC.SavedShadowSpr or
            --GenSprite("gfx/SWforgotten_chain.anm2")

            local basePos = worldToScreen(ent.Position)
            --local basePos = Isaac.WorldToRenderPosition(ent.Position )
            --local targetPos = LastPos

            _JFFC["baseOffset"] = _JFFC["baseOffset"] or Vector(0, 0)
            _JFFC["targetOffset"] = _JFFC["targetOffset"] or Vector(0, 0)

            local clamb = 0

            local Stretch = _JFFC.Stretch or 0

            --local Dis = ent.Position:Distance(LastPos)
            local CountPos = _JFFC.Unit or 10

            local Dungeon = false
            if room:GetType() == RoomType.ROOM_DUNGEON then
                Dungeon = true
            end
            local spritelenght = _JFFC.length or 96

            local frame = spr:GetFrame()

            if not _JFFC.pos then --Инит
                _JFFC.pos = {}
                _JFFC.Renderpos = {}
                _JFFC.vel = {}
                _JFFC.Zoff = {}
                _JFFC.CosinCoff = {}
                _JFFC.Height = {}
                _JFFC.shadowpos = {}
                for i = 1, CountPos - 1 do
                    --local TarPos = _JFFC.target.Position
                    _JFFC.pos[i] = ent.Position  --- (ent.Position - TarPos) / (CountPos - i)
                end
                for i = 1, CountPos do
                    _JFFC.CosinCoff[i] = math.abs(i - 1 - (CountPos) / 2) / ((CountPos) / 2)

                    local TOff = _JFFC["targetOffset"].Y * (CountPos - i) / (CountPos)
                    local BOff = _JFFC["baseOffset"].Y * (i) / (CountPos)
                    local height = (TOff + BOff) --*1.538
                    _JFFC.Height[i] = height
                    _JFFC.Zoff[i] = 0
                end
            end
            if rendermode == RenderMode.RENDER_WATER_REFLECT and not _JFFC.Reflectpos then --Инит для отражения
                _JFFC.Reflectpos = {}
                --_JFFC.Reflectvel = {}
                for i = 1, #_JFFC.pos do
                    _JFFC.Reflectpos[i] = _JFFC.pos[i]
                    --_JFFC.Reflectvel[i] = Vector(0,0)
                end
            end

            --[[if _JFFC["targetOffset"] or _JFFC["baseOffset"] then
                _JFFC.LastOffset = _JFFC.LastOffset or
                { targetOffset = _JFFC["targetOffset"], baseOffset = _JFFC["baseOffset"] }
                if (_JFFC.LastOffset["targetOffset"].X ~= _JFFC["targetOffset"].X or _JFFC.LastOffset["targetOffset"].Y ~= _JFFC["targetOffset"].Y)
                    or (_JFFC.LastOffset["baseOffset"].X ~= _JFFC["baseOffset"].X or _JFFC.LastOffset["baseOffset"].Y ~= _JFFC["baseOffset"].Y) then
                    _JFFC.OffsetChanged = true
                end
                _JFFC.LastOffset["targetOffset"] = _JFFC["targetOffset"]
                _JFFC.LastOffset["baseOffset"] = _JFFC["baseOffset"]
            end]]

            --if _JFFC.OffsetChanged then
                --for i = 1, CountPos do
                    --_JFFC.CosinCoff[i] = math.abs(i - 1 - (CountPos) / 2) / ((CountPos) / 2)
                    --local PrA, PrB = (CountPos-i)/(CountPos), (i-1)/(CountPos)
                   --local TOff = _JFFC["targetOffset"].Y * (CountPos - i) / (CountPos)
                    --local BOff = _JFFC["baseOffset"].Y * (i) / (CountPos)
                    --local height = worldToScreen(ent.Position ) - _JFFC["targetOffset"]    --(TOff + BOff) --*1.538
                    --_JFFC.Height[i] = height
                    --print(i,PrA, PrB,PrA+ PrB)
                --end

                --_JFFC.Height[1] = worldToScreen(ent.Position ) - _JFFC["targetOffset"]
                --_JFFC.Height[2] = _JFFC.Height[1] / 1.5

                --_JFFC.OffsetChanged = nil
            --end

            --[[if not game:IsPaused() and rendermode ~= RenderMode.RENDER_WATER_REFLECT then --физика
                if not _JFFC["CordFrame"] and Isaac.GetFrameCount() % 2 == 0 then
                    spr:Update()
                    --frame = spr:GetFrame()
                elseif _JFFC["CordFrame"] then
                    spr:SetFrame(_JFFC["CordFrame"])
                end
                local headWorldPos =  ScreenToWorld(headPos)

                for i = 1, CountPos - 1 do
                    --if not Game():IsPaused() and i ~= CountPos and Isaac.GetFrameCount()%2 == 0 then

                    if not _JFFC.vel or (_JFFC.vel and _JFFC.vel[i] == nil) then
                        _JFFC.vel = {}
                        for j = 1, #_JFFC.pos do
                            _JFFC.vel[j] = Vector(0, 0)
                        end
                    end

                    local nextpos
                    if _JFFC.pos[i + 1] then
                        nextpos = _JFFC.pos[i + 1]
                    end
                    --if i + 1 == CountPos and LastPos then
                        --nextpos = _JFFC.target.Position + _JFFC["baseOffset"] * 1.54 
                    --end

                    local prepos
                    if _JFFC.pos[i - 1] then
                        prepos = _JFFC.pos[i - 1]
                    end
                    if i - 1 == 0 then
                        prepos = ScreenToWorld(_JFFC["targetOffset"] ) --+ ent.Position
                    end

                    if prepos then
                        ---@type Vector
                        local scale = ent:GetSprite().Scale.Y
                        local lpos = _JFFC.pos[i]
                        local height = _JFFC.Height[i] or 0

                        --local bttdis = prepos:Distance(nextpos)
                        local velic = Vector(0,0)
                        if nextpos then
                            velic = (nextpos - lpos):Resized(
                                math.max(0, (nextpos:Distance(lpos) - Stretch*(scale)*0.8 ) * 0.20)) --0.07
                            velic = velic + Vector(0, (.05)*scale)
                        else
                            velic = velic + Vector(0, (.2)*scale)
                        end

                        local bttdis = lpos:Distance(prepos)
                
                        if bttdis > Stretch*1.2*scale then
                            _JFFC.pos[i] = prepos-(prepos-lpos):Resized(Stretch*1.2*scale)
                            lpos = _JFFC.pos[i]
                            --bttdis = scretch*scale -- math.min(bttdis, scretch*scale*4) --/scale
                        end

                        velic = velic +
                            (prepos - lpos):Resized(
                            math.max(0, (prepos:Distance(lpos) - Stretch*(scale)) * 0.10))
                        --velic = Dungeon and (velic + Vector(0, 0.1)) or velic
                        --velic = velic + Vector(0, ((i)*.05+.2)*scale)

                        if headPos then
                            local headPos = headWorldPos
                            local bttdis = lpos:Distance(headPos)/scale
                            --print(lpos , headPos)
                            local vel = (lpos - headPos):Resized(math.max(0, (27)-bttdis)*.06)
                            --_JFFC.pos[i] = _JFFC.pos[i] *.8 + vel* .2
                            _JFFC.vel[i] = _JFFC.vel[i] + vel*.1
                        end


                        _JFFC.vel[i] = _JFFC.vel[i] + velic                                                                 --*0.8
                        _JFFC.pos[i] = lpos + _JFFC.vel[i]
                        _JFFC.vel[i] = _JFFC.vel[i] * 0.87

                        local ScreenPos = worldToScreen(lpos)
                        --local ScreenPos = Isaac.WorldToRenderPosition(_JFFC.pos[i])

                        _JFFC.Renderpos[i] = ScreenPos --+ Vector(0,height)
                        --_JFFC.shadowpos[i] = ScreenPos - Vector(0, height)

                        if rendermode == RenderMode.RENDER_WATER_ABOVE then
                            local yof =  playerPos.Y - ScreenPos.Y   --ScreenToWorld(playerPos).Y - lpos.Y 
                            _JFFC.Reflectpos[i] = ScreenPos + Vector(0,  yof*2)    --worldToScreen( Vector(lpos.X,lpos.Y - yof*2 )   )    --- ScreenPos + Vector(0, height.Y*2)  
                            --print(i, _JFFC.Reflectpos[i], ScreenPos ,"|", ScreenToWorld(playerPos), lpos)
                        end

                        
                    end
                    --end
                end
            end]]

            spr.FlipY = rendermode == RenderMode.RENDER_WATER_REFLECT

            local IsReflect = rendermode == RenderMode.RENDER_WATER_REFLECT

            local clr = spr.Color
            local targetPos = _JFFC.pos[CountPos-1]
            local CordKcolor = ent:GetPlayerType() == PlayerType.PLAYER_JUDAS 
                and KColor(69/256 * clr.R, 66/256 * clr.G, 6/256 * clr.B, 1 * clr.A) or KColor(0.02* clr.R, 0.05* clr.G, 0.05* clr.B, 1* clr.A)

            if basePos and targetPos and not IsReflect or (IsReflect and not _JFFC["NoReflect"] and _JFFC.OffsetReflect) then
                for i = 1, CountPos do --Рендер
                    --Опредение начальной точки(basePos) и конечной точки(targetPos)
                    if i ~= 1 and _JFFC.Renderpos[i - 1] then
                        if IsReflect then
                            basePos = _JFFC.Reflectpos[i - 1] -- worldToScreen(ent.Position)
                        else
                            basePos = _JFFC.Renderpos[i - 1]
                        end
                    end
                    if i < CountPos and i ~= 1 and _JFFC.Renderpos[i] then
                        if IsReflect then
                            targetPos = _JFFC.Reflectpos[i]  -- worldToScreen(ent.Position)
                        else
                            targetPos = _JFFC.Renderpos[i]
                        end
                    elseif i == CountPos and LastPos then
                        targetPos = LastPos --game:GetRoom():WorldToScreenPosition(LastPos)

                        if _JFFC["baseOffset"] then
                            if IsReflect then
                                targetPos = targetPos +
                                Vector(_JFFC["baseOffset"].X, -_JFFC["baseOffset"].Y)                 --_JFFC["baseOffset"]
                            else
                                targetPos = targetPos + _JFFC["baseOffset"]
                            end
                        end
                    end
                    if i == 1 and _JFFC.Renderpos[i] then
                        if IsReflect then
                            if _JFFC["targetOffset"] then
                                basePos = --playerPos --basePos +
                                   Vector(_JFFC["targetOffset"].X, _JFFC["targetOffset"].Y) -- worldToScreen(ent.Position)
                                local yof =  playerPos.Y - basePos.Y
                                basePos.Y = basePos.Y +  yof*2
                            end
                            targetPos = _JFFC.Reflectpos[i]  --+ worldToScreen(ent.Position) 
                        else
                            if _JFFC["targetOffset"] then
                                basePos = _JFFC["targetOffset"] -- basePos + _JFFC["targetOffset"]
                            end
                            targetPos = _JFFC.Renderpos[i]
                        end
                    end

                    local height
                    if not _JFFC["NoZ"] and basePos and targetPos
                        and not IsReflect then --Смещение по высоте
                        local Zoffset
                        local CosinCoff = _JFFC["NoZ"] and 1 or (_JFFC.CosinCoff[i] or 0)
                        local ZoffMulti = _JFFC["NoZ"] and 0 or (_JFFC.ZoffMulti or 0)
                        local bottomBorder = 8
                        local bottomBorderMulti = 35

                        Zoffset = Dungeon and 0 or _JFFC["NoZ"] and 0 or
                        math.min(bottomBorder,
                            math.max(0, bottomBorderMulti / basePos:Distance(targetPos) / 1.54 - 1) * (1 - CosinCoff) *
                            ZoffMulti * 1)

                        height = (Zoffset or 0) or 0 --_JFFC.Height[i]

                        if not Game():IsPaused() then
                            _JFFC.Zoff[i] = (_JFFC.Zoff[i] or 0) * 0.7 + Zoffset * 0.3
                        end
                    else
                        --height = _JFFC.Height[i] --(TOff + BOff)
                    end

                    if i ~= 1 then
                        if IsReflect then
                            basePos = basePos -- Vector(0, _JFFC.Zoff[i] or 0)
                        else
                            basePos = basePos --+ Vector(0, _JFFC.Zoff[i] or 0)
                        end
                    end
                    if i < CountPos and i ~= 1 then
                        if IsReflect then
                            targetPos = targetPos - Vector(0, _JFFC.Zoff[i + 1] or 0)
                        else
                            targetPos = targetPos + Vector(0, _JFFC.Zoff[i + 1] or 0)
                        end
                    end
                    if i == 1 then
                        if _JFFC["targetOffset"] then
                            if IsReflect then
                                targetPos = targetPos - Vector(0, _JFFC.Zoff[i + 1] or 0)
                            else
                                targetPos = targetPos + Vector(0, _JFFC.Zoff[i + 1] or 0)
                            end
                        end
                    end

                    --Рендер
                    if ent.FrameCount > 1 and basePos and targetPos  then

                        if i < CountPos-1 then
                            --spr.Offset = Vector(0,0)
                            --spr.Scale = Vector(ent:GetSprite().Scale.X , (basePos):Distance(targetPos) / (spritelenght / CountPos) )
                            --spr.Rotation = (targetPos - basePos):GetAngleDegrees() -90

                            if not IsReflect then --Почему игра не может выдавать правильный offset
                                _JFFC.OffsetReflect = offset
                            elseif IsReflect and _JFFC.OffsetReflect then
                                --spr.Offset = spr.Offset - _JFFC.OffsetReflect + offset
                            end

                            --spr:Render(basePos - _JFFC.OffsetReflect + offset, Vector(0, 0), Vector(0, 6.66))
                            Isaac.DrawLine(basePos-_JFFC.OffsetReflect+offset, targetPos-_JFFC.OffsetReflect+offset,CordKcolor,CordKcolor,ent:GetSprite().Scale.X)
                        elseif i == CountPos-1 then
                            spr.Rotation = (targetPos - basePos):GetAngleDegrees() -90
                            local bttdis = (basePos):Distance(targetPos)
                            spr.Offset = Vector(0, (bttdis+1.2) * (i - 1)):Rotated(spr.Rotation + 180)
                            spr.Scale = Vector(ent:GetSprite().Scale.X , (bttdis) / (spritelenght / CountPos) )

                            if rendermode == RenderMode.RENDER_WATER_ABOVE then --Почему игра не может выдавать правильный offset
                                _JFFC.OffsetReflect = offset
                            elseif IsReflect and _JFFC.OffsetReflect then
                                --spr.Offset = spr.Offset - _JFFC.OffsetReflect + offset
                            end
                            --spr.Rotation = (targetPos - basePos):GetAngleDegrees() -90

                            if IsReflect and _JFFC.OffsetReflect then
                                spr:Render(basePos - _JFFC.OffsetReflect + offset, Vector(0, 9.3), Vector(0, 0))
                            else
                                spr:Render(basePos, Vector(0, 11.3), Vector(0, 0))
                            end
                            

                            --Isaac.DrawLine(basePos+Vector(2,0), targetPos,KColor(2,.2,.2, .1),KColor(2,.2,.2, .3), .5)
                        end
                        --Isaac.DrawLine(renderPos, targetPos,KColor(2,.2,.2, .1),KColor(2,.2,.2, .3),1)
                    end
                end
            end

            --[[if _JFFC.pos and _JFFC.targetOffset and not _JFFC.ignoreFrame
                and _JFFC.pos[1] and _JFFC.pos[1].Y - _JFFC.targetOffset.Y * 1.5 <= ent.Position.Y
                and rendermode ~= RenderMode.RENDER_WATER_REFLECT then
                _JFFC.ignoreFrame = true
                ent:Render(Vector(0, 0) + offset)
            end]]
        elseif data._JudasFezFakeCord and data._JudasFezFakeCord.ignoreFrame then
            data._JudasFezFakeCord.ignoreFrame = nil
        end
    end

    return tab
end