/obj/item/clothing/under/ship
	name = "Placeholder"
	icon = 'nsv13/icons/obj/clothing/uniforms.dmi' //Placeholder subtype for our own iconsets
	worn_icon = 'nsv13/icons/mob/uniform.dmi'
	icon_state = "nothing" //References uniforms.dmi
	worn_icon_state = "nothing" //Icon state for its worn icon, references uniform.dmi
	item_state = "bl_suit"
	can_adjust = FALSE //Can you roll its sleeves down? Default to no to avoid missing icons

/obj/item/clothing/under/ship/officer
	name = "Officer's uniform"
	desc = "A reasonably comfortable piece of clothing made of sweat absorbing materials. This piece of clothing is designed to keep you cool even when sitting at your station for hours on end."
	icon_state = "officer"
	worn_icon_state = "officer"
	item_state = "bl_suit"
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	can_adjust = TRUE

/obj/item/clothing/under/ship/peacekeeper
	name = "Space cop uniform"
	desc = "A smart shirt and pants combo with several badges stitched to it, 'To protect and serve'."
	icon_state = "peacekeeper"
	worn_icon_state = "peacekeeper"
	item_state = "bl_suit"
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30, "stamina" = 30)
	strip_delay = 50
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	can_adjust = TRUE

/obj/item/clothing/under/ship/engineer
	name = "Engineer's jumpsuit"
	desc = "A thick jumpsuit made of insulated materials which is worn by NT's engineering corps, it's rare to see one of these that isn't covered in layers of engine grease."
	icon_state = "engine"
	worn_icon_state = "engine"
	item_state = "bl_suit"
	can_adjust = TRUE

/obj/item/clothing/under/ship/medical
	name = "Doctor's jumpsuit"
	desc = "A durable jumpsuit made of hydrophobic materials which should help keep the blood off."
	icon_state = "medical"
	worn_icon_state = "medical"
	item_state = "bl_suit"

/obj/item/clothing/under/ship/assistant
	name = "Utilitarian coveralls"
	desc = "A slightly ragged but reliable jumpsuit fitted with padding and a few small pockets which has been designed with cost-effectiveness in mind."
	icon_state = "assistant"
	worn_icon_state = "assistant"
	item_state = "bl_suit"

/obj/item/clothing/under/ship/kiryujumpsuit
	name = "Kiryu jumpsuit"
	desc = "A jumpsuit for detectives that wish to look more to the mafia side, however the cigar smell is obvious."
	icon_state = "kiryujumpsuit"
	worn_icon_state = "kiryujumpsuit"
	item_state = "bl_suit"
	can_adjust = TRUE

/obj/item/clothing/suit/ship
	name = "Placeholder"
	icon = 'nsv13/icons/obj/clothing/suits.dmi' //Placeholder subtype for our own iconsets
	worn_icon = 'nsv13/icons/mob/suit.dmi'

/obj/item/clothing/suit/ship/assistant_jacket
	name = "Utility jacket"
	icon_state = "assistant_jacket"
	worn_icon_state = "assistant_jacket"
	desc = "A stylish but heavy jacket designed to protect its wearer from common hazards when serving aboard a ship."
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 10, "fire" = 10, "acid" = 10)

