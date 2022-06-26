
/datum/ship_subsystem
    var/obj/structure/overmap/owner
    var/tick_delay = 0  ///Ticks every (delay + 1) ticks
    var/system_integrity = 100 ///Integrity of the subsystem. Completely disabled at 0
    var/malfunction_integrity = 50 ///At which integrity or below can malfunctions occur
    var/malfunction_base = 5 ///Base chance of malfunctions at malfunction_integrity
    var/malfunction_scale = 1 ///By how much does this chance go up per % missing health relative to malfunction_integrity. Example, at 10% below malfunction integrity with value of 1, would be 10% bonus chance.
    var/malfunction_max = 90 ///Hard cap on malfunction chance, regardless of scale
    var/force_disable_ticker = 0 ///If above 0, prevents activation and decays by 1
    var/ignores_disruption = FALSE ///Does this ignore the fact the owner vessel is currently being disrupted? If no, rolls a check simillar to AI ship disruption, although with no cap on probability.

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
    force_disable_ticker += 2
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
