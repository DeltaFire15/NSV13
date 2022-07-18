
/**
Ship subsystems - special modules a ship can come installed with which provide unique capabilities.
Usually intended for AI, however commonly also compatible with player ships.
These must always be attached to a ship and should not be destroyed except by the ship itself being destroyed.
Damage may be caused to them, however this merely increases the risk of malfunctions and triggers a period of forced shutdown until repaired after reaching 0 integrity.
**/
/datum/ship_subsystem
    ///Name of this subsystem. Shows on consoles able to view these, once implemented.
    var/name = "Subsystem Basetype - this should not exist"
    ///What overmap object is this subsystem in?
    var/obj/structure/overmap/owner
    ///Ticks every (delay + 1) ship ticks
    var/tick_delay = 0  
    ///The current delay left until activation, after activation is set to tick_delay
    var/current_delay = 0 
    ///Integrity of the subsystem. Completely disabled at 0
    var/system_integrity = 100 
    ///At which integrity or below can malfunctions occur
    var/malfunction_integrity = 50 
    ///Base chance of malfunctions at malfunction_integrity
    var/malfunction_base = 5
    ///By how much does this chance go up per % missing health relative to malfunction_integrity. Example, at 10% below malfunction integrity with value of 1, would be 10% bonus chance.
    var/malfunction_scale = 1
    ///Hard cap on malfunction chance, regardless of scale
    var/malfunction_max = 90
    ///If above 0, prevents activation and decays by 1
    var/force_disable_ticker = 0 
    ///Does this ignore the fact the owner vessel is currently being disrupted? If no, rolls a check simillar to AI ship disruption, although with no cap on probability.
    var/ignores_disruption = FALSE 
    ///How much health is repaired each ship tick if the system is fully disabled
    var/breakdown_repair_per_tick = 0.5
    ///Is the system currently completely nonfunctional due to having suffered critical damage?
    var/breakdown = FALSE


/**
 * Activates a subsystem / performs its action.
 * Prior to this, also checks for if a malfunction might occur.
 * * Returns TRUE if activation succeeded, FALSE if something went wrong.
**/
/datum/ship_subsystem/proc/activate()
    if(malfunction_check())
        malfunction_act()
        return FALSE
    return TRUE

/**
 * Checks for if a subsystem can currently activate.
 * * Returns TRUE if yes, FALSE if not.
**/
/datum/ship_subsystem/proc/can_activate()
    if(force_disable_ticker)
        force_disable_ticker--
        return FALSE
    if(!ignores_disruption && prob(owner.disruption))
        return FALSE
    return TRUE

/**
 * If the malfunction check triggers a malfunction, this happens.
 * By default, adds two ticks of forced subsystem shutdown, although all kinds of things would be possible.
**/
/datum/ship_subsystem/proc/malfunction_act()
    force_disable_ticker += SHSUBSYS_BASE_MALF_DISABLE_TIME
    return TRUE

/**
 * Checks for if a system may be suffering a malfunction.
 * * Returns: TRUE on malfunction trigger, FALSE if not.
**/
/datum/ship_subsystem/proc/malfunction_check()
    if(system_integrity > malfunction_integrity)
        return FALSE
    var/malf_chance = min(malfunction_max, (malfunction_base + ((1 - (system_integrity / malfunction_integrity)) * 100 * malfunction_scale)))
    if(!prob(malf_chance))
        return FALSE
    return TRUE

/**
Called on every slow (~2 seconds) tick of a ship housing a subsystem. Handles tasks, breakdown repair and activation.
**/
/datum/ship_subsystem/proc/process_tick()
    if(breakdown)
        system_integrity = min(initial(system_integrity), system_integrity + breakdown_repair_per_tick)
        if(system_integrity == initial(system_integrity))
            breakdown = FALSE
        return
    if(current_delay > 0)
        current_delay--
        return
    current_delay = tick_delay
    if(!can_activate())
        return
    activate()

/**
Gets called by events which intend to damage one or multiple subsystems. Triggers breakdown if integrity reaches 0.
**/
/datum/ship_subsystem/proc/take_subsystem_damage(damage)
    if(damage == 0)
        return
    system_integrity = CLAMP(system_integrity - damage, 0, initial(system_integrity))
    if(system_integrity == 0)
        breakdown = TRUE


/*
---Subsystem variants go below here for now---
*/

/**
Jamming subsystem - Applies sensor jamming to all non-same-faction ships in system, caps at 20 ship ticks queued.
**/
/datum/ship_subsystem/heavy_jammer
    name = "Heavy Sensor Jammer" //R-WIP - add this to some [undefined] vessels
    tick_delay = 2

/datum/ship_subsystem/heavy_jammer/can_activate()
    . = ..()
    if(!.)
        return
    if(!owner.current_system)
        return FALSE
    return TRUE

/datum/ship_subsystem/heavy_jammer/activate()
    . = ..()
    if(!.)
        return
    for(var/obj/structure/overmap/jamming_target in owner.current_system.system_contents)
        if(jamming_target.faction == owner.faction)
            continue
        jamming_target.sensor_jamming = min(20, jamming_target.sensor_jamming + 5)
    return TRUE

/**
Munitions fabricator with a twist - converts hull matter into ammo - Yes this can destroy the ship. This one is intended for fighters so it eats a pretty high hull percentage.
* * Rearm priority: Heavy - Torpedoes - Missiles - Light
**/
/datum/ship_subsystem/unsafe_ammo_replicator
    name = "Aggressive Munitions Replicator" //R-WIP - add this to [undefined] fighters
    tick_delay = 4
    ///Eats this much of the hull in percent per resupply
    var/hull_percent_per_resupply = 10

