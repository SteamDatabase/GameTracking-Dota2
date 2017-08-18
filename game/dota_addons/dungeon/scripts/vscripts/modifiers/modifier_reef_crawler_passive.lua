modifier_reef_crawler_passive = class({})

------------------------------------------------------------

function modifier_reef_crawler_passive:IsHidden()
	return true
end

------------------------------------------------------------

function modifier_reef_crawler_passive:IsPurgable()
	return false
end

------------------------------------------------------------

function modifier_reef_crawler_passive:OnCreated( kv )
	if IsServer() then
		self:GetParent():SetRenderColor( 255, 0, 0 )
	end
end

------------------------------------------------------------

function modifier_reef_crawler_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return funcs
end

------------------------------------------------------------

function modifier_reef_crawler_passive:GetActivityTranslationModifiers( params )
	return "shadow_dance"
end