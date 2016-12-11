lm_spawn_enemy_at_target = class({})

function lm_spawn_enemy_at_target:DeclareFunctions()
	local funcs = {
		func1 = MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		func2 = MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		func3 = MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function lm_spawn_enemy_at_target:OnCreated( kv )
	Msg( string.format( "Self: %s\n{\n", self ) )
	for k,v in pairs( self ) do
		Msg( string.format( "%s=>%s\n", k, v ) )
	end
	Msg( "}\n" )
	Msg( string.format( "Params: %s\n{\n", kv ) )
	for k,v in pairs( kv ) do 
		Msg( string.format( "%s=>%s\n", k, v ) )
	end
	Msg( "}\n" )

	self:SetStackCount( 10 )
	self:StartIntervalThink( 1.0 )
end

function lm_spawn_enemy_at_target:OnDestroy()
	if IsServer() then

		local damage = {
							victim = self:GetCaster(),
							attacker = self:GetCaster(),
							damage = 100,
							damage_type = DAMAGE_TYPE_MAGICAL,
						}

		ApplyDamage( damage )
	end
end

function lm_spawn_enemy_at_target:OnIntervalThink()
	self:IncrementStackCount()
end

function lm_spawn_enemy_at_target:GetModifierPreAttack_BonusDamage( params )
	Msg( string.format( "Self: %s\n{\n", self ) )
	for k,v in pairs( self ) do
		Msg( string.format( "%s=>%s\n", k, v ) )
	end
	Msg( "}\n" )
	Msg( string.format( "Params: %s\n{\n", params ) )
	for k,v in pairs( params ) do 
		Msg( string.format( "%s=>%s\n", k, v ) )
	end
	Msg( "}\n" )
	return 100
end