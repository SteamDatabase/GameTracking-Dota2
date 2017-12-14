PHYSICS_VERSION = "1.01"

PHYSICS_NAV_NOTHING = 0
PHYSICS_NAV_HALT = 1
PHYSICS_NAV_SLIDE = 2
PHYSICS_NAV_BOUNCE = 3
PHYSICS_NAV_GROUND = 4

PHYSICS_GROUND_NOTHING = 0
PHYSICS_GROUND_ABOVE = 1
PHYSICS_GROUND_LOCK = 2

COLLIDER_SPHERE = 0
COLLIDER_BOX = 1
COLLIDER_AABOX = 2

PHYSICS_THINK = 0.01

if Physics == nil then
  print ( '[PHYSICS] creating Physics' )
  Physics = {}
  Physics.__index = Physics
end

function IsPhysicsUnit(unit)
  return unit.GetPhysicsVelocity ~= nil
end

function Physics:new( o )
  o = o or {}
  setmetatable( o, Physics )
  return o
end

ColliderProfiles = {}

function ColliderProfiles:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Physics:start()
  Physics = self

  if self.thinkEnt == nil then
    self.timers = {}
    self.Colliders = {}
    self.ColliderProfiles = {}
    self.anggrid = nil
    self.offsetX = nil
    self.offsetY = nil
    self.colliderSkipOffset = 0
    self.frameCount = 0

    --self.thinkEnt = Entities:CreateByClassname("info_target") -- Entities:FindByClassname(nil, 'CWorld')
    self.thinkEnt = SpawnEntityFromTableSynchronous("info_target", {targetname="physics_lua_thinker"})
    --wspawn:SetContextThink("PhysicsThink", Dynamic_Wrap( Physics, 'Think' ), PHYSICS_THINK )
    self.thinkEnt:SetThink("Think", self, "physics", PHYSICS_THINK)

    Convars:RegisterCommand( "phystest", Dynamic_Wrap(Physics, 'PhysicsTestCommand'), "Test different Physics library commands", FCVAR_CHEAT )
  end
end

function Physics:CreateColliderProfile(name, profile)
  self.ColliderProfiles[name] = ColliderProfiles:new(profile)
  profile.name = name
  return self.ColliderProfiles[name]
end

function Physics:ColliderFromProfile(name, collider)
  return self.ColliderProfiles[name]:new(collider)
end

function Physics:AddCollider(name, collider)
  if type(name) == "table" then
    collider = name
    name = DoUniqueString("collider")
  end

  collider.skipOffset = self.colliderSkipOffset
  self.colliderSkipOffset = self.colliderSkipOffset + 1

  collider.name = name
  self.Colliders[name] = collider
  return collider
end

function Physics:RemoveCollider(name)
  if type(name) == "table" then
    name = name.name
  end

  local collider = self.Colliders[name]
  if collider == nil then
    return
  end
  if collider.unit ~= nil and collider.unit.oColliders[collider.name] ~= nil then
    collider.unit.oColliders[collider.name] = nil
  end


  self.Colliders[name] = nil
end

function Physics:Think()
  if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
    return
  end

  -- Track game time, since the dt passed in to think is actually wall-clock time not simulation time.
  local now = GameRules:GetGameTime()
  --print("now: " .. now)
  if Physics.t0 == nil then
    Physics.t0 = now
  end
  local dt = now - Physics.t0
  Physics.t0 = now

  self.frameCount = self.frameCount + 1

  -- Process timers
  for k,v in pairs(Physics.timers) do
    -- Run the callback
    local status, nextCall = pcall(v.callback, Physics, v)

    -- Make sure it worked
    if status then
      -- Check if it needs to loop
      if nextCall then
        -- Change it's end time
        v.endTime = nextCall
      else
        Physics.timers[k] = nil
      end

      -- Update timer data
      --self:UpdateTimerData()
    else
      -- Nope, handle the error
      Physics.timers[k] = nil
      print('[PHYSICS] Timer error:' .. nextCall)
    end
  end

  if dt > 0 then
    for name,collider in pairs(Physics.Colliders) do
      if collider.skipFrames == 0 or ((self.frameCount + collider.skipOffset) % (collider.skipFrames + 1) == 0) then
        if collider.type == COLLIDER_SPHERE then
          local rad2 = collider.radius * collider.radius
          local unit = collider.unit
          if IsValidEntity(unit) then
            if collider.draw then
              local alpha = 0
              local color = Vector(200,0,0)
              if type(collider.draw) == "table" then
                alpha = collider.draw.alpha or alpha
                color = collider.draw.color or color
              end

              DebugDrawCircle(unit:GetAbsOrigin(), color, alpha, collider.radius, true, .01)
            end

            local ents = nil
            if collider.filter then
              if type(collider.filter) == "table" then
                ents = collider.filter
              else
                local status = nil
                status, ents = pcall(collider.filter, collider)
                if not status then
                  print('[PHYSICS] Collision Filter Failure!: ' .. ents)
                end
              end
            else
              ents = Entities:FindAllInSphere(unit:GetAbsOrigin(), collider.radius + 200)
            end

            for k,v in pairs(ents) do
              if IsValidEntity(v) and IsValidEntity(unit) and v ~= unit and rad2 >= VectorDistanceSq(unit:GetAbsOrigin(), v:GetAbsOrigin()) then
                local status, test = pcall(collider.test, collider, unit, v)

                if not status then
                  print('[PHYSICS] Collision Test Failure!: ' .. test)
                elseif test then
                  if collider.preaction then
                    local status, action = pcall(collider.preaction, collider, unit, v)
                    if not status then
                      print('[PHYSICS] Collision preaction Failure!: ' .. action)
                    end
                  end
                  local status, action = pcall(collider.action, collider, unit, v)
                  if not status then
                    print('[PHYSICS] Collision action Failure!: ' .. action)
                  end
                  if collider.postaction then
                    local status, action = pcall(collider.postaction, collider, unit, v)
                    if not status then
                      print('[PHYSICS] Collision postaction Failure!: ' .. action)
                    end
                  end


                  --unit.nNextCollide = now + collider.recollideTime
                  --v.nNextCollide = now + v.collider.recollideTime
                end
              end
            end
          else
            Physics:RemoveCollider(name)
          end
        elseif collider.type == COLLIDER_BOX then
          -- box collider
          local box = collider.box
          if box.recalculate or box.ad2 == nil then
            collider.box = Physics:PrecalculateBox(box)
          end

          if collider.draw then
            local alpha = 5
            local color = Vector(200,0,0)
            if type(collider.draw) == "table" then
              alpha = collider.draw.alpha or alpha
              color = collider.draw.color or color
            end

            if not collider.box.drawAngle then
               Physics:PrecalculateBoxDraw(collider.box)
            end

            DebugDrawBoxDirection(box.drawMins, Vector(0,0,0), box.drawMaxs - box.drawMins, RotatePosition(Vector(0,0,0), QAngle(0,box.drawAngle,0), Vector(1,0,0)), color, alpha, .01)
          end

          local ents = nil
          if collider.filter then
            if type(collider.filter) == "table" then
              ents = collider.filter
            else
              local status = nil
              status, ents = pcall(collider.filter, collider)
              if not status then
                print('[PHYSICS] Collision Filter Failure!: ' .. ents)
              end
            end
          else
            ents = Entities:FindAllInSphere(box.center, box.radius + 200)
          end

          for k,v in pairs(ents) do
            if IsValidEntity(v) then
              local pos = v:GetAbsOrigin()
              if (pos.z >= box.zMin and pos.z <= box.zMax) then
                pos.z = 0
                local am = pos - box.a
                local amDotAb = am:Dot(box.ab)
                if amDotAb > 0 and amDotAb < box.ab2 then
                  local amDotAd = am:Dot(box.ad)
                  if amDotAd > 0 and amDotAd < box.ad2 then
                    --inside
                    local status, test = pcall(collider.test, collider, v)

                    if not status then
                      print('[PHYSICS] Collision Test Failure!: ' .. test)
                    elseif test then
                      if collider.preaction then
                        local status, action = pcall(collider.preaction, collider, box, v)
                        if not status then
                          print('[PHYSICS] Collision preaction Failure!: ' .. action)
                        end
                      end
                      local status, action = pcall(collider.action, collider, box, v)
                      if not status then
                        print('[PHYSICS] Collision action Failure!: ' .. action)
                      end
                      if collider.postaction then
                        local status, action = pcall(collider.postaction, collider, box, v)
                        if not status then
                          print('[PHYSICS] Collision postaction Failure!: ' .. action)
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        elseif collider.type == COLLIDER_AABOX then
          -- box collider
          local box = collider.box
          if box.recalculate or box.xMin == nil then
            collider.box = Physics:PrecalculateAABox(box)
          end

          if collider.draw then
            local alpha = 5
            local color = Vector(200,0,0)
            if type(collider.draw) == "table" then
              alpha = collider.draw.alpha or alpha
              color = collider.draw.color or color
            end

            DebugDrawBox(Vector(0,0,0), Vector(box.xMin, box.yMin, box.zMin), Vector(box.xMax, box.yMax, box.zMax), color.x, color.y, color.z, alpha, .01)
          end

          local ents = nil
          if collider.filter then
            if type(collider.filter) == "table" then
              ents = collider.filter
            else
              local status = nil
              status, ents = pcall(collider.filter, collider)
              if not status then
                print('[PHYSICS] Collision Filter Failure!: ' .. ents)
              end
            end
          else
            ents = Entities:FindAllInSphere(box.center, box.radius + 200)
          end

          for k,v in pairs(ents) do
            if IsValidEntity(v) then
              local pos = v:GetAbsOrigin()
              if (pos.x >= box.xMin and pos.x <= box.xMax and
                  pos.y >= box.yMin and pos.y <= box.yMax and
                  pos.z >= box.zMin and pos.z <= box.zMax) then
                
                --inside
                local status, test = pcall(collider.test, collider, v)

                if not status then
                  print('[PHYSICS] Collision Test Failure!: ' .. test)
                elseif test then
                  if collider.preaction then
                    local status, action = pcall(collider.preaction, collider, box, v)
                    if not status then
                      print('[PHYSICS] Collision preaction Failure!: ' .. action)
                    end
                  end
                  local status, action = pcall(collider.action, collider, box, v)
                  if not status then
                    print('[PHYSICS] Collision action Failure!: ' .. action)
                  end
                  if collider.postaction then
                    local status, action = pcall(collider.postaction, collider, box, v)
                    if not status then
                      print('[PHYSICS] Collision postaction Failure!: ' .. action)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  return PHYSICS_THINK
end

function Physics:CreateTimer(name, args)
  if not args.endTime or not args.callback then
    print("Invalid timer created: "..name)
    return
  end

  Physics.timers[name] = args
end

function Physics:RemoveTimer(name)
  Physics.timers[name] = nil
end

function Physics:RemoveTimers(killAll)
  local timers = {}

  if not killAll then
    for k,v in pairs(Physics.timers) do
      if v.persist then
        timers[k] = v
      end
    end
  end

  Physics.timers = timers
end

