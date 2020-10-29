if modifier_candy_eaten_recently == nil then
modifier_candy_eaten_recently = class({})
end

------------------------------------------------------------------------------

function modifier_candy_eaten_recently:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_candy_eaten_recently:GetTexture()
	return "candy_eaten_recently"
end

--------------------------------------------------------------------------------

function modifier_candy_eaten_recently:IsPurgable()
	return false
end

