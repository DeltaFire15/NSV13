/*
TODOS GO HERE:
Emp act: disable for a short while, cause the depowering issues when active + shock. Obviously, very bad if currently firing but thats a 1 in thousands
Add wire power linkage stuff.
Main functionality
Setup circuit boards
Setup techweb
Setup needed components for machinery
Setup repair code
Add tool sounds to multitool realign / repair interactions.
Actually make the capacitors use power when energized and especially when charging a slug
Look at the whole energy -> speed thing since speed seems to be kinda weird.
Revisit zap multiplier -> might be still very big
Transfer of values between proto projectile and real one, ship weapon code integration
Revisit Capacitor code and maybe change it to KW/tick or a different power unit.
Make ONLY the core circuit nonprintable / indestructible.
UI
Sprites. ... --- ...
scream at code
*/

//Turn back all ye who enter here.

//Hmm lets assume something like 100MW charged as base damage for now.. Rails 5, capacitors 1. Base parts, up to x4 from adv parts.
//Delta from the future here, oh lord yeah this will require more number crunching than I like.
#define HVRC_POWER_UNITS_PER_DAMAGE 200000 //0.2 MW / point of damage, for now
#define HVRC_SPEED_EQUATION(x) (round(CLAMP(12 - (0.837537 * log((0.375504 * x) + 174.207) - 4.32207), 0.1, 12), 0.1)) //Starts at 12 ticks / tile, converges towards 0.1 at ~1GW Aka, this is substracted from the base value. Thank you function equation finder tool.
#define HVRC_OVERMAP_POWER_PER_RANGE 1000000 //1MW per point of range over its base of 10. Intended to end up pretty high.
#define HVRC_OVERMAP_MAX_RANGE 255 //Range can't get increases past this. For now. Although.......
#define HVRC_MIN_POWER_MEDIUM_DAMAGE 10000000 //10MW min charged to be a medium damtype projectile
#define HVRC_MIN_POWER_HEAVY_DAMAGE 80000000 //80MW min charged to be a heavy projectile

//x = (root(2) * root(y) / root(z)) - x = wanted existance in ticks, y = pixel distance to pass, z = gravity speed. Thank you integrals.
#define HVRC_PARTICLE_TIME_FUNCTION(y, z) (CEILING(((ROOT(1, 2) * ROOT(1, y)) / ROOT(1, z)),1)) //Ratvar ward me from this evil.

#define HVRC_BASE_MAX_CAPACITOR_CHARGERATE 1000000 //1MW / second max chargerate
#define HVRC_BASE_MAX_CAPACITOR_CHARGE 100000000 //100MW base maxcharge for the moment
#define HVRC_BASE_MAX_RAIL_DISCHARGE 20000000 //20MW maximum discharge per rail base for now.
#define RAIL_ZAP_COEFF 0.1 //Multiplier to how much of the actual applied power is in the zap. Should be small due to us throwing arounds metawatts of energy.
#define RAIL_ZAP_RANGE 4 //Base range of zaps emitted by rails.
#define HVRC_MIN_PEN_POWER 25000000 //25MW to penetrate

#define HVRC_MAX_PARTICLES_PER_TICK 10 //How many particles per tick does the HVRC generate at most when active?
#define HVRC_PARTICLE_BUILDUP_SPEED 1 //How fast does particles per tick go up per cycle?
#define HVRC_PARTICLE_BUILDUP_DELAY 5 //Delay between each buildup increase
#define HVRC_PARTICLE_WINDDOWN_SPEED 2 //How fast does particles per tick go down per cycle?
#define HVRC_PARTICLE_WINDDOWN_DELAY 5 //Delay between each buildup decrease

#define HVRC_BROKEN 0
#define HVRC_NORMAL 1
#define HVRC_CHANNELLING 2

#define GENTLE_DISCHARGE 1 //Rails properly depowered after losing charge due to firing.
#define VIOLENT_DISCHARGE 2 //Rails improperly discharged by manually releasing charged state without firing.

#define VIOLENT_DISCHARGE_COEFF 0.1 //How much power relative to the total power available in the capacitors do the rails shock with if improperly discharged? Should be low.

//TODO: Implement these defs into actual repair code.
#define HVRC_REPAIR_STAGE_NORMAL 0 //Not broken.
#define HVRC_REPAIR_STAGE_NEEDS_PLASTEEL 1 //Stage the device ends up in when broken, needs 5 plasteel applied.
#define HVRC_REPAIR_STAGE_NEEDS_WRENCH 2 //Next stage, needs wrenching.
#define HVRC_REPAIR_STAGE_NEEDS_WELD 3 //Next stage, needs welding.
#define HVRC_REPAIR_STAGE_NEEDS_WIRE 4 //Next stage, needs wiring.
#define HVRC_REPAIR_STAGE_NEEDS_METAL 5 //Next stage, needs metal (casing).
#define HVRC_REPAIR_STAGE_NEEDS_FINAL_WELD 6 //Final stage, once more welding. When done, calls repair().

//Rail nonfunctional.
#define RAILSTATE_NONE 0
//Rail operating nominally.
#define RAILSTATE_NOMINAL 1
//Rail diverging slightly but can get one more shot off.
#define RAILSTATE_DIVERGING 2
//Uh oh!
#define RAILSTATE_MISALIGNED 3

