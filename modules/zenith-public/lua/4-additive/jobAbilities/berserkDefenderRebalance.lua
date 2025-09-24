-----------------------------------
-- Berserk and Defender Job Ability Rebalance
-- Custom modifications for ZenithXI
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('beserkDefenderRebalance')

-- Berserk Job Ability Changes
-- Static 25% increase in Attack and Ranged Attack
-- Static 25% decrease in Defense
m:addOverride('xi.job_utils.warrior.useBerserk', function(player, target, ability)
    -- Static 25 power for all percentage modifiers
    player:addStatusEffect(xi.effect.BERSERK, 25, 0, 180 + player:getMod(xi.mod.BERSERK_DURATION))
end)

-- Defender Job Ability Changes
-- Static 25% increase in Defense
-- Static 25% decrease in Attack and Ranged Attack
m:addOverride('xi.job_utils.warrior.useDefender', function(player, target, ability)
    -- Using power of 1 to signal the effect is active
    -- The actual modifiers will be handled in the effect functions
    player:addStatusEffect(xi.effect.DEFENDER, 1, 0, 180 + player:getMod(xi.mod.DEFENDER_DURATION))
end)

-- Override the Berserk status effect to apply static modifiers
m:addOverride('xi.effects.berserk.onEffectGain', function(target, effect)
    local jpLevel = target:getJobPointLevel(xi.jp.BERSERK_EFFECT)
    local jpEffect = jpLevel * 2

    -- Apply static 25% modifiers
    target:addMod(xi.mod.ATTP, 25)
    target:addMod(xi.mod.RATTP, 25)
    target:addMod(xi.mod.DEFP, -25)

    -- Job Point Bonuses (keep existing functionality)
    target:addMod(xi.mod.ATT, jpEffect)
    target:addMod(xi.mod.RATT, jpEffect)
end)

m:addOverride('xi.effects.berserk.onEffectLose', function(target, effect)
    local jpLevel = target:getJobPointLevel(xi.jp.BERSERK_EFFECT)
    local jpEffect = jpLevel * 2

    -- Remove static 25% modifiers
    target:delMod(xi.mod.ATTP, 25)
    target:delMod(xi.mod.RATTP, 25)
    target:delMod(xi.mod.DEFP, -25)

    -- Remove Job Point Bonuses
    target:delMod(xi.mod.ATT, jpEffect)
    target:delMod(xi.mod.RATT, jpEffect)
end)

-- Override the Defender status effect to apply static modifiers
m:addOverride('xi.effects.defender.onEffectGain', function(target, effect)
    local jpLevel = target:getJobPointLevel(xi.jp.DEFENDER_EFFECT)

    -- Apply static 25% modifiers
    target:addMod(xi.mod.DEFP, 25)
    target:addMod(xi.mod.RATTP, -25)
    target:addMod(xi.mod.ATTP, -25)

    -- JP Bonus (keep existing functionality)
    target:addMod(xi.mod.DEF, jpLevel * 3)
end)

m:addOverride('xi.effects.defender.onEffectLose', function(target, effect)
    local jpLevel = target:getJobPointLevel(xi.jp.DEFENDER_EFFECT)

    -- Remove static 25% modifiers
    target:delMod(xi.mod.DEFP, 25)
    target:delMod(xi.mod.ATTP, -25)
    target:delMod(xi.mod.RATTP, -25)

    -- Remove JP Bonus
    target:delMod(xi.mod.DEF, jpLevel * 3)
end)

return m