/datum/ship_subsystem/unsafe_ammo_replicator/can_activate()
    . = ..()
    if(!.)
        return
    if(initial(owner.shots_left) > 0 && !owner.shots_left)
        return TRUE
    if(initial(owner.torpedoes) > 0 && !owner.torpedoes)
        return TRUE
    if(initial(owner.missiles) > 0 && !owner.missiles)
        return TRUE
    if(initial(owner.light_shots_left) > 0 && !owner.light_shots_left)
        return TRUE
    return FALSE

/datum/ship_subsystem/unsafe_ammo_replicator/activate()
    . = ..()
    if(!.)
        return
    if(initial(owner.shots_left) > 0 && !owner.shots_left)
        owner.shots_left = initial(owner.shots_left)
        owner.take_damage(owner.max_integrity / 100 * hull_percent_per_resupply, ignores_shields = TRUE)
        return TRUE
    if(initial(owner.torpedoes) > 0 && !owner.torpedoes)
        owner.torpedoes = initial(owner.torpedoes)
        owner.take_damage(owner.max_integrity / 100 * hull_percent_per_resupply, ignores_shields = TRUE)
        return TRUE
    if(initial(owner.missiles) > 0 && !owner.missiles)
        owner.missiles = initial(owner.missiles)
        owner.take_damage(owner.max_integrity / 100 * hull_percent_per_resupply, ignores_shields = TRUE)
        return TRUE
    if(initial(owner.light_shots_left) > 0 && !owner.light_shots_left)
        owner.light_shots_left = initial(owner.light_shots_left)
        owner.take_damage(owner.max_integrity / 100 * hull_percent_per_resupply, ignores_shields = TRUE)
        return TRUE
    return FALSE


/**
The much safer friend of the above munitions fabricator - Slowly fabricates ammo at no disadvantage. Intended for larger vesels.
* * Rearm priority: Torpedoes - Missiles - Heavy - Light
**/
/datum/ship_subsystem/ammunition_forge
    name = "Automated Munitions Forge" //R-WIP - add this to [undefined] capital ships
    tick_delay = 9  //Preetty slow

/datum/ship_subsystem/ammunition_forge/can_activate()
    . = ..()
    if(!.)
        return
    if(initial(owner.torpedoes) > 0 && owner.torpedoes < initial(owner.torpedoes))
        return TRUE
    if(initial(owner.missiles) > 0 && owner.missiles < initial(owner.missiles))
        return TRUE
    if(initial(owner.shots_left) > 0 && owner.shots_left < initial(owner.shots_left))
        return TRUE
    if(initial(owner.light_shots_left) > 0 && owner.light_shots_left < initial(owner.light_shots_left))
        return TRUE
    return FALSE

/datum/ship_subsystem/ammunition_forge/activate()
    . = ..()
    if(!.)
        return
    //Basically, how likely something is to be printed is determined by how important it is (the multiplier) and how low the percentage of ammo left is
    var/torp_weight = initial(owner.torpedoes) > 0 ? round(8 * (owner.torpedoes / initial(owner.torpedoes)) * 100) : 0
    var/missile_weight = initial(owner.missiles) > 0 ? round(6 * (owner.missiles / initial(owner.missiles)) * 100) : 0
    var/heavy_ammo_weight = initial(owner.shots_left) > 0 ? round(4 * (owner.shots_left / initial(owner.shots_left)) * 100) : 0
    var/light_ammo_weight = initial(owner.light_shots_left) > 0 ? round(2 * (owner.light_shots_left / initial(owner.light_shots_left)) * 100) : 0
    var/list/weightlist = list("torpedoes" = torp_weight, "missiles" = missile_weight, "heavy_ammo" = heavy_ammo_weight, "light_ammo" = light_ammo_weight)
    var/fab_pick = pickweight(weightlist)
    switch(fab_pick)
        if("torpedoes")
            owner.torpedoes = min(initial(owner.torpedoes), owner.torpedoes + 4) //Fabs 4 torps..
            return TRUE
        if("missiles")
            owner.missiles = min(initial(owner.missiles), owner.missiles + 8) //..or 8 missiles..
            return TRUE
        if("heavy_ammo")
            owner.shots_left = min(initial(owner.shots_left), owner.shots_left + 6) //..or 6 shells..
            return TRUE
        if("light_ammo")
            owner.shots_left = min(initial(owner.light_shots_left), owner.light_shots_left + 50) //..or 50 shots worth of light munitions.
            return TRUE
    return FALSE

/**
Autorepair unit that repairs a ship's hull at reasonable pace - no effect on armor.
**/
/datum/ship_subsystem/autorepair_unit
    name = "Automated Repair Unit" //R-WIP - add this to most [undefined] ships except fighters, maybe some important non-[undefined] too
    var/repair_amount = 5

/datum/ship_subsystem/autorepair_unit/can_activate()
    . = ..()
    if(!.)
        return
    if(owner.obj_integrity >= owner.max_integrity)
        return FALSE
    return TRUE

/datum/ship_subsystem/autorepair_unit/activate()
    . = ..()
    if(!.)
        return
    owner.obj_integrity = min(owner.max_integrity, owner.obj_integrity + repair_amount)
    return TRUE
