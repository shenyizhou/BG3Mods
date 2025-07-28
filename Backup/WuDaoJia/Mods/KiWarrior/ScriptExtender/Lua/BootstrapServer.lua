Ext.Entity.Subscribe("ActionResources", function (entity, _, _)
  if Osi.IsPlayer(entity.Uuid.EntityUuid) then  
    for b, resource in pairs(entity.ActionResources.Resources["887eaac7-5d85-4321-8417-cae8189e5c8e"]) do
      if resource.ResourceId == 0 then
        -- do stuff to Resource.Amount here
        local value = resource.Amount
        resource.Amount = math.max(0,math.floor(value))
      end
    end
  end
end)