/obj/item/clothing/suit/ship/peacekeeper
	name = "Peacekeeper vest"
	icon_state = "peacekeeper_vest"
	item_state = "peacekeeper_vest"
	desc = "A nanoweave vest capable of impeding most small arms fire as well as improvised weapons. It bears the logo of the North Star peacekeeper force"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 250
	resistance_flags = NONE
	armor = list("melee" = 30, "bullet" = 50, "laser" = 15, "energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 70, "acid" = 90, "stamina" = 30)

/obj/item/clothing/suit/ship/peacekeeper/Initialize(mapload)
	. = ..()
	allowed = GLOB.security_vest_allowed

/obj/item/clothing/suit/ship/peacekeeper/jacket
	name = "Peacekeeper jacket"
	icon_state = "peacekeeper_jacket"
	item_state = "peacekeeper_jacket"
	desc = "A comfortable grey leather jacket. Despite its heavy armour, it's still extremely comfortable to wear."
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list("melee" = 30, "bullet" = 60, "laser" = 15, "energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 70, "acid" = 90, "stamina" = 40)

/obj/item/clothing/suit/ship/peacekeeper/detective
	name = "DET jacket"
	desc = "A smart blue jacket, identifying the wearer as a forensics expert."
	icon_state = "det"
	item_state = "det"
	armor = list("melee" = 30, "bullet" = 40, "laser" = 10, "energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 50)
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/ship/peacekeeper/marine
	name = "NT-4 Marine vest"
	icon_state = "marine"
	item_state = "marine"
	desc = "A bulky vest worn by the colonial peacekeepers. Its nanocarbon mesh fabrics are sure to stop almost any projectile."
	armor = list("melee" = 30, "bullet" = 45, "laser" = 10, "energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 60)

/obj/item/clothing/suit/ship/officer
	name = "Officer's dress jacket"
	desc = "A rather heavy jacket of a reasonable quality. It's not the most comfortable thing you could wear, but it's remained part of an officer's uniform for quite some time."
	icon_state = "officer_jacket"

/obj/item/clothing/suit/ship/engineer
	name = "Engineering webbing"
	desc = "A basic storage vest which allows you to store a few small tools"
	icon_state = "engineer_vest"
	allowed = list(/obj/item/wrench, /obj/item/weldingtool, /obj/item/wirecutters, /obj/item/screwdriver, /obj/item/extinguisher, /obj/item/crowbar, /obj/item/analyzer, /obj/item/multitool, /obj/item/modular_computer/tablet)

/obj/item/clothing/suit/ship/kiryujacket
	name = "Kiryu jacket"
	desc = "A jacket for a detective that wishes to look more to the mafia side, just by looking at it you can smell the cigars that have been smoked with it."
	icon_state = "kiryujacket"
	item_state = "kiryujacket"

/obj/item/clothing/suit/ship/engineer
	name = "Engineering webbing"
	desc = "A basic storage vest which allows you to store a few small tools"
	icon_state = "engineer_vest"
	allowed = list(/obj/item/wrench, /obj/item/weldingtool, /obj/item/wirecutters, /obj/item/screwdriver, /obj/item/extinguisher, /obj/item/crowbar, /obj/item/analyzer, /obj/item/multitool, /obj/item/modular_computer/tablet)

/obj/item/clothing/head/ship
	name = "placeholder"
	icon = 'nsv13/icons/obj/clothing/hats.dmi' //Placeholder subtype for our own iconsets
	worn_icon = 'nsv13/icons/mob/head.dmi'
	icon_state = "beret"
	worn_icon_state = null

/obj/item/clothing/head/soft/assistant_soft
	name = "Utility cap"
	desc = "A rough and uncomfortable cap worn by the unwashed masses of Nanotrasen's naval forces."
	icon = 'nsv13/icons/obj/clothing/hats.dmi' //Placeholder subtype for our own iconsets
	worn_icon = 'nsv13/icons/mob/head.dmi'
	icon_state = "assistantsoft"
	worn_icon_state = "assistant"

/obj/item/clothing/head/ship/marine
	name = "Nt-4 Marine helmet"
	desc = "A large helmet made out of damage resistant materials."
	icon = 'nsv13/icons/obj/clothing/hats.dmi' //Placeholder subtype for our own iconsets
	worn_icon = 'nsv13/icons/mob/head.dmi'
	icon_state = "marine"
	worn_icon_state = null
	armor = list("melee" = 20, "bullet" = 20, "laser" = 10,"energy" = 5, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/head/beret/ship
	name = "beret"
	desc = "A beret, a mime's favorite headwear."
	icon = 'nsv13/icons/obj/clothing/hats.dmi' //Placeholder subtype for our own iconsets
	worn_icon = 'nsv13/icons/mob/head.dmi'
	icon_state = "beret"
	worn_icon_state = null

/obj/item/clothing/head/beret/ship/captain
	name = "captain's beret"
	desc = "An extremely comfortable cotton beret. It is emblazened with Nanotrasen's insignia and is only worn by those who have proven themselves."
	icon_state = "captain"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0, "energy" = 5, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 5)

/obj/item/clothing/head/beret/ship/xo
	name = "XO's beret"
	desc = "A very comfortable beret worn by a ship's second in command. If you're seeing this, you should probably salute"
	icon_state = "xo"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0, "energy" = 5, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 5)

/obj/item/clothing/head/beret/ship/flight_leader
	name = "Flight Leader's beret"
	desc = "A sturdy beret worn by air group commanders, this stunning beret is designed to make flight leaders feel confident in their leadership."
	icon_state = "xo"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0, "energy" = 5, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 5)

/obj/item/clothing/head/beret/ship/engineer
	name = "engineer's beret"
	desc = "In parts a fashion statement and a hard hat, this beret has been specially reinforced to protect its wearer against workplace accidents."
	icon_state = "engineer"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0, "energy" = 5, "bomb" = 10, "bio" = 0, "rad" = 5, "fire" = 30, "acid" = 5)

/obj/item/clothing/head/radiation //CREDIT TO GOON FOR THE SPRITE!
	name = "hazmat hood"
	desc = "A lead lined hood which is guaranteed to keep you safe from harmful nuclear emissions. Recommended by 9/10 nuclear engineers."
	icon = 'nsv13/icons/obj/clothing/hats.dmi' //Placeholder subtype for our own iconsets
	worn_icon = 'nsv13/icons/mob/head.dmi'

/obj/item/clothing/suit/radiation //CREDIT TO GOON FOR THE SPRITE!
	name = "hazmat suit"
	icon = 'nsv13/icons/obj/clothing/suits.dmi' //Placeholder subtype for our own iconsets
	worn_icon = 'nsv13/icons/mob/suit.dmi'

	//Hardsuits
/obj/item/clothing/head/helmet/space/hardsuit/pilot
	name = "fighter pilot helmet"
	icon = 'nsv13/icons/obj/clothing/hats.dmi'
	worn_icon = 'nsv13/icons/mob/head.dmi'
	icon_state = "hardsuit0-pilot"
	item_state = "hardsuit0-pilot"
	hardsuit_type = "pilot"
	desc = "A lightweight space-helmet designed to protect fighter pilots in combat situations."
	armor = list("melee" = 20, "bullet" = 12, "laser" = 10, "energy" = 10, "bomb" = 10, "bio" = 100, "rad" = 50, "fire" = 80, "acid" = 75)

/obj/item/clothing/suit/space/hardsuit/pilot
	name = "fighter pilot flightsuit"
	desc = "A space-proof flightsuit worn by fighter pilots in the Nanotrasen navy. It has been specially reinforced to protect its wearer against most threats."
	icon = 'nsv13/icons/obj/clothing/suits.dmi'
	worn_icon = 'nsv13/icons/mob/suit.dmi'
	icon_state = "pilot"
	item_state = "pilot"
	worn_icon_state = "pilot"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/pilot
	armor = list("melee" = 20, "bullet" = 12, "laser" = 10, "energy" = 10, "bomb" = 10, "bio" = 100, "rad" = 50, "fire" = 90, "acid" = 75)

/obj/item/clothing/under/ship/pilot
	name = "Pilot's combat jumpsuit"
	desc = "A lightweight jumpsuit with harness points and carabiners which is designed to be worn with a pilot's flightsuit."
	icon_state = "pilot"
	worn_icon_state = "pilot"
	item_state = "bl_suit"

/obj/item/clothing/under/ship/pilot/transport
	name = "Pilot's transport jumpsuit"
	desc = "A comfortable lightweight jumpsuit for non-combat positions."
	icon_state = "transport_pilot"
	worn_icon_state = "transport_pilot"
	item_state = "transport_pilot"

/obj/item/clothing/head/beret/ship/pilot
	name = "pilot's beret"
	desc = "In parts a fashion statement and a hard hat, this beret has been specially reinforced to protect its wearer against workplace accidents."
	icon_state = "pilot"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0, "energy" = 5, "bomb" = 10, "bio" = 0, "rad" = 5, "fire" = 30, "acid" = 5)

