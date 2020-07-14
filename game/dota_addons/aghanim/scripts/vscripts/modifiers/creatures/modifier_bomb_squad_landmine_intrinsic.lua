modifier_bomb_squad_landmine_intrinsic = class({})

--------------------------------------------------------------------------------

function modifier_bomb_squad_landmine_intrinsic:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_bomb_squad_landmine_intrinsic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs

end

----------------------------------------------------------------------------------

function modifier_bomb_squad_landmine_intrinsic:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_bomb_squad_landmine_intrinsic:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_bomb_squad_landmine_intrinsic:CanParentBeAutoAttacked()
	return true
end

------------------------------------------------------------

function modifier_bomb_squad_landmine_intrinsic:GetAbsoluteNoDamageMagical( params )
	return 1
end

------------------------------------------------------------

function modifier_bomb_squad_landmine_intrinsic:GetAbsoluteNoDamagePure( params )
	return 1
end

------------------------------------------------------------

function modifier_bomb_squad_landmine_intrinsic:GetAbsoluteNoDamagePhysical( params )
	return 1
end

------------------------------------------------------------

function modifier_bomb_squad_landmine_intrinsic:GetModifierIncomingDamage_Percentage( params )
	return -100
end


------------------------------------------------------------

function modifier_bomb_squad_landmine_intrinsic:OnAttacked( params )
	if IsServer() then
		
		if params.target == self:GetParent() then

			self:GetParent():ForceKill( false )
		end
	end

	return 1
end

------------------------------------------------------------

function modifier_bomb_squad_landmine_intrinsic:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			local iChainReactionRadius = self:GetAbility():GetSpecialValueFor( "chain_radius" )
			local hFriendlyMines = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, iChainReactionRadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			if #hFriendlyMines > 0 then
				for _,entity in pairs (hFriendlyMines) do
					if entity ~= nil and entity:IsNull() == false and entity ~= self:GetParent() and entity:IsAlive() and entity:GetUnitName() == self:GetParent():GetUnitName() and not entity:FindModifierByName("modifier_bomb_squad_landmine_detonate")  then
						local hAbility = entity:FindAbilityByName("bomb_squad_landmine_detonate")
						if hAbility ~= nil then
							entity:AddNewModifier( entity, hAbility, "modifier_bomb_squad_landmine_detonate", { duration = hAbility:GetSpecialValueFor( "chain_duration" ) } )
						end
					end
				end
			end	

			self:GetParent():AddEffects( EF_NODRAW )
		end		

	end

	return 0
end


