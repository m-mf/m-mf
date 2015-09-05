m&mf People Tracker
======================
Just use any of the people-locating methods - scent, window - it'll plot people on your map.

You can disable it or easily change color of labels in it's **mmconfig2** menu entry, along with the font size of labels.

The script works in tandem with the `Mudlet Mapper script <http://wiki.mudlet.org/w/IRE_mapping_script#Download>`_, and thus the latest version is required - or **12.5.10 at minimum**!

* if it's not possible to tell where exactly a person is, like when they're in a room with a non-unique name, then it'll put identifiers into all rooms that match and only put the list of people in the right-most room. This seems the best way to deal with this problem so far, but if you have better ideas let me know

Comprehensive guide to setting this up
----------------------------------------
1) **Get the map open** - press the Map button in Mudlet or *Toolbox → Show map* to spawn it. If you'd always like the map showing, `this script <http://wiki.mudlet.org/w/Mudlet_Mapper>`_ will help you do that. Don't worry if the map doens't track you / says invalid position or etc right now.

2) **Get the mapper script** - `go here <http://wiki.mudlet.org/w/IRE_mapping_script>`_ and install this script. If you already have it, remove it and install it - it is updated very often. After you install it, reconnect - that way it will know you're connected to Lusternia, and not another game.

3) **Get the map** - after you reconnected, opening the map should automatically download the map from the game - and you'll be set.

Aliases
^^^^^^^^
.. glossary::

  mmconfig2
    See its options - enable/disable, change color or font size.

  mmconfig labelsize <font size>
    Sets the size of the labels to use on the map. Default size is 10.

  mmconfig clearlabels yep/nope
    When enabled, this will automatically clear all labels on the map that are surrounded with () - so the ones that the peopletracker put on - when you move into a new area.

  mmconfig labelcolor <color>
    Allows you to choose the color of peopletrackers labels on the map.

  mmconfig labelsfont <font size>
    Sets the font size of the labels on the map.

  gotop
    Walks over to where your target (as defined by the 'target' variable) was known to be last.

  gotop <person>
    Walks over to where the person was known to be last.

  mstop
    stops walking from goto and gotop.

  <class locating ability, like scent or window>
    Plots that invididual on the map as you locate them.