--[[
  sequence:
     {"type",  Physics_LINEAR, Physics_CURVED, Physics_SPLIT
      LINEAR
      "distance" or "time" or "to"
      "toward" or "angle" or "to"
      "from" or nothing
      "speed" or nothing
      CURVED
      "toward" or "angle"
        "angleTick"
        "tick"
        "ticks"
      "around"
      "speed" or nothing
      SPLIT
      "TBD"
]]

function Physics:GenerateAngleGrid()
  local anggrid = {}
  local worldMin = Vector(GetWorldMinX(), GetWorldMinY(), 0)
  local worldMax = Vector(GetWorldMaxX(), GetWorldMaxY(), 0)

  print(worldMin)
  print(worldMax)

  local boundX1 = GridNav:WorldToGridPosX(worldMin.x)
  local boundX2 = GridNav:WorldToGridPosX(worldMax.x)
  local boundY1 = GridNav:WorldToGridPosX(worldMin.y)
  local boundY2 = GridNav:WorldToGridPosX(worldMax.y)
  local offsetX = boundX1 * -1 + 1
  local offsetY = boundY1 * -1 + 1

  print(boundX1 .. " -- " .. boundX2)
  print(boundY1 .. " -- " .. boundY2)
  print(offsetX)
  print(offsetY)

  local vecs = {
    {vec = Vector(0,1,0):Normalized(), x=0,y=1},-- N
    {vec = Vector(1,1,0):Normalized(), x=1,y=1}, -- NE
    {vec = Vector(1,0,0):Normalized(), x=1,y=0}, -- E
    {vec = Vector(1,-1,0):Normalized(), x=1,y=-1}, -- SE
    {vec = Vector(0,-1,0):Normalized(), x=0,y=-1}, -- S
    {vec = Vector(-1,-1,0):Normalized(), x=-1,y=-1}, -- SW
    {vec = Vector(-1,0,0):Normalized(), x=-1,y=0}, -- W
    {vec = Vector(-1,1,0):Normalized(), x=-1,y=1} -- NW
  }

  print('----------------------')

  anggrid[1] = {}
  for j=boundY1,boundY2 do
    anggrid[1][j + offsetY] = -1
  end
  anggrid[1][boundY2 + offsetY] = -1

  for i=boundX1+1,boundX2-1 do
    anggrid[i+offsetX] = {}
    anggrid[i+offsetX][1] = -1
    for j=(boundY1+1),boundY2-1 do
      local position = Vector(GridNav:GridPosToWorldCenterX(i), GridNav:GridPosToWorldCenterY(j), 0)
      local blocked = not GridNav:IsTraversable(position) or GridNav:IsBlocked(position) --or (pseudoGNV[i] ~= nil and pseudoGNV[i][j])
      local seg = 0
      local sum = Vector(0,0,0)
      local count = 0
      local inseg = false

      if blocked then
        for k=1,#vecs do
          local vec = vecs[k].vec
          local xoff = vecs[k].x
          local yoff = vecs[k].y
          local pos = Vector(GridNav:GridPosToWorldCenterX(i+xoff), GridNav:GridPosToWorldCenterY(j+yoff), 0)
          local blo = not GridNav:IsTraversable(pos) or GridNav:IsBlocked(pos) --or (pseudoGNV[i+xoff] ~= nil and pseudoGNV[i+xoff][j+yoff])

          if not blo then
            count = count + 1
            inseg = true
            sum = sum + vec
          else
            if inseg then
              inseg = false
              seg = seg + 1
            end
          end
        end

        if seg > 1 then
          print ('OVERSEG x=' .. i .. ' y=' .. j)
          anggrid[i+offsetX][j+offsetY] = -1
        elseif count > 5 then
          print ('PROTRUDE x=' .. i .. ' y=' .. j)
          anggrid[i+offsetX][j+offsetY] = -1
        elseif count == 0 then
          anggrid[i+offsetX][j+offsetY] = -1
        else
          local sum = sum:Normalized()
          local angle = math.floor((math.acos(Vector(1,0,0):Dot(sum:Normalized()))/ math.pi * 180))
          if sum.y < 0 then
            angle = -1 * angle
          end
          anggrid[i+offsetX][j+offsetY] = angle
        end
      else
        anggrid[i+offsetX][j+offsetY] = -1
      end
    end
    anggrid[i+offsetX][boundY2+offsetY] = -1
  end

  anggrid[boundX2+offsetX] = {}
  for j=boundY1,boundY2 do
    anggrid[boundX2+offsetX][j+offsetY] = -1
  end
  anggrid[boundX2+offsetX][boundY2+offsetY] = -1

  print('--------------')
  print(#anggrid)
  print(#anggrid[1])
  print(#anggrid[2])
  print(#anggrid[3])

  if MAP_DATA  then
    MAP_DATA.anggrid = anggrid
  end
  Physics:AngleGrid(anggrid)
end

function Physics:AngleGrid( anggrid, angoffsets )
  self.anggrid = anggrid
  print('[PHYSICS] Angle Grid Set')
  local worldMin = Vector(GetWorldMinX(), GetWorldMinY(), 0)
  local worldMax = Vector(GetWorldMaxX(), GetWorldMaxY(), 0)
  local boundX1 = GridNav:WorldToGridPosX(worldMin.x)
  local boundX2 = GridNav:WorldToGridPosX(worldMax.x)
  local boundY1 = GridNav:WorldToGridPosX(worldMin.y)
  local boundY2 = GridNav:WorldToGridPosX(worldMax.y)
  local offsetX = boundX1 * -1 + 1
  local offsetY = boundY1 * -1 + 1
  self.offsetX = offsetX
  self.offsetY = offsetY

  if angoffsets ~= nil then
    self.offsetX = math.abs(angoffsets.x) + 1
    self.offsetY = math.abs(angoffsets.y) + 1
  end
end

function Physics:CalcSlope(pos, unit, dir)

  dir = Vector(dir.x, dir.y, 0):Normalized()
  local f = GetGroundPosition(pos + dir, unit)
  local b = GetGroundPosition(pos - dir, unit)

  return (f - b):Normalized() 
end

function Physics:CalcNormal(pos, unit, scale)
  scale = scale or 1
  local nscale = -1 * scale
  local diag = 0.70710678118 * scale
  local ndiag = -1 * diag

  local zl =  GetGroundPosition(pos + Vector(nscale,0,0), unit).z
  local zr =  GetGroundPosition(pos + Vector(scale,0,0), unit).z
  local zu =  GetGroundPosition(pos + Vector(0,scale,0), unit).z
  local zd =  GetGroundPosition(pos + Vector(0,nscale,0), unit).z

  --[[local zld = GetGroundPosition(pos + Vector(ndiag,ndiag,0), unit).z
  local zlu = GetGroundPosition(pos + Vector(ndiag,diag,0), unit).z
  local zrd = GetGroundPosition(pos + Vector(diag,ndiag,0), unit).z
  local zru = GetGroundPosition(pos + Vector(diag,diag,0), unit).z]]

  --print (Vector(zld - zlu, zrd - zru, 2*scale))
  --print (Vector(zl - zr, zd - zu, 2*scale))
  --return (RotatePosition(Vector(0,0,0), QAngle(0,45,0), Vector(zld - zlu, zrd - zru, 2*scale)) + Vector(zl - zr, zd - zu, 2*scale)):Normalized()
  return Vector(zl - zr, zd - zu, 2*scale):Normalized()
end

function Physics:Unit(unit)
  if IsPhysicsUnit(unit) then
    if Convars:GetBool("developer") then
      unit:StopPhysicsSimulation()
    else
      return
    end
  end
  function unit:StopPhysicsSimulation ()
    Physics.timers[unit.PhysicsTimerName] = nil
    unit.bStarted = false
  end
  function unit:StartPhysicsSimulation ()
    Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
    unit.PhysicsTimer.endTime = GameRules:GetGameTime()
    unit.PhysicsLastPosition = unit:GetAbsOrigin()
    unit.PhysicsLastTime = GameRules:GetGameTime()
    unit.vLastVelocity = Vector(0,0,0)
    unit.vSlideVelocity = Vector(0,0,0)
    unit.bStarted = true
  end
  
  function unit:SetPhysicsVelocity (velocity)
    unit.vVelocity = velocity / 30
    if unit.nVelocityMax > 0 and unit.vVelocity:Length() > unit.nVelocityMax then
      unit.vVelocity = unit.vVelocity:Normalized() * unit.nVelocityMax
    end
    
    if unit.bStarted and unit.bHibernating then
      Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
      unit.PhysicsTimer.endTime = GameRules:GetGameTime()
      unit.PhysicsLastPosition = unit:GetAbsOrigin()
      unit.PhysicsLastTime = GameRules:GetGameTime()
      unit.vLastVelocity = Vector(0,0,0)
      unit.vSlideVelocity = Vector(0,0,0)
      unit.bHibernating = false
    end
  end
  function unit:AddPhysicsVelocity (velocity)
    unit.vVelocity = unit.vVelocity + velocity / 30
    if unit.nVelocityMax > 0 and unit.vVelocity:Length() > unit.nVelocityMax then
      unit.vVelocity = unit.vVelocity:Normalized() * unit.nVelocityMax
    end
    
    if unit.bStarted and unit.bHibernating then
      Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
      unit.PhysicsTimer.endTime = GameRules:GetGameTime()
      unit.PhysicsLastPosition = unit:GetAbsOrigin()
      unit.PhysicsLastTime = GameRules:GetGameTime()
      unit.vLastVelocity = Vector(0,0,0)
      unit.vSlideVelocity = Vector(0,0,0)
      unit.bHibernating = false
    end
  end
  
  function unit:SetPhysicsVelocityMax (velocityMax)
    unit.nVelocityMax = velocityMax / 30
  end
  function unit:GetPhysicsVelocityMax ()
    return unit.vVelocity * 30
  end
  
  function unit:SetPhysicsAcceleration (acceleration)
    unit.vAcceleration = acceleration / 900
    
    if unit.bStarted and unit.bHibernating then
      Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
      unit.PhysicsTimer.endTime = GameRules:GetGameTime()
      unit.PhysicsLastPosition = unit:GetAbsOrigin()
      unit.PhysicsLastTime = GameRules:GetGameTime()
      unit.vLastVelocity = Vector(0,0,0)
      unit.vSlideVelocity = Vector(0,0,0)
      unit.bHibernating = false
    end
  end
  function unit:AddPhysicsAcceleration (acceleration)
    unit.vAcceleration = unit.vAcceleration + acceleration / 900
    
    if unit.bStarted and unit.bHibernating then
      Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
      unit.PhysicsTimer.endTime = GameRules:GetGameTime()
      unit.PhysicsLastPosition = unit:GetAbsOrigin()
      unit.PhysicsLastTime = GameRules:GetGameTime()
      unit.vLastVelocity = Vector(0,0,0)
      unit.vSlideVelocity = Vector(0,0,0)
      unit.bHibernating = false
    end
  end
  
  function unit:SetPhysicsFriction (percFriction, flatFriction)
    unit.fFriction = percFriction
    unit.fFlatFriction = (flatFriction or (unit.fFlatFriction*30))/30
  end
  
  function unit:GetPhysicsVelocity ()
    return unit.vVelocity  * 30
  end
  function unit:GetPhysicsAcceleration ()
    return unit.vAcceleration * 900
  end
  function unit:GetPhysicsFriction ()
    return unit.fFriction, unit.fFlatFriction*30
  end
  
  function unit:FollowNavMesh (follow)
    unit.bFollowNavMesh = follow
  end
  function unit:IsFollowNavMesh ()
    return unit.bFollowNavMesh
  end
  
  function unit:SetGroundBehavior (ground)
    unit.nLockToGround = ground
  end
  function unit:GetGroundBehavior ()
    return unit.nLockToGround
  end
  
  function unit:SetSlideMultiplier (slideMultiplier)
    unit.fSlideMultiplier = slideMultiplier
  end
  function unit:GetSlideMultiplier ()
    return unit.fSlideMultiplier
  end
  
  function unit:Slide (slide)
    unit.bSlide = slide
    
    if unit.bStarted and unit.bHibernating then
      Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
      unit.PhysicsTimer.endTime = GameRules:GetGameTime()
      unit.PhysicsLastPosition = unit:GetAbsOrigin()
      unit.PhysicsLastTime = GameRules:GetGameTime()
      unit.vLastVelocity = Vector(0,0,0)
      unit.vSlideVelocity = Vector(0,0,0)
      unit.bHibernating = false
    end
  end
  function unit:IsSlide ()
    return unit.bSlide
  end
  
  function unit:PreventDI (prevent)
    unit.bPreventDI = prevent
    if not prevent and unit:HasModifier("modifier_rooted") then
      unit:RemoveModifierByName("modifier_rooted")
    end
  end
  function unit:IsPreventDI ()
    return unit.bPreventDI
  end
  
  function unit:SetNavCollisionType (collisionType)
    unit.nNavCollision = collisionType
  end
  function unit:GetNavCollisionType ()
    return unit.nNavCollision
  end
  
  function unit:OnPhysicsFrame(fun)
    unit.PhysicsFrameCallback = fun
  end
  
  function unit:SetVelocityClamp (clamp)
    unit.fVelocityClamp = clamp / 30
  end
  
  function unit:GetVelocityClamp ()
    return unit.fVelocityClamp * 30
  end
  
  function unit:Hibernate (hibernate)
    unit.bHibernate = hibernate
  end
  
  function unit:IsHibernate ()
    return unit.bHibernate
  end
  
  function unit:DoHibernate ()
    Physics.timers[unit.PhysicsTimerName] = nil
    unit.bHibernating = true
  end
  
  function unit:OnHibernate(fun)
    unit.PhysicsHibernateCallback = fun
  end

  function unit:OnPreBounce(fun)
    unit.PhysicsOnPreBounce = fun
  end

  function unit:OnBounce(fun)
    unit.PhysicsOnBounce = fun
  end

  function unit:OnPreSlide(fun)
    unit.PhysicsOnPreSlide = fun
  end

  function unit:OnSlide(fun)
    unit.PhysicsOnSlide = fun
  end

  function unit:AdaptiveNavGridLookahead (adaptive)
    unit.bAdaptiveNavGridLookahead = adaptive
  end
  
  function unit:IsAdaptiveNavGridLookahead ()
    return unit.bAdaptiveNavGridLookahead
  end
  
  function unit:SetNavGridLookahead (lookahead)
    unit.nNavGridLookahead = lookahead
  end
  
  function unit:GetNavGridLookahead ()
    return unit.nNavGridLookahead
  end
  
  function unit:SkipSlide (frames)
    unit.nSkipSlide = frames or 1
  end
  
  function unit:SetRebounceFrames ( rebounce )
    unit.nMaxRebounce = rebounce
    unit.nRebounceFrames = 0
  end
  
  function unit:GetRebounceFrames ()
    unit.nRebounceFrames = 0
    return unit.nMaxRebounce
  end
  
  function unit:GetLastGoodPosition ()
    return unit.vLastGoodPosition
  end
  
  function unit:SetStuckTimeout (timeout)
    unit.nStuckTimeout = timeout
    unit.nStuckFrames = 0
  end
  function unit:GetStuckTimeout ()
    unit.nStuckFrames = 0
    return unit.nStuckTimeout
  end
  
  function unit:SetAutoUnstuck (unstuck)
    unit.bAutoUnstuck = unstuck
  end
  function unit:GetAutoUnstuck ()
    return unit.bAutoUnstuck
  end

  function unit:SetBounceMultiplier (bounce)
    unit.fBounceMultiplier = bounce
  end
  function unit:GetBounceMultiplier ()
    return unit.fBounceMultiplier
  end

  function unit:GetTotalVelocity()
    if unit.bStarted and not unit.bHibernating then
      return unit.vTotalVelocity
    else
      return Vector(0,0,0)
    end
  end

  function unit:GetColliders()
    return unit.oColliders
  end

  function unit:RemoveCollider(name)
    if name == nil then
      local i,v = next(unit.oColliders,  nil)
      if i == nil then
        return
      end
      name = unit.oColliders[i].name
    elseif type(name) == "table" then
      name = name.name
    end
    Physics:RemoveCollider(name)
  end

  function unit:AddCollider(name, collider)
    local coll = Physics:AddCollider(name, collider)
    coll.unit = unit
    unit.oColliders[coll.name] = coll
    return coll
  end

  function unit:AddColliderFromProfile(name, profile, collider)
    if profile == nil then
      profile = name
      name = DoUniqueString("collider")
    elseif type(profile) == "table" then
      collider = profile
      profile = name
      name = DoUniqueString("collider")
    end
    local coll = Physics:AddCollider(name, Physics:ColliderFromProfile(profile, collider))
    coll.unit = unit
    unit.oColliders[coll.name] = coll
    return coll
  end

  function unit:GetMass()
    return unit.fMass
  end

  function unit:SetMass(mass)
    unit.fMass = mass
  end

  function unit:GetNavGroundAngle()
    return math.acos(unit.fNavGroundAngle) * 180 / math.pi 
  end

  function unit:SetNavGroundAngle(angle)
    unit.fNavGroundAngle = math.cos(angle * math.pi / 180)
  end

  function unit:CutTrees(cut)
    unit.bCutTrees = cut
  end

  function unit:IsCutTrees()
    return unit.bCutTrees
  end

  function unit:IsInSimulation()
    return unit.bStarted
  end

  function unit:SetBoundOverride(bound)
    unit.fBoundOverride = bound
  end

  function unit:GetBoundOverride()
    return unit.fBoundOverride
  end

  function unit:ClearStaticVelocity()
    unit.staticForces = {}
    unit.staticSum = Vector(0,0,0)
  end

  function unit:SetStaticVelocity(name, velocity)
    if unit.staticForces[name] ~= nil then
      unit.staticSum = unit.staticSum - unit.staticForces[name]
    end
    unit.staticForces[name] = velocity / 30
    unit.staticSum = unit.staticSum + unit.staticForces[name]

    if unit.bStarted and unit.bHibernating then
      Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
      unit.PhysicsTimer.endTime = GameRules:GetGameTime()
      unit.PhysicsLastPosition = unit:GetAbsOrigin()
      unit.PhysicsLastTime = GameRules:GetGameTime()
      unit.vLastVelocity = Vector(0,0,0)
      unit.vSlideVelocity = Vector(0,0,0)
      unit.bHibernating = false
    end
  end

  function unit:GetStaticVelocity(name)
    if name == nil then
      return unit.staticSum
    else
      return unit.staticForces[name]
    end
  end

  function unit:AddStaticVelocity(name, velocity)
    if unit.staticForces[name] == nil then
      unit.staticForces[name] = velocity / 30
      unit.staticSum = unit.staticSum + unit.staticForces[name]
    else
      unit.staticSum = unit.staticSum - unit.staticForces[name]
      unit.staticForces[name] = unit.staticForces[name] + velocity / 30
      unit.staticSum = unit.staticSum + unit.staticForces[name]
    end

    if unit.bStarted and unit.bHibernating then
      Physics.timers[unit.PhysicsTimerName] = unit.PhysicsTimer
      unit.PhysicsTimer.endTime = GameRules:GetGameTime()
      unit.PhysicsLastPosition = unit:GetAbsOrigin()
      unit.PhysicsLastTime = GameRules:GetGameTime()
      unit.vLastVelocity = Vector(0,0,0)
      unit.vSlideVelocity = Vector(0,0,0)
      unit.bHibernating = false
    end
  end

  function unit:SetPhysicsFlatFriction(flatFriction)
    unit.fFlatFriction = flatFriction / 30
  end

  function unit:GetPhysicsFlatFriction()
    return unit.fFlatFriction
  end


  unit.lastGoodGround = Vector(0,0,0)
  unit.PhysicsTimerName = DoUniqueString('phys')
  Physics:CreateTimer(unit.PhysicsTimerName, {
    endTime = GameRules:GetGameTime(),
    useGameTime = true,
    callback = function(reflex, args)
      local prevTime = unit.PhysicsLastTime
      if not IsValidEntity(unit) then
        return
      end
      local curTime = GameRules:GetGameTime()
      local prevPosition = unit.PhysicsLastPosition
      local position = unit:GetAbsOrigin()
      local slideVelocity = Vector(0,0,0)
      local lastVelocity = unit.vLastVelocity
      unit.vTotalVelocity = (position - prevPosition) / (curTime - prevTime)

      unit.PhysicsLastTime = curTime
      unit.PhysicsLastPosition = position
      
      if unit.bPreventDI and not unit:HasModifier("modifier_rooted") then
        unit:AddNewModifier(unit, nil, "modifier_rooted", {})
      end
      
      if unit.bSlide and unit.nSkipSlide <= 0 then
        slideVelocity = ((position - prevPosition) - lastVelocity + unit.vSlideVelocity) * unit.fSlideMultiplier
      else
        --print(unit.nSkipSlide)
        unit.vSlideVelocity = Vector(0,0,0)
      end
      
      unit.nSkipSlide = unit.nSkipSlide - 1
      
      -- Adjust velocity
      local newVelocity = unit.vVelocity + unit.vAcceleration + (-1 * unit.fFriction * unit.vVelocity) + slideVelocity
      local newVelLength
      if unit.fFlatFriction > 0 then
        newVelLength = newVelocity:Length()
        if newVelLength ~= 0 then
          newVelocity = newVelocity * (math.max(0, newVelLength - unit.fFlatFriction) / newVelLength)
        end
      end

      local staticSum = unit.staticSum
      newVelocity = newVelocity + staticSum
      newVelLength = newVelocity:Length()
      local staticSumLength = staticSum:Length()


      local vel = unit.vVelocity + staticSum
      local staticSumz = staticSum.z
      local newVelz = newVelocity.z
      local dontSet = false
      local dontSetGround = false
      --print('vel: ' .. tostring(unit.vVelocity:Length()) .. ' -- svel: ' .. tostring(slideVelocity:Length()) .. " -- nvel: " .. tostring(newVelocity:Length()))
      
      -- Calculate new position
      local newPos = position + vel
      
      
      
      local blockedPos = not GridNav:IsTraversable(position) or GridNav:IsBlocked(position)
      if not blockedPos then
        unit.vLastGoodPosition = position
        unit.nStuckFrames = 0
      else
        unit.nStuckFrames = unit.nStuckFrames + 1
      end

      
      if vel ~= Vector(0,0,0) or slideVelocity ~= Vector(0,0,0) or unit.nNavCollision == PHYSICS_NAV_GROUND then
        if unit.nNavCollision == PHYSICS_NAV_GROUND then
          local newGround = GetGroundPosition(newPos, unit)
          local ground = GetGroundPosition(position, unit)

          --if unit.vVelocity.x ~= 0 and unit.vVelocity.y ~= 0 then
          if newPos.z - newGround.z < 0 or position.z - ground.z < 0 then -- and newPos.z ~= position.z then
            local velLen = Vector(vel.x,vel.y,0):Length()
            local diff = vel:Normalized()
            local subpos = position
            local minnormal = Vector(0,0,1)
            --local avgnormal = Vector(0,0,0)
            for i=1,math.ceil(velLen)+1 do
              local normal = Physics:CalcNormal(subpos, unit, 15)
              --local subground = GetGroundPosition(subpos, unit)
              --print(i .. ' -- ' .. tostring(normal))
              if normal.z < minnormal.z then
                minnormal = normal
                --subground = subpos
              end
              --DebugDrawLine_vCol(subground, subground + normal * 100, Vector(100,0,0), true, 1.1)
              subpos = subpos + diff
              --avgnormal = avgnormal + normal
            end

            --DebugDrawLine_vCol(position, position + Physics:CalcSlope(position, unit, vel) * 100, Vector(0,0,200), true, 1.1)

            --avgnormal = avgnormal / math.ceil(velLen)+1
            --avgnormal = Vector(avgnormal.x, avgnormal.y, minnormal.z):Normalized()
            --DebugDrawLine_vCol(position, position + minnormal * 200, Vector(255,0,0), true, 1.1)

            if minnormal.z < unit.fNavGroundAngle then
              --steep
              local xynorm = Vector(minnormal.x, minnormal.y, 0)
              local xynormlen = xynorm:Length()
              if xynorm:Length() > .98 then
                minnormal = xynorm / xynormlen                
                --avgnormal = Vector(avgnormal.x, avgnormal.y, 0):Normalized()
              end
              --print('-------------')
              --print(minnormal)

              --DebugDrawLine_vCol(position, position + Physics:CalcSlope(position, unit, minnormal) * 200, Vector(0,200,200), true, 1)
              --DebugDrawLine_vCol(position, position + avgnormal * 200, Vector(0,100,0), true, 1.1)

              local velz = vel.z
              --newVelocity.z = 0
              --vel.z = 0

              local dot = vel:Dot(-1 * minnormal) *1.01
              if dot >= 0 then
                vel = vel + dot * minnormal
                --DebugDrawLine_vCol(position, position + vel, Vector(0,255,0), true, 1.1)

                newVelocity = newVelocity + newVelocity:Dot(-1 * minnormal)*1.01 * minnormal
                --DebugDrawLine_vCol(position, position + newVelocity, Vector(0,255,122), true, 1.1)
                staticSum = staticSum + staticSum:Dot(-1 * minnormal)*1.01 * minnormal
                --DebugDrawLine_vCol(position, position + staticSum, Vector(255,0,122), true, 1.1)

                --DebugDrawLine_vCol(position, position + vel * 10, Vector(0,255,0), true, 1.1)
              end
              
              newPos = position + vel
              local nz = newPos.z
              --DebugDrawCircle(newPos, Vector(0,255,0), 1, 15, true, 1.1)
              local gnorm = GetGroundPosition(newPos + minnormal * 50, unit)
              --DebugDrawCircle(gnorm, Vector(255,0,0), 1, 15, true, 1.1)
              --DebugDrawCircle(unit.lastGoodGround, Vector(255,255,255), 1, 15, true, 1.1)
              local ng = GetGroundPosition(newPos, unit)
              if ng.z >= newPos.z and newPos.z < gnorm.z then
                --print(tostring(newPos.z) .. ' -- ' .. tostring(gnorm.z) .. ' -- ' .. tostring(ng.z) .. ' -- ' .. tostring(unit.lastGoodGround.z))
                if ng.z > gnorm.z then
                  newPos.z = gnorm.z
                else
                  newPos.z = ng.z
                end
                staticSum.z = 0
                if newPos.z > position.z and (newPos - position):Normalized().z > unit.fNavGroundAngle then --newPos.z-position.z > vel.z*1.5 then
                  --newPos = Vector(position.x,position.y,unit.lastGoodGround.z)
                  newPos = position + Vector(0,0,newVelocity.z)
                  if newPos.z < unit.lastGoodGround.z then
                    newPos.z = unit.lastGoodGround.z
                    newVelocity.z = math.max(0, newVelocity.z)
                  end

                  --newVelocity.z = 0
                else
                  newVelocity.z = math.max(0, newVelocity.z)
                end
              end
              --DebugDrawCircle(newPos, Vector(150,0,255), 1, 15, true, 1.1)
              
              unit:SetAbsOrigin(newPos)
              dontSet = true
              dontSetGround = true
              ground = ng
              --unit:SetAbsOrigin(position)
            --elseif (ground - position):Normalized().z > unit.fNavGroundAngle then
              --unit.lastGoodGround = ground
            end
          else
            unit.lastGoodGround = ground
          end

          local bound = 1
          if unit.fBoundOverride then
            bound = unit.fBoundOverride
          elseif unit.GetPaddedCollisionRadius then
            bound = unit:GetPaddedCollisionRadius()
          elseif unit.GetBoundingMaxs then
            bound = math.max(unit:GetBoundingMaxs().x, unit:GetBoundingMaxs().y)
          end
          -- tree check
          local connect = position-- + diff * bound
          local treeConnect = (not GridNav:IsTraversable(connect) or GridNav:IsBlocked(connect)) and GridNav:IsNearbyTree(connect, 30, true)
          local lookaheadNum = unit.nNavGridLookahead
          if unit.bAdaptiveNavGridLookahead then
            lookaheadNum = math.ceil(vel:Length() / 16)
          end
          local diff = vel:Normalized()
          local tot = lookaheadNum + 1
          local div = 1 / tot
          local index = 1
          while not treeConnect and index < tot do
            connect = position + vel * (div * index) + diff * bound
            treeConnect = (not GridNav:IsTraversable(connect) or GridNav:IsBlocked(connect)) and GridNav:IsNearbyTree(connect, 30, true)
            if treeConnect then
              --DebugDrawCircle(connect, Vector(0,200,0), 100, 10, true, 1)
            end
            index = index + 1
          end

          --print (tostring(treeConnect) .. ' -- ' .. ground.z .. ' -- ' .. newPos.z .. ' -- ' .. position.z)
          if treeConnect and ground.z + 340 >= newPos.z and newPos.z + 2 > ground.z then
            if position.z >= ground.z + 340 then
              newVelocity.z = math.max(0, newVelocity.z)
              staticSum.z = math.max(0, staticSum.z)
              --unit:SetAbsOrigin(newPos + Vector(0,0,ground.z + 340 - newPos.z))
              newPos = Vector(newPos.x, newPos.y, ground.z + 340)
              --print('treetop')
            else
              --print('treeConnect')
              local vec = Vector(GridNav:GridPosToWorldCenterX(GridNav:WorldToGridPosX(connect.x)), GridNav:GridPosToWorldCenterY(GridNav:WorldToGridPosY(connect.y)), ground.z)
              --DebugDrawCircle(vec, Vector(200,200,200), 100, 10, true, .5)
              if unit.bCutTrees then
                local ents = Entities:FindAllByClassnameWithin("ent_dota_tree", vec, 70)
                if #ents > 0 then
                  local tree = ents[1]
                  tree:CutDown(unit:GetTeamNumber())
                end
              else
                local off = (Vector(position.x,position.y,vec.z) - vec):Normalized()
                local normal = nil
                if math.abs(off.x) > math.abs(off.y) then
                  normal = Vector(math.abs(off.x)/off.x, 0, 0)
                  local vec2 = vec + normal * 64
                  local treeConnect2 = (not GridNav:IsTraversable(vec2) or GridNav:IsBlocked(vec2)) and GridNav:IsNearbyTree(vec2, 30, true)
                  if treeConnect2 then
                    normal = Vector(0, math.abs(off.y)/off.y, 0)
                    vec2 = vec + normal * 64
                    treeConnect2 = (not GridNav:IsTraversable(vec2) or GridNav:IsBlocked(vec2)) and GridNav:IsNearbyTree(vec2, 30, true)
                    if treeConnect2 then
                      normal = (Vector(diff.x,diff.y,0) * -1):Normalized()
                    end
                  end
                else
                  normal = Vector(0, math.abs(off.y)/off.y, 0)
                  local vec2 = vec + normal * 64
                  local treeConnect2 = (not GridNav:IsTraversable(vec2) or GridNav:IsBlocked(vec2)) and GridNav:IsNearbyTree(vec2, 30, true)
                  if treeConnect2 then
                    normal = Vector(math.abs(off.x)/off.x, 0, 0)
                    vec2 = vec + normal * 64
                    treeConnect2 = (not GridNav:IsTraversable(vec2) or GridNav:IsBlocked(vec2)) and GridNav:IsNearbyTree(vec2, 30, true)
                    if treeConnect2 then
                      normal = (Vector(diff.x,diff.y,0) * -1):Normalized()
                    end
                  end
                end

                --DebugDrawLine_vCol(vec, vec + off * 100, Vector(0,200,0), true, 1)
                --DebugDrawLine_vCol(vec, vec + normal * 100, Vector(200,200,200), true, 1)

                --newVelocity.z = newVelz
                local dot = vel:Dot(-1 * normal)
                if dot >= 0 then
                  vel = vel + dot * 1.0 * normal
                  newVelocity = newVelocity + newVelocity:Dot(-1 * normal) * 1.0 * normal
                  staticSum = staticSum + staticSum:Dot(-1 * normal) * 1.0 * normal
                  local newground = GetGroundPosition(position + vel, unit)
                  local new = position + vel
                  if newground.z > new.z then
                    new.z = newground.z
                  end

                  off = (Vector(new.x, new.y, vec.z) - vec):Normalized()
                  local scalar = math.min((32+bound) / math.abs(off.x), (32+bound) / math.abs(off.y))
                  --local scalar = math.min((32) / math.abs(off.x), (32) / math.abs(off.y))
                  unit.nSkipSlide = 1
                  newPos = vec + Vector(scalar*off.x, scalar*off.y, new.z - vec.z)
                end
                --unit:SetAbsOrigin(new)
              end
            end
          end
        elseif unit.bFollowNavMesh then
          local diff = vel:Normalized()
          --FindClearSpaceForUnit(unit, newPos, true)

          local bound = 1
          if unit.fBoundOverride then
            bound = unit.fBoundOverride
          elseif unit.GetPaddedCollisionRadius then
            bound = unit:GetPaddedCollisionRadius() + 1
          elseif unit.GetBoundingMaxs then
            bound = math.max(unit:GetBoundingMaxs().x, unit:GetBoundingMaxs().y)
          end
          
          local connect = position-- + diff * bound
          local navConnect = not GridNav:IsTraversable(connect) or GridNav:IsBlocked(connect) 
          local lookaheadNum = unit.nNavGridLookahead
          if unit.bAdaptiveNavGridLookahead then
            lookaheadNum = math.ceil(unit.vVelocity:Length() / 32)
          end
          local tot = lookaheadNum + 1
          local div = 1 / tot
          local index = 1
          while not navConnect and index < tot do
            connect = position + unit.vVelocity * (div * index) + diff * bound
            navConnect = not GridNav:IsTraversable(connect) or GridNav:IsBlocked(connect)
            index = index + 1
          end
          --or not GridNav:IsTraversable(newPos + unit.vVelocity * .5) -- diff * unit.nNavGridLookahead
            --or  or GridNav:IsBlocked(newPos + unit.vVelocity * .5)
          if unit.nNavCollision == PHYSICS_NAV_HALT and navConnect then
            newVelocity = Vector(0,0,0)
            staticSum = Vector(0,0,0)
            FindClearSpaceForUnit(unit, newPos, true)
            dontSet = true
            unit.nSkipSlide = 1
          elseif unit.nNavCollision == PHYSICS_NAV_SLIDE and navConnect then
            local navX = GridNav:WorldToGridPosX(connect.x)
            local navY = GridNav:WorldToGridPosY(connect.y)
            local navPos = Vector(GridNav:GridPosToWorldCenterX(navX), GridNav:GridPosToWorldCenterY(navY), 0)
            --unit.nRebounceFrames = unit.nMaxRebounce
            
            local normal = nil
            local anggrid = self.anggrid
            local offX = self.offsetX
            local offY = self.offsetY
            if anggrid then
              local angSize = #anggrid
              local angX = navX + offX
              local angY = navY + offY

              --print(offX .. ' -- ' .. angX .. ' == ' .. angY .. ' -- ' .. offY)
              
              local angle = anggrid[angX][angY]
              if angle ~= -1 then
                angle = angle
                normal = -1 * RotatePosition(Vector(0,0,0), QAngle(0,angle,0), Vector(1,0,0))
                --print(angle)
                --print(normal)
                --print('----------')
              end
            end
            
            local dir = navPos - position
            if normal == nil then
              --local face = navPos - position
              --print("face: " .. tostring(face)) 
              dir.z = 0
              dir = dir:Normalized()
              -- Nav bounce checks
              --local angx = (math.acos(dir.x)/ math.pi * 180)
              --local angy = (math.acos(dir.y)/ math.pi * 180)
              --print(tostring(dir:Length()) .. " -- " .. tostring(dir))
              --print(dir:Dot(Vector(1,0,0)))
              --print(dir:Dot(Vector(-1,0,0)))
              --print(dir:Dot(Vector(0,1,0)))
              --print(dir:Dot(Vector(0,-1,0)))
              --print('---------------')
              if dir:Dot(Vector(1,0,0)) > .707 then
                normal = Vector(1,0,0)
                local navPos2 = navPos + Vector(-64,0,0)
                local navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                if navConnect2 then
                  if vel.y > 0 then
                    normal = Vector(0,1,0)
                    navPos2 = navPos + Vector(0,-64,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x, diff.y, diff.z)
                    end
                  else
                    normal = Vector(0,-1,0)
                    navPos2 = navPos + Vector(0,64,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x, diff.y, diff.z)
                    end
                  end
                end
              elseif dir:Dot(Vector(-1,0,0)) > .707 then
                normal = Vector(-1,0,0)
                local navPos2 = navPos + Vector(64,0,0)
                local navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                if navConnect2 then
                  if vel.y > 0 then
                    normal = Vector(0,1,0)
                    navPos2 = navPos + Vector(0,-64,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x, diff.y, diff.z)
                    end
                  else
                    normal = Vector(0,-1,0)
                    navPos2 = navPos + Vector(0,64,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x, diff.y, diff.z)
                    end
                  end
                end
              elseif dir:Dot(Vector(0,1,0)) > .707 then
                normal = Vector(0,1,0)
                local navPos2 = navPos + Vector(0,-64,0)
                local navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                if navConnect2 then
                  if vel.x > 0 then
                    normal = Vector(1,0,0)
                    navPos2 = navPos + Vector(-64,0,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x, diff.y, diff.z)
                    end
                  else
                    normal = Vector(-1,0,0)
                    navPos2 = navPos + Vector(64,0,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x, diff.y, diff.z)
                    end
                  end
                end
              elseif dir:Dot(Vector(0,-1,0)) > .707 then
                normal = Vector(0,-1,0)
                local navPos2 = navPos + Vector(0,64,0)
                local navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                if navConnect2 then
                  if vel.x > 0 then
                    normal = Vector(-1,0,0)
                    navPos2 = navPos + Vector(-64,0,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x, diff.y, diff.z)
                    end
                  else
                    normal = Vector(0,-1,0)
                    navPos2 = navPos + Vector(64,0,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x, diff.y, diff.z)
                    end
                  end
                end
              end
              --FindClearSpaceForUnit(unit, newPos, true)
              --print(tostring(unit:GetAbsOrigin()) .. " -- " .. tostring(navPos))
            end

            if unit.PhysicsOnPreSlide then
              local status, nextCall = pcall(unit.PhysicsOnPreSlide, unit, normal)
              if not status then
                print('[PHYSICS] Failed OnPreSlide: ' .. nextCall)
              end
            end

            newVelocity = (-1 * newVelocity:Dot(normal) * normal) + newVelocity
            staticSum = (-1 * staticSum:Dot(normal) * normal) + staticSum
            local ndir = dir * -1
            local scalar = math.min((32+bound) / math.abs(ndir.x), (32+bound) / math.abs(ndir.y))

            unit.nSkipSlide = 1
            newPos = navPos + Vector(scalar*ndir.x, scalar*ndir.y, newPos.z)
            
            if unit.PhysicsOnSlide then
              local status, nextCall = pcall(unit.PhysicsOnSlide, unit, normal)
              if not status then
                print('[PHYSICS] Failed OnSlide: ' .. nextCall)
              end
            end
          elseif unit.nRebounceFrames <= 0 and unit.nNavCollision == PHYSICS_NAV_BOUNCE and navConnect then
            local navX = GridNav:WorldToGridPosX(connect.x)
            local navY = GridNav:WorldToGridPosY(connect.y)
            local navPos = Vector(GridNav:GridPosToWorldCenterX(navX), GridNav:GridPosToWorldCenterY(navY), 0)
            unit.nRebounceFrames = unit.nMaxRebounce
            
            local normal = nil
            local anggrid = self.anggrid
            local offX = self.offsetX
            local offY = self.offsetY
            if anggrid then
              local angSize = #anggrid
              local angX = navX + offX
              local angY = navY + offY

              --print(offX .. ' -- ' .. angX .. ' == ' .. angY .. ' -- ' .. offY)
              
              local angle = anggrid[angX][angY]
              if angle ~= -1 then
                angle = angle
                normal = RotatePosition(Vector(0,0,0), QAngle(0,angle,0), Vector(1,0,0))
                --print(normal)
                --print('----------')
              end
            end
            
            if normal == nil then
              --local face = navPos - position
              --print("face: " .. tostring(face))
              --local dir = navPos - position
              local dir = navPos - position
              dir.z = 0
              dir = dir:Normalized()
              -- Nav bounce checks
              --local angx = (math.acos(dir.x)/ math.pi * 180)
              --local angy = (math.acos(dir.y)/ math.pi * 180)
              --print(tostring(dir:Length()) .. " -- " .. tostring(dir))
              --print(dir:Dot(Vector(1,0,0)))
              --print(dir:Dot(Vector(-1,0,0)))
              --print(dir:Dot(Vector(0,1,0)))
              --print(dir:Dot(Vector(0,-1,0)))
              --print('---------------')
              if dir:Dot(Vector(1,0,0)) > .707 then
                normal = Vector(1,0,0)
                local navPos2 = navPos + Vector(-64,0,0)
                local navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                if navConnect2 then
                  if vel.y > 0 then
                    normal = Vector(0,1,0)
                    navPos2 = navPos + Vector(0,-64,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  else
                    normal = Vector(0,-1,0)
                    navPos2 = navPos + Vector(0,64,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  end
                end
              elseif dir:Dot(Vector(-1,0,0)) > .707 then
                normal = Vector(-1,0,0)
                local navPos2 = navPos + Vector(64,0,0)
                local navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                if navConnect2 then
                  if vel.y > 0 then
                    normal = Vector(0,1,0)
                    navPos2 = navPos + Vector(0,-64,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  else
                    normal = Vector(0,-1,0)
                    navPos2 = navPos + Vector(0,64,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  end
                end
              elseif dir:Dot(Vector(0,1,0)) > .707 then
                normal = Vector(0,1,0)
                local navPos2 = navPos + Vector(0,-64,0)
                local navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                if navConnect2 then
                  if vel.x > 0 then
                    normal = Vector(1,0,0)
                    navPos2 = navPos + Vector(-64,0,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  else
                    normal = Vector(-1,0,0)
                    navPos2 = navPos + Vector(64,0,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  end
                end
              elseif dir:Dot(Vector(0,-1,0)) > .707 then
                normal = Vector(0,-1,0)
                local navPos2 = navPos + Vector(0,64,0)
                local navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                if navConnect2 then
                  if vel.x > 0 then
                    normal = Vector(-1,0,0)
                    navPos2 = navPos + Vector(-64,0,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  else
                    normal = Vector(0,-1,0)
                    navPos2 = navPos + Vector(64,0,0)
                    navConnect2 = not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2)
                    if navConnect2 then
                      normal = Vector(diff.x * -1, diff.y * -1, diff.z)
                    end
                  end
                end
              end
              --FindClearSpaceForUnit(unit, newPos, true)
              --print(tostring(unit:GetAbsOrigin()) .. " -- " .. tostring(navPos))
            end

            if unit.PhysicsOnPreBounce then
              local status, nextCall = pcall(unit.PhysicsOnPreBounce, unit, normal)
              if not status then
                print('[PHYSICS] Failed OnPreBounce: ' .. nextCall)
              end
            end
            newVelocity = ((-2 * newVelocity:Dot(normal) * normal) + newVelocity) * unit.fBounceMultiplier
            staticSum = ((-2 * staticSum:Dot(normal) * normal) + staticSum) * unit.fBounceMultiplier
            if unit.PhysicsOnBounce then
              local status, nextCall = pcall(unit.PhysicsOnBounce, unit, normal)
              if not status then
                print('[PHYSICS] Failed OnBounce: ' .. nextCall)
              end
            end
          end
        end
      end

      --if newPos.z > unit:GetAbsOrigin().z then print (tostring(newPos) .. ' -- ' .. tostring(unit:GetAbsOrigin())) end
      --if newPos == unit:GetAbsOrigin() and newPos ~= prevPosition then print (tostring(dontSet) .. ' -- ' .. tostring(newPos) .. ' -- ' .. tostring(unit:GetAbsOrigin())) end
      newVelLength = newVelocity:Length()
      local groundPos = GetGroundPosition(newPos, unit)

      if unit.nVelocityMax > 0 and newVelLength > unit.nVelocityMax then
        newVelocity = newVelocity:Normalized() * unit.nVelocityMax
        staticSum = staticSum:Normalized() * unit.nVelocityMax
      end

      local xylen = newVelocity:Length2D()
      if unit.vAcceleration.x == 0 and unit.vAcceleration.y == 0 and xylen < unit.fVelocityClamp and (unit.vAcceleration.z == 0 or groundPos.z == newPos.z) then
        --print('clamp')
        newVelocity = Vector(0,0,newVelocity.z)
        staticSum = Vector(0,0,staticSum.z)

        if unit.bHibernate then
          unit:DoHibernate()
          local ent = Entities:FindInSphere(nil, position, 35)
          local blocked = false
          while ent ~= nil and not blocked do
            if ent.GetUnitName ~= nil and ent ~= unit then
              blocked = true
            end
            --print(ent:GetClassname() .. " -- " .. ent:GetName() .. " -- " .. tostring(ent.IsHero))
            ent = Entities:FindInSphere(ent, position, 35)
          end
          if blocked or blockedPos or GridNav:IsNearbyTree(position, 30, true) then
            FindClearSpaceForUnit(unit, position, true)
            unit.nSkipSlide = 1
            --print('FCS hib')
          end
          if unit.PhysicsHibernateCallback ~= nil then
            local status, nextCall = pcall(unit.PhysicsHibernateCallback, unit)
            if not status then
              print('[PHYSICS] Failed HibernateCallback: ' .. nextCall)
            end
          end
          return
        end

        --[[if unit:HasModifier("modifier_rooted") then
          unit:RemoveModifierByName("modifier_rooted")
        end

        local ent = Entities:FindInSphere(nil, position, 35)
        local blocked = false
        while ent ~= nil and not blocked do
          if ent.IsHero ~= nil and ent ~= unit then
            blocked = true
          end
          --print(ent:GetClassname() .. " -- " .. ent:GetName() .. " -- " .. tostring(ent.IsHero))
          ent = Entities:FindInSphere(ent, position, 35)
        end
        if blocked or not GridNav:IsTraversable(position) or GridNav:IsBlocked(position) or GridNav:IsNearbyTree(position, 30, true) then
          FindClearSpaceForUnit(unit, position, true)
          unit.nSkipSlide = 1
          --print('FCS nothib lowv + blocked')
        end ]]
      end

      if not dontSetGround then
        if unit.nLockToGround == PHYSICS_GROUND_LOCK then
          local groundPos = GetGroundPosition(newPos, unit)
          newPos = groundPos
          newVelocity.z = 0
          staticSum.z = 0
        elseif unit.nLockToGround == PHYSICS_GROUND_ABOVE then
          local groundPos = GetGroundPosition(newPos, unit)
          --print(groundPos.z .. ' -- ' .. newPos.z .. ' -- ' .. (groundPos - position):Normalized().z)
          if unit.nNavCollision == PHYSICS_NAV_GROUND and groundPos.z > position.z and (groundPos - position):Normalized().z > unit.fNavGroundAngle then
            newVelocity.z = math.max(0, newVelocity.z)
            staticSum.z = 0
            --[[newPos = position + Vector(0,0,newVelocity.z)
            if newPos.z < unit.lastGoodGround.z then
              DebugDrawCircle(unit.lastGoodGround, Vector(255,255,255), 1, 15, true, 1.1)
              DebugDrawCircle(groundPos, Vector(255,0,0), 1, 15, true, 1.1)
              DebugDrawCircle(newPos, Vector(0,255,0), 1, 15, true, 1.1)
              print ('LAST GROUND2') 
              newPos.z = unit.lastGoodGround.z
              newVelocity.z = 0
              staticSum.z = 0
            end]]
          elseif groundPos.z >= newPos.z then
            newPos = groundPos
            newVelocity.z = 0
            staticSum.z = 0
          end
        end
      end

      if not dontSet then
        unit:SetAbsOrigin(newPos)
      end
      
      unit.nRebounceFrames = unit.nRebounceFrames - 1
      unit.vLastVelocity = unit.vVelocity
      unit.vVelocity = newVelocity - staticSum
      
      if unit.PhysicsFrameCallback ~= nil then
        local status, nextCall = pcall(unit.PhysicsFrameCallback, unit)
        if not status then
          print('[PHYSICS] Failed FrameCallback: ' .. nextCall)
        end
      end
      
      if unit.nNavCollision ~= PHYSICS_NAV_NOTHING and  unit.bAutoUnstuck and unit.nStuckFrames >= unit.nStuckTimeout then
        unit.nStuckFrames = 0
        unit.nSkipSlide = 1

        local navX = GridNav:WorldToGridPosX(position.x)
        local navY = GridNav:WorldToGridPosY(position.y)

        local anggrid = self.anggrid
        local offX = self.offsetX
        local offY = self.offsetY
        if anggrid then
          local angSize = #anggrid
          local angX = navX + offX
          local angY = navY + offY

          --print(offX .. ' -- ' .. angX .. ' == ' .. angY .. ' -- ' .. offY)
          
          local angle = anggrid[angX][angY]
          if angle ~= -1 then
            local normal = RotatePosition(Vector(0,0,0), QAngle(0,angle,0), Vector(1,0,0))
            --print(normal)
            --print('----------')

            unit:SetAbsOrigin(position + normal * 64)
          else
            unit:SetAbsOrigin(unit.vLastGoodPosition)
          end
        else
          unit:SetAbsOrigin(unit.vLastGoodPosition)
        end
      end
      
      return curTime
    end
  })
  
  unit.PhysicsTimer = Physics.timers[unit.PhysicsTimerName]
  unit.vVelocity = Vector(0,0,0)
  unit.vLastVelocity = Vector(0,0,0)
  unit.vAcceleration = Vector(0,0,0)
  unit.fFriction = .05
  unit.fFlatFriction = 0
  unit.PhysicsLastPosition = unit:GetAbsOrigin()
  unit.PhysicsLastTime = GameRules:GetGameTime()
  unit.vTotalVelocity = Vector(0,0,0)
  unit.bFollowNavMesh = true
  unit.nLockToGround = PHYSICS_GROUND_ABOVE
  unit.bPreventDI = false
  unit.bSlide = false
  unit.nNavCollision = PHYSICS_NAV_SLIDE
  unit.fNavGroundAngle = .6
  unit.fSlideMultiplier = 0.1
  unit.nVelocityMax = 0
  unit.PhysicsFrameCallback = nil
  unit.fVelocityClamp = 20.0 / 30.0
  unit.bHibernate = true
  unit.bHibernating = false
  unit.bStarted = true
  unit.bCutTrees = false
  unit.vSlideVelocity = Vector(0,0,0)
  unit.nNavGridLookahead = 1
  unit.bAdaptiveNavGridLookahead = false
  unit.nSkipSlide = 0
  unit.nMaxRebounce = 2
  unit.nRebounceFrames = 2
  unit.vLastGoodPosition = unit:GetAbsOrigin()
  unit.bAutoUnstuck = true
  unit.nStuckTimeout = 600
  unit.nStuckFrames = 0
  unit.fBounceMultiplier = 1.0
  unit.oColliders = {}
  unit.fMass = 100
  unit.staticForces = {}
  unit.staticSum = Vector(0,0,0)
end


Physics.testUnitNum = 0
Physics.testUnits = {}
-- Physics Testing commands
function Physics:PhysicsTestCommand(...)

  local args = {...}
  local text = table.concat (args, " ")
  local ply = Convars:GetCommandClient()
  local plyID = ply:GetPlayerID()

  local hero = ply:GetAssignedHero()

  if text == "" or string.find(text, "^help") then
    print("PHYSTEST Help")
    print('---------------------')
    print("vel X Y Z        -- Adds the given velocity X,Y,Z to the current hero's velocity.")
    print("velmax X         -- Sets the maximum velocity of the current hero to X.")
    print("clamp X          -- Sets the to-zero velocity clamp to X hammer units per second.")
    print("acc X Y Z        -- Sets the given acceleration X,Y,Z to the current hero's acceleration.")
    print("fric X           -- Sets the frcition of the current hero to X / 100.")
    print("prevent          -- Toggles Directional Influence prevention (aka right click moving).")
    print("slidemult X      -- Sets the slide multiplier to X / 100.")
    print("slide            -- Toggles Slide on/off.")
    print("nav              -- Toggles FollowNavMesh on/off.  Nav collision will not trigger if this is not set.")
    print("navtype          -- Cycles through the navtype collision types.")
    print("hibernate        -- Toggles hibernate on/off.")
    print("ground           -- Cycles through the ground behavior.")
    print("mass X           -- Sets the mass of this unit to X for momentum collision calculations.")
    print("bouncemult X     -- Sets the bounce multiplier to X / 100.")
    print("unstuck          -- Toggles AutoUnstuck on/off.")
    print("stuckframes X    -- Sets the number of frames to wait before triggering an Unstuck.")
    print("rebounceframes X -- Sets the number of frames to wait between NAV_BOUNCE bounces.")
    print("lookahead X      -- Sets the number of lookahead frames for nav collision detection.")
    print("phys             -- Activates this hero as a physics unit.")
    print("regrow           -- Regrow all trees on the map.")
    print("anggrid          -- Process the map into an anglegrid to use with SLIDE/BOUNCE nav collision.")
    print('---------------------')
  end

  if string.find(text, "^regrow") then
    GridNav:RegrowAllTrees()
  end

  if string.find(text, "^unstuck") then    
    hero:SetAutoUnstuck(not hero:GetAutoUnstuck())
    print(hero:GetAutoUnstuck())
  end

  local mass1 = string.match(text, "^mass%s+(-?%d+)")
  if mass1 ~= nil then
    hero:SetMass(mass1)
  end

  local bmult1 = string.match(text, "^bouncemult%s+(-?%d+)")
  if bmult1 ~= nil then
    hero:SetBounceMultiplier(bmult1 / 100) 
  end

  local stuckTimeout1 = string.match(text, "^stuckframes%s+(%d+)")
  if stuckTimeout1 ~= nil then
    hero:SetStuckTimeout(stuckTimeout1)
  end

  local rebounce1 = string.match(text, "^rebounceframes%s+(%d+)")
  if rebounce1 ~= nil then
    hero:SetRebounceFrames(rebounce1)
  end
  
  local lookahead1 = string.match(text, "^lookahead%s+(%d+)")
  if lookahead1 ~= nil then
    hero:SetNavGridLookahead(lookahead1)
  end

  if string.find(text, "^spider") then
    local mapGnv = {}
    local worldMin = Vector(GetWorldMinX(), GetWorldMinY(), 0)
    local worldMax = Vector(GetWorldMaxX(), GetWorldMaxY(), 0)

    print(worldMin)
    print(worldMax)

    local boundX1 = GridNav:WorldToGridPosX(worldMin.x)
    local boundX2 = GridNav:WorldToGridPosX(worldMax.x)
    local boundY1 = GridNav:WorldToGridPosX(worldMin.y)
    local boundY2 = GridNav:WorldToGridPosX(worldMax.y)

    print(boundX1 .. " -- " .. boundX2)
    print(boundY1 .. " -- " .. boundY2)

    print('----------------------')

    InitLogFile("addons/dotadash/spider.txt", "")
    AppendToLogFile("addons/dotadash/spider.txt", "P1")
    AppendToLogFile("addons/dotadash/spider.txt", "#spider created pbm")
    AppendToLogFile("addons/dotadash/spider.txt", tostring(boundX2 - boundX1 + 1) .. " " .. tostring(boundY2 - boundY1 + 1))

    local pseudoGNV = {}
    local WALLS = self.WALLS
    for i=1,#WALLS do
      local from = WALLS[i].from
      local to = WALLS[i].to
      local cur = from
      local dist = to - from
      dist.z = 0
      local dir = dist:Normalized()
      dist = dist:Length()
      local norm = RotatePosition(Vector(0,0,0), QAngle(0,90,0), dir)

      for j=1,math.floor(dist/30) do
        local pos = cur + norm * 64
        local pos2 = cur - norm * 64
        local x = GridNav:WorldToGridPosX(pos.x)
        local y = GridNav:WorldToGridPosY(pos.y)
        if pseudoGNV[x] == nil then
          pseudoGNV[x] = {}
        end
        pseudoGNV[x][y] = true

        x = GridNav:WorldToGridPosX(pos2.x)
        y = GridNav:WorldToGridPosY(pos2.y)
        if pseudoGNV[x] == nil then
          pseudoGNV[x] = {}
        end
        pseudoGNV[x][y] = true

        x = GridNav:WorldToGridPosX(cur.x)
        y = GridNav:WorldToGridPosY(cur.y)
        if pseudoGNV[x] == nil then
          pseudoGNV[x] = {}
        end
        pseudoGNV[x][y] = true

        cur = from + dir*j*30
      end

      cur = to
      local pos = cur + norm * 64
      local pos2 = cur - norm * 64
      local blocked = not GridNav:IsTraversable(pos) or GridNav:IsBlocked(pos)
      if blocked then
        local x = GridNav:WorldToGridPosX(pos.x)
        local y = GridNav:WorldToGridPosY(pos.y)
        if pseudoGNV[x] == nil then
          pseudoGNV[x] = {}
        end
        pseudoGNV[x][y] = true
      end

      blocked = not GridNav:IsTraversable(pos2) or GridNav:IsBlocked(pos2)
      if blocked then
        local x = GridNav:WorldToGridPosX(pos2.x)
        local y = GridNav:WorldToGridPosY(pos2.y)
        if pseudoGNV[x] == nil then
          pseudoGNV[x] = {}
        end
        pseudoGNV[x][y] = true
      end

      blocked = not GridNav:IsTraversable(cur) or GridNav:IsBlocked(cur)
      if blocked then
        local x = GridNav:WorldToGridPosX(cur.x)
        local y = GridNav:WorldToGridPosY(cur.y)
        if pseudoGNV[x] == nil then
          pseudoGNV[x] = {}
        end
        pseudoGNV[x][y] = true
      end
    end

    --PrintTable(pseudoGNV)
    --print('---------------')

    local s = ""

    for i=boundY2,boundY1,-1 do
      for j=boundX1,boundX2 do
        local position = Vector(GridNav:GridPosToWorldCenterX(j), GridNav:GridPosToWorldCenterY(i), 0)
        local blocked = not GridNav:IsTraversable(position) or GridNav:IsBlocked(position) or (pseudoGNV[j] ~= nil and pseudoGNV[j][i])

        if blocked then
          s = s .. "1"
        else
          s = s .. "0"
        end

        if j == boundX2 then
          AppendToLogFile("addons/dotadash/spider.txt", s)
          s = ""
        else
          s = s .. " "
        end
      end
    end
  end

  if string.find(text, "^anggrid") then
    Physics:GenerateAngleGrid()
  end
  
  local ap = abilPoints

  local fname = string.match(text, "^angsave%s+(.+)")
  if fname ~= nil then
    -- Process map
    local addString = function (stack, s)
        table.insert(stack, s)    -- push 's' into the the stack
        for i=table.getn(stack)-1, 1, -1 do
          if string.len(stack[i]) > string.len(stack[i+1]) then
            break
          end
          stack[i] = stack[i] .. table.remove(stack)
        end
      end

    local s = {""}
    addString(s, "{")
    local anggrid = Physics.anggrid
    for x=1,#anggrid do
      addString(s, "{")
      for y=1,#anggrid[x] do
        addString(s, tostring(anggrid[x][y]))
        if y < #anggrid[x] then
          addString(s, ",")
        end
      end
      addString(s, "}")
      if x < #anggrid then
        addString(s, ",")
      end
    end
    addString(s, "}")

    s = table.concat(s)
    print('------------')
    print(fname)
    print(s)

    InitLogFile("addons/dotadash/" .. fname .. ".txt", s)
  end

  if string.find(text, "^units") then
    local m = string.match(text, "(%d+)")
    if m ~= nil then
      Physics.testUnitNum = Physics.testUnitNum + m
      print (Physics.testUnitNum)
      for i=1,m do 
        local unit = CreateUnitByName('npc_dummy_blank', hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
        unit:AddNewModifier(unit, nil, "modifier_phased", {})
        unit:SetModel('models/heroes/lycan/lycan_wolf.vmdl')
        unit:SetOriginalModel('models/heroes/lycan/lycan_wolf.vdl')
        
        Physics:Unit(unit)
        unit:SetPhysicsFriction(0)
        unit:SetPhysicsVelocity(RandomVector(2000))
        unit:SetNavCollisionType(PHYSICS_NAV_BOUNCE)
      end
    end
  end
  
  
  if string.find(text, "^hibtest") then
    local m = string.match(text, "(%d+)")
    if m ~= nil and m == "0" then
      Timers:CreateTimer('units2',{
        useOldStyle = true,
        useGameTime = true,
        endTime = GameRules:GetGameTime(),
        callback = function(reflex, args)
          local pushNum = math.floor(#units / 10) + 1
          for i=1,pushNum do
            local unit = units[RandomInt(1, #units)]
            unit:AddPhysicsVelocity(RandomVector(RandomInt(1000,2000)))
          end
          
          return GameRules:GetGameTime() + 1
        end
      })
    elseif m ~= nil then
      Physics.testUnitNum = Physics.testUnitNum + m
      print (Physics.testUnitNum)
      for i=1,m do 
        local unit = CreateUnitByName('npc_dummy_blank', hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
        unit:AddNewModifier(unit, nil, "modifier_phased", {})
        unit:SetModel('models/heroes/lycan/lycan_wolf.vmdl')
        unit:SetOriginalModel('models/heroes/lycan/lycan_wolf.vmdl')
        
        Physics:Unit(unit)
        unit:SetNavCollisionType(PHYSICS_NAV_BOUNCE)
        
        Physics.testUnits[#Physics.testUnits + 1] = unit
      end
    end
  end
  
  local vel1,vel2,vel3 = string.match(text, "^vel%s+(-?%d+)%s+(-?%d+)%s+(-?%d+)")
  if vel1 ~= nil and vel2 ~= nil and vel3 ~= nil then
    hero:AddPhysicsVelocity(Vector(tonumber(vel1), tonumber(vel2), tonumber(vel3)))
  end
  
  local velmax1 = string.match(text, "^velmax%s+(%d+)")
  if velmax1 ~= nil then
    hero:SetPhysicsVelocityMax(tonumber(velmax1))
  end
  
  local acc1,acc2,acc3 = string.match(text, "^acc%s+(-?%d+)%s+(-?%d+)%s+(-?%d+)")
  if acc1 ~= nil and acc2 ~= nil and acc3 ~= nil then
    hero:SetPhysicsAcceleration(Vector(tonumber(acc1), tonumber(acc2), tonumber(acc3)))
  end
  
  local fric1 = string.match(text, "^fric%s+(-?%d+)")
  if fric1 ~= nil then
    hero:SetPhysicsFriction(tonumber(fric1) / 100 )
  end
  
  local slide1 = string.match(text, "^slidemult%s+(-?%d+)")
  if slide1 ~= nil then
    hero:SetSlideMultiplier(tonumber(slide1) / 100 )
  end
  
  if string.find(text, "^prevent") then
    hero:PreventDI(not hero:IsPreventDI())
    print(hero:IsPreventDI())
  end

  if string.find(text, "^phys") and hero.IsSlide == nil then
    Physics:Unit(hero)
  end
  
  if string.find(text, "^onframe") then
    hero:OnPhysicsFrame(function(unit)
      --PrintTable(unit)
      --print('----------------')
    end)
  end
  
  if string.find(text, "^slide$") then
    hero:Slide(not hero:IsSlide())
    print(hero:IsSlide())
  end
  
  if string.find(text, "^nav$") then
    hero:FollowNavMesh(not hero:IsFollowNavMesh())
    print(hero:IsFollowNavMesh())
  end
  
  local clamp1 = string.match(text, "^clamp%s+(%d+)")
  if clamp1 ~= nil then
    hero:SetVelocityClamp( tonumber(clamp1))
  end
  
  if string.find(text, "^hibernate") then
    hero:Hibernate(not hero:IsHibernate())
    print(hero:IsHibernate())
  end
  
  if string.find(text, "^navtype") then
      local navType = hero:GetNavCollisionType()
      navType = (navType + 1) % 4
      local navStr = "NOTHING"
      if navType == PHYSICS_NAV_NOTHING then
        navStr = "NOTHING"
      elseif navType == PHYSICS_NAV_HALT then
        navStr = "HALT"
      elseif navType == PHYSICS_NAV_BOUNCE then
        navStr = "BOUNCE"
      elseif navType == PHYSICS_NAV_SLIDE then
        navStr = "SLIDE"
      end
      print('navtype: ' .. navStr)
      hero:SetNavCollisionType(navType)
  end
  
  if string.find(text, "^ground") then
    local ground = hero:GetGroundBehavior()
    ground = (ground + 1) % 3
    local groundStr = "NOTHING"
    if ground == PHYSICS_GROUND_NOTHING then
      groundStr = "NOTHING"
    elseif ground == PHYSICS_GROUND_ABOVE then
      groundStr = "ABOVE"
    elseif ground == PHYSICS_GROUND_LOCK then
      groundStr = "LOCK"
    end
    print('ground: ' .. groundStr)
    hero:SetGroundBehavior(ground)
  end
end

function Physics:BlockInSphere(unit, unitToRepel, radius, findClearSpace)
  local pos = unit:GetAbsOrigin()
  local vPos = unitToRepel:GetAbsOrigin()
  local dir = vPos - pos
  local dist2 = VectorDistanceSq(pos, vPos)
  local move = radius
  local move2 = move * move

  if move2 < dist2 then
    return
  end

  if IsPhysicsUnit(unitToRepel) then
    unitToRepel.nSkipSlide = 1
  end

  if findClearSpace then
    FindClearSpaceForUnit(unitToRepel, pos + (dir:Normalized() * move), true)
  else
    unitToRepel:SetAbsOrigin(pos + (dir:Normalized() * move))
  end
end

function Physics:BlockInBox(unit, dist, normal, buffer, findClearSpace)
  local toside = (dist + buffer) * normal

  if IsPhysicsUnit(unit) then
    unit.nSkipSlide = 1
  end

  if findClearSpace then
    FindClearSpaceForUnit(unit, unit:GetAbsOrigin() + toside, true)
  else
    unit:SetAbsOrigin(unit:GetAbsOrigin() + toside)
  end
end

function Physics:BlockInAABox(unit, xblock, value, buffer, findClearSpace)
  if IsPhysicsUnit(unit) then
    unit.nSkipSlide = 1
  end

  local pos = unit:GetAbsOrigin()

  if xblock then
    pos.x = value
  else
    pos.y = value
  end

  if findClearSpace then
    FindClearSpaceForUnit(unit, pos, true)
  else
    unit:SetAbsOrigin(pos)
  end
end

function Physics:DistanceToLine(point, lineA, lineB)
  local a = (lineA - point):Length()
  local b = (lineB - point):Length()
  local c = (lineB - lineA):Length()
  local s = (a+b+c)/2
  local num = (math.sqrt(s*(s-a)*(s-b)*(s-c)) * 2 / c)
  if num ~= num then
    return 0
  end
  return num
end

function Physics:CreateBox(a, b, width, center)
  local az = Vector(a.x,a.y,0)
  local bz = Vector(b.x,b.y,0)
  local height = math.abs(b.z - a.z)
  if height < 1 then 
    b.z = b.z + width/2 
    a.z = a.z - width/2
  end

  local dir = (bz-az):Normalized()
  local rot = Vector(-1*dir.y,dir.x,0)

  local box = {}
  if center then
    box[1] = a + -1 * rot * width / 2
    box[2] = b + -1 * rot * width / 2
    box[3] = a + rot * width / 2
  else
    box[1] = a
    box[2] = b
    box[3] = a + rot * width
  end

  return box
end

function Physics:PrecalculateBoxDraw(box)
  local ang = RotationDelta(VectorToAngles(box.upNormal), VectorToAngles(Vector(1,0,0))).y
  local ang2 = RotationDelta(VectorToAngles(box.rightNormal), VectorToAngles(Vector(1,0,0))).y
  if ang > 90 then
    ang = 180 - ang
  elseif ang < -90 then
    ang = -180 - ang
  end

  if ang2 > 90 then
    ang2 = 180 - ang2
  elseif ang2 < -90 then
    ang2 = -180 - ang2
  end

  local a = ang
  if math.abs(ang2) < math.abs(ang) then
    a = ang2
  end

  local aRot = RotatePosition(box.a, QAngle(0, a, 0), box.a)
  local bRot = RotatePosition(box.a, QAngle(0, a, 0), box.b)
  local cRot = RotatePosition(box.a, QAngle(0, a, 0), box.c)
  local dRot = RotatePosition(box.a, QAngle(0, a, 0), box.d)

  local minX = math.min(math.min(math.min(aRot.x, bRot.x), cRot.x), dRot.x)
  local minY = math.min(math.min(math.min(aRot.y, bRot.y), cRot.y), dRot.y)
  local maxX = math.max(math.max(math.max(aRot.x, bRot.x), cRot.x), dRot.x)
  local maxY = math.max(math.max(math.max(aRot.y, bRot.y), cRot.y), dRot.y)

  box.drawAngle = -1 * a
  box.drawMins = Vector(minX, minY, box.zMin)
  box.drawMaxs = Vector(maxX, maxY, box.zMax)
end

function Physics:PrecalculateBox(box)
  box.zMin = math.min(math.min(box[1].z, box[2].z), box[3].z)
  box.zMax = math.max(math.max(box[1].z, box[2].z), box[3].z)
  box.center = box[2] + (box[3] - box[2]) / 2
  box.center.z = (box.zMin + box.zMax) / 2
  box.radius = math.max((box[3] - box.center):Length(), (box[2] - box.center):Length())
  box.middle = Vector(box.center.x, box.center.y, box.center.z)
  box.middle.z = 0
  box.a = box[1]
  box.a.z = 0
  box.b = box[2]
  box.b.z = 0
  box.d = box[3]
  box.d.z = 0
  box.c = box.b + (box.d - box.a)
  box.upNormal = (box.d - box.a):Normalized()
  box.rightNormal = (box.b - box.a):Normalized()

  box[1] = nil
  box[2] = nil
  box[3] = nil

  box.ab = box.b - box.a
  box.ad = box.d - box.a
  box.ab2 = box.ab:Dot(box.ab)
  box.ad2 = box.ad:Dot(box.ad)

  box.recalculate = nil
  return box
end

function Physics:PrecalculateAABox(box)
  box.xMin = math.min(box[1].x, box[2].x)
  box.xMax = math.max(box[1].x, box[2].x)
  box.yMin = math.min(box[1].y, box[2].y)
  box.yMax = math.max(box[1].y, box[2].y)
  box.zMin = math.min(box[1].z, box[2].z)
  box.zMax = math.max(box[1].z, box[2].z)
  box.center = Vector((box.xMin + box.xMax) / 2, (box.yMin + box.yMax) / 2, (box.zMin + box.zMax) / 2)
  box.radius =(Vector(xMax, yMax, zMax) - box.center):Length()
  box.middle = Vector(box.center.x, box.center.y, 0)

  box.xScale = box.xMax - box.middle.x
  box.yScale = box.yMax - box.middle.y

  box[1] = nil
  box[2] = nil

  box.recalculate = nil
  return box
end


if not Physics.timers then Physics:start() end

Physics:CreateColliderProfile("blocker", 
  {
    type = COLLIDER_SPHERE,
    radius = 100,
    recollideTime = 0,
    skipFrames = 0,
    moveSelf = false,
    buffer = 0,
    findClearSpace = false,
    test = function(self, collider, collided)
      return collided.IsRealHero and collided:IsRealHero() and collider:GetTeam() ~= collided:GetTeam()
    end,
    action = function(self, unit, v)
      if self.moveSelf then
        Physics:BlockInSphere(v, unit, self.radius + self.buffer, self.findClearSpace)
      else
        Physics:BlockInSphere(unit, v, self.radius + self.buffer, self.findClearSpace)
      end
    end
  })

Physics:CreateColliderProfile("delete", 
  {
    type = COLLIDER_SPHERE,
    radius = 100,
    recollideTime = 0,
    skipFrames = 0,
    deleteSelf = true,
    removeCollider = true,
    test = function(self, collider, collided)
      return collided.IsRealHero and collided:IsRealHero() and collider:GetTeam() ~= collided:GetTeam()
    end,
    action = function(self, unit, v)
      if self.deleteSelf then
        UTIL_Remove(unit)
      else
        UTIL_Remove(v)
      end

      if self.removeCollider then
        Physics:RemoveCollider(self)
      end
    end
  })

Physics:CreateColliderProfile("gravity", 
  {
    type = COLLIDER_SPHERE,
    radius = 100,
    recollideTime = 0,
    skipFrames = 0,
    minRadius = 0,
    fullRadius = 0,
    linear = false,
    force = 1000,
    test = function(self, collider, collided)
      return collided.IsRealHero and collided:IsRealHero() and collider:GetTeam() ~= collided:GetTeam() and IsPhysicsUnit(collided)
    end,
    action = function(self, unit, v)
      local pos = unit:GetAbsOrigin()
      local vPos = v:GetAbsOrigin()
      local dir = pos - vPos
      local len = dir:Length()
      if len > self.minRadius then
        local radDiff = self.radius - self.fullRadius
        local dist = math.max(0, len - self.fullRadius)
        local factor = (radDiff - dist) / radDiff

        local force = self.force
        if self.linear then
          force = force * factor / 30
        else
          local factor2 = factor * factor
          force = force * factor2 / 30
        end

        force = force * (self.skipFrames + 1)

        v:AddPhysicsVelocity(dir:Normalized() * force)
      end
    end
  })

Physics:CreateColliderProfile("repel", 
  {
    type = COLLIDER_SPHERE,
    radius = 100,
    recollideTime = 0,
    skipFrames = 0,
    minRadius = 0,
    fullRadius = 0,
    linear = false,
    force = 1000,
    test = function(self, collider, collided)
      return collided.IsRealHero and collided:IsRealHero() and collider:GetTeam() ~= collided:GetTeam() and IsPhysicsUnit(collided)
    end,
    action = function(self, unit, v)
      local pos = unit:GetAbsOrigin()
      local vPos = v:GetAbsOrigin()
      local dir = pos - vPos
      local len = dir:Length()
      if len > self.minRadius then
        local radDiff = self.radius - self.fullRadius
        local dist = math.max(0, len - self.fullRadius)
        local factor = (radDiff - dist) / radDiff

        local force = self.force
        if self.linear then
          force = force * factor / 30
        else
          local factor2 = factor * factor
          force = force * factor2 / 30
        end

        force = force * (self.skipFrames + 1)

        v:AddPhysicsVelocity(-1 * dir:Normalized() * force)
      end
    end
  })


Physics:CreateColliderProfile("reflect", 
  {
    type = COLLIDER_SPHERE,
    radius = 100,
    recollideTime = 0,
    skipFrames = 0,
    multiplier = 1,
    block = true,
    blockRadius = 100,
    moveSelf = false,
    findClearSpace = false,
    test = function(self, collider, collided)
      return collided.IsRealHero and collided:IsRealHero() and collider:GetTeam() ~= collided:GetTeam() and IsPhysicsUnit(collided)
    end,
    action = function(self, unit, v)
      local pos = unit:GetAbsOrigin()
      local vPos = v:GetAbsOrigin()
      local normal = vPos - pos
      normal = normal:Normalized()

      local newVelocity = v.vVelocity
      if newVelocity:Dot(normal) >= 0 then
        return
      end

      v:SetPhysicsVelocity(((-2 * newVelocity:Dot(normal) * normal) + newVelocity) * self.multiplier * 30)

      if self.block then
        if self.moveSelf then
          Physics:BlockInSphere(v, unit, self.blockRadius, self.findClearSpace)
        else
          Physics:BlockInSphere(unit, v, self.blockRadius, self.findClearSpace)
        end
      end
    end
  })

Physics:CreateColliderProfile("momentum", 
  {
    type = COLLIDER_SPHERE,
    radius = 100,
    recollideTime = .1,
    skipFrames = 0,
    block = true,
    blockRadius = 50,
    moveSelf = false,
    findClearSpace = false,
    elasticity = 1,
    test = function(self, collider, collided)
      return collided.IsRealHero and collided:IsRealHero() and collider:GetTeam() ~= collided:GetTeam() and IsPhysicsUnit(collided)
    end,
    action = function(self, unit, v)
      if self.hitTime == nil or GameRules:GetGameTime() >= self.hitTime then
        local pos = unit:GetAbsOrigin()
        local vPos = v:GetAbsOrigin()
        local dir = vPos - pos
        local mass = unit:GetMass()
        local vMass = v:GetMass()
        --dir.z = 0
        dir = dir:Normalized()
        
        local neg = -1 * dir
        
        local dot = dir:Dot(unit:GetTotalVelocity())
        local dot2 = dir:Dot(v:GetTotalVelocity())

        local v1 = (self.elasticity * vMass * (dot2 - dot) + (mass * dot) + (vMass * dot2)) / (mass + vMass)
        local v2 = (self.elasticity * mass * (dot - dot2) + (mass * dot) + (vMass * dot2)) / (mass + vMass)
        
        --if dot < 1 and dot2 < 1 then
          --return
        --end

        unit:AddPhysicsVelocity((v1 - dot) * dir)
        v:AddPhysicsVelocity((v2 - dot2) * dir)

        if self.block then
          if self.moveSelf then
            Physics:BlockInSphere(v, unit, self.blockRadius, self.findClearSpace)
          else
            Physics:BlockInSphere(unit, v, self.blockRadius, self.findClearSpace)
          end
        end

        self.hitTime = GameRules:GetGameTime() + self.recollideTime
      end
    end
  })

Physics:CreateColliderProfile("momentumFull", 
  {
    type = COLLIDER_SPHERE,
    radius = 100,
    recollideTime = .1,
    skipFrames = 0,
    block = true,
    blockRadius = 50,
    moveSelf = false,
    findClearSpace = false,
    elasticity = 1,
    test = function(self, collider, collided)
      return collided.IsRealHero and collided:IsRealHero() and collider:GetTeam() ~= collided:GetTeam() and IsPhysicsUnit(collided)
    end,
    action = function(self, unit, v)
      if self.hitTime == nil or GameRules:GetGameTime() >= self.hitTime then
        local pos = unit:GetAbsOrigin()
        local vPos = v:GetAbsOrigin()
        local dir = vPos - pos
        local mass = unit:GetMass()
        local vMass = v:GetMass()
        --dir.z = 0
        dir = dir:Normalized()
        
        local neg = -1 * dir
        
        local dot = unit:GetTotalVelocity():Length()
        local dot2 = -1 * v:GetTotalVelocity():Length()

        local v1 = (self.elasticity * vMass * (dot2 - dot) + (mass * dot) + (vMass * dot2)) / (mass + vMass)
        local v2 = (self.elasticity * mass * (dot - dot2) + (mass * dot) + (vMass * dot2)) / (mass + vMass)
        
        --if dot < 1 and dot2 < 1 then
          --return
        --end

        unit:AddPhysicsVelocity((v1 - dot) * dir)
        v:AddPhysicsVelocity((v2 - dot2) * dir)

        if self.block then
          if self.moveSelf then
            Physics:BlockInSphere(v, unit, self.blockRadius, self.findClearSpace)
          else
            Physics:BlockInSphere(unit, v, self.blockRadius, self.findClearSpace)
          end
        end

        self.hitTime = GameRules:GetGameTime() + self.recollideTime
      end
    end
  })

Physics:CreateColliderProfile("boxblocker", 
  {
    type = COLLIDER_BOX,
    box = {Vector(0,0,0), Vector(200,100,500), Vector(0,100,0)},
    slide = true,
    recollideTime = 0,
    skipFrames = 0,
    buffer = 0,
    findClearSpace = false,
    test = function(self, unit)
      return unit.IsRealHero and unit:IsRealHero() and unit:GetTeam() ~= unit:GetTeam() and IsPhysicsUnit(unit)
    end,
    action = function(self, box, unit)
      --PrintTable(box)
      local pos = unit:GetAbsOrigin()
      pos.z = 0

      --face collide determination
      local diff =  (pos - box.middle):Normalized()
      local up = diff:Dot(box.upNormal)
      local right = diff:Dot(box.rightNormal)
      local normal = box.upNormal
      local toside = 0
      local leg1 = box.c
      local leg2 = box.d
      if up >= 0 then
        if right >= 0 then
          -- check top,right
          local u = Physics:DistanceToLine(pos, box.c, box.d)
          local r = Physics:DistanceToLine(pos, box.c, box.b)
          if u < r then
            normal = box.upNormal
            leg1 = box.c
            leg2 = box.d
            toside = u
          else
            normal = box.rightNormal
            leg1 = box.c
            leg2 = box.b
            toside = r
          end
        else
          -- check top,left
          local u = Physics:DistanceToLine(pos, box.c, box.d)
          local l = Physics:DistanceToLine(pos, box.a, box.d)
          if u < l then
            normal = box.upNormal
            leg1 = box.c
            leg2 = box.d
            toside = u
          else
            normal = -1 * box.rightNormal
            leg1 = box.a
            leg2 = box.d
            toside = l
          end
        end
      else
        if right >= 0 then
          -- check bot,right
          local b = Physics:DistanceToLine(pos, box.a, box.b)
          local r = Physics:DistanceToLine(pos, box.c, box.b)
          if b < r then
            normal = -1 * box.upNormal
            leg1 = box.a
            leg2 = box.b
            toside = b
          else
            normal = box.rightNormal
            leg1 = box.c
            leg2 = box.b
            toside = r
          end
        else
          -- check bot,left
          local b = Physics:DistanceToLine(pos, box.a, box.b)
          local l = Physics:DistanceToLine(pos, box.a, box.d)
          if b < l then
            normal = -1 * box.upNormal
            leg1 = box.c
            leg2 = box.d
            toside = b
          else
            normal = -1 * box.rightNormal
            leg1 = box.a
            leg2 = box.d
            toside = l
          end
        end
      end

      normal = normal:Normalized()

      Physics:BlockInBox(unit, toside, normal, self.buffer, self.findClearSpace)

      if self.slide and IsPhysicsUnit(unit) then
        unit:AddPhysicsVelocity(math.max(0,unit:GetPhysicsVelocity():Dot(normal * -1)) * normal)
      end
    end
  })

Physics:CreateColliderProfile("boxreflect", 
  {
    type = COLLIDER_BOX,
    box = {Vector(0,0,0), Vector(200,100,500), Vector(0,100,0)},
    recollideTime = 0,
    skipFrames = 0,
    buffer = 0,
    block = true,
    findClearSpace = false,
    multiplier = 1,
    test = function(self, unit)
      return unit.IsRealHero and unit:IsRealHero() and unit:GetTeam() ~= unit:GetTeam() and IsPhysicsUnit(unit)
    end,
    action = function(self, box, unit)
      local pos = unit:GetAbsOrigin()
      pos.z = 0

      --face collide determination
      local diff =  (pos - box.middle):Normalized()
      local up = diff:Dot(box.upNormal)
      local right = diff:Dot(box.rightNormal)
      local normal = box.upNormal
      local toside = 0
      local leg1 = box.c
      local leg2 = box.d
      if up >= 0 then
        if right >= 0 then
          -- check top,right
          local u = Physics:DistanceToLine(pos, box.c, box.d)
          local r = Physics:DistanceToLine(pos, box.c, box.b)
          if u < r then
            normal = box.upNormal
            leg1 = box.c
            leg2 = box.d
            toside = u
          else
            normal = box.rightNormal
            leg1 = box.c
            leg2 = box.b
            toside = r
          end
        else
          -- check top,left
          local u = Physics:DistanceToLine(pos, box.c, box.d)
          local l = Physics:DistanceToLine(pos, box.a, box.d)
          if u < l then
            normal = box.upNormal
            leg1 = box.c
            leg2 = box.d
            toside = u
          else
            normal = -1 * box.rightNormal
            leg1 = box.a
            leg2 = box.d
            toside = l
          end
        end
      else
        if right >= 0 then
          -- check bot,right
          local b = Physics:DistanceToLine(pos, box.a, box.b)
          local r = Physics:DistanceToLine(pos, box.c, box.b)
          if b < r then
            normal = -1 * box.upNormal
            leg1 = box.a
            leg2 = box.b
            toside = b
          else
            normal = box.rightNormal
            leg1 = box.c
            leg2 = box.b
            toside = r
          end
        else
          -- check bot,left
          local b = Physics:DistanceToLine(pos, box.a, box.b)
          local l = Physics:DistanceToLine(pos, box.a, box.d)
          if b < l then
            normal = -1 * box.upNormal
            leg1 = box.c
            leg2 = box.d
            toside = b
          else
            normal = -1 * box.rightNormal
            leg1 = box.a
            leg2 = box.d
            toside = l
          end
        end
      end

      normal = normal:Normalized()

      if self.block then
        Physics:BlockInBox(unit, toside, normal, self.buffer, self.findClearSpace)
      end

      local newVelocity = unit.vVelocity
      if newVelocity:Dot(normal) >= 0 then
        return
      end

      unit:SetPhysicsVelocity(((-2 * newVelocity:Dot(normal) * normal) + newVelocity) * self.multiplier * 30)
    end
  })

Physics:CreateColliderProfile("aaboxblocker", 
  {
    type = COLLIDER_AABOX,
    box = {Vector(0,0,0), Vector(200,100,500)},
    slide = true,
    recollideTime = 0,
    skipFrames = 0,
    buffer = 0,
    findClearSpace = false,
    test = function(self, unit)
      return unit.IsRealHero and unit:IsRealHero() and unit:GetTeam() ~= unit:GetTeam() and IsPhysicsUnit(unit)
    end,
    action = function(self, box, unit)
      --PrintTable(box)
      local pos = unit:GetAbsOrigin()
      pos.z = 0

      local x = pos.x
      local y = pos.y
      local middle = box.middle
      local xblock = true
      local value = 0
      local normal = Vector(1,0,0)

      if x > middle.x then
        if y > middle.y then
          -- up,right
          local relx = (pos.x - middle.x) / box.xScale
          local rely = (pos.y - middle.y) / box.yScale

          if relx > rely then
            --right
            normal = Vector(1,0,0)
            value = box.xMax
            xblock = true
          else
            --up
            normal = Vector(0,1,0)
            value = box.yMax
            xblock = false
          end
        elseif y <= middle.y then
          -- down,right
          local relx = (pos.x - middle.x) / box.xScale
          local rely = (middle.y - pos.y) / box.yScale

          if relx > rely then
            --right
            normal = Vector(1,0,0)
            value = box.xMax
            xblock = true
          else
            --down
            normal = Vector(0,-1,0)
            value = box.yMin
            xblock = false
          end
        end
      elseif x <= middle.x then
        if y > middle.y then
          -- up,left
          local relx = (middle.x - pos.x) / box.xScale
          local rely = (pos.y - middle.y) / box.yScale

          if relx > rely then
            --left
            normal = Vector(-1,0,0)
            value = box.xMin
            xblock = true
          else
            --up
            normal = Vector(0,1,0)
            value = box.yMax
            xblock = false
          end
        elseif y <= middle.y then
          -- down,left
          local relx = (middle.x - pos.x) / box.xScale
          local rely = (middle.y - pos.y) / box.yScale

          if relx > rely then
            --left
            normal = Vector(-1,0,0)
            value = box.xMin
            xblock = true
          else
            --down
            normal = Vector(0,-1,0)
            value = box.yMin
            xblock = false
          end
        end
      end

      Physics:BlockInAABox(unit, xblock, value, buffer, findClearSpace)

      if self.slide and IsPhysicsUnit(unit) then
        unit:AddPhysicsVelocity(math.max(0,unit:GetPhysicsVelocity():Dot(normal * -1)) * normal)
      end
    end
  })


Physics:CreateColliderProfile("aaboxreflect", 
  {
    type = COLLIDER_AABOX,
    box = {Vector(0,0,0), Vector(200,100,500)},
    recollideTime = 0,
    skipFrames = 0,
    buffer = 0,
    block = true,
    findClearSpace = false,
    multiplier = 1,
    test = function(self, unit)
      return unit.IsRealHero and unit:IsRealHero() and unit:GetTeam() ~= unit:GetTeam() and IsPhysicsUnit(unit)
    end,
    action = function(self, box, unit)
      --PrintTable(box)
      local pos = unit:GetAbsOrigin()
      pos.z = 0

      local x = pos.x
      local y = pos.y
      local middle = box.middle
      local xblock = true
      local value = 0
      local normal = Vector(1,0,0)

      if x > middle.x then
        if y > middle.y then
          -- up,right
          local relx = (pos.x - middle.x) / box.xScale
          local rely = (pos.y - middle.y) / box.yScale

          if relx > rely then
            --right
            normal = Vector(1,0,0)
            value = box.xMax
            xblock = true
          else
            --up
            normal = Vector(0,1,0)
            value = box.yMax
            xblock = false
          end
        elseif y <= middle.y then
          -- down,right
          local relx = (pos.x - middle.x) / box.xScale
          local rely = (middle.y - pos.y) / box.yScale

          if relx > rely then
            --right
            normal = Vector(1,0,0)
            value = box.xMax
            xblock = true
          else
            --down
            normal = Vector(0,-1,0)
            value = box.yMin
            xblock = false
          end
        end
      elseif x <= middle.x then
        if y > middle.y then
          -- up,left
          local relx = (middle.x - pos.x) / box.xScale
          local rely = (pos.y - middle.y) / box.yScale

          if relx > rely then
            --left
            normal = Vector(-1,0,0)
            value = box.xMin
            xblock = true
          else
            --up
            normal = Vector(0,1,0)
            value = box.yMax
            xblock = false
          end
        elseif y <= middle.y then
          -- down,left
          local relx = (middle.x - pos.x) / box.xScale
          local rely = (middle.y - pos.y) / box.yScale

          if relx > rely then
            --left
            normal = Vector(-1,0,0)
            value = box.xMin
            xblock = true
          else
            --down
            normal = Vector(0,-1,0)
            value = box.yMin
            xblock = false
          end
        end
      end

      if self.block then
        Physics:BlockInAABox(unit, xblock, value, buffer, findClearSpace)
      end

      local newVelocity = unit.vVelocity
      if newVelocity:Dot(normal) >= 0 then
        return
      end

      unit:SetPhysicsVelocity(((-2 * newVelocity:Dot(normal) * normal) + newVelocity) * self.multiplier * 30)      
    end
  })