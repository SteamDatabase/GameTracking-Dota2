if modifier_purge == nil then
	modifier_purge = class({})
end

--------------------------------------------------------------------------------

function modifier_purge:OnCreated( kv )
    self:GetParent():Purge(
        kv.positive_buffs == 1,
        kv.negative_buffs == 1,
        kv.frame_only == 1,
        kv.remove_stuns == 1,
        kv.remove_exceptions == 1
    )
end