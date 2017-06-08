modifier_building_remove_invuln = class({})

--------------------------------------------------------------------------------

function modifier_building_remove_invuln:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_building_remove_invuln:OnCreated( kv )
	if IsServer() then
		self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_no_healthbar", { duration = -1 } )
		self:StartIntervalThink( 1 )
	end
end

--------------------------------------------------------------------------------

function modifier_building_remove_invuln:OnIntervalThink()
	if IsServer() then
		if self:GetParent():HasModifier( "modifier_invulnerable" ) then
		--	print( "found modifier_invulnerable, remove it" )
			self:GetParent():RemoveModifierByName( "modifier_invulnerable" )
			return -1
		end
	end
end

--------------------------------------------------------------------------------
