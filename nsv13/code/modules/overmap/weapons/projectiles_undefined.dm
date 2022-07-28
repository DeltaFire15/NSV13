
//A bunch of nonstandard projectiles and weapons that I felt wouldn't really fit into the basic projectiles_fx file.

/obj/item/projectile/bullet/mac/hvrc
    name = "railcannon round"
    flag = "overmap_heavy"
    //icon_state = TEMP - U-WIP
    damage = 400
    speed = 0.4
    obj_integrity = 200
    max_integrity = 200
    projectile_piercing = ALL
    relay_projectile_type = /obj/item/projectile/bullet/mac_relayed_round/hvrc

/obj/item/projectile/bullet/mac_relayed_round/hvrc
    name = "railcannon round"
    //icon_state = TEMP - U-WIP
    damage = 80
    speed = 0.4
    dismemberment = 80 //I hope you didn't need all your limbs.

/obj/item/projectile/bullet/mac_relayed_round/hvrc/on_hit(atom/target, blocked, pierce_hit)
    . = ..()
    if(!isliving(target) || !. || . == BULLET_ACT_BLOCK)
        return
    var/mob/living/mob_target = target
    if(!mob_target.client)
        return
    to_chat(mob_target, "<span class='boldwarning'>[src] tears through you!</span>", MESSAGE_TYPE_WARNING)

/obj/item/projectile/guided_munition/torpedo/critbuster
    name = "hullbuster torpedo"
    //icon_state = TEMP - U-WIP
    damage = 50
    speed = 2.5
    homing_turn_speed = 20

/obj/item/projectile/guided_munition/torpedo/critbuster/spec_overmap_hit(obj/structure/overmap/target)
    if(target.structure_crit)
        damage *= 10
        relay_projectile_type = /obj/item/projectile/bullet/critbuster_relayed //Stronger z level hit and massive damage if the ship is in hullcrit.

/obj/item/projectile/bullet/critbuster_relayed
    name = "hullbuster torpedo"
    icon = 'nsv13/icons/obj/projectiles_nsv.dmi'
    icon_state = "torpedo" //icon_state = TEMP - U-WIP
    damage = 50
    range = 255

/obj/item/projectile/bullet/critbuster_relayed/on_hit(atom/target, blocked, pierce_hit)
    . = ..()
    explosion(target, 4, 0, 7, 7, flame_range = 6)
    var/base_angle_offset = -45
    var/turf/boom_turf = get_turf(target)
    for(var/counter = 1; counter <= 4, counter++)
        var/modified_angle = base_angle_offset + rand(-14, 14)
        base_angle_offset += 30
        var/turf/beam_at = get_turf_in_angle(Angle + modified_angle, boom_turf, 12)
        if(!beam_at)
            continue
        var/list/turfs_to_fry = getline(boom_turf, beam_at)
        for(var/turf/burn_turf as anything in turfs_to_fry)
            if(locate(/obj/effect/temp_visual/hullburn) in burn_turf)
                continue
            new /obj/effect/temp_visual/hullburn(burn_turf)

/obj/effect/temp_visual/hullburn
    duration = 6 SECONDS
    name = "chemical fire"
    desc = "You feel like you really shouldn't be near this."
    icon = 'icons/effects/fire.dmi'
    icon_state = "2" //thank you fire dmi.
    opacity = TRUE
    layer = FLY_LAYER
    color = COLOR_PURPLE
    light_color = LIGHT_COLOR_PURPLE
    light_range = LIGHT_RANGE_FIRE
    ///How much of an effect does this have on the affected tile the moment the burn finishes?
    var/burn_power = EXPLODE_DEVASTATE
    ///Does this obliterate a window on the same tile once the burn ends?
    var/window_b_gone = FALSE
    //U-WIP debug: SDQL2-query "CALL fire() ON /obj/item/projectile/bullet/critbuster_relayed

/obj/effect/temp_visual/hullburn/Destroy()
    var/turf/shred_turf = get_turf(src)
    if(shred_turf)
        if(isclosedturf(shred_turf))
            shred_turf.ScrapeAway()
        if(window_b_gone)
            var/obj/structure/window/maybe_window = (locate(/obj/structure/window) in shred_turf)
            if(maybe_window)
                maybe_window.take_damage(2000, BRUTE, "energy", FALSE)
        shred_turf.ex_act(burn_power)
    return ..()

/obj/effect/temp_visual/hullburn/medium
    burn_power = EXPLODE_HEAVY
    window_b_gone = TRUE

/obj/item/projectile/guided_munition/torpedo/minisun
    name = "ominous torpedo"
    //icon_state = TEMP - U-WIP - Use some slight blueish shock animation like for the anomalies.
    damage = 800
    speed = 4 //Very slow
    homing_turn_speed = 30

/obj/item/projectile/guided_munition/torpedo/minisun/detonate(atom/target)
    explosion(target, 9, 0, 0, 12, ignorecap = TRUE, flame_range = 9)

/obj/item/projectile/bullet/energized_particle
    name = "energized particle blast"
    damage = 60
    speed = 0.7
    icon_state = "pdc" //icon_state = TEMP - U-WIP
    icon = 'nsv13/icons/obj/projectiles_nsv.dmi'
    flag = "overmap_heavy"
    relay_projectile_type = /obj/item/projectile/bullet/energized_particle_relayed

/obj/item/projectile/bullet/energized_particle_relayed
    name = "energized particle blast"
    damage = 35
    speed = 0.7
    range = 255
    icon_state = "pdc" //icon_state = TEMP - U-WIP
    icon = 'nsv13/icons/obj/projectiles_nsv.dmi'
    flag = "energy"

/obj/item/projectile/bullet/energized_particle_relayed/on_hit(atom/target, blocked, pierce_hit)
    . = ..()
    new /obj/effect/temp_visual/hullburn/medium(get_turf(target))