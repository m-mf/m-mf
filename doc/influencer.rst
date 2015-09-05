m&mf Influencer
======================
The influencer handles all kinds of influencing for you - guard stacks, events and so on.

It can either influence everything in the room for you with the best type, automatically, with *inf all*, or you can influence a specific thing by doing *empower/paranoia/weaken/charity/village/seduction/seduce/amnesty thing*. Use *village* for village revolts!

To automatically drain esteem into a figurine, provide the figurine ID with *mmconfig figurine #*.

You can skip influencing a thing with inf stop, or stop influencing everything altogether with inf stopall.

Aliases
^^^^^^^^
.. glossary::

  inf all
    Influences the whole room using the best type of influencing for the NPCs.

  inf clear uninfluencable
    The script remembers things it can't influence so it won't try to influence them all the time - however you can clear its memory in case you need to with this alias.

  empower/paranoia/weaken/charity/village/seduction/seduce/amnesty <npc>
    Influences one NPC with the given mode of attack.

  village <npc>
    Influences an NPC for village revolts with your org-appropriate attacks.

  mmconfig figurine #
    Automatically drains essence after every NPC influenced into a figurine. Set the ID to 0 if you'd like it to stop doing that.