/*
Base Type for things HVRC machinery components may have in common.
ALL HVRC-weapon-centric machinery only faces "nosewards" for a ship, aka RIGHT.
*/
/obj/machinery/hvrc
    name = "This shouldn't exist"
    desc = "You have encountered a basetype that people shouldn't be able to see! Uh oh, report this to some coder and/or create a github issue."
    icon = 'nsv13/icons/obj/munitions/hvrc.dmi'
    icon_state = "uhoh"
    max_integrity = 400
    obj_integrity = 400
    use_power = NO_POWER_USE //This runs off its own mechanics and doesn't need the APC.
    anchored = TRUE
    density = TRUE
    ///Icon state used for the broken machine as these cannon simply desintegrate from damage alone.
    var/broken_state = "uhoh"
    var/repair_stage = HVRC_REPAIR_STAGE_NORMAL
    ///Current state
    var/current_state = HVRC_NORMAL
    ///Which core is this machine linked to? Cores themselves obviously have no link.
    var/obj/machinery/hvrc/core/linked_core

///Special things that some HVRC machinery might do when linked to its core.
/obj/machinery/hvrc/proc/on_link()
    return

///Special things that some HVRC machinery might do when unlinked from its core (usually forced due to no manual way to do this).
/obj/machinery/hvrc/proc/on_unlink()
    if(current_state == HVRC_CHANNELLING)
        switch_state(HVRC_NORMAL)
    return
    
///Overrides parent proc!
/obj/machinery/hvrc/obj_destruction(damage_flag)
    icon_state = broken_state
    obj_integrity = max_integrity
    obj_flags |= INDESTRUCTIBLE
    flags_1 |= TESLA_IGNORE_1
    repair_stage = HVRC_REPAIR_STAGE_NEEDS_PLASTEEL
    switch_state(HVRC_BROKEN)
    update_icon()

/obj/machinery/hvrc/Destroy()
    if(linked_core)
        linked_core.unlink_all()
    return ..()

///For switching to different which may have secondary effects depending on situation.
/obj/machinery/hvrc/proc/switch_state(switch_to)
    if(current_state == switch_to)
        return FALSE
    current_state = switch_to
    return TRUE

///Called when repairs on a machine are finished after it broke apart.
/obj/machinery/hvrc/proc/repair()
    switch_state(HVRC_NORMAL)
    icon_state = initial(icon_state)
    obj_integrity = max_integrity
    obj_flags &= ~INDESTRUCTIBLE
    flags_1 &= ~TESLA_IGNORE_1
    repair_stage = HVRC_REPAIR_STAGE_NORMAL
    update_icon()

/obj/machinery/hvrc/ex_act(severity, target)
    if((obj_flags & INDESTRUCTIBLE))
        return
    switch(severity)
        if(EXPLODE_DEVASTATE)
            take_damage(5000, BRUTE, "bomb", FALSE)
        if(EXPLODE_HEAVY)
            take_damage(rand(100, 400), BRUTE, "bomb", FALSE)
        if(EXPLODE_LIGHT)
            take_damage(rand(30, 100), BRUTE, "bomb", FALSE)

/obj/machinery/hvrc/proc/hvrc_slug_action(obj/item/projectile/bullet/proto_hvrc/passing_slug)
    if(current_state != HVRC_CHANNELLING || passing_slug.finished)
        detonate_hvrc(passing_slug.stored_power)
        qdel(passing_slug)
        return FALSE
    return TRUE

///If you do bad things, cannon go boom.
/obj/machinery/hvrc/proc/detonate_hvrc(power)
    var/light_radius = CEILING(power / 20000000, 1) + 2
    var/heavy_radius = CEILING(power / 40000000, 1) + 1
    var/devastation_radius = CEILING(power / 80000000, 1)
    explosion(src, devastation_radius, heavy_radius, light_radius, light_radius, ignorecap = TRUE)


/*
Core of a HVRC.
Handles linkages, is where the shell is loaded, is what has the actual linkage to the ship weapon part of this gun (If I need that?)
Circuit board indestructible and cannot be printed without admin intervention or possibly some very good luck.
*/
/obj/machinery/hvrc/core
    name = "HVRC Core"
    desc = "The Core of an High Velocity Railcannon. This controls linkage of its constituent parts, aswell as holds the slug prior to firing."
    circuit = /obj/item/circuitboard/hvrc_core
    icon_state = "temp_core"
    broken_state = "temp_core_broken"
    ///Which HVRC parts are linked to this core? Generally, an HVRC requires a Core, a Control Console, a muzzle, at least one rail and at least one capacitor bank.
    var/list/linked_components = list()
    ///The control console for this HVRC. A HVRC can only have one control console at a time. These can also break normally as with all consoles.
    var/obj/machinery/computer/hvrc_control/hvrc_control
    ///Checks whether the console-intiated linkage is finished, after that is done linking capacitors is permitted.
    var/primary_linkage_finished = FALSE


    ///How much energy did all capacitors together have available at the time of firing?
    var/total_available_energy = 0
    ///Console controlled, how high of a percentage of capacitor energy does each shot have available?
    var/allocated_percentage = 0
    ///How many rails did the HVRC have at the time of firing?
    var/total_rails = 0
    ///The currently loaded railcannon slug, if any.
    var/obj/item/ship_weapon/ammunition/hvrc/loaded_slug
    ///The ship weapon this is linked to.
    var/datum/ship_weapon/hvrc_snowflake_weapon/linked_gun
    ///Linked overmap
    var/obj/structure/overmap/linked_overmap
    ///HVRC particles which have emission triggered when energized and disabled when deenergized.
    var/obj/effect/abstract/particle_holder/hvrc_particle_holder

/obj/machinery/hvrc/core/switch_state(switch_to)
    var/was_charged = (current_state == HVRC_CHANNELLING ? TRUE : FALSE)
    . = ..()
    if(!.)
        return //Make sure we return if the state is still the same.
    if(was_charged)
        stop_channelling_particles()
    else if(switch_to == HVRC_CHANNELLING)
        start_channelling_particles()

