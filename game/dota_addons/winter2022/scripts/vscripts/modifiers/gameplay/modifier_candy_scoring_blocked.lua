if modifier_candy_scoring_blocked == nil then
	modifier_candy_scoring_blocked = class({})
end

------------------------------------------------------------------------------

function modifier_candy_scoring_blocked:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_candy_scoring_blocked:GetTexture()
	return "candy_scoring_blocked"
end

--------------------------------------------------------------------------------

function modifier_candy_scoring_blocked:IsPurgable()
	return false
end