/obj/item/clothing/head/ship/rising_sun
	name = "headband of the rising sun"
	desc = "DEATH BEFORE DISHONOR! BANZAAAAAI!"
	icon_state = "sun"
	item_state = "sun"
	dynamic_hair_suffix = ""

/obj/item/clothing/accessory/bomber_jacket_accessory
	name = "thin bomber jacket"
	desc = "A cheap, wafer thin replica of a bomber jacket, this would fit on top of most things."
	icon = 'nsv13/icons/obj/clothing/accessories.dmi'
	icon_state = "bomberthin"
	worn_icon_state = "bomberthin"
	item_state = "bomberthin"
	above_suit = TRUE

/obj/item/clothing/head/helmet/transport_pilot
	name = "Transport Pilot's Helmet"
	desc = "A large helmet made for protecting the head and ears."
	icon = 'nsv13/icons/obj/clothing/hats.dmi'
	worn_icon = 'nsv13/icons/mob/head.dmi'
	icon_state = "transport_pilot"
	worn_icon_state = null
	flags_inv = HIDEEARS|HIDEHAIR
	bang_protect = 1
	armor = list("melee" = 20, "bullet" = 20, "laser" = 10,"energy" = 5, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/head/helmet/space/hardsuit/syndi/peacekeeper //Ironic type path. We're inheriting the "dual mode" behaviour from the syndie hardsuit.
	name = "SG-1 Mjolnir Helmet"
	icon = 'nsv13/icons/obj/clothing/hats.dmi'
	worn_icon = 'nsv13/icons/mob/head.dmi'
	icon_state = "hardsuit1-peacekeeper_space"
	item_state = "peacekeeper_space"
	hardsuit_type = "peacekeeper_space"
	desc = "A hardsuit helmet fitted with highly experimental magnetic interlocks, allowing it to create a vacuum seal around the user, permitting usage in a hard vacuum. It is currently in EVA mode."
	alt_desc = "A hardsuit helmet fitted with highly experimental magnetic interlocks, allowing it to create a vacuum seal around the user, permitting usage in a hard vacuum. It is currently in IVA mode."
	armor = list("melee" = 40, "bullet" = 50, "laser" = 15,"energy" = 30, "bomb" = 25, "bio" = 100, "rad" = 50, "fire" = 75, "acid" = 75, "stamina" = 50)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT //we want to see the mask

/obj/item/clothing/suit/space/hardsuit/syndi/peacekeeper
	name = "SG-1 Mjolnir Armour"
	desc = "An extremely bulky suit of armour fitted with highly experimental magnetic interlocks, allowing it to create a vacuum seal around the user, permitting usage in a hard vacuum. It is currently in EVA mode."
	alt_desc = "An extremely bulky suit of armour fitted with highly experimental magnetic interlocks, allowing it to create a vacuum seal around the user, permitting usage in a hard vacuum. It is currently in IVA mode."
	icon = 'nsv13/icons/obj/clothing/suits.dmi'
	worn_icon = 'nsv13/icons/mob/suit.dmi'
	icon_state = "hardsuit1-peacekeeper_space"
	item_state = "peacekeeper_space"
	hardsuit_type = "peacekeeper_space"
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/stock_parts/cell)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/peacekeeper
	armor = list("melee" = 40, "bullet" = 50, "laser" = 15, "energy" = 30, "bomb" = 25, "bio" = 100, "rad" = 50, "fire" = 75, "acid" = 75, "stamina" = 50)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/stomp_cooldown_time = 0.5 SECONDS
	var/current_cooldown = 0
	w_class = WEIGHT_CLASS_BULKY
	supports_variations = NO_VARIATION
	item_flags = NONE
	cm_slowdown = 0.2 //up for debate