///Starts emitting particles to make the HVRC look cooler (and also to notify that it is channelling). Winds up over time to their max count.
/obj/machinery/hvrc/core/proc/start_channelling_particles()
    set waitfor = FALSE
    var/particles/hvrc_energized_particles/linked_particles = hvrc_particle_holder.particles
    if(!linked_particles)
        CRASH("For some reason the attached particles meant to be on a HVRC were missing.")
    var/noncapacitor_component_count = 0
    for(var/obj/machinery/hvrc/hvrc_machine as anything in linked_components)
        if(istype(hvrc_machine, /obj/machinery/hvrc/capacitor))
            continue
        noncapacitor_component_count++
    //TODO: This curremtly isn't working as expected. Check on this stuff and see how you make them disappear properly. Oh wait it's SECONDS the TIME!! - need to do integral solving.
    linked_particles.width = min(32*(noncapacitor_component_count*2+1), 640) //I don't know how big I can make these without causing potatoes to explode so I'll cap it at 20 tiles of HVRC for safety
    var/distance_to_pass = 32*noncapacitor_component_count
    var/particle_acceleration = 0.2 //TODO: Make this dependant on power level!
    linked_particles.gravity = list(particle_acceleration, 0)
    linked_particles.lifespan = HVRC_PARTICLE_TIME_FUNCTION(distance_to_pass, particle_acceleration)
    while(TRUE)
        if(QDELETED(src))
            return
        if(current_state != HVRC_CHANNELLING)
            return
        var/new_spawning = min(linked_particles.spawning + HVRC_PARTICLE_BUILDUP_SPEED, HVRC_MAX_PARTICLES_PER_TICK)
        if(linked_particles.spawning == new_spawning)
            return
        linked_particles.spawning = new_spawning
        sleep(HVRC_PARTICLE_BUILDUP_DELAY) //TODO: Play around with buildup change per tick.

///Winds down current particle emissions towards 0 over time, to signify the Railcannon shutting down.
/obj/machinery/hvrc/core/proc/stop_channelling_particles()
    set waitfor = FALSE
    var/particles/hvrc_energized_particles/linked_particles = hvrc_particle_holder.particles
    if(!linked_particles)
        CRASH("For some reason the attached particles meant to be on a HVRC were missing.")
    while(TRUE)
        if(QDELETED(src))
            return
        if(current_state == HVRC_CHANNELLING)
            return
        var/new_spawning = max(linked_particles.spawning - HVRC_PARTICLE_WINDDOWN_SPEED, 0)
        if(linked_particles.spawning == new_spawning)
            return
        linked_particles.spawning = new_spawning
        sleep(HVRC_PARTICLE_WINDDOWN_DELAY) //TODO: Play around with winddown discharge per tick.

/**
 * Uses power from capacitors linked to the core.
 * * Args:
 * * * amount: How much power is to be used.
 * * * soft_limit: If true, it will also accept less power than amount if it's bigger than zero.
 * * Returns:
 * * * power used, 0 if failed.
**/
/obj/machinery/hvrc/core/proc/use_capacitor_power(amount, soft_limit = FALSE)
    return TRUE
    //TODO actually use power from linked capacitors, return amount used if successful, 0 if not enough. Amount used can be smaller than amount if there was not enough, provided soft_limit is true.

/obj/machinery/hvrc/core/Initialize(mapload)
    . = ..()
    if(!mapload)
        link_to_overmap()
    else
        addtimer(CALLBACK(src, .proc/link_to_overmap), 15 SECONDS)
    hvrc_particle_holder = new(src, /particles/hvrc_energized_particles)

/obj/machinery/hvrc/core/Destroy()
    if(linked_gun)
        linked_gun.linked_hvrc_cores -= src
    if(loaded_slug)
        QDEL_NULL(loaded_slug)
    return ..()

/obj/machinery/hvrc/core/proc/link_to_overmap()
    linked_overmap = get_overmap()
    if(!linked_overmap)
        return
    for(var/I = FIRE_MODE_ANTI_AIR; I <= MAX_POSSIBLE_FIREMODE; I++) //Do we already have a weapon?
        var/datum/ship_weapon/SW = linked_overmap.weapon_types[I]
        if(!SW)
            continue
        if(istype(SW, /datum/ship_weapon/hvrc_snowflake_weapon)) //Does this ship have a weapon type registered for us? Prevents phantom weapon groups.
            var/datum/ship_weapon/hvrc_snowflake_weapon/hvrc_weapon = SW
            hvrc_weapon.link_hvrc(src)
            return TRUE
    linked_overmap.weapon_types[FIRE_MODE_RAILGUN] = new /datum/ship_weapon/hvrc_snowflake_weapon(linked_overmap)
    var/datum/ship_weapon/hvrc_snowflake_weapon/hvrc_weapon = linked_overmap.weapon_types[FIRE_MODE_RAILGUN] //Overriding weapons this way causes harddels but oh well thats an issue for another day since all the guns do this.
    hvrc_weapon.link_hvrc(src)

///Is called when the projectile successfully leaves the muzzle of the Railcannon and powers down the rails.
/obj/machinery/hvrc/core/proc/firing_cycle_slug_launch(obj/item/projectile/bullet/proto_hvrc/fired_slug)
    discharge_system(GENTLE_DISCHARGE)

///Is called when the projectile successfully reaches the end of the z level and is turned into a true overmap projectile.
/obj/machinery/hvrc/core/proc/complete_firing_cycle(obj/item/projectile/bullet/proto_hvrc/fired_slug)
    if(!linked_gun)
        return //Guh?
    linked_gun.transmute_true_projectile(fired_slug)

