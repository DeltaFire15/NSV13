/**
Nanogoop which slowly spreads through open spaces of the ship.
Probably a bad idea to touch, ingest, or worse.
**/

//Handles spread
/datum/goop_controller
    ///All goop tiles.
    var/list/goop_structures = list()
    ///Goop tiles that are currently processing their spread. Gets reset back to the all-encompassing list once empty.
    var/list/goop_processing = list()
    ///Min cooldown between spreads.
    var/min_spread_cooldown = 3 SECONDS
    ///Max cooldown between spreads.
    var/max_spread_cooldown = 5 SECONDS
    ///Next world.time it will attempt to spread.
    var/next_spread = 0
    ///Is this currently dying? ceases processing if the case.
    var/dying = FALSE

/datum/goop_controller/New()
    . = ..()
    START_PROCESSING(SSobj, src)

/datum/goop_controller/Destroy(force, ...)
    STOP_PROCESSING(SSobj, src)
    return ..()

///Called by a destroyed goop on its controller if the goop is destroyed.
/datum/goop_controller/proc/on_goop_destroy(obj/structure/nano_goop/destroyed_goop)
    goop_structures.Remove(destroyed_goop)
    goop_processing.Remove(destroyed_goop)
    if(!length(goop_structures))
        qdel(src)

///One of the ways to get the controller setup, creating the controller, then linking a list of created goop tiles
/datum/goop_controller/proc/link_goop(list/goop_to_link)
    if(!islist(goop_to_link))
        goop_to_link = list(goop_to_link)
    for(var/obj/structure/nano_goop/link_gup as anything in goop_to_link)
        link_gup.goop_control = src
        goop_structures.Add(link_gup)
        goop_processing.Add(link_gup)

///Alternate to linking existing gup, one can also be created at a target tile
/datum/goop_controller/proc/spawn_goop(turf/target)
    if(!isturf(target))
        CRASH("invalid turf input")
    var/obj/structure/nano_goop/gup = new /obj/structure/nano_goop(target)
    gup.goop_control = src
    goop_structures.Add(gup)
    goop_processing.Add(gup)

/datum/goop_controller/process(delta_time)
    if(dying)
        return PROCESS_KILL
    if(!length(goop_structures))
        return
    if(next_spread > world.time)
        return
    next_spread = world.time + rand(min_spread_cooldown, max_spread_cooldown)
    if(!length(goop_processing))
        goop_processing = goop_structures.Copy()
    var/obj/structure/nano_goop/goop = pick(goop_processing)
    var/tries = clamp(round(length(goop_structures) * 0.1), 1, 10)
    for(var/i = 1; i<= tries; i++)
        if(!goop.try_spread())
            goop_processing.Remove(goop)
        else
            break

/datum/goop_controller/proc/self_terminate(obj/structure/nano_goop/source)
    dying = TRUE
    for(var/obj/structure/nano_goop/goop as anything in (goop_structures - source))
        var/deltime = rand(20, 50) //2 - 5 seconds until del
        animate(goop, alpha = 0, time = deltime, flags = ANIMATION_END_NOW)
        QDEL_IN(goop, deltime)

//The actual goop ///OBSOL-WIP - Maybe give them an alpha mask that blocks out part of the legs of mobs? That'd be pretty cool.
/obj/structure/nano_goop
    name = "weird goop" //Yikes.
    desc = "A mass of grey-blackish goop with a slimy-looking consistency. Looking at it for a bit, you could swear it is slowly moving."
    icon = 'icons/obj/smooth_structures/alien/weeds1.dmi' //OBSOL-WIP - TEMP sprite
    icon_state = "weeds" //OBSOL-WIP - TEMP icon state
    anchored = TRUE
    layer = LOW_OBJ_LAYER ///OBSOL-WIP - investigate what layer this should be.
    density = FALSE
    max_integrity = 500 //OBSOL-WIP - fire-based weapons, energy / lasers and atmos fire should do very high damage and easily destroy this.
    obj_integrity = 500
    ///Spreading onto a space tile leaves a goop structure with one less of this value than its parent, spreading onto ground increases it by one up to its starting value.
    var/space_spread = 3
    ///The linked goop controller
    var/datum/goop_controller/goop_control
    ///weak to fire - high bonus damage from fire act
    var/fire_weakness = 200
    ///weak to fire - high bonus damage from anything that welds
    var/welder_weakness = 250
    ///weak to fire - decent bonus damage multiplier from lasers and energy weapons
    var/laser_weakness = 4
    ///target mobs on the tile currently being affected. Used to moving out and back in doesn't dupe callbacks
    var/list/affecting_mobs = list()


/obj/structure/nano_goop/Destroy()
    if(goop_control)
        goop_control.on_goop_destroy(src)
        goop_control = null
    for(var/obj/thing in contents)
        thing.forceMove(get_turf(src))
    UnregisterSignal(get_turf(src), COMSIG_ATOM_ENTERED)
    return ..()

