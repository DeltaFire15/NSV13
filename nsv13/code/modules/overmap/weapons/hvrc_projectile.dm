/obj/item/ship_weapon/ammunition/hvrc
    name = "400mm Railcannon Slug"
    icon = 'nsv13/icons/obj/munitions.dmi' //TEMP
    icon_state = "torpedo" //TEMP
    desc = "A heavy slug to be fired out a Railcannon."
    anchored = FALSE
    w_class = WEIGHT_CLASS_HUGE
    move_resist = MOVE_FORCE_EXTREMELY_STRONG //Possible to pick up with two hands
    density = TRUE
    projectile_type = /obj/item/projectile/bullet/proto_hvrc
    obj_integrity = 1000
    max_integrity = 1000 //Brick of metal
    volatility = 0

/obj/item/projectile/bullet/proto_hvrc
    flag = "bullet"
    icon = 'nsv13/icons/obj/projectiles_nsv.dmi' //TEMP
    icon_state = "railgun" //TEMP
    name = "railcannon slug"
    damage = 10
    speed = 12
    obj_integrity = 300
    max_integrity = 300
    range = 255
    ///How much power has this slug absorbed from HVRC rails.
    var/stored_power = 0
    ///Has this left the muzzle? If not, very volatile movement.
    var/finished = FALSE
    ///HVRC core of the cannon that fired this.
    var/obj/machinery/hvrc/core/linked_hvrc_core
    ///Did the firing cycle succeed?
    var/fire_success = FALSE
    ///What does this turn into on the overmap?
    var/true_projectile_type = /obj/item/projectile/bullet/hvrc
    ///What is the turf the overmap gunner's target was on?
    var/turf/preserved_target_turf

/obj/item/projectile/bullet/proto_hvrc/Destroy()
    if(!fire_success && !QDELETED(linked_hvrc_core))
        linked_hvrc_core.fail_firing_cycle(src)
    return ..()

/obj/item/projectile/bullet/proto_hvrc/proc/set_up(obj/machinery/hvrc/core/fired_from)
    linked_hvrc_core = fired_from

/obj/item/projectile/bullet/proto_hvrc/can_hit_target(atom/target, direct_target, ignore_loc, cross_failed)
    . = ..()
    if(!.)
        return
    if(istype(target, /obj/machinery/hvrc) && !finished)
        var/obj/machinery/hvrc/passed_hvrc = target
        passed_hvrc.hvrc_slug_action(src)
        return FALSE
    return .

/obj/item/projectile/bullet/proto_hvrc/on_hit(atom/target, blocked, pierce_hit)
    . = ..()
    if(iswallturf(target))
        var/turf/closed/wall/demolish = target
        demolish.dismantle_wall(TRUE)
    if(!isliving(target) || !. || . == BULLET_ACT_BLOCK)
        return
    if(damage < 80)
        return
    var/mob/living/mob_target = target
    if(!mob_target.client)
        return
    to_chat(mob_target, "<span class='boldwarning'>[src] tears through you!</span>", MESSAGE_TYPE_WARNING)

/obj/item/projectile/bullet/proto_hvrc/Move(atom/newloc, direct)
    . = ..()
    if(!.)
        return
    if(!finished && !locate(/obj/machinery/hvrc) in newloc)
        detonate_proto_hvrc(stored_power)
        return
    else if(x >= world.maxx - TRANSITIONEDGE - 3)
        if(!QDELETED(linked_hvrc_core))
            linked_hvrc_core.complete_firing_cycle(src)
            fire_success = TRUE
        qdel(src)
        

/obj/item/projectile/bullet/proto_hvrc/proc/detonate_proto_hvrc(power)
    stored_power *= 0.5
    var/light_radius = CEILING(power / (20 MEGA), 1) + 2
    var/heavy_radius = CEILING(power / (40 MEGA), 1) + 1
    var/devastation_radius = CEILING(power / (80 MEGA), 1)
    explosion(src, devastation_radius, heavy_radius, light_radius, light_radius, ignorecap = TRUE)    

/obj/item/projectile/bullet/hvrc
    flag = "overmap_light"
    icon = 'nsv13/icons/obj/projectiles_nsv.dmi' //TEMP
    icon_state = "railgun" //TEMP
    name = "railcannon slug"
    damage = 10
    speed = 12
    obj_integrity = 300
    max_integrity = 300
    range = 10