///Is called when the projectile doesn't reach the end of the z level for whichever reason, e.g. hitting something.
/obj/machinery/hvrc/core/proc/fail_firing_cycle(obj/item/projectile/bullet/proto_hvrc/fired_slug)
    //TODO:Just cancel fire here and discharge rails.
    discharge_system(GENTLE_DISCHARGE)

/obj/machinery/hvrc/core/proc/charge_system()
    if(current_state != HVRC_NORMAL)
        return FALSE
    if(!get_available_power())
        return FALSE
    if(!primary_linkage_finished)
        return FALSE
    switch_state(HVRC_CHANNELLING)
    for(var/obj/machinery/hvrc/hvrc_machine as anything in linked_components)
        hvrc_machine.switch_state(HVRC_CHANNELLING)
    return TRUE

/obj/machinery/hvrc/core/proc/discharge_system(discharge_type)
    if(current_state == HVRC_CHANNELLING)
        switch_state(HVRC_NORMAL)
    var/available_power = get_available_power()
    for(var/obj/machinery/hvrc/hvrc_machine as anything in linked_components)
        if(hvrc_machine.current_state != HVRC_CHANNELLING)
            continue
        hvrc_machine.switch_state(HVRC_NORMAL)
        if(discharge_type != VIOLENT_DISCHARGE)
            continue
        if(istype(hvrc_machine, /obj/machinery/hvrc/rail))
            var/obj/machinery/hvrc/rail/hvrc_rail = hvrc_machine
            hvrc_rail.degrade_rail(min(hvrc_rail.maximum_discharge, FLOOR(available_power * VIOLENT_DISCHARGE_COEFF, 1)), 2)
    
    if(discharge_type == VIOLENT_DISCHARGE)
        for(var/obj/machinery/hvrc/capacitor/hvrc_capacitor in linked_components)
            hvrc_capacitor.stored_charge = 0


///The actual fire proc for the proto shell
/obj/machinery/hvrc/core/proc/fire_proto_slug(turf/target_turf)
    if(!loaded_slug || !primary_linkage_finished || current_state != HVRC_CHANNELLING)
        return FALSE
    prefire_acquire_values()
    if(!total_rails || !total_available_energy || !allocated_percentage)
        return FALSE
    var/proto_slug_type = loaded_slug.projectile_type
    var/obj/item/projectile/bullet/proto_hvrc/proto_hvrc = new proto_slug_type(get_turf(src))
    proto_hvrc.linked_hvrc_core = src
    proto_hvrc.preserved_target_turf = target_turf
    /*
    var/pseudo_target = get_step(src, EAST)
    proto_proto_hvrc.preparePixelProjectile(pseudo_target, src)
    */
    proto_hvrc.fire(90)
    QDEL_NULL(loaded_slug)


///testing proc for the proto shell firing. DEBUG ONLY.
/obj/machinery/hvrc/core/proc/proto_proto_fire()
    if(!loaded_slug)
        message_admins("No slug")
        return
    if(!primary_linkage_finished)
        message_admins("Bruh")
        return
    prefire_acquire_values()
    if(!total_rails)
        message_admins("My man, there's no rails.")
        return
    if(!total_available_energy)
        message_admins("No power.")
        return
    if(!allocated_percentage)
        message_admins("At least allocate some power?")
        return
    current_state = HVRC_CHANNELLING //Should be done from console prefire, remember?
    for(var/obj/machinery/hvrc/linked_machine as anything in linked_components)
        linked_machine.current_state = HVRC_CHANNELLING
    var/proto_proto_slug_type = loaded_slug.projectile_type
    var/obj/item/projectile/bullet/proto_hvrc/proto_proto_hvrc = new proto_proto_slug_type(get_turf(src))
    proto_proto_hvrc.linked_hvrc_core = src
    /*
    var/pseudo_target = get_step(src, EAST)
    proto_proto_hvrc.preparePixelProjectile(pseudo_target, src)
    */
    proto_proto_hvrc.fire(90)
    QDEL_NULL(loaded_slug)
    message_admins("Woo fired, testing time!")

/obj/machinery/hvrc/core/attackby(obj/item/I, mob/living/user, params)
    if(!linked_overmap)
        link_to_overmap()
    if(istype(I, /obj/item/ship_weapon/ammunition/hvrc))
        if(current_state == HVRC_CHANNELLING)
            to_chat(user, "<span class='warning'>Its rails are currently charged, you probably shouldn't touch it!</span>")
            return
        if(loaded_slug)
            to_chat(user, "<span class='warning'>There is already a shell loaded!</span>")
            return
        to_chat(user, "<span class='notice'>You begin loading [I] into [src].</span>")
        if(!do_after(user, 2 SECONDS, target=src))
            return
        if(loaded_slug || current_state == HVRC_CHANNELLING)
            return //bad
        I.forceMove(src)
        loaded_slug = I
        to_chat(user, "<span class='notice'>You load [I] into [src].</span>")
        return TRUE
    return ..()


/obj/machinery/hvrc/core/proc/unlink_all()
    if(hvrc_control)
        hvrc_control.linked_hvrc_core = null
        hvrc_control = null
    for(var/obj/machinery/hvrc/hvrc_machine as anything in linked_components)
        hvrc_machine.on_unlink()
        hvrc_machine.linked_core = null
    linked_components.Cut()


/obj/machinery/hvrc/core/proc/prefire_acquire_values()
    for(var/obj/machinery/hvrc/hvrc_machine as anything in linked_components)
        if(istype(hvrc_machine, /obj/machinery/hvrc/rail))
            total_rails++
    total_available_energy = get_available_power()

