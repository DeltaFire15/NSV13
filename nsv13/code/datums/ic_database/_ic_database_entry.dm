

//SDE-WIP: MAKE SURE THESE PASS STATIC DATA TO THE TGUI!! DON'T YOU DARE SENDING THESE REPEATEDLY!!!!!!!!
///Generic database entry. Should be single-instance. Currently unused, but I felt like making more types of IC database info easy to add!
/datum/ic_database_entry
	///name of the entry. Set in here.
	var/entry_name = "UH OH THIS IS THE GENERIC ENTRY NAME"
	///Determines if this entry is aligned to a faction. null = visible by all. Hostile faction entries are only visible after finding them if not of that faction.
	var/entry_faction = null
	///This does not show up in the database unless you have found it, even if you are an enemy faction ship.
	var/secret_entry = FALSE
