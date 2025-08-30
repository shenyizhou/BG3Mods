-- 徒手攻击穿刺伤害转换
local function SetPiercingDamageType(entity, event)
    local entityUuid = entity.Uuid.EntityUuid
    if Osi.HasActiveStatus(entityUuid, "PIERCING_STRIKE_ACTIVE") == 1 then
        event.Functor.DamageType = "Piercing"
    end
end

-- 监听伤害事件
Ext.Events.DealDamage:Subscribe(function(e)
    local caster = e.Caster
    local weaponType = e.Functor.WeaponType
    local hasPiercingStrike = false
    
    if caster ~= nil and caster.Stats ~= nil then 
        local casterUuid = caster.Uuid.EntityUuid
        hasPiercingStrike = caster.ServerCharacter ~= nil and 
            Osi.HasPassive(casterUuid, "PiercingStrike_Gloves") == 1 and 
            Osi.HasActiveStatus(casterUuid, "PIERCING_STRIKE_ACTIVE") == 1
    end

    if e.Hit.ConditionRolls[1] ~= nil then 
        if hasPiercingStrike and weaponType == "UnarmedDamage" and 
           e.Hit.ConditionRolls[1].Roll.Roll.RollType == "MeleeUnarmedAttack" then 
            SetPiercingDamageType(caster, e)
        end
    end
end)