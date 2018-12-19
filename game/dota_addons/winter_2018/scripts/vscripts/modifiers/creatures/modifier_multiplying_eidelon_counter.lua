
modifier_multiplying_eidelon_counter = class({})

--------------------------------------------------------------------------------

function modifier_multiplying_eidelon_counter:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
function modifier_multiplying_eidelon_counter:OnCreated( kv )
	
	self.max_hits = self:GetAbility():GetSpecialValueFor( "max_hits" )
	self.max_spawns = self:GetAbility():GetSpecialValueFor( "max_spawns" )
	if current_spawns == nil then
		current_spawns = 1
	end

	if IsServer() then 
			self:SetStackCount(0)
	end
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_multiplying_eidelon_counter:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end


--------------------------------------------------------------------------------

function modifier_multiplying_eidelon_counter:OnAttackLanded( params )
	if IsServer() then

		if params.attacker ~= self:GetParent() then
			return
		end
		
		if self:GetStackCount() < self.max_hits then
			self:IncrementStackCount()
			return
		else
			if current_spawns >= self.max_spawns then
				return
			end

			local hCreep = CreateUnitByName( "npc_dota_creature_multiplying_eidelon", self:GetCaster():GetOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )

				local nMaxVectorLength = 150
				local vLoc = self:GetParent():GetAbsOrigin() + RandomVector( nMaxVectorLength )

			self:SetStackCount(0)
			current_spawns = current_spawns + 1
			if hCreep ~= nil then
				hCreep:SetOwner( self:GetCaster() )
				hCreep:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), false )
				hCreep:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
				hCreep:SetDeathXP( 0 )
				hCreep:SetMinimumGoldBounty( 0 )
				hCreep:SetMaximumGoldBounty( 0 )
				local kv =
				{
					vLocX = vLoc.x,
					vLocY = vLoc.y,
					vLocZ = vLoc.z,
				}
				hCreep:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_earthshaker_enchant_totem_leap", kv )
			end
			local nFXIndex = ParticleManager:CreateParticle( "particles/items_fx/necronomicon_spawn_smoke.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin()  )
			EmitSoundOn( "Hero_Enigma.Demonic_Conversion", self:GetParent() )
		end	
	end
end

--------------------------------------------------------------------------------

function modifier_multiplying_eidelon_counter:GetModifierModelScale( params )
	return 30 * self:GetStackCount() 
end
--------------------------------------------------------------------------------