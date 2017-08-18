modifier_undead_tusk_bone_ball = class({})

-----------------------------------------------------------------------

function modifier_undead_tusk_bone_ball:IsHidden()
	return true
end

-----------------------------------------------------------------------

function modifier_undead_tusk_bone_ball:IsPurgable()
	return false
end

-----------------------------------------------------------------------

function modifier_undead_tusk_bone_ball:OnCreated( kv )
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
	end
end

-----------------------------------------------------------------------

function modifier_undead_tusk_bone_ball:OnIntervalThink()
	if IsServer() then
		self:StartIntervalThink( -1 )
		self:GetAbility():LaunchBoneBall()
		self.bLaunched = true
	end
end

-----------------------------------------------------------------------

function modifier_undead_tusk_bone_ball:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		if self.bLaunched ~= true then
			local entities = FindUnitsInRadius( me:GetTeamNumber(), me:GetOrigin(), self:GetCaster(), 300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 0, false )
			for _,ent in pairs( entities ) do
				if ent ~= nil and ent:IsNull() == false and self:GetAbility():HasLoadedUnit( ent ) == false and ent ~= self:GetCaster() then
					self:GetAbility():LoadUnit( ent )
				end
			end
		end
		
		me:SetOrigin( self:GetAbility().vProjectileLocation )
	end
end

--------------------------------------------------------------------------------

function modifier_undead_tusk_bone_ball:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_undead_tusk_bone_ball:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetAbility():EndBoneBall( false )
	end
end