/obj/item/clothing/suit/space/hardsuit/syndi/peacekeeper/artifact_immunity()
    return

/obj/item/clothing/suit/space/hardsuit/syndi/peacekeeper/on_mob_move()
	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H.wear_suit != src)
		return
	if(current_cooldown <= world.time) //Deliberately not using a timer here as that would spam create tonnes of timer objects, hogging memory.
		current_cooldown = world.time + stomp_cooldown_time
		var/list/sounds = list('nsv13/sound/effects/footstep/heavy1.ogg','nsv13/sound/effects/footstep/heavy2.ogg','nsv13/sound/effects/footstep/heavy3.ogg')
		playsound(src, pick(sounds), 40, 1)

/obj/item/clothing/suit/space/hardsuit/syndi/peacekeeper/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_OCLOTHING)
		if(listeningTo)
			UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
		return
	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_mob_move))
	listeningTo = user

/obj/item/clothing/suit/space/hardsuit/syndi/peacekeeper/dropped()
	. = ..()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)

/obj/item/clothing/suit/space/hardsuit/syndi/peacekeeper/Destroy()
	listeningTo = null
	return ..()

/obj/machinery/suit_storage_unit/peacekeeper
	suit_type = /obj/item/clothing/suit/space/hardsuit/syndi/peacekeeper
	mask_type = /obj/item/clothing/mask/gas/sechailer
	storage_type = /obj/item/tank/internals/oxygen

/obj/item/clothing/suit/space/syndicate/odst
	name = "drop trooper space suit"
	desc = "A bulky and somewhat primitive space suit with armour plates bolted on. Despite its primitive and jury rigged nature, these suits are worn by Syndicate shock troopers on CQC boarding operations."
	icon = 'nsv13/icons/obj/clothing/suits.dmi'
	worn_icon = 'nsv13/icons/mob/suit.dmi'
	icon_state = "syndicate-space"
	item_state = "syndicate-space"
	worn_icon_state = "syndicate-space"
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/stock_parts/cell)
	slowdown = 1
	resistance_flags = ACID_PROOF
	strip_delay = 12

/obj/item/clothing/head/helmet/space/syndicate/odst
	name = "drop trooper space suit"
	desc = "An ominous space helmet littered with blood red decals and motifs. Wearers of helmets like this should not be taken lightly."
	icon = 'nsv13/icons/obj/clothing/hats.dmi'
	worn_icon = 'nsv13/icons/mob/head.dmi'
	icon_state = "syndicate-space"
	item_state = "syndicate-space"
	worn_icon_state = "syndicate-space"

//Subytype which spawns with a camera for boarders
/obj/item/clothing/head/helmet/space/syndicate/odst/camera/Initialize()
	. = ..()
	install_camera(faction = "Syndicate")

/obj/item/storage/belt/utility/syndicate
	name = "syndicate utility belt"
	desc = "A large, black belt which facilitates tool storage."
	icon_state = "assaultbelt"
	item_state = "security"

/obj/item/storage/belt/utility/syndicate/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.silent = TRUE