/obj/machinery/hvrc/core/proc/get_available_power()
    . = 0
    for(var/obj/machinery/hvrc/hvrc_machine as anything in linked_components)
        if(!istype(hvrc_machine, /obj/machinery/hvrc/capacitor))
            continue
        var/obj/machinery/hvrc/capacitor/hvrc_capacitor = hvrc_machine
        if(hvrc_capacitor.current_state == HVRC_BROKEN)
            continue
        . += hvrc_capacitor.stored_charge

/obj/machinery/hvrc/core/multitool_act(mob/living/user, obj/item/I)
    if(!multitool_check_buffer(user, I))
        return FALSE
    . = TRUE
    var/obj/item/multitool/tool = I
    if(QDELETED(tool.buffer))
        to_chat(user, "<span class='warning'>No buffer detected. Non-rail machines are linked to the core via their link, not the opposite.</span>")
        return
    if(istype(tool.buffer, /obj/machinery/computer/hvrc_control))
        var/obj/machinery/computer/hvrc_control/control_cast = tool.buffer
        if(control_cast.linked_hvrc_core)
            to_chat(user, "<span class='warning'>Buffered control console already linked to a core!</span>")
            return
        if(hvrc_control)
            to_chat(user, "<span class='warning'>This core is already linked to a control console!</span>")
            return
        hvrc_control = control_cast
        control_cast.linked_hvrc_core = src
        to_chat(user, "<span class='notice'>Control console linkage successful.</span>")
        tool.buffer = null
        return TRUE
    if(!istype(tool.buffer, /obj/machinery/hvrc))
        to_chat(user, "<span class='warning'>Invalid buffer type!</span>")
        return
    if(!primary_linkage_finished)
        to_chat(user, "<span class='warning'>Secondary components can only be linked after primary linkage has been intiated on the control console.</span>")
        return
    var/obj/machinery/hvrc/hvrc_buffer = tool.buffer
    if(hvrc_buffer.linked_core)
        to_chat(user, "<span class='warning'>Buffered machine is already linked to a core.</span>")
        return
    hvrc_buffer.linked_core = src
    linked_components += hvrc_buffer
    hvrc_buffer.on_link()
    to_chat(user, "<span class='notice'>Secondary component successfully linked.</span>")
    tool.buffer = null
    return TRUE


/*
Rail of a HVRC.
This is the meat of this gun and what makes it so fun.
Slugs pass through this and get charged the more energy is allocated and the more rails are passed.
The firing process can cause discharges and misalignment, which require recalibration via a multitool.
Failure to maintain the rails between firing cycles may lead to consequences.
Need to be energized before firing, which drains capacitor over time at an exponential rate.
Manually cancelling energizing process or running out of power causes discharges and misalignement.
*/
/obj/machinery/hvrc/rail
    name = "HVRC Rail"
    desc = "These Rails make up the main component of a Railcannon, providing velocity (and therefore energy and damage) to a fired slug. Very prone to volatile discharges and misalignment, requiring frequent recalibration."
    circuit = /obj/item/circuitboard/hvrc_rail
    icon_state = "temp_rail"
    broken_state = "temp_rail_broken"
    ///Current status of the rail. Deteriorates when charging fired slugs.
    var/rail_status = RAILSTATE_NOMINAL
    ///Whats the current state of the overlay? Null if there is currently no overlay.
    var/current_rail_status_overlay = null
    ///Determines how much power a rail can use at most, regardless of any settings. Parts determine this. In power units
    var/maximum_discharge = HVRC_BASE_MAX_RAIL_DISCHARGE
    ///Is someone currently interacting with this using a multitool?
    var/multitool_interacting = FALSE

/obj/machinery/hvrc/rail/Initialize(mapload)
    . = ..()
    update_icon()

/obj/machinery/hvrc/rail/obj_destruction(damage_flag)
    rail_status = RAILSTATE_NONE
    return ..()

// :)
/obj/machinery/hvrc/rail/emag_act()
    . = ..()
    if(CHECK_BITFIELD(obj_flags, EMAGGED))
        return FALSE
    if(current_state == HVRC_CHANNELLING)
        return FALSE
    ENABLE_BITFIELD(obj_flags, EMAGGED)
    update_icon()
    return TRUE


/obj/machinery/hvrc/rail/on_unlink()
    if(linked_core && current_state == HVRC_CHANNELLING)
        var/zappy = min(linked_core.get_available_power(), maximum_discharge)
        rail_zap(zappy)
    return ..()

/obj/machinery/hvrc/rail/repair()
    rail_status = RAILSTATE_MISALIGNED //After fixing a completely busted rail you also have to realign it.
    return ..()

/obj/machinery/hvrc/rail/update_icon()
    . = ..()
    if(current_rail_status_overlay)
        cut_overlay(current_rail_status_overlay)
    if(rail_status != RAILSTATE_NONE && CHECK_BITFIELD(obj_flags, EMAGGED))
        add_overlay("temp_state_diverging")
        current_rail_status_overlay = "temp_state_diverging"
    switch(rail_status)
        if(RAILSTATE_NONE)
            current_rail_status_overlay = null
        if(RAILSTATE_NOMINAL)
            add_overlay("temp_state_nominal")
            current_rail_status_overlay = "temp_state_nominal"
        if(RAILSTATE_DIVERGING)
            add_overlay("temp_state_diverging")
            current_rail_status_overlay = "temp_state_diverging"
        if(RAILSTATE_MISALIGNED)
            add_overlay("temp_state_misaligned")
            current_rail_status_overlay = "temp_state_misaligned"

