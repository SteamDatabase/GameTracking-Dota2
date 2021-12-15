require( "modifiers/modifier_blessing_base" )

modifier_blessing_damage_reflect = class( modifier_blessing_base )

----------------------------------------

function modifier_blessing_damage_reflect:OnBlessingCreated( kv )
	self.flDamageReflectPercentage = kv.damage_reflect
	--print ( "Reflecting Damage = " .. self.flDamageReflectPercentage  )
end

--------------------------------------------------------------------------------

function modifier_blessing_damage_reflect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end
--------------------------------------------------------------------------------
function modifier_blessing_damage_reflect:IsPermanent()
	return true
end
--------------------------------------------------------------------------------

function modifier_blessing_damage_reflect:OnTakeDamage( params )
	if IsServer() then
		-- Are we being attacked?
		local hUnit = params.unit
		if hUnit ~= self:GetParent() then
			return 0
		end

		-- Is the attacker something to reflect damage upon
		local hAttacker = params.attacker
		if hAttacker == nil or hAttacker:IsBuilding() then
			return 0
		end

		if hAttacker == self:GetParent() or hAttacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
			return 0
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end

		-- Get damage amount and calculate the relfected amount
		local flDamage = params.damage
		local flDamageReflect = flDamage * self.flDamageReflectPercentage

		-- Create reflect sound (BladeMail)
		--EmitSoundOn( "DOTA_Item.BladeMail.Damage", self:GetParent() )

		-- Send damage back
		local damageInfo = 
		{
			victim = hAttacker,
			attacker = self:GetParent(),
			damage = flDamageReflect,
			damage_type = params.damage_type,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			ability = nil,
		}
		ApplyDamage( damageInfo )
		--print( "Damage = " .. flDamage .. ", Reflecting Damage = " .. flDamageReflect )
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_blessing_damage_reflect:OnTooltip( params )
	local nDamageReflectPercentage = ( self.flDamageReflectPercentage * 100.0 )
	return nDamageReflectPercentage
end