/obj/item/storage/belt/utility/syndicate/PopulateContents()
	new /obj/item/screwdriver/nuke(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/crowbar/red(src)
	new /obj/item/wirecutters(src, "red")
	new /obj/item/multitool(src)

/obj/item/clothing/shoes/ship
	name = "Placeholder"
	icon = 'nsv13/icons/obj/clothing/shoes.dmi' //Placeholder subtype for our own iconsets
	worn_icon = 'nsv13/icons/mob/feet.dmi'

/obj/item/clothing/shoes/ship/kiryushoes
	name = "Kiryu shoes"
	desc = "A pair of shoes for the detectives that want to look like mafia, there is some sticky substance on the sole that has formed from various crime scenes."
	icon_state = "kiryushoes"
	item_state = "kiryushoes"

/obj/item/clothing/shoes/clown_shoes/delinquent
	name = "Delinquent's shoes"
	icon = 'nsv13/icons/obj/clothing/shoes.dmi'
	icon_state = "clown_shoes"
	worn_icon = 'nsv13/icons/mob/feet.dmi'
	desc = "A set of pristine white sneakers. Good grief."

/obj/item/clothing/suit/ship/delinquent
	name = "Delinquent's jacket"
	desc = "A modified and probably stolen Nanotrasen academy jacket, adorned with countless badges and references. Good grief."
	icon_state = "clown_suit"
	actions_types = list(/datum/action/item_action/menacing_pose)

/datum/action/item_action/menacing_pose
	name = "Strike a menacing pose"
	button_icon_state = "menacing"
	icon_icon = 'nsv13/icons/mob/actions/actions.dmi'
	var/cooldown = FALSE

/datum/action/item_action/menacing_pose/Trigger()
	if(!IsAvailable())
		return
	pose(owner)
	return TRUE

/datum/action/item_action/menacing_pose/proc/pose(mob/user)
	if(cooldown)
		return
	cooldown = TRUE
	UpdateButtonIcon()
	addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), 10 SECONDS)
	var/message = pick("[user] strikes a menacing pose", "[user] poses menacingly", "[user] looks menacing")
	user.visible_message("<span class='game deadsay'>[message]</span>")
	user.shake_animation()
	for(var/I = 0, I<rand(3,5), I++)
		new /obj/effect/temp_visual/menacing(get_turf(user))

/datum/action/item_action/menacing_pose/proc/reset_cooldown()
	cooldown = FALSE
	UpdateButtonIcon()

/datum/action/item_action/menacing_pose/IsAvailable()
	if(cooldown)
		return FALSE
	return ..()

/obj/item/clothing/suit/ship/delinquent/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, 7 SECONDS, NO_SLIP_WHEN_WALKING)

/obj/item/clothing/under/ship/delinquent
	name = "Delinquent's uniform"
	desc = "An extremely smart looking uniform consisting of a shirt, jumper and pants. Good grief."
	icon_state = "clown_uniform"
	worn_icon_state = "clown_uniform"
	item_state = "bl_suit"

/obj/effect/temp_visual/menacing
	name = "Menacing..."
	icon = 'nsv13/icons/overmap/effects.dmi'
	icon_state = "menacing"
	randomdir = TRUE
	duration = 2 SECONDS

/obj/item/clothing/under/rank/munitions_tech
	name = "camouflage fatigues"
	desc = "A green military camouflage uniform worn by specialists."
	icon_state = "camogreen"
	item_state = "g_suit"
	worn_icon_state = "camogreen"
	can_adjust = FALSE

/obj/item/clothing/under/rank/master_at_arms
	name = "master at arms' jumpsuit"
	desc = "It's a jumpsuit worn by those with the experience to be \"Master At Arms\". It provides minor fire protection."
	icon_state = "tactifool" //PLACEHOLDER
	item_state = "bl_suit"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 50, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 0)

/obj/item/clothing/under/ship/decktech
	name = "munitions tech overalls"
	desc = "a pair of hard worn overalls worn by those in charge of firing the ship's guns. These wouldn't be complete without a thick layer of grease."
	icon_state = "deck_tech"
	item_state = "bl_suit"
	worn_icon_state = "deck_tech"
	can_adjust = TRUE

/obj/item/clothing/head/helmet/decktech
	name = "Munitions Technician's Helmet"
	desc = "A welding helmet for protecting technicians in a hazardous environment."
	icon = 'nsv13/icons/obj/clothing/hats.dmi'
	worn_icon = 'nsv13/icons/mob/head.dmi'
	icon_state = "decktech_helmet"
	item_state = "decktech_helmet"
	actions_types = list(/datum/action/item_action/toggle)
	tint = 2
	flash_protect = 2
	flags_inv = HIDEHAIR|HIDEEYES
	flags_cover = HEADCOVERSEYES
	visor_flags_inv = HIDEEYES
	visor_vars_to_toggle = VISOR_FLASHPROTECT | VISOR_TINT

/obj/item/clothing/head/helmet/decktech/attack_self(mob/user)
	weldingvisortoggle(user)

/obj/item/clothing/suit/ship/munitions_jacket
	name = "Munitions technician jacket"
	desc = "The standard uniform of a Munitions Technician. Contains high vis orange, while remaining black."
	icon_state = "munitions_jacket"
	item_state = "munitions_jacket"

/obj/item/clothing/suit/ship/maa_jacket
	name = "Master-At-Arm's formal jacket"
	desc = "The formal uniform of the Master-At-Arms. Vibrant high vis orange, sleek stylish black."
	icon_state = "maa_jacket"
	item_state = "maa_jacket"

