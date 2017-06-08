modifier_invoker_juggle = class({})

--------------------------------------------------------------------------------

function modifier_invoker_juggle:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_invoker_juggle:OnCreated( kv )
	if IsServer() then
		local Quas = self:GetCaster():FindAbilityByName( "invoker_quas" )
		if Quas then
			self:GetCaster():CastAbilityImmediately( Quas, self:GetCaster():GetPlayerOwnerID() )
		end
		local Wex = self:GetCaster():FindAbilityByName( "invoker_wex" )
		if Wex then
			self:GetCaster():CastAbilityImmediately( Wex, self:GetCaster():GetPlayerOwnerID() )
		end
		local Exort = self:GetCaster():FindAbilityByName( "invoker_exort" )
		if Exort then
			self:GetCaster():CastAbilityImmediately( Exort, self:GetCaster():GetPlayerOwnerID() )
		end
		--self:GetCaster():StartGesture( ACT_DOTA_TAUNT )
		--self:StartIntervalThink( 6.0 )
	end
end

--------------------------------------------------------------------

function modifier_invoker_juggle:OnIntervalThink()
	if IsServer() then
		--self:GetCaster():StartGesture( ACT_DOTA_TAUNT )
	end
end

--------------------------------------------------------------------

function modifier_invoker_juggle:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return funcs
end

-------------------------------------------------------------------------------


function modifier_invoker_juggle:GetActivityTranslationModifiers( params )
	return "juggle_gesture"
end



