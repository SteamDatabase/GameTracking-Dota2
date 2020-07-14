modifier_boss_timbersaw_reactive_armor = class({})

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:constructor()
	self.max_stacks = 0
	self.armor_per_stack = 0
	self.magic_resist_per_stack = 0
	self.regen_per_stack = 0
	self.bEnraged = false
end

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:OnCreated( kv )
	self.max_stacks = self:GetAbility():GetSpecialValueFor( "max_stacks" )
	self.armor_per_stack = self:GetAbility():GetSpecialValueFor( "armor_per_stack" )
	self.magic_resist_per_stack = self:GetAbility():GetSpecialValueFor( "magic_resist_per_stack" )
	self.regen_per_stack = self:GetAbility():GetSpecialValueFor( "regen_per_stack" )
	self.status_resist =self:GetAbility():GetSpecialValueFor( "status_resist" )
	self.nPhysicalMode = 0
	self.bEnraged = false
	self.nModeFX = -1
	self.ParticleIndices = {}

	if IsServer() then
		CustomNetTables:SetTableValue( "boss_net_table", "boss_timbersaw", { physical = self.nPhysicalMode } )
		


		self:SwitchMode()
	else


		for i=1,4 do
			local szParticlename = string.format( "particles/creatures/boss_timbersaw/shredder_armor_lyr%d.vpcf", i )
			local nFXIndex = ParticleManager:CreateParticle( szParticlename, PATTACH_CUSTOMORIGIN, self:GetParent() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_armor", self:GetParent():GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 0, 0, 0 ) )
			ParticleManager:SetParticleControl( nFXIndex, 3, Vector( 0, 0, 0 ) )
			ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_chimmney", self:GetParent():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 5, Vector( 2.0, 0, 0 ) ) 
			self:AddParticle( nFXIndex, false, false, -1, false, false )

			table.insert( self.ParticleIndices, nFXIndex )
		end
	end
end

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:OnRefresh( kv )
	if IsServer() then
		local netTable = {}
		netTable[ "physical" ] = self.nPhysicalMode
		if self:GetParent().AI and self:GetParent().AI.bEnraged then
			netTable[ "enraged" ] = 1
		else
			netTable[ "enraged" ] = 0
		end
		CustomNetTables:SetTableValue( "boss_net_table", "boss_timbersaw", netTable )
	else
		local netTable = CustomNetTables:GetTableValue( "boss_net_table", "boss_timbersaw" )
		self.nPhysicalMode = netTable[ "physical" ]
		self.bEnraged = true
	end
end

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:CheckState()
	local state =
	{
		--[MODIFIER_STATE_HEXED] = false,
		--[MODIFIER_STATE_ROOTED] = false,
		--[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
	return state
end

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:OnTakeDamage( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hVictim = params.unit
		if hAttacker ~= nil and hVictim ~= nil and hVictim == self:GetParent() then
			if hVictim:FindModifierByName( "modifier_provide_vision" ) == nil then
				--printf( "Provide Vision" )
				hVictim:AddNewModifier( hAttacker, self:GetAbility(), "modifier_provide_vision", { duration = -1 } ) 
			end

			if params.original_damage > 50 then
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_shredder/shredder_reactive_hit.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_chimmney", self:GetParent():GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				self:IncrementStackCount()
				EmitSoundOn( "Hero_Shredder.ReactiveArmor", self:GetParent() )
				if self:GetStackCount() >= self.max_stacks then
					self:SwitchMode()
				end
			end
		end
	end
	return 0
end

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:OnStackCountChanged( nOldCount )
		

		local nNewCount = self:GetStackCount()
		
		local nStacksPerLayer = self.max_stacks / 4
		local nNumLayers = math.floor( nNewCount / nStacksPerLayer ) + 1

	if IsServer() then
		if self.bEnraged == true then
			return
		end


		if self:GetParent().AI and self:GetParent().AI.bEnraged == true and self.bEnraged == false then
			self.bEnraged = true	
			nNumLayers = 4
		end
	else

		for _,nFXIndex in pairs ( self.ParticleIndices ) do
			if nNumLayers > 0 then
				ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1, 0, 0 ) )
				nNumLayers = nNumLayers - 1
			else
				ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 0, 0, 0 ) )
			end
		end
	end
end

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:SwitchMode()
	if IsServer() then
		if self.nPhysicalMode == 1 then
			self.nPhysicalMode = 0
		else
			self.nPhysicalMode = 1
		end

		CustomNetTables:SetTableValue( "boss_net_table", "boss_timbersaw", { physical = self.nPhysicalMode } )
		self:SetStackCount( 0 )
		self:SendBuffRefreshToClients()
		--todo, toggle the visibility on the shield

		local nFXIndex = nil
		ParticleManager:DestroyParticle( self.nModeFX, false )
		self.nModeFX = -1
		if self.nPhysicalMode == 1 then
			EmitSoundOn( "Item.CrimsonGuard.Cast", self:GetParent() )
			nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/vanguard_active_launch.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 500, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			self.nModeFX = ParticleManager:CreateParticle( "particles/items2_fx/vanguard_active.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 500, 0, 0 ) )
		else
			EmitSoundOn( "DOTA_Item.Pipe.Activate", self:GetParent() )
			nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/pipe_of_insight_launch.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector(  500, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			self.nModeFX = ParticleManager:CreateParticle( "particles/items2_fx/pipe_of_insight.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 500, 0, 0 ) )
		end
	end
end

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:GetModifierConstantHealthRegen( params )
	return self:GetStackCount() * self.regen_per_stack
end

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:GetModifierPhysicalArmorBonus( params )
	if self.nPhysicalMode == 1 then
		return self:GetStackCount() * self.armor_per_stack
	end
	return 0
end

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:GetModifierMagicalResistanceBonus( params )
	if self.nPhysicalMode == 0 then
		return self:GetStackCount() * self.magic_resist_per_stack
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_boss_timbersaw_reactive_armor:GetModifierStatusResistanceStacking( params )
	if IsServer() then
		if self.bEnraged then
			return self.status_resist * 2
		end
	end
	return self.status_resist 
end

----------------------------------------

function modifier_boss_timbersaw_reactive_armor:GetModifierMoveSpeedBonus_Percentage( params )
	if self.bEnraged then
		return 50
	end

	return 0
end