/obj/item/clothing/head/ship/maa_hat
	name = "Master-At-Arm's hat"
	desc = "The Master-At-Arm's authorative hat."
	icon_state = "maa_hat"
	item_state = "maa_hat"

/obj/item/clothing/head/helmet/space/hardsuit/master_at_arms
	name = "Master-At-Arm's Bombsuit Helmet"
	desc = "Use in case of bomb."
	icon = 'nsv13/icons/obj/clothing/hats.dmi'
	worn_icon = 'nsv13/icons/mob/head.dmi'
	icon_state = "hardsuit0-maa"
	hardsuit_type = "maa"
	armor = list("melee" = 20, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 100, "bio" = 100, "rad" = 50, "fire" = 80, "acid" = 65, "stamina" = 10)
	min_cold_protection_temperature = EMERGENCY_HELM_MIN_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/master_at_arms
	name = "Master-At-Arm's Bombsuit"
	desc = "An advanced suit designed for safety when handling explosives."
	icon = 'nsv13/icons/obj/clothing/suits.dmi'
	worn_icon = 'nsv13/icons/mob/suit.dmi'
	icon_state = "maa_bombsuit"
	armor = list("melee" = 20, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 100, "bio" = 100, "rad" = 50, "fire" = 80, "acid" = 65, "stamina" = 10)
	min_cold_protection_temperature = EMERGENCY_SUIT_MIN_TEMP_PROTECT
	slowdown = 1.5
	permeability_coefficient = 0.01
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/master_at_arms




/obj/item/clothing/under/ship/syndicate_tech
	name = "Syndicate technician jumpsuit"
	desc = "A jumpsuit worn by Syndicate technicians, it's been armour plated to protect the wearer in combat scenarios."
	icon_state = "syndicate_tech"
	worn_icon_state = "syndicate_tech"
	item_state = "bl_suit"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30)
	can_adjust = TRUE

/obj/item/clothing/suit/ship/syndicate_crew
	name = "Syndicate jacket"
	desc = "A comfortable, but padded jacket worn by elite officers in the Syndicate navy. Where there would likely be medals on its Nanotrasen counterpart, it instead has space for marking kills."
	icon_state = "syndicate_officer"
	worn_icon_state = "syndicate_officer"

/obj/item/clothing/under/ship/pilot/syndicate
	name = "Syndicate combat jumpsuit"
	desc = "A set of camoflauged fatigues which make up part of a Syndicate uniform."

/obj/item/clothing/neck/cloak/ship
	name = "Placeholder"
	icon = 'nsv13/icons/obj/clothing/neck.dmi' //Placeholder subtype for our own iconsets
	worn_icon = 'nsv13/icons/mob/neck.dmi'
	icon_state = "nothing" //References uniforms.dmi
	worn_icon_state = "nothing" //Icon state for its worn icon, references uniform.dmi
	item_state = ""	//no inhands

//Admiral kit. Credit to Idinuum from Yogstation for most of this!


/obj/item/clothing/head/ship/fleet_admiral
	name = "Admiral's hat"
	desc = "An imposing cap worn by those who are extremely high-up in Nanotrasen's naval corps."
	icon_state = "fleet_admiral"
	worn_icon_state = "fleet_admiral"

/obj/item/clothing/head/beret/ship/admiral
	name = "Admiral's beret"
	desc = "A sturdy beret worn by those holding an admiral rank."
	icon_state = "beret_admiral"
	item_state = "beret_admiral"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0, "energy" = 5, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 5)

/obj/item/clothing/neck/cloak/ship/admiral
	name = "Grand admiral's cloak"
	desc = "A flowing cloak worn by fleet admirals. These cloaks are worn by the absolute elite of Nanotrasen's naval corps. Encountering someone with such a rank is both an extreme priviledge, and a bad omen."
	icon_state = "fleet_admiral"
	worn_icon_state = "fleet_admiral"

/obj/item/clothing/suit/ship/officer/admiral
	name = "Admiral's dress jacket"
	desc = "A hefty and high quality jacket worn by those who bear any admiral rank. It is adorned with countless medals and stamps."
	icon_state = "jacket_admiral"

/obj/item/clothing/suit/ship/officer/admiral/fleet
	name = "Fleet admiral's dress jacket"
	icon_state = "jacket_fleet_admiral"

/obj/item/clothing/suit/ship/officer/admiral/grand
	name = "Grand admiral's dress jacket"
	icon_state = "jacket_grand_admiral"

/obj/item/clothing/under/ship/officer/admiral
	name = "Admiral's uniform"
	icon_state = "admiral"
	worn_icon_state = "admiral"

/obj/item/clothing/under/ship/officer/admiral/fleet
	name = "Fleet admiral's uniform"
	icon_state = "fleet_admiral"
	worn_icon_state = "fleet_admiral"

/obj/item/clothing/under/ship/officer/admiral/grand
	name = "Grand admiral's uniform"
	icon_state = "grand_admiral"
	worn_icon_state = "grand_admiral"