/obj/structure/nano_goop/Initialize(mapload)
    . = ..()
    var/turf/goop_turf = get_turf(src)
    alpha = 0
    animate(src, alpha = 255, time = 6 SECONDS)
    RegisterSignal(goop_turf, COMSIG_ATOM_ENTERED, .proc/on_enter)
    for(var/atom/movable/thing in goop_turf)
        on_enter(goop_turf, thing, goop_turf)

/obj/structure/nano_goop/fire_act(exposed_temperature, exposed_volume)
    . = ..()
    take_damage(fire_weakness, BURN, "fire", 0)

/obj/structure/nano_goop/attackby(obj/item/I, mob/living/user, params)
    if(!I || I.tool_behaviour != TOOL_WELDER)
        return ..()
    if(!I.tool_start_check(user, amount=0))
        return ..()
    user.do_attack_animation(src)
    take_damage(welder_weakness, BURN, "fire", 0)
    return TRUE

/obj/structure/nano_goop/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armour_penetration)
    if(damage_flag == "energy" || damage_flag == "laser")
        damage_amount *= laser_weakness
    return ..()

///Goops things when the turf with the goop is entered.
/obj/structure/nano_goop/proc/on_enter(datum/source, atom/movable/thing, atom/oldloc) //OBSOL-WIP - needs sounds for its things, probably from the slime sound effects
    SIGNAL_HANDLER

    if(thing.loc != get_turf(src))
        return
    if(isitem(thing))
        var/obj/item/item = thing
        if(!item.anchored)
            visible_message("<span class='notice'>[item] sinks into [src].</span>", blind_message = "<span class='warning'>You hear weird goopy noises.</span>")
            item.forceMove(src)
            playsound(src, 'sound/effects/blobattack.ogg', 10, TRUE, -12, ignore_walls = FALSE, falloff_distance = 3)
        return
    if(ismachinery(thing))
        var/obj/machinery/machinery = thing
        if(!machinery.anchored)
            visible_message("<span class='notice'>[machinery] sinks into [src].</span>", blind_message = "<span class='warning'>You hear weird goopy noises.</span>")
            machinery.forceMove(src)
            playsound(src, 'sound/effects/blobattack.ogg', 10, TRUE, -12, ignore_walls = FALSE, falloff_distance = 3)
        return
    if(isstructure(thing))
        var/obj/structure/structure = thing
        if(!structure.anchored)
            visible_message("<span class='notice'>[structure] sinks into [src].</span>", blind_message = "<span class='warning'>You hear weird goopy noises.</span>")
            structure.forceMove(src)
            playsound(src, 'sound/effects/blobattack.ogg', 10, TRUE, -12, ignore_walls = FALSE, falloff_distance = 3)
        return
    if(isliving(thing))
        var/mob/living/L = thing
        if(HAS_TRAIT(L, TRAIT_OBSOLESCENT) || ("obsolescent" in L.faction))
            return //You may pass.
        if(iscarbon(L))
            if(!L.adjustCloneLoss(1, TRUE)) //Creatures resistant to cloneloss get easier damagetypes, but twice the raw amount. No escape.
                L.adjustBruteLoss(1, forced = TRUE)
                L.adjustFireLoss(1, TRUE, TRUE)
        else
            L.adjustFireLoss(1, TRUE, TRUE)
        if(L in affecting_mobs)
            return //Don't dupe timers.
        var/critorworse = (L.stat >= UNCONSCIOUS || L.IsSleeping() || L.IsUnconscious())
        if(critorworse)
            L.visible_message("<span class='warning'>[L] starts to sink into [src].</span>", "<span class='warning'>You start to sink into [src]!</span>")
            playsound(src, 'sound/effects/blobattack.ogg', 5, TRUE, -14, ignore_walls = FALSE, falloff_distance = 2)
            animate(L, alpha = 0, time = 2 SECONDS)
        affecting_mobs += L
        addtimer(CALLBACK(src, .proc/recheck_mob, L, critorworse), 2 SECONDS)