///Checks for high-stress degradation from firing slugs.
/obj/machinery/hvrc/rail/proc/degradation_check(obj/item/projectile/bullet/proto_hvrc/proto_slug, applied_charge)
    switch(rail_status)
        if(RAILSTATE_NONE)
            detonate_hvrc(proto_slug)
            qdel(proto_slug)
            return FALSE
        if(RAILSTATE_NOMINAL)
            var/discharge_prob = 5 + ((CEILING(max(0, applied_charge - 60000000) / 10000000, 1)) * 5) //You are throwing HOW MUCH power at this thing?
            if(prob(discharge_prob))
                degrade_rail(applied_charge)
            return TRUE
        if(RAILSTATE_DIVERGING)
            degrade_rail(applied_charge)
            return TRUE
        if(RAILSTATE_MISALIGNED)
            rail_zap(proto_slug.stored_power)
            detonate_hvrc(proto_slug)
            qdel(proto_slug)
            return FALSE

///Degrades rail maintenance by one tier.
/obj/machinery/hvrc/rail/proc/degrade_rail(applied_charge, degrade_levels = 1)
    ///Power of a possible zap due to degradation, determined by projectile stats.
    var/zap_power = applied_charge * RAIL_ZAP_COEFF
    switch(rail_status)
        if(RAILSTATE_NONE)
            return //Huh?
        if(RAILSTATE_NOMINAL)
            if(degrade_levels == 1)
                rail_status = RAILSTATE_DIVERGING
            else
                rail_status = RAILSTATE_MISALIGNED
            update_icon()
            rail_zap(FLOOR(zap_power / 5, 1))
        if(RAILSTATE_DIVERGING)
            rail_status = RAILSTATE_MISALIGNED
            update_icon()
            rail_zap(zap_power)
        if(RAILSTATE_MISALIGNED)
            rail_zap(zap_power)


/obj/machinery/hvrc/rail/proc/rail_zap(power_level)
    playsound(get_turf(src), 'sound/magic/lightningshock.ogg', 100, 1, extrarange = 5)
    tesla_zap(src, RAIL_ZAP_RANGE, power_level, TESLA_MOB_DAMAGE|TESLA_MOB_STUN)

/obj/machinery/hvrc/rail/hvrc_slug_action(obj/item/projectile/bullet/proto_hvrc/passing_slug)
    . = ..()
    if(!.)
        return
    if(!linked_core)
        detonate_hvrc(passing_slug.stored_power)
        qdel(passing_slug)
        return
    var/available_charge = min(FLOOR(linked_core.total_available_energy * (linked_core.allocated_percentage * 0.01) / linked_core.total_rails, 1), maximum_discharge)
    if(!degradation_check(passing_slug, available_charge))
        return FALSE
    if(!linked_core.use_capacitor_power(available_charge, TRUE))
        detonate_hvrc(passing_slug.stored_power)
        qdel(passing_slug)
        return FALSE
    passing_slug.stored_power += available_charge
    passing_slug.damage = initial(passing_slug.damage) + FLOOR(passing_slug.stored_power / HVRC_POWER_UNITS_PER_DAMAGE, 1)
    if(CHECK_BITFIELD(obj_flags, EMAGGED))
        passing_slug.stored_power = FLOOR(passing_slug.stored_power * 0.5, 1)
        passing_slug.setAngle(-passing_slug.Angle) //:)
    var/new_speed = HVRC_SPEED_EQUATION(passing_slug.stored_power)
    passing_slug.speed = new_speed
    passing_slug.set_pixel_speed(new_speed)
    if(passing_slug.stored_power > HVRC_MIN_PEN_POWER)
        passing_slug.projectile_piercing = ALL
        passing_slug.dismemberment = 200
    return TRUE

/obj/machinery/hvrc/rail/multitool_act(mob/living/user, obj/item/I)
    multitool_interacting = TRUE
    . = TRUE
    switch(rail_status)
        if(RAILSTATE_NONE)
            to_chat(user, "<span class='warning'>Nothing happens, it appears to be broken.</span>")
        if(RAILSTATE_NOMINAL)
            to_chat(user, "<span class='warning'>This rail is already properly aligned")
        if(RAILSTATE_DIVERGING, RAILSTATE_MISALIGNED)
            var/realignment_delay = 3 SECONDS
            var/slowed = FALSE
            if(rail_status == RAILSTATE_MISALIGNED)
                realignment_delay *= 3
                slowed = TRUE
            to_chat(user, "<span class='notice'>You start [slowed ? "slowly " : ""]reconfiguring the [slowed ? "highly" : "slightly"] misaligned rails.</span>")
            if(do_after(user, realignment_delay, target = src))
                if(!(rail_status == RAILSTATE_DIVERGING || rail_status == RAILSTATE_MISALIGNED))
                    multitool_interacting = FALSE
                    return
                to_chat(user, "<span class='notice'>You successfully realign the rail.</span>")
                rail_status = RAILSTATE_NOMINAL
                update_icon()
            else
                to_chat(user, "<span class='warning>You stopped reconfiguring the rail.</span>")
    multitool_interacting = FALSE
    

/*
Muzzle of a HVRC.
This turns the "proto-projectile" that is gaining energy from rails into its "finished" form and performs final trajectory alignment changes.
After it leaves this component, the slug will no longer detonate if it passes a non-HVRC-tile.
However it can still fail to fire if it hits something inbetween it leaving the muzzle and it leaving the z level.
Once the slug successfully reaches the z level boarder, it turns into an actual overmap projectile with potentially devastating power.
*/
/obj/machinery/hvrc/muzzle
    name = "HVRC Muzzle"
    desc = "Slug goes out this end if everything went right! Be careful and keep clear of the opening. Very heavily armored."
    circuit = /obj/item/circuitboard/hvrc_muzzle
    armor = list("melee" = 100, "bullet" = 95, "laser" = 75, "energy" = 50, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100, "stamina" = 100, "overmap_light" = 100, "overmap_medium" = 90, "overmap_heavy" = 75)
    icon_state = "temp_muzzle"
    broken_state = "temp_muzzle_broken"

