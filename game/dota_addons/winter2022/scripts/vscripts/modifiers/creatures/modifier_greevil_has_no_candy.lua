if modifier_greevil_has_no_candy == nil then
    modifier_greevil_has_no_candy = class({})
end
    
------------------------------------------------------------------------------

function modifier_greevil_has_no_candy:IsHidden() 
    return true
end

--------------------------------------------------------------------------------

function modifier_greevil_has_no_candy:IsPurgable()
    return false
end
    
    