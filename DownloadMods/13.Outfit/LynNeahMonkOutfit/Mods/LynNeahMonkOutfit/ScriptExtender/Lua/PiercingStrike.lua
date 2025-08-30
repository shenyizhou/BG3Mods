-- 调试开关
Debug = false

-- 徒手攻击穿刺伤害转换
local function SetPiercingDamageType(entity, event)
    event.Functor.DamageType = "Piercing"

    if Debug then
        local entityUuid = entity.Uuid.EntityUuid
        Ext.Utils.PrintWarning("Converting unarmed damage to Piercing for entity: ", entityUuid)
    end
end

-- 监听伤害事件
Ext.Events.DealDamage:Subscribe(function(e)
    local caster = e.Caster
    local weaponType = e.Functor.WeaponType
    local hasPiercingStrike = false
    local hasDraconicDisciple = false
    local hasAstralArms = false

    if caster ~= nil and caster.Stats ~= nil then
        local casterUuid = caster.Uuid.EntityUuid
		hasPiercingStrike = caster.ServerCharacter ~= nil and Osi.HasActiveStatus(casterUuid, "PIERCING_STRIKE_ACTIVE") == 1
        hasDraconicDisciple = caster.ServerCharacter ~= nil and Osi.HasPassive(casterUuid, "DraconicStrike_AD") == 1 and (Osi.HasActiveStatus(casterUuid, "DRACONIC_STRIKE_ACID") == 1 or Osi.HasActiveStatus(casterUuid, "DRACONIC_STRIKE_COLD") == 1
			or Osi.HasActiveStatus(casterUuid, "DRACONIC_STRIKE_FIRE") == 1 or Osi.HasActiveStatus(casterUuid, "DRACONIC_STRIKE_LIGHTNING") == 1 or Osi.HasActiveStatus(casterUuid, "DRACONIC_STRIKE_POISON") == 1)
		hasAstralArms = caster.ServerCharacter ~= nil and Osi.HasPassive(casterUuid, "AstralSelfArmsUnlock") == 1 and Osi.HasActiveStatus(casterUuid, "USING_ASTRAL_ARMS") == 1

        if Debug then
            print('OriginalWeaponType: ', e.Functor.WeaponType)
            print('OriginalDamageType: ', e.Functor.DamageType)
            print('HasPiercingStrike: ', hasPiercingStrike)
        end
    end

    if e.Hit.ConditionRolls[1] ~= nil then
        if not hasDraconicDisciple and not hasAstralArms and not hasPiercingStrike and weaponType == "UnarmedDamage" and e.Hit.ConditionRolls[1].Roll.Roll.RollType == "MeleeUnarmedAttack" then
			e.Functor.DamageType = e.SpellId.SpellProto.DamageType or "Bludgeoning"
		end
        -- 处理穿刺打击的情况
        if hasPiercingStrike and weaponType == "UnarmedDamage" and
           e.Hit.ConditionRolls[1].Roll.Roll.RollType == "MeleeUnarmedAttack" then
            SetPiercingDamageType(caster, e)
        end
    end
end)