//Solgov uniforms.
/obj/item/clothing/under/ship/solgov
	name = "Solgov cadet uniform"
	desc = "A comfortable uniform worn by officers serving under SolGov's exploratory corps."
	icon_state = "solgov_cadet"
	worn_icon_state = "solgov_cadet"

/obj/item/clothing/under/ship/solgov/command
	name = "Solgov command uniform"
	icon_state = "solgov_command"
	worn_icon_state = "solgov_command"

/obj/item/clothing/under/ship/solgov/engsec
	name = "Solgov engsec uniform"
	icon_state = "solgov_engsec"
	worn_icon_state = "solgov_engsec"

/obj/item/clothing/under/ship/solgov/medsci
	name = "Solgov medsci uniform"
	icon_state = "solgov_medsci"
	worn_icon_state = "solgov_medsci"

/obj/item/clothing/under/ship/solgov/pilot
	name = "Solgov pilot uniform"
	icon_state = "solgov_pilot"
	worn_icon_state = "solgov_pilot"

/obj/item/clothing/under/ship/solgov/admiral
	name = "Solgov admiral uniform"
	icon_state = "solgov_admiral"
	worn_icon_state = "solgov_admiral"

/obj/item/clothing/accessory/solgov_jacket
	name = "uniform jacket"
	desc = "An extremely comfortable jacket with some storage pockets for tools."
	icon = 'nsv13/icons/obj/clothing/accessories.dmi'
//	worn_icon = 'nsv13/icons/mob/accessories.dmi' For some reason this doesn't just work :(
	icon_state = "trekjacket"
	worn_icon_state = "trekjacket"
	item_state = "trekjacket"
	actions_types = list(/datum/action/item_action/nsv13_jacket_swap)
	var/toggled = TRUE //Starts by displaying your departmental colours

/obj/item/clothing/accessory/solgov_jacket/command
	name = "uniform jacket"
	desc = "An extremely comfortable jacket with some storage pockets for tools."
	icon_state = "trekjacket_command"
	worn_icon_state = "trekjacket_command"
	item_state = "trekjacket_command"

/obj/item/clothing/accessory/solgov_jacket/engsec
	name = "uniform jacket"
	desc = "An extremely comfortable jacket with some storage pockets for tools."
	icon_state = "trekjacket_engsec"
	worn_icon_state = "trekjacket_engsec"
	item_state = "trekjacket_engsec"

/obj/item/clothing/accessory/solgov_jacket/medsci
	name = "uniform jacket"
	desc = "An extremely comfortable jacket with some storage pockets for tools"
	icon_state = "trekjacket_medsci"
	worn_icon_state = "trekjacket_medsci"
	item_state = "trekjacket_medsci"

/obj/item/clothing/accessory/solgov_jacket/formal
	name = "XO's dress jacket"
	desc = "An extremely comfortable jacket laced with gold silk, such a piece is usually reserved for diplomatic occasions."
	icon_state = "trekjacket_captain"
	worn_icon_state = "trekjacket_captain"
	item_state = "trekjacket_captain"

/obj/item/clothing/accessory/solgov_jacket/formal/captain
	name = "captain's dress jacket"
	desc = "An extremely comfortable jacket laced with gold silk. Reserved for starship captains and above, it's emblazened with Solgov's crest and signifies grace."
	icon_state = "trekjacket_formal"
	worn_icon_state = "trekjacket_formal"
	item_state = "trekjacket_formal"

/datum/action/item_action/nsv13_jacket_swap
	name = "Toggle jacket style"
	desc = "Display or hide your departmental colours for your suit jacket by reversing its shoulder pads."
	button_icon_state = "jacketswap"
	icon_icon = 'nsv13/icons/mob/actions/actions_spells.dmi'

/obj/item/clothing/accessory/solgov_jacket/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/nsv13_jacket_swap))
		toggle(user)
		return TRUE

