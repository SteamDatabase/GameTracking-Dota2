
function TableContains( table, element )
	for _, v in pairs( table ) do
		if v == element then
			return true
		end
	end

	return false
end

