Quake Reignited makes a few changes to co-op that allows for a smoother experience. This includes an entirely new co-op type
alongside the ability to play vanilla co-op. To set this, usage of the console "coop" variable is needed. Note that any changes
require a map change to update:

•coop 1 - Quake Reignited co-op (default when starting a co-op game normally)

•coop 2 - Vanilla co-op

There are several flags available that allow for more customization. To set these, take the current coop value and add the given
number to it:

•Flags that affect both types

	•+8 - Disable respawning (map restarts if a player dies)
	
	•+16 - Disable friendly fire damage
	
•Flags that affect Quake Reignited co-op only

	•+32 - Respawn where died (unless unsafe to do so)
	
	•+64 - Share weapons with all players on pick up

For instance, if you wanted to disable respawning and friendly fire in a session, it would be:

•coop 1 + 8 + 16 = coop 25

If playing with respawning where died enabled, the "kill" console command will forcibly set the player back to spawn. This can be
used in case a player gets stuck at any point.

General changes made to Quake Reignited co-op:

•Players are given 3 seconds of invulnerability on respawn

•Keys are now shared with all players on pick up

•Keys are now taken away from all players when used and the corresponding picked up key is removed from the map

•Backpacks will no longer drop. Instead, players will keep their current inventory on respawn

	•If respawning disabled, resets back to the state players entered the map with similar to single player

•Common items will now remain in the map until all players have picked them up at least once. Players cannot pick up duplicates

•Rising platforms that require a player to stand on them to activate now have a 1 second delay