-- 调试开关
Debug = false

-- 徒手攻击穿刺伤害转换
local function SetPiercingDamageType(entity, event)
    local entityUuid = entity.Uuid.EntityUuid
    if Osi.HasActiveStatus(entityUuid, "PIERCING_STRIKE_ACTIVE") == 1 then
        event.Functor.DamageType = "Piercing"

        if (Debug) then
            Ext.Utils.PrintWarning("Converting unarmed damage to Piercing for entity: ", entityUuid)
        end
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
            Osi.HasActiveStatus(casterUuid, "PIERCING_STRIKE_ACTIVE") == 1

        if (Debug) then
            print('OriginalWeaponType: ', e.Functor.WeaponType)
            print('OriginalDamageType: ', e.Functor.DamageType)
            print('HasPiercingStrike: ', hasPiercingStrike)
        end
    end

    if e.Hit.ConditionRolls[1] ~= nil then
        -- 重要：先处理非穿刺打击的情况，重置为默认伤害类型
        if not hasPiercingStrike and weaponType == "UnarmedDamage" and
           e.Hit.ConditionRolls[1].Roll.Roll.RollType == "MeleeUnarmedAttack" then
            -- 重置为法术的默认伤害类型或钝击伤害
            e.Functor.DamageType = e.SpellId.SpellProto.DamageType or "Bludgeoning"

            if (Debug) then
                print('Reset to default damage type: ', e.Functor.DamageType)
            end
        end

        -- 然后处理穿刺打击的情况
        if hasPiercingStrike and weaponType == "UnarmedDamage" and
           e.Hit.ConditionRolls[1].Roll.Roll.RollType == "MeleeUnarmedAttack" then
            SetPiercingDamageType(caster, e)
        end
    end
end)