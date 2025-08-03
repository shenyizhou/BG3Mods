
SRD_NullUUID_Short = "00000000-0000-0000-0000-000000000000"
SRD_NullUUID_Long = "NULL_00000000-0000-0000-0000-000000000000"

function SRD_ShortUUID(uuid)
	return (uuid and string.sub(uuid, -36)) or SRD_NullUUID_Short
end

function SRD_IsNullUUID(uuid)
	return (uuid == nil) or uuid:find('00000000[-]0000[-]0000[-]0000[-]000000000000$')
end

function SRD_HasStatusFrom(target, status, statusCause)
	local entity = Ext.Entity.Get(target)
	local causeGuid = string.sub(statusCause, -36)
	local result = false

	if entity ~= nil then
		local obj = entity.ServerCharacter ~= nil or entity.ServerItem ~= nil and entity.ServerItem.Item
		if obj ~= nil then
			for _, statusObj in pairs (obj.StatusManager.Statuses) do
				if statusObj.StatusId == status and statusObj.CauseGUID == causeGuid then
					 result = true
				end
			end
		end
	end
	
	return result
end

function SRD_DelayedCall(msDelay, func)
    local startTime = Ext.Utils.MonotonicTime()
    local handlerId;
    handlerId = Ext.Events.Tick:Subscribe(function()
        if (Ext.Utils.MonotonicTime() - startTime > msDelay) then
            Ext.Events.Tick:Unsubscribe(handlerId)
            func()
        end
    end) 
end
