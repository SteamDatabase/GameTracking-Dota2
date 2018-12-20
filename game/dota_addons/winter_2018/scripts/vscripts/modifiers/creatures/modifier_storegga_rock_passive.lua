
modifier_storegga_rock_passive = class({})

--------------------------------------------------------------------------------

function modifier_storegga_rock_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_rock_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_rock_passive:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 0.2 )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_rock_passive:OnIntervalThink()
	if self:GetCaster() == nil or self:GetCaster():IsNull() or self:GetCaster():IsAlive() == false then
		--print( "modifier_storegga_rock_passive - ForceKill rock" )

		self:GetParent():ForceKill( false )
		self:GetParent():AddEffects( EF_NODRAW )
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_rock_passive:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[ MODIFIER_STATE_ROOTED ] = true,
			[ MODIFIER_STATE_ATTACK_IMMUNE ] = true,
		}
	end
	
	return state
end

--------------------------------------------------------------------------------