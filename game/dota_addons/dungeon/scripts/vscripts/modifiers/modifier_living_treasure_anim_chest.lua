
modifier_living_treasure_anim_chest = class({})

--------------------------------------------------------------------------------

function modifier_living_treasure_anim_chest:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_living_treasure_anim_chest:OnCreated( kv )
	if IsServer() then
		--self:GetParent():SetSequence( "beetlejaws_ground_spawn" )
		--self:GetParent():StartGesture( ACT_DOTA_SPAWN )

		-- Start thinking in 83 / 8 / 30 seconds to get the correct time of the anim ( 0.345833 )
		--self:StartIntervalThink( 0.345833 )
		self:StartIntervalThink( 0.1 )
	end
end

--------------------------------------------------------------------------------

function modifier_living_treasure_anim_chest:OnIntervalThink()
	if IsServer() then
		--self:GetParent():SetSequence( "beetlejaws_ground_spawn" )
		self:GetParent():StartGesture( ACT_DOTA_SPAWN )

		--print( "OnIntervalThink() - StopAnimation" )
		self:GetParent():StopAnimation()

		--self:StartIntervalThink( -1 )

		return 0.1
	end
end

--------------------------------------------------------------------------------