/obj/machinery/hvrc/muzzle/hvrc_slug_action(obj/item/projectile/bullet/proto_hvrc/passing_slug)
    . = ..()
    if(!.)
        return
    if(!linked_core)
        detonate_hvrc(passing_slug.stored_power)
    passing_slug.finished = TRUE
    linked_core.firing_cycle_slug_launch(passing_slug)

/*
Capacitor of an HVRC.
These things take power from the power grid (directly via wire) and store it, which is then expended when energizing rails (over time) and in a big burst when firing (which the rails transfer into energy for the slug)
Controlled via the HVRC Console.
TODO:Should probably NOT be a hvrc machinery type?
*/
/obj/machinery/hvrc/capacitor
    name = "HVRC Capacitor"
    desc = "These capacitors, which may or may not be jury-rigged SMES units, store tremendous amounts of energy which is then channelled into the rails, and therefore slug, during the firing process of the Railcannon. Charged via direct power grid linkage."
    icon_state = "uhoh" //I'll probably just use an SMES state with some jury-rigging like a charge meter..
    circuit = /obj/item/circuitboard/hvrc_capacitor
    ///Maximum charge in power units
    var/maximum_charge = HVRC_BASE_MAX_CAPACITOR_CHARGE
    ///Current stored charge in power units
    var/stored_charge = 0
    ///Maximum charge rate in power units / machinery tick
    var/max_charge_rate = HVRC_BASE_MAX_CAPACITOR_CHARGERATE
    ///Current defined charge rate in power units / machinery tick
    var/current_charge_rate = 0

/obj/machinery/hvrc/capacitor/multitool_act(mob/living/user, obj/item/I)
    if(!multitool_check_buffer(user, I))
        return FALSE
    . = TRUE
    if(linked_core)
        to_chat(user, "<span class='warning'>Capacitor is already linked.</span>")
        return
    var/obj/item/multitool/tool = I
    to_chat(user, "<span class='notice'>Capacitor ID saved to buffer.</span>")
    tool.buffer = src
    return TRUE


/*
HVRC Control Computer.
This links directly to the core and controls the entire operations of the HVRC.
Energizing Rails needs to be triggered via this for bridge to be able to fire.
Capacitors and rails can be configured in here (although likely each setting will apply for all machines of its kind that are linked).
Contains various readouts.
*/
/obj/machinery/computer/hvrc_control
    name = "HVRC Control Console"
    desc = "This diminutive console controls all operations of its linked Railcannon via a directg link to its core. For the ship's Tactical operator to be able to fire this weapon, firing readiness and rail energization must first be manually triggered here."
    circuit = /obj/item/circuitboard/computer/hvrc_control
    ///The core, and therefore weapon, this control console is linked to
    var/obj/machinery/hvrc/core/linked_hvrc_core

///Run via the only button that shows up on a console that is linked to a core.
/obj/machinery/computer/hvrc_control/proc/run_linkage()
    if(!linked_hvrc_core)
        return
    if(length(linked_hvrc_core.linked_components))
        say("Error: Core already configured")
        return FALSE
    if(linked_hvrc_core.current_state == HVRC_BROKEN)
        say("Error: Core nonfunctional.")
        return FALSE
    var/turf/handling_turf = get_turf(linked_hvrc_core)
    var/list/found_machinery = list()
    var/railcount = 0
    var/found_muzzle = FALSE
    while(handling_turf)
        handling_turf = get_step(handling_turf, EAST)
        var/obj/machinery/hvrc/link_to = locate() in handling_turf
        //Maybe change this to be a proc onm the different hvrc devices instead of an elif chain?
        if(!link_to)
            say("Error: Incomplete linkage chain.")
            return FALSE
        else if(istype(link_to, /obj/machinery/hvrc/core))
            say("Error: Cores cannot link to cores.")
            return FALSE
        else if(istype(link_to, /obj/machinery/hvrc/capacitor))
            say("Error: Capacitors should not be in the cannon's line of fire.")
            return FALSE
        else if(istype(link_to, /obj/machinery/hvrc/rail))
            railcount++
            found_machinery += link_to
        else if(istype(link_to, /obj/machinery/hvrc/muzzle))
            found_muzzle = TRUE
            found_machinery += link_to
            break
    if(railcount < 1 || !found_muzzle)
        say("Error: Missing components detected.")
        return FALSE
    say("HVRC primary system linkage successfully established.")
    linked_hvrc_core.linked_components = found_machinery
    for(var/obj/machinery/hvrc/hvrc_component as anything in found_machinery)
        hvrc_component.on_link()
        hvrc_component.linked_core = linked_hvrc_core
    linked_hvrc_core.primary_linkage_finished = TRUE

/obj/machinery/computer/hvrc_control/multitool_act(mob/living/user, obj/item/I)
    if(!multitool_check_buffer(user, I))
        return FALSE
    . = TRUE
    if(linked_hvrc_core)
        to_chat(user, "<span class='warning'>Console is already linked.</span>")
        return
    var/obj/item/multitool/tool = I
    to_chat(user, "<span class='notice'>Console ID saved to buffer.</span>")
    tool.buffer = src
    return TRUE
        

/*
TEMP Location for HVRC Boards
Move these somewhere they make more sense later!
*/

/obj/item/circuitboard/hvrc_core

/obj/item/circuitboard/hvrc_core/Destroy(force=FALSE)
    if(force)
        return ..()
    return QDEL_HINT_LETMELIVE

