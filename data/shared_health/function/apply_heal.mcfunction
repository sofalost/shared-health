# shared_health — apply_heal (macro)
# amp = niveau d'Instant Health (instant_health heal = 4*(amp+1) HP)
# Imprécision ±3 HP, corrigée au prochain event de dégâts
$effect give @s minecraft:instant_health 1 $(amp) true
