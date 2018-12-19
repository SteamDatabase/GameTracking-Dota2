
modifier_broodmother_web = class({})

-----------------------------------------------------------------------------

function modifier_broodmother_web:GetEffectName()
	return "particles/items2_fx/rod_of_atos.vpcf"
end

-----------------------------------------------------------------------------

function modifier_broodmother_web:OnCreated( kv )
	if IsServer() then
		EmitSoundOn( "Creature_Spectre.Dagger.VictimLoop", self:GetParent() )
	end
end

-----------------------------------------------------------------------------

function modifier_broodmother_web:OnDestroy()
	if IsServer() then
		StopSoundOn( "Creature_Spectre.Dagger.VictimLoop", self:GetParent() )
		EmitSoundOn( "Creature_Spectre.Dagger.VictimEnd", self:GetParent() )
	end
end

-----------------------------------------------------------------------------

function modifier_broodmother_web:CheckState()
	local state =
	{
		[ MODIFIER_STATE_ROOTED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------