///Rechecks mobs still on a turf after the timer runs out, effectively creating a loop of sorts, ending when either moving off the turf, or when gooped.
/obj/structure/nano_goop/proc/recheck_mob(mob/living/mob_target, was_sinking) //OBSOL-WIP - animate the "sinking" part before the forcemove -> alphamask or simillar?
    if(mob_target.loc != get_turf(src))
        if(was_sinking)
            mob_target.alpha = 255
        affecting_mobs -= mob_target
        return
    if(HAS_TRAIT(mob_target, TRAIT_OBSOLESCENT) || ("obsolescent" in mob_target.faction))
        affecting_mobs -= mob_target
        return //You may pass.
    if(was_sinking)
        mob_target.visible_message("<span class='warning'>[mob_target] submerges in [src].</span>", "<span class='warning'>You completely submerge in [src]!</span>", "<span class='warning'>You hear weird goopy noises.</span>")
        playsound(src, 'sound/effects/blobattack.ogg', 30, TRUE, -9, falloff_distance = 7)
        mob_target.forceMove(src)
        if(ishuman(mob_target))
            if(!mob_target.adjustCloneLoss(200, TRUE))
                mob_target.adjustFireLoss(250, TRUE, TRUE)
            addtimer(CALLBACK(src, .proc/convert, mob_target), 15 SECONDS)
        else
            mob_target.adjustBruteLoss(150)
            mob_target.adjustFireLoss(150, TRUE)
        return

    if(iscarbon(mob_target))
        if(!mob_target.adjustCloneLoss(2, TRUE)) //Doubled for staying on the tile instead of passing through.
            mob_target.adjustBruteLoss(2, forced = TRUE)
            mob_target.adjustFireLoss(2, TRUE, TRUE)
    else
        mob_target.adjustFireLoss(2, TRUE, TRUE)
    var/critorworse = (mob_target.stat >= UNCONSCIOUS || mob_target.IsSleeping() || mob_target.IsUnconscious())
    if(critorworse)
        mob_target.visible_message("<span class='warning'>[mob_target] starts to sink into [src].</span>", "<span class='warning'>You start to sink into [src]!</span>")
        playsound(src, 'sound/effects/blobattack.ogg', 5, TRUE, -14, ignore_walls = FALSE, falloff_distance = 2)
        animate(mob_target, alpha = 0, time = 2 SECONDS) //Maybe try an alpha mask for this instead? Eh.
    addtimer(CALLBACK(src, .proc/recheck_mob, mob_target, critorworse), 2 SECONDS)

///Converts a human into an obsolescent, then ejects them.
/obj/structure/nano_goop/proc/convert(mob/living/carbon/converting)
    if(converting.loc != src)
        return
    if(!isobsolescent(converting))
        converting.make_obsolescent()
    converting.forceMove(get_turf(src))
    playsound(src, 'sound/effects/splat.ogg', 70, TRUE, 0, falloff_distance = 7)
    converting.alpha = 255
    converting.visible_message("<span class='warning'>[converting] is ejected from [src]!</span>", "span class='notice'>You are ejected from [src].", "<span class='warning'>You hear weird goopy noises!</span>")

///Tries to spread the goop to another adjacent tile. Also goes up / down ladders if possible.
/obj/structure/nano_goop/proc/try_spread()
    var/list/options = GLOB.cardinals.Copy()
    . = 0
    var/turf/current_turf = get_turf(src)
    var/obj/structure/ladder/ladder = (locate() in current_turf)
    if(ladder)
        if(ladder.up)
            options.Add(UP)
        if(ladder.down)
            options.Add(DOWN)
    for(var/dir as anything in options)
        var/turf/tile_target = get_step(get_turf(src), dir)
        if(!check_tile(tile_target))
            continue
        if(!spread_tile(tile_target))
            continue
        playsound(tile_target, 'sound/effects/blobattack.ogg', 5, FALSE, -14)
        . = 1
        break

///Checks if a tile is viable to spread to
/obj/structure/nano_goop/proc/check_tile(turf/target)
    if(isspaceturf(target) && space_spread == 0)
        return FALSE
    if(isclosedturf(target))
        return FALSE
    if(locate(/obj/structure/nano_goop) in target)
        return FALSE
    for(var/thing in target)
        var/atom/movable/AM = thing
        if(istype(AM, /obj/machinery/door))
            continue
        if(AM.density && AM.anchored)
            return FALSE
    return TRUE

///Spreads to a new tile
/obj/structure/nano_goop/proc/spread_tile(turf/target)
    var/obj/structure/nano_goop/goop = new /obj/structure/nano_goop(target)
    goop.goop_control = goop_control
    goop_control.goop_processing.Add(goop)
    goop_control.goop_structures.Add(goop)
    if(isspaceturf(target))
        goop.space_spread = max(space_spread - 1, 0)
    else
        goop.space_spread = min(space_spread + 1, initial(space_spread))
    return TRUE

/**
 * A special type of this goop placed by obsolescents. Creates a controller for itself, but quickly deteriorates if this core is destroyed.
 * * Effectively, their way of turf "terra"forming.
**/
/obj/structure/nano_goop/core
    name = "weird glowing goop" ///OBSOL-WIP - needs custom sprite and a slight either purple or cyan glow. Glow alone could probably also be enough.
    desc = "A mass of grey-blackish goop with an eerie glow eminating from somewhere within."

    //Cores are more resistant than base goop, but will still break fairly easily when fought with fire.
    fire_weakness = 150
    welder_weakness = 100
    laser_weakness = 2

/obj/structure/nano_goop/core/Initialize(mapload)
    . = ..()
    goop_control = new()
    goop_control.link_goop(src)

/obj/structure/nano_goop/core/Destroy()
    if(goop_control)
        goop_control.self_terminate(src)
    return ..()
