modifier_imprisoned_soldier = class({})

--------------------------------------------------------------------------------

function modifier_imprisoned_soldier:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_imprisoned_soldier:OnCreated( kv )
	if IsServer() then
		self.bRescued = false
		self.bTeleporting = false

		if self:GetParent():GetUnitName() == "npc_dota_creature_friendly_ogre_tank" then
			self.nFXIndex = ParticleManager:CreateParticle("particles/test_particle/dungeon_debuff_webs.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		end

		if self:GetParent():GetUnitName() ~= "npc_dota_radiant_captain" and self:GetParent():GetUnitName() ~= "npc_dota_creature_friendly_ogre_tank" then
			self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_imprisoned_soldier_animation", {} )
		else
			self:StartIntervalThink( 1.0 )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_imprisoned_soldier:OnIntervalThink()
	if IsServer() then
		self:GetParent():RemoveModifierByName( "modifier_npc_dialog" )

		local flSearchRadius = 150
		if self:GetParent():GetUnitName() ~= "npc_dota_radiant_captain" and self:GetParent():GetUnitName() ~= "npc_dota_creature_friendly_ogre_tank" then
			flSearchRadius = FIND_UNITS_EVERYWHERE			
		end
		if not self.bRescued then
			local friendlyHeroes = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetParent(), flSearchRadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _, friendlyHero in pairs( friendlyHeroes ) do
				if friendlyHero ~= nil and friendlyHero:IsOwnedByAnyPlayer() then
					--BroadcastMessage( "Rescued Soldier", 1.5 )

					GameRules.Dungeon:OnDialogBegin( friendlyHero, self:GetParent() )
					self:GetParent():RemoveModifierByName( "modifier_imprisoned_soldier_animation" )
					self.bRescued = true
					self:StartIntervalThink( 2 )
					if self:GetParent():GetUnitName() == "npc_dota_creature_friendly_ogre_tank" then
						ParticleManager:DestroyParticle( self.nFXIndex, false )
					end
					return
				end
			end
		else
			self:TeleportOut()
			self:StartIntervalThink( -1 )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_imprisoned_soldier:TeleportOut()
	--print( "try teleport out" )
	local teleports = Entities:FindAllByName( "desert_outpost_teleport" )
	local teleport = teleports[RandomInt( 1, #teleports )]
	if self:GetParent():GetUnitName() == "npc_dota_radiant_captain" then
		teleport = Entities:FindByNameNearest( "desert_outpost_teleport_captain", self:GetParent():GetOrigin(), 99999 )
	end
	if self:GetParent():GetUnitName() == "npc_dota_creature_friendly_ogre_tank" then
		teleport = Entities:FindByNameNearest( "desert_outpost_teleport_ogre", self:GetParent():GetOrigin(), 99999 )
	end
	if teleport ~= nil then
	--	print( "found a tower" )
		for i = 0, DOTA_ITEM_MAX - 1 do
			local item = self:GetParent():GetItemInSlot( i )
			if item then
				if item:GetAbilityName() == "item_tpscroll" then
					--print( "Execute order" )
					ExecuteOrderFromTable({
						UnitIndex = self:GetParent():entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = item:entindex(),
						Position = teleport:GetOrigin(),
					})
					self.bTeleporting = true
					return
				end
			else
				FindClearSpaceForUnit( self:GetParent(), teleport:GetOrigin(), true )
				self:GetParent():ForceKill( false )
			end
		end
	else
		--print( "didn't find a tower" )
	end
end

--------------------------------------------------------------------------------

function modifier_imprisoned_soldier:OnTeleported( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:GetParent():RemoveAbility( self:GetAbility():GetAbilityName() )
			self:GetParent():Interrupt()
			self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_npc_dialog", { duration = -1 } )
			self:Destroy()

			local hAnimationBuff = self:GetParent():FindModifierByName( "modifier_stack_count_animation_controller" )
			if hAnimationBuff ~= nil and self:GetParent():GetUnitName() ~= "npc_dota_radiant_captain" and self:GetParent():GetUnitName() ~= "npc_dota_creature_friendly_ogre_tank" then
				local nRandomAnim = RandomInt( 0, 3 )
				if nRandomAnim == 0 then
					hAnimationBuff:SetStackCount( ACT_DOTA_IDLE_SLEEPING )
					self:GetParent():RemoveModifierByName( "modifier_npc_dialog" )
				end
				if nRandomAnim == 1 then
					hAnimationBuff:SetStackCount( ACT_DOTA_LOOK_AROUND )
				end
				if nRandomAnim == 2 then
					hAnimationBuff:SetStackCount( ACT_DOTA_SHARPEN_WEAPON )
				end
			end
		end	
	end
end


--------------------------------------------------------------------------------

function modifier_imprisoned_soldier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
		MODIFIER_EVENT_ON_TELEPORTED,
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_imprisoned_soldier:GetFixedDayVision( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_imprisoned_soldier:GetFixedNightVision( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_imprisoned_soldier:GetModifierDisableTurning( params )
	if IsServer() then
		if self.bTeleporting == true or self:GetParent():GetUnitName() == "npc_dota_radiant_captain" then
			return 0
		end
		return 1
	end
	return 1
end

--------------------------------------------------------------------------------

function modifier_imprisoned_soldier:CheckState()
	local state = {}
	if IsServer() then
		state[MODIFIER_STATE_INVULNERABLE] = true
		state[MODIFIER_STATE_ATTACK_IMMUNE] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_UNSELECTABLE] = self:GetParent():GetUnitName() ~= "npc_dota_radiant_captain" and self:GetParent():GetUnitName() ~= "npc_dota_creature_friendly_ogre_tank" and self:GetParent():GetUnitName() ~= "npc_dota_creature_friendly_ogre_tank_webtrapped"
		state[MODIFIER_STATE_BLIND] = true
		state[MODIFIER_STATE_SILENCED] = true
		state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
		state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
		state[MODIFIER_STATE_ROOTED] = ( self.bTeleporting == false )
	end
	
	return state
end