/obj/item/clothing/accessory/solgov_jacket/proc/toggle(mob/user)
	if(toggled)
		to_chat(user, "<span class='notice'>You cover up [src]'s departmental colours.</span>")
		icon_state = "trekjacket"
		worn_icon_state = "trekjacket"
		item_state = "trekjacket"
		toggled = FALSE
	else
		to_chat(user, "<span class='notice'>You display [src]'s departmental colours.</span>")
		icon_state = initial(icon_state)
		worn_icon_state = initial(worn_icon_state)
		item_state = initial(item_state)
		toggled = TRUE

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate/admiral
	name = "syndicate admiral's vest"
	desc = "A sinister looking vest of advanced armor worn over a black and red fireproof jacket. The gold collar and shoulders denote that this belongs to a high ranking syndicate officer. This one has been modified to be space proof, and highly resistant to Nanotrasen's laser based weapons."
	icon_state = "syndievest_space"
	worn_icon = 'icons/mob/suit.dmi'
	armor = list("melee" = 60, "bullet" = 70, "laser" = 40, "energy" = 80, "bomb" = 60, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	clothing_flags = THICKMATERIAL | STOPSPRESSUREDAMAGE
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/head/helmet/space/skinsuit
	name = "skinsuit helmet"
	icon = 'icons/obj/clothing/hats.dmi'
	w_class = WEIGHT_CLASS_SMALL //Don't question it. We want it to fit back in the box
	worn_icon = 'icons/mob/head.dmi'
	icon_state = "skinsuit_helmet"
	item_state = "skinsuit_helmet"
	desc = "An airtight helmet meant to protect the wearer during emergency situations."
	permeability_coefficient = 0.01
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 20, "rad" = 0, "fire" = 0, "acid" = 0, "stamina" = 0)
	min_cold_protection_temperature = EMERGENCY_HELM_MIN_TEMP_PROTECT
	heat_protection = NONE
	flash_protect = 0
	bang_protect = 0
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	clothing_flags = STOPSPRESSUREDAMAGE | SNUG_FIT
	max_heat_protection_temperature = 100

/obj/item/clothing/suit/space/skinsuit
	name = "skinsuit"
	desc = "A slim, compression-based spacesuit meant to protect the user during emergency situations. It's only a little warmer than your uniform."
	icon = 'icons/obj/clothing/suits.dmi'
	worn_icon = 'icons/mob/suit.dmi'
	icon_state = "skinsuit_rolled"
	slowdown = 3 //Higher is slower
	w_class = WEIGHT_CLASS_SMALL
	clothing_flags = STOPSPRESSUREDAMAGE
	gas_transfer_coefficient = 0.5
	permeability_coefficient = 0.5
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 10, "rad" = 0, "fire" = 0, "acid" = 0, "stamina" = 0)
	min_cold_protection_temperature = EMERGENCY_SUIT_MIN_TEMP_PROTECT
	heat_protection = NONE
	max_heat_protection_temperature = 100
	var/rolled_up = TRUE

/obj/item/clothing/suit/space/skinsuit/mob_can_equip(mob/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(rolled_up && slot == ITEM_SLOT_OCLOTHING)
		if(equipper)
			to_chat(equipper, "<span class='warning'>You need to unroll \the [src], silly.</span>")
		else
			to_chat(M, "<span class='warning'>You need to unroll \the [src], silly.</span>")
		return FALSE
	return ..()

/obj/item/clothing/suit/space/skinsuit/examine(mob/user)
	. = ..()
	if(rolled_up)
		. += "<span class='notice'>It is currently rolled up.</span>"
	else
		. += "<span class='notice'>It can be rolled up to fit in a box.</span>"


/obj/item/clothing/suit/space/skinsuit/attack_self(mob/user)
	if(rolled_up)
		to_chat(user, "<span class='notice'>You unroll \the [src].</span>")
		icon_state = "skinsuit"
		update_icon()
		w_class = WEIGHT_CLASS_NORMAL
	else
		to_chat(user, "<span class='notice'>You roll up \the [src].</span>")
		icon_state = "skinsuit_rolled"
		update_icon()
		w_class = WEIGHT_CLASS_SMALL

	rolled_up = !rolled_up

/obj/item/clothing/head/maidheadband/syndicate
	name = "tactical maid headband"
	desc = "Tacticute."
	icon = 'nsv13/icons/obj/clothing/hats.dmi'
	worn_icon = 'nsv13/icons/mob/head.dmi'
	icon_state = "syndieheadband"
	item_state = "syndieheadband"

/obj/item/clothing/under/syndicate/maid
	name = "tactical maid outfit"
	desc = "A 'tactical' turtleneck fashioned to the likeness of a maid outfit. Why the Syndicate has these, you'll never know."
	icon = 'nsv13/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'nsv13/icons/mob/uniform.dmi'
	icon_state = "syndimaid"
	item_state = "syndimaid"
	can_adjust = FALSE

/obj/item/clothing/under/syndicate/skirt/maid/Initialize()
	. = ..()
	var/obj/item/clothing/accessory/maidapron/syndicate/A = new (src)
	attach_accessory(A)

/obj/item/clothing/gloves/combat/maid
	name = "combat maid sleeves"
	desc = "These 'tactical' gloves and sleeves are fireproof and electrically insulated. Warm to boot."
	icon = 'nsv13/icons/obj/clothing/gloves.dmi'
	worn_icon = 'nsv13/icons/mob/hands.dmi'
	icon_state = "syndimaid_arms"
	worn_icon_state = "syndimaid_arms"
	item_state = "syndimaid_arms"

/obj/item/clothing/accessory/maidapron/syndicate
	name = "syndicate maid apron"
	desc = "Practical? No. Tactical? Also no. Cute? Most definitely yes."
	icon = 'nsv13/icons/mob/accessories.dmi'
	icon_state = "maidapronsynd"
	item_state = "maidapronsynd"
