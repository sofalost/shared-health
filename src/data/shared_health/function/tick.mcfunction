# ============================================================
# shared_health — tick
# MC 26.2 / pack_format 107.1
#
# Principe : tous les joueurs partagent la meme barre de vie.
# Quand un joueur prend des degats, tous les autres aussi.
#
# Methode : damage-only. On lit Health chaque tick, on prend la
# valeur la plus basse parmi les joueurs qui ont bouge, et on
# inflige la difference aux autres via /damage (macro).
#
# NB : `store result entity @s Health` ne marche PAS sur les
# joueurs (NBT joueur en lecture seule). D'ou /damage.
#
# Le soin n'est pas propage (pas de moyen precis de soigner).
# Mort/respawn non propages (filtre hp_cur ET hp_prev > 0).
# ============================================================

# 0. Perimetre : survival/adventure uniquement
tag @a remove hp_sync
tag @a[gamemode=!creative,gamemode=!spectator] add hp_sync

# Creative/spectator : re-amorcage force au retour en survie
execute as @a[tag=!hp_sync] run scoreboard players set @s hp_init 0

# 1. Lire la sante courante (HP entiers, pas de dixiemes)
execute as @a[tag=hp_sync] store result score @s hp_cur run data get entity @s Health 1

# 2. Amorcage : nouveau joueur -> hp_prev = hp_cur (pas de faux delta)
execute as @a[tag=hp_sync] unless score @s hp_init matches 1 run scoreboard players operation @s hp_prev = @s hp_cur
execute as @a[tag=hp_sync] unless score @s hp_init matches 1 run scoreboard players set @s hp_init 1

# 3. Delta = changement ce tick
execute as @a[tag=hp_sync] run scoreboard players operation @s hp_delta = @s hp_cur
execute as @a[tag=hp_sync] run scoreboard players operation @s hp_delta -= @s hp_prev

# 4. Marquer les joueurs dont la vie a change
#    Filtre : hp_cur ET hp_prev > 0 (ignore mort/respawn)
tag @a remove hp_changed
execute as @a[tag=hp_sync] unless score @s hp_delta matches 0 if score @s hp_cur matches 1.. if score @s hp_prev matches 1.. run tag @s add hp_changed

# 5. Cible = sante la plus basse parmi les joueurs modifies
scoreboard players set #target_hp timer 99999
execute as @a[tag=hp_changed] if score @s hp_cur < #target_hp timer run scoreboard players operation #target_hp timer = @s hp_cur

# 6. Sync : chaque joueur au-dessus de la cible encaisse la difference
execute if score #target_hp timer matches ..99998 as @a[tag=hp_sync] run function shared_health:sync

# 7. Pas de sync ce tick -> memoriser tel quel
#    (le cas sync est traite dans sync.mcfunction, par joueur)
execute if score #target_hp timer matches 99999 as @a[tag=hp_sync] run scoreboard players operation @s hp_prev = @s hp_cur
