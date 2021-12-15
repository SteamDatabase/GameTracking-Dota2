
modifier_bucket_soldier_passive = class({})

-------------------------------------------------------

function  modifier_bucket_soldier_passive:IsPurgable()
	return false
end

-------------------------------------------------------

function modifier_bucket_soldier_passive:OnCreated( kv )
	if IsServer() then
		print( "Bucket Soldier Spawned" )

		self.nFXIndex = ParticleManager:CreateParticle( "particles/creatures/candy_well/bucket_soldier_leash.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )

		self:AddParticle( self.nFXIndex, false, false, -1, false, false ) 

	end
end

-------------------------------------------------------

function modifier_bucket_soldier_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

-------------------------------------------------------

function modifier_bucket_soldier_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}

	return state
end

-------------------------------------------------------

function modifier_bucket_soldier_passive:OnDeath( params )
	if IsServer() then
		if params.unit ~= nil and params.unit:GetUnitName() == 'npc_dota_building_candy_well' then
			self:Destroy()
		end
	end
end
