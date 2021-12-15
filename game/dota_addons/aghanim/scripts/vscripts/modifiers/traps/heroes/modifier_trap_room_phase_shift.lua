
modifier_trap_room_phase_shift = class({})

--------------------------------------------------------------------------------

function modifier_trap_room_phase_shift:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_trap_room_phase_shift:GetEffectName()
	return "particles/units/heroes/hero_puck/puck_phase_shift.vpcf"
end

--------------------------------------------------------------------------------

function modifier_trap_room_phase_shift:GetStatusEffectName()
	return "particles/status_fx/status_effect_phase_shift.vpcf";
end

--------------------------------------------------------------------------------

function modifier_trap_room_phase_shift:OnCreated( kv )
	if IsServer() then
		self:GetParent():AddEffects( EF_NODRAW )

		self:GetParent():Purge( false, true, false, false, false )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_puck/puck_phase_shift.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_CUSTOMORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false )

		local nStatusFX = ParticleManager:CreateParticle( "particles/status_fx/status_effect_phase_shift.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nStatusFX, 0, self:GetParent(), PATTACH_CUSTOMORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
		self:AddParticle( nStatusFX, false, true, 75, false, false )

		--[[ REFERENCE
		ParticleIndex_t nFXIndex = GetParticleManager()->CreateParticleIndex( "particles/units/heroes/hero_puck/puck_phase_shift.vpcf", PATTACH_CUSTOMORIGIN, nullptr, nullptr, GetCaster() );
		GetParticleManager()->SetParticleControlEnt( nFXIndex, 0, GetParent(), PATTACH_CUSTOMORIGIN_FOLLOW, nullptr );
		AddParticle( nFXIndex, false, false, -1 );
		
		nFXIndex = GetParticleManager()->CreateParticleIndex( "particles/status_fx/status_effect_phase_shift.vpcf", PATTACH_CUSTOMORIGIN, nullptr, nullptr, GetCaster() );
		GetParticleManager()->SetParticleControlEnt( nFXIndex, 0, GetParent(), PATTACH_CUSTOMORIGIN_FOLLOW, nullptr );
		AddParticle( nFXIndex, false, true, 75 );
		]]

		EmitSoundOn( "TrapRoomPhaseShift.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function modifier_trap_room_phase_shift:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveEffects( EF_NODRAW )
	end
end

--------------------------------------------------------------------------------

function modifier_trap_room_phase_shift:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ORDER,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_trap_room_phase_shift:GetModifierInvisibilityLevel()
	return 1.0
end

--------------------------------------------------------------------------------

function modifier_trap_room_phase_shift:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit
		if hOrderedUnit ~= self:GetParent() then
			return 0
		end

		-- These commands don't interrupt Phase Shift
		local nOrderType = params.order_type
		if nOrderType == DOTA_UNIT_ORDER_TRAIN_ABILITY or
				nOrderType == DOTA_UNIT_ORDER_PING_ABILITY or
				nOrderType == DOTA_UNIT_ORDER_PURCHASE_ITEM or
				nOrderType == DOTA_UNIT_ORDER_SELL_ITEM or
				nOrderType == DOTA_UNIT_ORDER_DISASSEMBLE_ITEM or
				nOrderType == DOTA_UNIT_ORDER_MOVE_ITEM or
				nOrderType == DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH or
				nOrderType == DOTA_UNIT_ORDER_GLYPH then

			return 0
		else
			self:Destroy()
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_trap_room_phase_shift:CheckState()
	local state =
	{
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_ATTACK_IMMUNE ] = true,
		[ MODIFIER_STATE_UNSELECTABLE ] = true,
		[ MODIFIER_STATE_OUT_OF_GAME ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
	}

	return state
end

--------------------------------------------------------------------------------