/obj/item/circuitboard/hvrc_rail

/obj/item/circuitboard/hvrc_muzzle

/obj/item/circuitboard/hvrc_capacitor

/obj/item/circuitboard/computer/hvrc_control

/*
Suffering which I wish was temp but probably will have to do entirely.
Snowflake weapon datum because this isn't a machinery/ship_weapon subtype due to having no common elements below the machinery layer.
*/

/*
This shouldn't exist but alas it does because single inheritance. Basically, normally these datums link to ship weapon machines but the HVRC is its own type.
AI currently canno use this weapon on their ships. So, don't hand it to them.
*/
/datum/ship_weapon/hvrc_snowflake_weapon
    name = "Railcannons"
    ///List of hvrc cores linked to this ship weapon.
    var/list/linked_hvrc_cores = list()
    lateral = FALSE
    miss_chance = 0
    max_miss_distance = 0

///Always fires forwards on any click. Overrides parent proc. Also fires as fast as you can load and charge the thing.
/datum/ship_weapon/hvrc_snowflake_weapon/special_fire(atom/target, ai_aim)
    . = 2 //Do not let the normal fire proc do anything with this gun. Magicnumbered because FIRE_INTERCETED gets undef'd.
    ///TODO: Do the fancy stuff here.
    for(var/obj/machinery/hvrc/core/linked_core as anything in linked_hvrc_cores)
        if(!linked_core.loaded_slug || linked_core.current_state != HVRC_CHANNELLING)
            continue
        linked_core.fire_proto_slug(get_turf(target))
        break

/datum/ship_weapon/hvrc_snowflake_weapon/proc/transmute_true_projectile(obj/item/projectile/bullet/proto_hvrc/proto_slug)
    var/slug_power = proto_slug.stored_power
    var/slug_speed = HVRC_SPEED_EQUATION(slug_power)
    var/obj/item/projectile/bullet/hvrc/true_slug = holder.fire_projectile(proto_slug.true_projectile_type, proto_slug.preserved_target_turf, FALSE, slug_speed, lateral=lateral, ai_aim=FALSE, miss_chance=miss_chance, max_miss_distance=max_miss_distance)
    true_slug.damage = initial(true_slug.damage) + FLOOR(slug_power / HVRC_POWER_UNITS_PER_DAMAGE, 1)
    if(slug_power > HVRC_MIN_PEN_POWER)
        true_slug.projectile_piercing = ALL
        true_slug.dismemberment = 200
    true_slug.range = min(HVRC_OVERMAP_MAX_RANGE, round(initial(true_slug.range) + (slug_power / HVRC_OVERMAP_POWER_PER_RANGE),1))
    switch(slug_power)
        if(HVRC_MIN_POWER_HEAVY_DAMAGE to INFINITY)
            true_slug.flag = "overmap_heavy"
        if(HVRC_MIN_POWER_MEDIUM_DAMAGE to HVRC_MIN_POWER_HEAVY_DAMAGE)
            true_slug.flag = "overmap_medium"
        else
            true_slug.flag = "overmap_light"


/datum/ship_weapon/hvrc_snowflake_weapon/get_max_ammo()
    return length(linked_hvrc_cores)

/datum/ship_weapon/hvrc_snowflake_weapon/get_ammo()
    . = 0
    for(var/obj/machinery/hvrc/core/linked_core as anything in linked_hvrc_cores)
        if(linked_core.loaded_slug && linked_core.current_state == HVRC_CHANNELLING)
            . += 1

/datum/ship_weapon/hvrc_snowflake_weapon/reload()
    return //No.

/datum/ship_weapon/hvrc_snowflake_weapon/get_loaded_weapon_count()
    . = 0
    for(var/obj/machinery/hvrc/core/linked_core as anything in linked_hvrc_cores)
        if(linked_core.loaded_slug && linked_core.current_state == HVRC_CHANNELLING)
            . += 1

/datum/ship_weapon/hvrc_snowflake_weapon/proc/link_hvrc(obj/machinery/hvrc/core/to_link)
    if(linked_hvrc_cores.Find(to_link))
        return
    linked_hvrc_cores.Add(to_link)
    to_link.linked_gun = src
        

/*
HVRC Particle effect(s)
I have no idea how these actually work so bear with me here.
*/
/particles/hvrc_energized_particles
    color = "#173ff055"
    width = 320
    height = 64
    count = 1000
    spawning = 0 //TODO: Wind up / down when activated / deactived?
    bound1 = list(-1000, -1000, -1000) //-100, -1000, 0?
    bound2 = list(1000, 1000, 1000) //100, 1000, 0? //TODO: Can I use and varchange these to basically go exactly the length of the Cannon?
    gravity = list(0.2, 0) //Relative to power in the gun?
    lifespan = 5 SECONDS
    fade = 0.5 SECONDS
    position = generator("vector", list(16, -16), list(16, 16), NORMAL_RAND)
    velocity = list(0,0)
    scale = generator("vector", list(0.5, 0.5), list(1.0, 1.0), NORMAL_RAND)
    grow = 0 //TODO: Try out some stuff here?
    rotation = 0
    spin = 0 //TODO: Try out some stuff here?
    drift = 0 //Try out some stuff here?
    icon = 'nsv13/icons/effects/generic_particles.dmi' //TODO - testing
    icon_state = "cross"
//TODO: Make particles for the HVRC to release when currently channelling.

#undef HVRC_BROKEN
#undef HVRC_NORMAL
#undef HVRC_CHANNELLING

#undef RAILSTATE_NONE
#undef RAILSTATE_NOMINAL
#undef RAILSTATE_DIVERGING
#undef RAILSTATE_MISALIGNED
