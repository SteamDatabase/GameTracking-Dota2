function Spawn()
	Timers:CreateTimer(0.03,
      function()
        local ability = thisEntity:FindAbilityByName("pudge_rot_lua")
		ability:ToggleAbility()
      end)	
end
