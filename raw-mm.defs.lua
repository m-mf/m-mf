-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

pl.dir.makepath(getMudletHomeDir() .. "/m&m/defup+keepup")

--[[ a small dictionary to know which defences belong to which skillset ]]
defences.def_types = {}

-- the list from 'def'
defences.def_def_list = {}
defences.defup_timer = createStopWatch()

function defences.gettime(defence, max)
  if not defc[defence] or not dict[defence] or not dict[defence].stopwatch then debugf("no %s or it doesn't have stopwatch", tostring(defence)) return "" end

  local time = max-math.ceil(getStopWatchTime(dict[defence].stopwatch)/max)
  if time < 0 then return "" else
    return time.."m"
  end
end

-- functions to handle the defc table events updates
function defences.got(def)
  if not defc[def] then defc[def] = true; raiseEvent("m&m got def", def) end
end

function defences.lost(def)
  if defc[def] then defc[def] = false; raiseEvent("m&m lost def", def) end
end

-- custom def types like songs or spiritbonds
defences.custom_types = {}

defences.nodef_list = phpTable()

defdefup = {
  basic = {},
  combat = {},
  empty = {}
}

defkeepup = {
  basic = {},
  combat = {},
  empty = {}
}

defs.mode = "basic"

-- defc = current defs

defs_data = phpTable({
  kirigami = { type = "general",
    def = "You are blessed with the origami charm of kirigami.",
    off = "A swirling energy suddenly manifests around you and collapses inward, briefly taking the shape of a kirigami before it vanishes, leaving you curiously refreshed.",
    onr = [[^You release .+ and it flutters into the air and around you, its kirigami charm dissolving into the air around you as the vellum disappears in tiny motes of dust\.$]],
    onshow = function ()
      return defences.gettime("kirigami", 60) end,
    tooltip = "+5 DMP and an improved crit rate"},
  wetfold = { type = "general",
    def = "You are blessed with the origami charm of wet fold origami.",
    off = "A swirling energy suddenly manifests around you and collapses inward, briefly taking the shape of a wet fold origami before it vanishes, leaving you curiously refreshed.",
    onr = [[^You release .+ and it flutters into the air and around you, its wet fold origami charm dissolving into the air around you as the vellum disappears in tiny motes of dust\.$]],
    onshow = function ()
      return defences.gettime("wetfold", 60) end,
    tooltip = "Boosts influencing and increases esteem gain"},
  truetime = { type = "general",
    off = "You feel less protected against variations in time.",
    onshow = function ()
      return defences.gettime("wetfold", 5) end,
    def = "You are slightly protected against shifting time.",
    onr = [[^You quickly wind up .+? as tightly as you can\. The hands on .+? begin to spin faster and faster and time, itself, seems to distort around you\.$]]
    },
  holylight = {
    nodef = true,
    ondef = function () return matches[2] end,
    defr = [[^You have (\d+) globes of Holy Light entwined with your soul\.$]],
  },
  frost = { type = "general", def = "You are tempered against fire damage.",
    on = "A chill runs over your icy skin.",
    off = "Forks of flame lick against your skin, melting away your protection against fire."},
  nightsight = { type = "general", def = "Your vision is heightened to see in the dark.",
    on = {"Your vision sharpens with light as you gain night sight.", "Your eyes are already attuned to the shadows of night."}},
  deathsight = { type = "general",
    on = {"You touch the cosmos and allow your eyes to pierce through the veil of death.", "You shut your eyes and concentrate on the end of life. A moment later, you feel inextricably linked with the strings of fate.", "You already are seeing death.", "Your mind is already linked to the strings of fate."}},
  thirdeye = { type = "general", def = "You are viewing the world through the third eye.",
    on = {"You now possess the gift of the third eye.", "You already possess the thirdeye."}},
  lovedef = { type = "general",
    invisibledef = true,
    on = "Mmmm! You are seized with a sudden desire to find a mate!",
    off = "What were you thinking? You have no desire to find a mate."},
  lipread = {
    type = "general",
    def = "You are lipreading to overcome deafness.",
    on = {"You are already lipreading.", "You will now lip read to overcome the effects of deafness."},
    specialskip = function ()
      return (affs.blind and not defc.trueblind)
    end
  },
  keeneye = { type = "general",
    on = {"You begin to examine your surroundings with a keen eye.", "You are already alerted by a keen eye."},
    def = "You are observing with a keen eye.",
    tooltip = "Shows whenever venoms have been delivered successfully",
    off = {"You cease using your keen eye.", "You are not currently alerted by a keen eye."}},
  obliviousness = { type = "general", mana = "little",
    on = {"You will yourself to become oblivious to your surroundings.", "You already are oblivious to your surroundings."},
    off = {"You allow yourself to become aware of your surroundings.","You aren't oblivious to your surroundings."}},
  metawake = { type = "general", def = "You are concentrating on maintaining distance from the dreamworld.",
    mana = "lots",
    off = "You cease concentrating on maintaining distance from the dreamworld.",
    on = {"You order your mind to ensure you will not journey far into the dreamworld.", "You already have metawake turned on."},
    off = {"You cease concentrating on maintaining distance from the dreamworld.", "You already have metawake turned off."}},
  yoyo = { type = "general",
    def = "You are carrying a noisy clockwork yoyo.",
    on = {"You deftly unroll a noisy clockwork yoyo which begins spinning rapidly.", "You are already spinning your yoyo."},
    off = {"You catch a noisy clockwork yoyo as it spins up and into your hands.", "You are not spinning your yoyo."}},
  protection = { type = "general",
    offr = [[^\w+ dissolves the shimmering field around you\.$]]},
  breath = { type = "general" },
  selfishness = { type = "general", def = "You are feeling quite selfish.",
    on = {"You rub your hands together greedily.", "You already are a selfish bastard."},
    off = {"A feeling of generosity spreads throughout you.", "No worries. You're not a selfish bastard as is."}},
  attune = { type = "general",
    nodef = true,
    ondef = function () return matches[2]:gsub("(%w)(%w+) (%w+)", "%1%3") end,
    defr = [[^You are attuned to being in the (.+) environment\.$]], },
  riding = { type = "general",
    ondef = function ()
      if tostring(conf.ridingsteed) and tostring(conf.ridingsteed):match("([A-Za-z]+)") and string.find(matches[2], tostring(conf.ridingsteed):match("([A-Za-z]+)"), nil, true) then
        return "("..tostring(conf.ridingsteed):match("([A-Za-z]+)")..")"
      else
        return "("..matches[2]..")"
      end
    end,
    defr = [[^You are riding (.+)\.$]],
    onr = {[[^You climb up on .+\.$]], [[^You easily vault onto the back of .+\.$]]},
    on = {"You must dismount before you can mount anything else.", "You must dismount from what you are currently riding before you can mount anything else."},
    offr = {[[^You step down off of .+\.$]], [[^You lose purchase on .+\.$]]},
    off = {"You are not currently riding anything."}
  },
  alacrity = { nodef = true,
    def = "You are surrounded by a field of alacrity."},
  redgenies = { type = "artifact",
    on = {"Four genies burst out of their bottles, whirling around you as they wrap you in ribbons of multicoloured light. Your health swells as the blessing of the genies settle around you.", "You already have a curio health blessing!"},
    def = "You have a curio health blessing.",
    tooltip = "Add a 1/8 boost to health"},
  bluegenies = { type = "artifact",
    on = {"Four genies burst out of their bottles, whirling around you as they wrap you in ribbons of multicoloured light. Your mana swells as the blessing of the genies settle around you.", "You already have a curio mana blessing!"},
    def = "You have a curio mana blessing.",
    tooltip = "Adds a 1/8 boost to mana"},
  yellowgenies = { type = "artifact",
    on = {"Four genies burst out of their bottles, whirling around you as they wrap you in ribbons of multicoloured light. Your ego swells as the blessing of the genies settle around you.", "You already have a curio ego blessing!"},
    def = "You have a curio ego blessing.",
    tooltip = "Adds a 1/8 boost to ego"},
  catsluck = { type = "artifact",
    on = {"You are now protected by the catsluck defence.","You feel an aura of luck surround you."},
    def = "Cat's Luck (catsluck) (indefinite).",
    tooltip = "boosts critical hits",
    },
  mint = { type = "artifact",
    on = "You are now protected by the mint defence.",
    off = "Your mint defence has expired.",
    defr = [[^Mint Candy \(mint\) \(\d+ minutes\)\.]],
    tooltip = "provides 10% ego boost during influencing, last 1 hour."},
  gumball = { type = "artifact",
    on = "You are now protected by the gumball defence.",
    off = "Your gumball defence has expired.",
    defr = [[^Gumball Candy \(gumball\) \(\d+ minutes\)\.]],
    tooltip = "provides 10% chance of forming a shield during bashing, last 1 hour."},
  fireball = { type = "artifact",
    on = "You are now protected by the fireball defence.",
    off = "Your fireball defence has expired.",
    defr = [[^Fireball Candy \(fireball\) \(\d+ minutes\)\.]],
    tooltip = "provides 10% chance of releasing firebreath attack during bashing, last 1 hour."},
  rockcandy = { type = "artifact",
    on = "You are now protected by the rockcandy defence.",
    off = "Your rockcandy defence has expired.",
    defr = [[^Rock Candy \(rockcandy\) \(\d+ minutes\)\.]],
    tooltip = "gives moderate rooting bonus, last 1 hour."},
  licorice = { type = "artifact",
    on = "You are now protected by the licorice defence.",
    off = "Your licorice defence has expired.",
    defr = [[^Licorice Candy \(licorice\) \(\d+ minutes\)\.]],
    tooltip = "provides 3/13 health buff, last 1 hour."},
  jellybaby = { type = "artifact",
    on = "You are now protected by the jellybaby defence.",
    off = "Your jellybaby defence has expired.",
    defr = [[^Jelly Baby Candy \(jellybaby\) \(\d+ minutes\)\.]],
    tooltip = "provides 3/13 mana buff, last 1 hour."},
  creamchew = { type = "artifact",
    on = "You are now protected by the creamchew defence.",
    off = "Your creamchew defence has expired.",
    defr = [[^Cream Chew Candy \(creamchew\) \(\d+ minutes\)\.]],
    tooltip = "provides 3/13 ego buff, last 1 hour."},
  waxlips = { type = "artifact",
    on = "You are now protected by the waxlips defence.",
    off = "Your waxlips defence has expired.",
    defr = [[^Wax Lips Candy \(waxlips\) \(\d+ minutes\)\.]],
    tooltip = "provides 25% xp bonus, last 1 hour."},
  redlollipop = { type = "artifact",
    on = "You are now protected by the redlollipop defence.",
    off = "Your redlollipop defence has expired.",
    defr = [[^Red Lollipop Candy \(redlollipop\) \(\d+ minutes\)\.]],
    tooltip = "provides 5/5 balance buff, lasts 1 minute."},
  bluelollipop = { type = "artifact",
    on = "You are now protected by the bluelollipop defence.",
    off = "Your bluelollipop defence has expired.",
    defr = [[^Blue Lollipop Candy \(bluelollipop\) \(\d+ minutes\)\.]],
    tooltip = "provides 5/5 equilibrium buff, lasts 1 minute."},
  faerie = { nodef = true,
    def = "You are wearing a pair of faerie wings."},
  gravity = { nodef = true,
    def = "You are surrounded by an aura of divine gravity.",
    tooltip = "Causes slower movement for Order enemies in the room with you"},
  bluntdef = { nodef = true,
    ondef = function () return string.format("(%dh %dm)", matches[2], matches[3]) end,
    defr = [[^You are resisting blunt damage for another (\d+) hours and (\d+) minutes\.$]],
    tooltip = "Blunt damage resistance" },
  magicaldef = { nodef = true,
    ondef = function () return string.format("(%dh %dm)", matches[2], matches[3]) end,
    defr = [[^You are resisting magical damage for another (\d+) hours and (\d+) minutes\.$]],
    tooltip = "Magical damage resistance" },
  firedef = { nodef = true,
    ondef = function () return string.format("(%dh %dm)", matches[2], matches[3]) end,
    defr = [[^You are resisting fire damage for another (\d+) hours and (\d+) minutes\.$]],
    tooltip = "Fire damage resistance" },
  poisondef = { nodef = true,
    ondef = function () return string.format("(%dh %dm)", matches[2], matches[3]) end,
    defr = [[^You are resisting poison damage for another (\d+) hours and (\d+) minutes\.$]],
    tooltip = "Poison damage resistance" },
  asphyxdef = { nodef = true,
    ondef = function () return string.format("(%dh %dm)", matches[2], matches[3]) end,
    defr = [[^You are resisting asphyxiating damage for another (\d+) hours and (\d+) minutes\.$]],
    tooltip = "Asphyxiating damage resistance" },
  asphyxdef = { nodef = true,
    ondef = function () return string.format("(%dh %dm)", matches[2], matches[3]) end,
    defr = [[^You are resisting asphyxiating damage for another (\d+) hours and (\d+) minutes\.$]],
    tooltip = "Asphyxiating damage resistance" },
  electricdef = { nodef = true,
    ondef = function () return string.format("(%dh %dm)", matches[2], matches[3]) end,
    defr = [[^You are resisting electrical damage for another (\d+) hours and (\d+) minutes\.$]],
    tooltip = "Electrical damage resistance" },
  psychicdef = { nodef = true,
    ondef = function () return string.format("(%dh %dm)", matches[2], matches[3]) end,
    defr = [[^You are resisting psychic damage for another (\d+) hours and (\d+) minutes\.$]],
    tooltip = "Psychic damage resistance" },
  divinusdef = { nodef = true,
    ondef = function () return string.format("(%dh %dm)", matches[2], matches[3]) end,
    defr = [[^You are resisting divinus damage for another (\d+) hours and (\d+) minutes\.$]],
    tooltip = "Divinus damage resistance" },

  xpboost = { nodef = true,
    ondef = function () return "("..matches[2]..")" end,
    defr = [[^You are experiencing a (\d+) percent experience boost\.$]] },
  xpbonus = { nodef = true,
    ondef = function () return "("..matches[2]..")" end,
    defr = [[^You are benefiting from a (\d+)% experience bonus\.$]] },
  perfume = { nodef = true,
    ondef = function () return "("..matches[2]..")" end,
    defr = [[^You are lightly coated with a layer of (jasmine|vanilla|dragonsblood|sandalwood|musk)\.$]]
  },
  spirits = { nodef = true,
    ondef = function () return "("..matches[2]..")" end,
    defr = [[^You have (\d+) spirits caught within your aura of death\.$]]
  },
  blessings = { nodef = true,
    ondef = function () return "("..matches[2]..")" end,
    defr = [[^You have (\d+) blessings upon your Aura of Salvation\.$]]
  },
  immune = { nodef = true,
    ondef = function () return "("..matches[2]..")" end,
  },
  role = { nodef = true,
    defr = [[^You are performing the role of a (.+)\.$]],
    ondef = function () return "("..matches[2]..")" end,
  },
  ["cement socks"] = { nodef = true,
    def = "You are wearing cement socks, giving you great summon resistance.",
    tooltip = "adds rooting at the cost of celerity"
  },
  anamnesis = {nodef = true,
    defr = [[^You are recalling your past life as an? (\w+)\.$]],
    ondef = function () return "("..matches[2]..")" end,
  },
  wondermask = {nodef = true,
    defr = [[^You are wearing a Wonder Mask with a (\w+) face\.$]],
    ondef = function () return "("..matches[2]:lower()..")" end,
    },
  haircurio = {nodef = true,
    def = "Your influencing is buffed by hair! Glorious hair!"
  },
  gestalt = { nodef = true,
    defr = [[^You have a \w+ gestalt composed of \w+ ikons\.$]]
  },
  ["poteen xp"] = { nodef = true,
    defr = [[^You burped up increased experience gain for \d+ minutes\.$]]
  },
  ["poteen karma"] = { nodef = true,
    defr = [[^You burped up increased karma gain for \d+ minutes\.$]]
  },
  ["poteen mana"] = { nodef = true,
    defr = [[^You burped up increased mana for \d+ minutes\.$]],
    tooltip = "Adds a 1/8 mana bonus",
  },
  healaura = { nodef = true,
    ondef = function () return "("..matches[2]..")" end,
    tooltip = "Passively cures afflictions from a given affliction set",
    defr = [[^You are surrounded by a healing (\w+) aura\.$]]
  },
  stance = { nodef = true,
    ondef = function () return "("..matches[2]..")" end,
    tooltip = "Adds a minimal chance of defending an attack against the limbs being protected.",
    defr = [[^Your fighting stance is defending your (\w+)(?: \w+)?\.$]]
  },
  forsaken = { nodef = true,
    def = "You are blessed by the Forsaken.",
    tooltip = "+20 psychic DMP"},
  drunkard = { nodef = true },
  sober = { nodef = true },
  wounded = { nodef = true },
  genderbend = { nodef = true },
  lawyerly = { nodef = true },
  zealotry = { nodef = true },
  saintly = { nodef = true },
  powermask = { nodef = true },
  bloodrage = { nodef = true },
  curiodef = { nodef = true,
    defr = {[[^You are using a curio for (\d+) (\w+) damage absorption\.]], [[^You are using a curio for (\d+) (\w+) & (\d+) (\w+) damage absorption\.$]]},
    ondef = function () return string.format("(%d %s%s)", matches[2], matches[3], (matches[4] and ", "..matches[4].." "..matches[5] or '')) end,
  },
  curioatk = { nodef = true,
    defr = {[[^You are using a curio for (\d+) (\w+) damage enhancement\.$]],
            [[^You are using a curio for 1 (\w+) \& 1 (\w+) damage enhancement\.$]]},
    ondef = function ()
      if tonumber(matches[2]) then
        return string.format("(%d %s)", matches[2], matches[3])
      else
        return string.format("(%s/%s)", matches[2], matches[3])
      end
    end,
  },
  curiofood = { nodef = true,
    defr = [[^You will receive a Level (\d+) Critical Hit Bonus \(Blessed Food\)\.$]],
    ondef = function () return string.format("(%d)",matches[2]) end,
    },
  wigcurio = { nodef = true,
    def = "Your influencing is buffed by hair! Glorious hair!."
  },
  enigmaticeye = { nodef = true,
    def = "You have opened your third eye.",
    tooltip = "Insanity protection and illusion detection",
  },
  timesense = { nodef = true,
    def = "You are more aware of the passage of time.",
  },
  lichseed = { nodef = true,
    def = "Your body is prepared for lichdom when death comes knocking."},
  noetics = { nodef = true,
    def = "You are under the influence of divine Noetics." },
  decease = { nodef = true,
    def = "You have incredibly thickened skin.",
    tooltip = "+35 physical DMP"},
  wondercornbal = { type = "artifact",
    on = {"Your balance is enhanced by the fine food.", "You feel completely enhanced by the fine food."},
    def = "Your balance has been enhanced through fine food.",
    tooltip = "Adds 1/3 boost to balance, doesn't stack with herofete"},
  wondercornhp = { type = "artifact",
    on = {"Your health is enhanced by the fine food.", "You feel completely enhanced by the fine food."},
    def = "Your health has been enhanced through fine food.",
    tooltip = "adds 1/5 boost to health, doesn't stack with herofete"},
  wondercornmp = { type = "artifact",
    on = {"Your mana is enhanced by the fine food.", "You feel completely enhanced by the fine food."},
    def = "Your mana has been enhanced through fine food.",
    tooltip = "adds 1/5 boost to mana, doesn't stack with herofete"},
  wondercornego = { type = "artifact",
    on = {"Your ego is enhanced by the fine food.", "You feel completely enhanced by the fine food."},
    def = "Your ego has been enhanced through fine food.",
    tooltip = "adds 1/5 boost to ego, doesn't stack with herofete"},
  wondercornres = { type = "artifact",
    on = {"Your resistance is enhanced by the fine food.", "You feel completely enhanced by the fine food."},
    def = "Your resistance has been enhanced through fine food.",
    tooltip = "adds 1/3 boost to resistance, doesn't stack with herofete"},
  wondercorndam = { type = "artifact",
    on = {"Your damage is enhanced by the fine food.", "You feel completely enhanced by the fine food."},
    def = "Your damage has been enhanced through fine food.",
    tooltip = "adds 1/3 boost to damage, doesn't stack with herofete"},
  wondercorneq = { type = "artifact",
    on = {"Your equilibrium is enhanced by the fine food.", "You feel completely enhanced by the fine food."},
    def = "Your equilibrium has been enhanced through fine food.",
    tooltip = "adds 1/3 boost to equilibrium, doesn't stack with herofete"},
  hardsmoke = { type = "artifact",
    on = {"The smoke settles around you in a haze, strangely weighing your body down.", "The smoke settles around you, but your body is already weighed down."},
    def = "Hardsmoke (hardsmoke) (indefinite).",
    defr = [[^Hardsmoke \(hardsmoke\) \(\d+ minutes\)\.$]]},
  smokeweb = { type = "artifact",
    on = "The smoke wafts across the ground, spreading to fill the area around you with a nigh-imperceptible haze.",
    def = "Smokeweb (smokeweb) (indefinite).",
    defr = [[^Smokeweb \(smokeweb\) \(\d+ minutes\)\.$]]},
  charismaticaura = { type = "general",
    def = "You are compellingly charismatic.",
    mana = "lots",
    on = {"Summoning all your influence, you begin to verily radiate charisma, creating an aura about yourself and those loyal to you.", "You already exude a charismatic aura."},
    off = {"Your posture relaxes as you allow your charismatic aura to drain away, your mind feeling less strained, though those loyal to you appear slightly disappointed.", "You already don't exude a charismatic aura."}},
  performance = {
    type = "general",
    mana = "little",
    def = "You are in performance mode.",
    on = {"You take a deep breath and mentally shift into performance mode.", "You are already in performance."},
    off = {"You let out a deep breath and release yourself from performing.", "You aren't in performance mode."}
  },
  fire = { type = "general",
    onr = [[^\w+ closes (?:his|her) eyes for a moment and turns towards you, beseeching the sun to shine\. A shaft of warm, golden light falls over you, soothing your body\.$]],
    on = "A feeling of comfortable warmth spreads over you.",
    def = "Your insides are warmed by a fire potion." },
  trueblind = { type = "general" },
  ["regal aura"] = { nodef = true,
    def = "You are surrounded by a regal aura."},
  galvanism = { type = "general",
    on = "A jolting surge rumbles through your insides."},
  truedeaf = { type = "general", def = "Sounds are heard through your true hearing." },
  kafe = {
    type = "general",
    def = "You have ingested the kafe bean and are feeling extremely energetic.",
    off = "You feel yourself calm down as the effects of kafe wear off."
  },
  insomnia = { type = "general",
    def = "You have insomnia, and cannot easily go to sleep.",
    off = {"Your insomnia has cleared up.", "Your mind relaxes and you feel as if you could sleep."}
  },
  rebounding = { type = "general", def = "You are protected from hand-held weapons with an aura of rebounding." },
  waterwalk = {
    type = "enchantment",
    def = "Waterwalking (waterwalk) (indefinite).",
    defr = [[^Waterwalking \(waterwalk\) \(\d+ minutes\)\.$]],
    on = {"You are already water walking.", "You pull a cosmic web down around your feet, and you sense that gravity will be your ally when entering water."}
  },
  waterbreathing = {
    type = "enchantment",
    on = {"You briefly hold your hand over your mouth until your lips and tongue tingle.","You are already filtering air out of water."},
    def = "Water Breathing (waterbreathe) (indefinite).",
    defr = [[^Water Breathing \(waterbreathe\) \(\d+ minutes\)\.$]],
    tooltip = "Allows breathing underwater."
  },
  perfection = {
    type = "enchantment",
    defr = [[^Perfection Enchantment \(perfection\) \(\d+ minutes\)\.$]],
    on = "A ray of golden light suddenly spotlights you.",
  },
  acquisitio = { type = "enchantment",
    def = "Ritual of Acquisitio (acquisitio) (indefinite).",
    defr = [[^Ritual of Acquisitio \(acquisitio\) \(\d+ minutes\)\.$]],
    off = "You allow the charm of Acquisitio to leave you and are no longer gripped by an unnatural need to accumulate things.",
    on = {"You narrow your eyes and look around greedily for something to add to your hoard.", "Chanting the ritual of Acquisitio to yourself, you narrow your eyes and look around greedily for something to add to your hoard."} },
  beauty = {
    type = "enchantment",
    def = "Beauty Enchantment (beauty) (indefinite).",
    defr = [[^Beauty Enchantment \(beauty\) \(\d+ minutes\)\.$]],
    on = "A ray of pink light suddenly spotlights you."
  },
  kingdom = {
    type = "enchantment",
    def = "Kingdom Enchantment (kingdom) (indefinite).",
    defr = [[^Kingdom Enchantment \(kingdom\) \(\d+ minutes\)\.$]],
    on = "A ray of green light suddenly spotlights you."
  },
  avaricehorn = {
    type = "enchantment",
    def = "You are instilled with a need to hoard gold.",
    tooltip = "Lets you automatically pick up gold from things you slay. Hoarder.",
    onr = [[^You hold .+ to your lips and blow a light, twinkling ditty. As the notes fade, you cannot help but look around with avarice in your eyes.]]
  },
  azurebox = {
    type = "enchantment",
    defr = [[^You are playing .+ to disrupt mana regeneration\.$]],
    onr = {[[^You carefully crank up .+? and hold it up as it begins to play\. Mentally jarring notes rise up from .+? as an azure glow radiates outwards from it to engulf all nearby\.$]], [[^You cannot crank .+? again so soon\.$]]},
    offr = [[^An? .+? slows and stops playing\.$]],
    tooltip = "Removes three levels of mana regeneration from enemies"
  },
  goldenbox = {
    type = "enchantment",
    defr = [[^You are playing .+? to disrupt ego regeneration\.$]],
    onr = {[[^You carefully crank up .+? and hold it up as it begins to play\. Sombre notes rise up from .+? as a golden glow radiates outwards from it to engulf all nearby\.]], [[^You cannot crank .+? again so soon\.$]]},
    offr = [[^An? .+? slows and stops playing\.$]],
    tooltip = "Removes three levels of ego regeneration from enemies"
  },
  emeraldbox = {
    type = "enchantment",
    defr = [[^You are playing .+? to disrupt health regeneration\.$]],
    onr = {[[^You carefully crank up .+? and hold it up as it begins to play\. Sickly notes rise up from .+? as an emerald glow radiates outwards from it to engulf all nearby\.$]], [[^You cannot crank .+? again so soon\.$]]},
    offr = [[^An? .+? slows and stops playing\.$]],
    tooltip = "Removes three levels of health regeneration from enemies"
  },
#if not skills.cosmic then
  nimbus = {
    type = "enchantment",
    def = "Cosmic Nimbus (cosmicnimbus) (indefinite).", -- system calls it nimbus, hence why brackets not recognised
    defr = [[^Cosmic Nimbus \(cosmicnimbus\) \(\d+ minutes\)\.$]],
    on = {"A nimbus of glittering motes blossoms around you.", "You are already surrounded with a cosmic nimbus.","You are now protected by the cosmicnimbus defence."}
  },
#end
#if not skills.elementalism then
  levitation = { type = "enchantment",
    on = {"You are now protected by the levitate defence.","You begin to rise on a cushion of air.", "You are already walking on a small cushion of air."},
    def = "Levitation (levitate) (indefinite).",
    defr = [[^Levitation \(levitate\) \(\d+ minutes\)\.$]],},
#end
  mercy = { type = "enchantment", on = "A ray of purple light suddenly spotlights you.",
    defr = [[^Mercy Enchantment \(mercy\) \(?:(indefinite|\d+ minutes)\)\.$]],
   },
  rebounding = {
    type = "general",
    off = "Your aura of weapons rebounding disappears."
  },
  quicksilver = { type = "general",
    on = "Tiny tremors spread through your body as the world seems to slow down."},
  planarbond = { type = "general",
    nodef = true,
    onr = [[^You suddenly feel the mind of \w+ brushing yours, (?:his|her) questing ended as s?he begins to bring you into resonance with the aetherwave of the ship\.$]],
  },
  aethersight = { type = "general",
    on = {"You are already sensing disruptions in the aether.",
          "You open your eyes wide, concentrating on the small strands of aether around you."},
    off = {"You close your eyes for a moment, and cease concentrating on the aether."},
  },
  amberbeer = { type = "general",
    on = "You sigh contentedly as the amber brew takes away your pain.",
    off = "You belch loudly and begin to feel the pain."},
  darkbeer = { type = "general",
    on = "The dark brew stokes a delicious fire within your belly.",
    off = "You belch deeply and no longer feel so stoked."},
  blacktea = { type = "general",
    on = "Your blood surges as the black tea enters your system."},
  oolongtea = { type = "general",
    on = "The flowery tea awakens a passion within you."},
  greentea = { type = "general",
    on = "Your movements become fluid as you drink the green tea."},
  whitetea = { type = "general",
    on = "As you sip the white tea, your thoughts become clearer."},
  psishield = {
    type = "general",
    on = "You concentrate for a moment, surrounding yourself with a psionic barrier.",
    command = "invoke psi shield",
    def = "You are protected by a psionic barrier."
  },
  crotamine = { nodef = true, def = "Your veins burn with immunity to deadly venoms."},
  dionamus = { nodef = true, def = "You are blessed by the Spire of Dionamus."},
  divinefire = { nodef = true, def = "You have wreathed yourself in divine fire."},
  vitae = { nodef = true, def = "The power of the elixir vitae flows through your veins."},
  ["domoth lesser beauty"] = { nodef = true, def = "You are under a Lesser Blessing of the Domotheos of Beauty."},
  ["domoth major beauty"] = { nodef = true, def = "You are under a Major Blessing of the Domotheos of Beauty."},
  ["domoth minor beauty"] = { nodef = true, def = "You are under a Minor Blessing of the Domotheos of Beauty."},
  ["domoth lesser death"] = { nodef = true },
  ["domoth lsr chaos"] = { nodef = true, defr = [[^Your (\w+) is under a Lesser Blessing of the Domotheos of Chaos\.$]],
    ondef = function ()
      if matches[2] == "health" then
        return "(hp)"
      elseif matches[2] == "mana" then
        return "(mana)"
      elseif matches[2] == "ego" then
        return "(ego)"
      else
        return "("..tostring(matches[2])..")"
      end
    end
  },
  ["domoth major chaos"] = { nodef = true, def = "You are under a Major Blessing of the Domotheos of Chaos."},
  ["dmth minor chaos"] = { nodef = true, defr = [[^Your (\w+) is under a Minor Blessing of the Domotheos of Chaos\.$]],
    ondef = function ()
      if matches[2] == "strength" then
        return "(str)"
      elseif matches[2] == "intelligence" then
        return "(int)"
      elseif matches[2] == "constitution" then
        return "(con)"
      elseif matches[2] == "charisma" then
        return "(cha)"
      elseif matches[2] == "dexterity" then
        return "(dex)"
      else
        return "("..tostring(matches[2])..")"
      end
    end
  },
  ["domoth major death"] = { nodef = true, def = "You are under a Major Blessing of the Domotheos of Death."},
  ["domoth minor death"] = { nodef = true, def = "You are under a Minor Blessing of the Domotheos of Death."},
  ["domoth lesser harmony"] = { nodef = true, def = "You are under a Lesser Blessing of the Domotheos of Harmony."},
  ["domoth major harmony"] = { nodef = true, def = "You are under a Major Blessing of the Domotheos of Harmony."},
  ["domoth minor harmony"] = { nodef = true, def = "You are under a Minor Blessing of the Domotheos of Harmony."},
  ["domoth lesser justice"] = { nodef = true, def = "You are under a Lesser Blessing of the Domotheos of Justice."},
  ["domoth major justice"] = { nodef = true, def = "You are under a Major Blessing of the Domotheos of Justice."},
  ["domoth minor justice"] = { nodef = true, def = "You are under a Minor Blessing of the Domotheos of Justice."},
  ["domoth lesser knowledge"] = { nodef = true, def = "You are under a Lesser Blessing of the Domotheos of Knowledge."},
  ["domoth major knowledge"] = { nodef = true, def = "You are under a Major Blessing of the Domotheos of Knowledge."},
  ["domoth minor knowledge"] = { nodef = true, def = "You are under a Minor Blessing of the Domotheos of Knowledge."},
  ["domoth lesser life"] = { nodef = true, def = "You are under a Lesser Blessing of the Domotheos of Life."},
  ["domoth major life"] = { nodef = true, def = "You are under a Major Blessing of the Domotheos of Life."},
  ["domoth minor life"] = { nodef = true, def = "You are under a Minor Blessing of the Domotheos of Life."},
  ["domoth lesser war"] = { nodef = true, def = "You are under a Lesser Blessing of the Domotheos of War."},
  ["domoth major war"] = { nodef = true, def = "You are under a Major Blessing of the Domotheos of War."},
  ["domoth minor war"] = { nodef = true, def = "You are under a Minor Blessing of the Domotheos of War.", tooltip = "Weighted +2 to strength."},
  ["judicious presence"] = { nodef = true, def = "You are bolstered by the righteous cause of a Judicious Presence.", tooltip = "+10% to max health, mana and ego"},
  ["havoc cry"] = { nodef = true, def = "You are whipped into a frenzied bloodlust by a Havoc Cry.", tooltip = "+10% damage boost against players"},
  ["flight"] = { nodef = true },
  ["dexterity food"] = { nodef = true,
    def = "Your dexterity has been enhanced through fine food."},
  ["constitution food"] = { nodef = true,
    def = "Your constitution has been enhanced through fine food."},
  ["charisma food"] = { nodef = true,
    def = "Your charisma has been enhanced through fine food."},
  ["intelligence food"] = { nodef = true,
    def = "Your intelligence has been enhanced through fine food."},
  ["strength food"] = { nodef = true,
    def = "Your strength has been enhanced through fine food."},
  ["grappling"] = { nodef = true },
  ["illithoid"] = { nodef = true },
  ["vindicated vendetta"] = { nodef = true,
    def = "You have carrying a Vendetta against opposing cultists.",
  ["vendetta"] = { nodef = true },
  ["shrineheal"] = { nodef = true },
  ["shrinecure"] = { nodef = true },
    tooltip = "+10% more damage" },
  ["devout shield"] = { nodef = true,
    defr = [[^You are protected by a Devout's Shield from the .+\.]],
    tooltip = "+10 DMP"},
  ["deiparous speed"] = { nodef = true,
    tooltip = "+1 room per second to walking speed",
    def = "You are blessed with Deiparous Speed."},
  ["celerity"] = { nodef = true,
    tooltip = "Faster equilibrium and balance recovery"},
  ["vendetta"] = { nodef = true },
  ["baba yaga"] = { nodef = true,
    def = "You are riding a wiccan broom.",
    tooltip = "You're feeling rather Wiccanish."},
  ["inner serpent"] = { nodef = true },
  ["kite"] = { nodef = true },
  ["mana blessing"] = { nodef = true },
  ["health blessing"] = { nodef = true },
  ["ego blessing"] = { nodef = true },
  ["divine ego blessing"] = { nodef = true },
  ["divine health blessing"] = { nodef = true },
  ["divine mana blessing"] = { nodef = true },
  ["maw"] = { nodef = true },
  reflection = { nodef = true },
  benignprophesy = { nodef = true },
  terror = { nodef = true },
  ["shadow shroud"] = { nodef = true },
  ["mindfield arti"] = { nodef = true,
    def = "You will discharge a psychic lash from a powerful artifact on those who scry.",
    },
  ["solstice resist"] = {nodef = true,
    ondef = function () return "("..matches[2]..")" end,
    defr = [[^Solstice Resist \(solsticeresist\) \((\d+) minutes\)\.$]],
    tooltip = "Adds 2/6 universal resistance."},
  ["solstice health"] = {nodef = true,
    ondef = function () return "("..matches[2]..")" end,
    defr = [[^Solstice Health \(solsticehealth\) \((\d+) minutes\)\.$]],
    tooltip = "Adds 2/6 boost to health."},
  ["solstice mana"] = {nodef = true,
    ondef = function () return "("..matches[2]..")" end,
    defr = [[^Solstice Mana \(solsticemana\) \((\d+) minutes\)\.$]],
    tooltip = "Adds 2/6 boost to mana."},
  ["solstice ego"] = { nodef = true,
    ondef = function () return "("..matches[2]..")" end,
    defr = [[^Solstice Ego \(solsticeego\) \((\d+) minutes\)\.$]],
    tooltip = "Adds 2/6 boost to ego"},
  ["masquerade"] = { nodef = true,
    def = "You are masking your divine spark to appear mortal."},
  ["prismatic barrier"] = { nodef = true },
  ["nightsweats"] = { nodef = true }, -- ?? if skills.night, etc, enable this
  ["garb"] = { nodef = true }, -- ?? if skills.night, etc, enable this
  dolphin = { nodef = true }, -- to be overwritten later ;)
  dragon = { nodef = true },
  glacier = { nodef = true },
  ["green tea ceremony"] = { nodef = true,
    def = "Your movements are ceremonially heightened.",
    tooltip = "14% chance to resist paralysis, weakness or rigormortis"},
  lion = { nodef = true },
  antlers = { nodef = true },
  bumblebee = { nodef = true },
  volcano = { nodef = true },
  spider = { nodef = true },
  skull = { nodef = true },
  twincrystals = { nodef = true },
  burningcenser = { nodef = true },
  penumbra = { nodef = true },
  crocodile = { nodef = true },
  aegis = { nodef = true },
  purity = { nodef = true },
  resistance = { nodef = true },
  fitness = { nodef = true },
  ["crit bonus"] = { nodef = true,
    defr = [[^You are benefiting from lucky critical hits for (\d+) hours? and (\d+) minutes\.$]],
    ondef = function () return string.format("(%sh, %sm)", matches[2], matches[3]) end,
  },
  ["xp bonus"] = { nodef = true,
    def = "You have been kissed by the Fates." },
  spiritcrow = { nodef = true,
    def = "You are being guarded by a spirit crow.",
    tooltip = "+5 DMP and the 'crow knockdown' skill"},
  crowknockdown = { nodef = true,
    def = "Your guardian spirit crow is knocking down flyers.",
    tooltip = "passively knocks down flyers for 5 minutes"},
  constitution = { nodef = true },
  healingaura = { nodef = true, def = "You are surrounded by a refreshing health aura." },
  nightwraith = { nodef = true, def = "You are a Nightwraith."},
  chaosbutterfly = { nodef = true, def = "You have a single chaos butterfly resting on your shoulder.", tooltip = "Enables use of ChaoteSign" },
  moonchilde = { nodef = true },

#if skills.knighthood then
  aggressive = { type = "knighthood",
    on = "You focus your attention on the aggressive fighting style.",
    off = "You focus your attention on using no specific fighting style."},
  engage = { type = "knighthood" },
  grip = { type = "knighthood",
    on = {"You already have a firm grip.", "You concentrate on gripping tightly with your hands."},
    off = {"You relax your grip.", "Your grip is already relaxed."}},
  lightning = { type = "knighthood",
    def = "You are fighting with headstrong speed.",
    on = "You focus your attention on the lightning fighting style.",
    off = "You focus your attention on using no specific fighting style.",
    tooltip = "Increases speed but decreases damage."},
  concentrated = { type = "knighthood", def = "You are fighting with focused strikes.",
    on = "You focus your attention on the concentrated fighting style.",
    off = "You focus your attention on using no specific fighting style." },
  defensive = { type = "knighthood", def = "You are fighting defensively.",
    on = "You focus your attention on the defensive fighting style.",
    off = "You focus your attention on using no specific fighting style." },
  bleeder = { type = "knighthood",
    def = "You are fighting with a bleeder's precision.",
    on = "You focus your attention on the bleeder fighting style.",
    off = "You focus your attention on using no specific fighting style."},
  berserker = { type = "knighthood",
    def = "You are fighting with a berserker's abandon.",
    on = "You focus your attention on the berserker fighting style.",
    off = "You focus your attention on using no specific fighting style."},
  bludgeoner = { type = "knighthood",
    def = "You are fighting with a bludgeoner's strength.",
    on = "You focus your attention on the bludgeoner fighting style.",
    off = "You focus your attention on using no specific fighting style."},
  pulverizer = { type = "knighthood",
    def = "You are fighting with a pulverizers's brutality.",
    on = "You focus your attention on the pulverizer fighting style.",
    off = "You focus your attention on using no specific fighting style."},
  mutilator = { type = "knighthood",
    def = "You are fighting with a mutilator's cunning.",
    on = "You focus your attention on the mutilator fighting style.",
    off = "You focus your attention on using no specific fighting style."},
  poisonist = { type = "knighthood",
    def = "You are fighting with a poisonist's eye.",
    on = "You focus your attention on the poisonist fighting style.",
    off = "You focus your attention on using no specific fighting style."},
#end

#if skills.cavalier then
  strikes = { type = "cavalier",
    on = {"You flex your muscles and hone your mind on the task of recovering any missed strikes and converting them to swings with the shaft of your weapon.", "You are already recovering your strikes."},
    def = "You are recovering your missed strikes and converting them to swings.",
    off = "Your mind wanders from the task of converting missed strikes to swings."},
  guarding = { type = "cavalier",
    onr = {[[^You grip a worn bardiche of corroding iron, ready to guard \w+ against assault\.$]], [[^You grip .+, ready to guard yourself against assault\.$]], [[^You grip .+ finished with golden webbing, ready to guard yourself against assault\.$]], [[^You are already guarding \w+\.$]]},
    on = "You are already guarding yourself.",
    ondef = function () return "("..matches[2]..")" end,
    defr = {[[^You are watching for attacks against (\w+)'s person\.$]], [[^You are watching for attacks against (you)r person\.$]]}},
  hefting = { type = "cavalier",
    defr = [[You are hefting your weapon in preparation to attack (\w+)\.$]],
    ondef = function () return "("..matches[2]..")" end,
  },
#end

#if skills.stealth then
  veil = { type = "stealth" },
  agility = { type = "stealth",
    on = {"Running in place, you stretch your muscles and enhance your agility and speed.", "You already have enhanced agility!"}},
  awareness = { type = "stealth",
    mana = "little",
    on = {"You focus your senses to become hyperaware of your surroundings.", "You are already aware of your surroundings!"},
    off = {"With a relaxing yawn, you dull your senses and are no longer hyperaware of your surroundings.", "You are currently unaware of your surroundings already."}},
  bracing = { type = "stealth",
    on = {"Grabbing your wrists firmly in opposite hands, you pull and brace yourself to absorb any damage dealt to you.", "You are already bracing against damage!"}},
  eavesdrop = { type = "stealth",
    onr = [[^You begin to eavesdrop to the \w+\.$]],},
  whisper = { type = "stealth",
    on = {"You prepare your voice to sound in whisper mode.", "You are already in whisper mode!"}},
  infiltrate = { type = "stealth",
    onr = [[^You infiltrate the channels of \w+\.$]]},
  masquerade = { type = "stealth" },
  deepcover = { type = "stealth" },
  screen = { type = "stealth",
    on = {"You shift your belongings around, screening them from prying eyes.", "You are already screening your items!"}},
  mislead = { type = "stealth",
    onr = [[^You prepare your next movement to mislead to the \w+\.$]],
    offr = [[^You mislead to the \w+\.$]]},
  sneak = { type = "stealth",
    on = {"You step backwards, sneaking into the cover of the shadows.", "You already are sneaking around."},
    off = {"You step out of the cover of the shadows and cease sneaking around.", "You already aren't sneaking around."},
    def = "You are sneaking around in the shadows."},
#end

#if skills.acrobatics then
  adroitness = { type = "acrobatics",
    on = {"You inhale a deep breath, ready to run quickly if the need arises.", "You are already moving at an increased pace."}},
  avoid = { type = "acrobatics",
    on = "You tense your muscles with the sinuous grace of a predator, prepared to avoid any incoming blows.",
    off = "You cease preparing to avoid the next attack."},
  balancing = { type = "acrobatics",
    on = {"You dance as nimbly as a cat, maintaining your balance on the balls of your feet.", "You are already protecting yourself against falling."},
    off = {"You relax your nimble stance, falling into a comfortable posture.", "You are not currently protecting yourself against falling.", "You can no longer concentrate on maintaining your balance."}},
  elasticity = { type = "acrobatics",
    on = {"Concentrating briefly, you will parts of your muscles to relax, giving them more elasticity to prevent damage.", "You are already relaxing your muscles to prevent damage to them."}},
  falling = { type = "acrobatics",
    on = {"Casting a wary eye about your surroundings, you ready yourself for a fall.", "You are already concentrating on breaking your falls."}},
  handstand = { type = "acrobatics",
    on = "You dive dramatically towards the ground, flowing lithely into a graceful handstand that leaves you staring at everything upside-down."},
  hyperactive = { type = "acrobatics" },
  tripleflash = { type = "acrobatics",
    on = "You dance around chaotically, avoiding incoming blows."},
  hyperventilate = { type = "acrobatics",
    on = {"You breathe in and exhale in a regular, steady rhythm, mastering your control over your breathing.", "You are already controlling your breathing masterfully."}},
  limber = { type = "acrobatics",
    on = {"You stretch your muscles, focusing on swift and nimble movements.", "You are already quite limber!"}},
#end

#if skills.celestialism then
  wings = { type = "celestialism",
    on = {"You bow your head and pray to the divinities of Celestia, and glorious golden wings unfurl upon your back.", "You already have wings."}},
  halo = { type = "celestialism",
    on = {"You bow your head and pray to the divinities of Celestia, and your soul is purified as a radiant halo settles upon your brow.", "You already are surrounded by a radiant halo."}},
  channels = { type = "celestialism",
    on = {"Your channels are already open.", "You press your hands together and bow your head, concentrating upon opening up the aetheric channels to other planar entities."}},
  stigmata = { type = "celestialism",
    on = {"You prepare your body and soul for a spiritual battle."},
    off = {"You relax your readiness for a spiritual battle."}},
#end

#if skills.astrology then
  dragon = { type = "astrology",
    on = "You hold out your hands and a scintillating globe of energy surrounds you, which manifests into the Sphere of the Dragon.",
    on_only = "That person already is under the influence of the sphere of the Dragon.",
    off = "You no longer have the Sphere of Dragon surrounding you."
  },
  dolphin = { type = "astrology",
    on = "You hold out your hands and a scintillating globe of energy surrounds you, which manifests into the Sphere of the Dolphin.",
    on_only = "That person already is under the influence of the sphere of the Dolphin.",
    off = "You no longer have the Sphere of Dolphin surrounding you."
  },
  glacier = { type = "astrology",
    on = "You hold out your hands and a scintillating globe of energy surrounds you, which manifests into the Sphere of the Glacier.",
    on_only = "That person already is under the influence of the sphere of the Glacier.",
    off = "You no longer have the Sphere of Glacier surrounding you."
  },
  lion = { type = "astrology",
    on = "You hold out your hands and a scintillating globe of energy surrounds you, which manifests into the Sphere of the Lion.",
    on_only = "That person already is under the influence of the sphere of the Lion.",
    off = "You no longer have the Sphere of Lion surrounding you."
  },
  antlers = { type = "astrology",
    on = "You hold out your hands and a scintillating globe of energy surrounds you, which manifests into the Sphere of the Antlers.",
    on_only = "That person already is under the influence of the sphere of the Antlers.",
    off = "You no longer have the Sphere of Antlers surrounding you."
  },
  bumblebee = { type = "astrology",
    on = "You hold out your hands and a scintillating globe of energy surrounds you, which manifests into the Sphere of the Bumblebee.",
    on_only = "That person already is under the influence of the sphere of the Bumblebee.",
    off = "You no longer have the Sphere of Bumblebee surrounding you."
  },
  volcano = { type = "astrology",
    on = "You hold out your hands and a scintillating globe of energy surrounds you, which manifests into the Sphere of the Volcano.",
    on_only = "That person already is under the influence of the sphere of the Volcano.",
    off = "You no longer have the Sphere of Volcano surrounding you."
  },
  spider = { type = "astrology",
    on = "You hold out your hands and a scintillating globe of energy surrounds you, which manifests into the Sphere of the Spider.",
    on_only = "That person already is under the influence of the sphere of the Spider.",
    off = "You no longer have the Sphere of Spider surrounding you."
  },
  skull = { type = "astrology",
    on = "You hold out your hands and a scintillating globe of energy surrounds you, which manifests into the Sphere of the Skull.",
    on_only = "That person already is under the influence of the sphere of the Skull.",
    off = "You no longer have the Sphere of Skull surrounding you."
  },
  twincrystals = { type = "astrology",
    on = "You hold out your hands and a scintillating globe of energy surrounds you, which manifests into the Sphere of the Twin Crystals.",
    on_only = "That person already is under the influence of the sphere of the Twin Crystals.",
    off = "You no longer have the Sphere of Twin Crystals surrounding you."
  },
  burningcenser = { type = "astrology",
    on = "You hold out your hands and a scintillating globe of energy surrounds you, which manifests into the Sphere of the Burning Censer.",
    on_only = "That person already is under the influence of the sphere of the Burning Censer.",
    off = "You no longer have the Sphere of Burning Censer surrounding you."
  },
  crocodile = { type = "astrology",
    on = "You hold out your hands and a scintillating globe of energy surrounds you, which manifests into the Sphere of the Crocodile.",
    on_only = "That person already is under the influence of the sphere of the Crocodile.",
    off = "You no longer have the Sphere of Crocodile surrounding you."
  },
#end

#if skills.ascendance then
  presence = { type = "ascendance" },
  fearaura = { type = "ascendance" },
  respect = { type = "general",
    on = {"You draw upon all of your courage and confidence to exude an aura of power that simply cannot be denied. Standing straight, you feel yourself begin to radiate aptitude and competence in every action you make.", "You are already demanding respect from those you lead."},
    off = "You begin to slouch as you focus less on commanding respect from those you lead.",
    def = "You are radiating an aura of respect." },
  judiciouspresence = { type = "ascendance",
    def = "You are maintaining a Judicious Presence."},
  omniscience = { type = "ascendance",
    def = "You are omnisciently listening to the aetheric winds.",
    tooltip = "Lets you talk and hear from aetherbubbles" },
  deathaura = { type = "ascendance",
    on = {"You reach out, focusing upon the dark energies of the Domotheos of Death, drawing them into yourself. Your vision goes dark for a moment as you twist the energies to form a blackened aura of death about you, the soft wailing of spirits emanating from deep within.", "Your Aura of Death is already active."},
    def = "You are emanating an aura of death.", tooltip = "Reserves substitute, powered by souls."},
  puresoul = { type = "ascendance",
    on = {"A salubrious radiance permeates your awareness, the beauteous miracle of life and the preciousness of its sanctity unfolding within your mind.", "Your Aura of Purity is already active."},
    def = "You are enveloped in a radiant Aura of Salvation."},
#end

#if skills.glamours then
  glamour = { type = "glamours" },
  illusoryself = { type = "glamours",
    on = {"You weave an impossibly complex glamour of light, producing an unerring replica of yourself that floats eerily around you and prevents your precise location from being easily determined.", "You are already protected by an illusory self.", "You are already protected by an illusory glamour of yourself.",
          "Your illusory doppleganger completely absorbs the damage."},
    off = "Your illusory glamour you have woven of yourself melts away."},
#end

#if skills.hexes then
  hexaura = { type = "hexes",
    on = {"Stretching your arms out to your sides, you spin in a quick circle, a faint light engulfing your form before fading away.", "Your hex aura is already on."},
    off = {"Dropping your hands to your sides, you feel the hex aura surrounding you dissolve.", "Your hex aura is already off."}},
  hexsense = { type = "hexes",
    on = {"You begin to sense the activation of your hexes.", "You are already sensing the activation of your hexes."},
    off = "You cease to sense the activation of your hexes."},
  hexcontrol = { type = "hexes",
    on = {"You control your hexes to preserve them for throwing.", "You already are controlling your hexes."},
    off = {"You release control of your hexes so they will hit enemies who stumble upon them.", "Your hexes are not controlled already."}},
#end

#if skills.wicca then
  channels = { type = "wicca",
    on = {"Your channels are already open.", "You press your hands together and bow your head, concentrating upon opening up the aetheric channels to other planar entities."}},
#end

#if skills.phantasms then
  phantomarmour = { type = "phantasms",
    on = {"You fluidly wave your arms about your body and notice that with each pass pieces of phantom armour are revealed. Finally, you appraise your body and admire the purple sheen now surrounding you.", "You already don a suit of phantom armour."},
    off = "Within the blink of an eye, your phantom armour dissipates into the aether."},
  burningeye = { type = "phantasms",
    on = {"You tilt your head backwards and draw your arms up, delicately weaving threads of burning illusion into the shape of an all-seeing eye, which you leave floating darkly above your head.", "You already have a burning eye above you."},
    def = "A darkly burning illusory eye floats above your head.",
    off = "With a slow, final blink, the burning eye above your head dissipates with a quiet sizzle."},
#end

#if skills.elementalism then
  elementshield = { type = "elementalism",
    on = {"You cross your arms and a shimmering elemental shield surrounds you.", "You already possess an element shield."}},
  levitate = { type = "elementalism",
    on = {"You take a deep breath and fill your cheeks with air until they bulge out. After a moment, the air in your cheeks disappears and is absorbed into you.", "You are already walking on a small cushion of air."},
    def = "Levitation (levitate) (indefinite).",
    defr = [[^Levitation \(levitate\) \(\d+ minutes\)\.$]], },
  waterbreathe = { type = "elementalism",
    on = {"You briefly hold your hand over your mouth until your lips and tongue tingle.", "You are already filtering air out of water."},
    def = "Water Breathing (waterbreathe) (indefinite).",
    defr = [[^Water Breathing \(waterbreathe\) \(\d+ minutes\)\.$]]},
  stoneskin = { type = "elementalism",
    on = {"Calling the powers of the elemental earth, your skin hardens with a layer of supple granite.", "You already are coated with stone."}},
#end

#if skills.lowmagic then
  yellow = { type = "lowmagic", def = "You have empowered your yellow chakra.",
    on = {"The yellow chakra already burns bright within your body.", "Pressing your hands together before you, you concentrate on your solar plexus chakra. A golden glow suffuses your solar plexus and your body swells with power."},
    onshow = function ()
      return defences.gettime("yellow", 60) end,
    off = "You feel your yellow chakra fade."},
  red = { type = "lowmagic", def = "The pull of the earth roots you more firmly to the ground.",
    on = {"Pressing your hands together before you, you concentrate on your root chakra. A red glow runs down your spine, helping anchor you to the earth.", "The red chakra already burns bright within your body."}},
  blue = { type = "lowmagic", def = "You have empowered your blue chakra.",
    on = {"Pressing your hands together before you, you concentrate on your throat chakra. A blue glow suffuses your throat, protecting all your communications.", "The blue chakra already burns bright within your body."}},
  orange = { type = "lowmagic", def = "You have empowered your orange chakra.",
    on = "Pressing your hands together before you, you concentrate on your belly chakra. An orange glow suffuses the area around your stomach and the pangs of hunger disappear.",
    off = "You feel your orange chakra fade."},
  autumn = { type = "lowmagic",
    on = {"Turning to the west, you beseech the Spirits of Autumn to make your harvest plentiful. A sparkling wind comes forth and wraps around you, promising your harvests will be fruitful.", "The autumn wind is already with you."},
    off = "You feel the autumn wind subside."},
  shield = { type = "lowmagic",
    on = {"Spreading your arms wide, you spin clockwise and visualize a circle of protection. A shimmering white orb springs up around you.", "Muttering words of power, you trace a cobalt blue pentagram in the air that remains hovering before you, protecting against assault"},
    off = {"Your movement causes your magical shield to dissipate.", "Your action causes the nearly invisible magical shield around you to fade away."}
  },
#end

#if skills.healing then
  aurasense = { type = "healing",
    on = {"You touch two fingers to your forehead, and attune your inner eye to the fluctuations of your healing auras.", "You are already sensing your healing auras."},
    off = {"You touch two fingers to your forehead and dissolve your link to your healing auras.", "You are not attuned to the fluctuations of your healing auras."},
    def = "You are sensing fluctuations in your healing auras."},
  healingaura = { type = "healing",
    on = {"You bow your head and close your eyes, radiating a powerful, refreshing health aura around yourself.", "You are already under the effect of a refreshing health aura."},
    off = "The refreshing health aura surrounding you dissipates.",
    def = "You are surrounded by a refreshing health aura.",
    tooltip = "Passive health regeneration"},
  vitalityaura = { type = "healing",
    off = "You wince in pain as the backlash from your healing energies threatens to overtake you, but your aura of refreshing vitality soothes your wounds before dissipating.",
    on = {"You radiate a powerful aura of vitality, that winds protectively around your body to shield it from the ravages of a healing backlash.", "You are already radiating a healing aura of vitality."},
  },
  quickeningaura = { type = "healing",
    off = "Your quickened healing proficiency slows back down.",
    on = "You touch two fingers to your heart, causing the internal pulse of your body to quicken with every beat of healing energy that thrums through you."},
  depressionaura = { type = "healing",
    on = {"You bow your head and close your eyes, radiating a powerful, healing depression aura around yourself.", "You are already under the effect of a healing depression aura."}},
$(for _, aura in ipairs({"temperature", "auric", "fractures", "glandular", "senses", "neurosis", "breaks", "choleric", "curses", "muscles", "sanguine", "blood", "melancholic", "phobias", "phlegmatic", "nervous", "mania", "skin"}) do
  _put(string.format([[%s = { type = "healing",
    on = {"You bow your head and close your eyes, radiating a powerful, healing %s aura around yourself.", "You are already under the effect of a healing %s aura."},
    off = "The healing %s aura surrounding you dissipates.",
    def = "You are surrounded by a healing %s aura."},]], aura, aura, aura, aura, aura))
end)
#end

#if skills.aeonics then
  mindclock = { type = "aeonics",
    def = "Your mind's inner clock is synchronised with your body.",
    tooltip = "Chance to avoid aeon effects",
    on = {"You force your mind to synchronise with your body's inner clock.", "Your time clock is already active."}},
  alacrity = { type = "aeonics",
    on = {"Raising your arms, you allow the time field around you to quicken its pulse.", "Alacrity already surrounds you."},
    def = "You are surrounded by a field of alacrity."},
  timelessbody = { type = "aeonics",
    def = "Your body is tempered in a time field.",
    tooltip = "Chance to avoid some physical afflictions",
    on = {"You spin around and allow the time field around you to saturate into your body.", "Your body is already timeless."}},
  switchfate = { type = "aeonics",
    tooltip = "Chance to redirect damage to you to another enemy in the area",
    on = "Breathing deeply in and out, you cast out your temporal lines and tangle it with that of another.",
    off = "The timelines that surround you are no longer tangled with that of another.",
    def = "Your fate is switched with another.",
  },
  aeonfield = { type = "aeonics",
    tooltip = "Aeons enemies in room at regular intervals",
    on = {"Raising your arms, you twist the temporal currents until an aeonic field surrounds you, filling the air with a deep vibrating hum.", "You are already surrounded by an aeon field."},
    off = "The aeonic field that surrounds you fades away.",
    def = "You are surrounded by an aeon field."},
  insight = { type = "aeonics",
    def = "You have insight into your own mind.",
    tooltip = "Chance to avoid some mental afflictions",
    on = {"You close your eyes and focus on the inner turmoil of your own mind. You force your thoughts into order and find insight into your own being.", "You already have insight into your own mind."}},
  futureglimpse = { type = "aeonics",
    def = "You are gazing into the future.",
    tooltip = "20% chance to avoid any affliction",
    on = {"You press your fingers against your temples and gaze deeply into the timelines that surround you, catching glimpses of your own future.", "You are already glimpsing into the future."},
    offs = "Unfortunately, your glimpse into the future fades away into the mists of time."},
  foresight = { type = "aeonics",
    def = "You are using foresight.",
    tooltip = "Chance to avoid incoming attacks, limited duration",
    on = {"You open your inner eye to watch possible timelines.", "You are already using your foresight."},
    off = "You have exhausted your foresight."},
  paradox = { type = "aeonics",
    invisibledef = true,
    on = "You project your consciousness into the future, tying the temporal lines between you and your future selves. You allow the paradox to form and surround you.",
    off = "You no longer walk in a paradox."},
#end

#if skills.rituals then
  draconis = { type = "rituals",
    on = {"Your skin is already thick.", "You chant the ritual of Draconis and sense a numinous layer of dragon scales surround you."},
    on_only = "That ritual is already in effect.",
  },
  fortuna = { type = "rituals",
    on = {"You are already reaping the gifts of Fortuna.","The air around you blurs as you chant the ritual of Fortuna. You feel the winds of chance and change pass through you."},
    on_only = "That ritual is already in effect.",},
  populus = { type = "rituals",
    on = {"You are already filled with the exuberance of Populus.","You are already filled with the exuberence of Populus.", "Confidence and exuberance fills you as you chant the joyful ritual of Populus."},
    on_only = "That ritual is already in effect.",},
  rubeus = { type = "rituals",
    on = {"A red haze fills your field of vision as you chant the ritual of Rubeus.", "The red haze of rubeus already fills you.", "The red haze of Rubeus already fills you."},
    off = "You feel the ritual of Rubeus leave you, your mind once again vulnerable to fear.",
    on_only = "That ritual is already in effect.",},
  acquisitio = { type = "rituals",
    off = "You allow the charm of Acquisitio to leave you and are no longer gripped by an unnatural need to accumulate things.",
    on = {"You narrow your eyes and look around greedily for something to add to your hoard.", "Chanting the ritual of Acquisitio to yourself, you narrow your eyes and look around greedily for something to add to your hoard."},
    on_only = "That ritual is already in effect.",
  },
#end

#if skills.necroscream then
  encore = { type = "necroscream",
    on = "With a deep breath, you ready yourself to play a rousing encore performance at a tempo accelerando.",
    def = "You let out a breath as your encore ends, returning your performance to normal tempo." },
  tempo = { type = "general",
    onr = [[^As you wind .+ up, the hands on its face begin to move slower and slower. Suddenly, a flurry of bright yellow sparks spray out of .+, and you feel your musical aptitude take on a new dimension\.$]],
    onshow = function ()
      return defences.gettime("tempo", 60) end,
    off = "Your enhanced sense of music fades from your mind as quickly as it came."},
#end

#if skills.shadowbeat then
  encore = { type = "shadowbeat",
    on = "With a deep breath, you ready yourself to play a rousing encore performance at a tempo accelerando.",
    def = "You let out a breath as your encore ends, returning your performance to normal tempo." },
  tempo = { type = "general",
    onr = [[^As you wind .+? up, the hands on its face begin to move slower and slower\. Suddenly, a flurry of bright yellow sparks spray out of .+?, and you feel your musical aptitude take on a new dimension\.$]],
    onshow = function ()
      return defences.gettime("tempo", 60) end,
    off = "Your enhanced sense of music fades from your mind as quickly as it came."},
#end

#if skills.minstrelry then
  encore = { type = "minstrelry",
    on = "With a deep breath, you ready yourself to play a rousing encore performance at a tempo accelerando.",
    def = "You let out a breath as your encore ends, returning your performance to normal tempo." },
  tempo = { type = "general",
    onr = [[^As you wind .+? up, the hands on its face begin to move slower and slower\. Suddenly, a flurry of bright yellow sparks spray out of .+?, and you feel your musical aptitude take on a new dimension\.$]],
    onshow = function ()
      return defences.gettime("tempo", 60) end,
    off = "Your enhanced sense of music fades from your mind as quickly as it came."},
  burningpower = { type = "minstrelry",
    ondef = function () return "("..matches[2]..")" end,
    defr = [[^You can draw upon the latent power of the burning desert another (\w+) times\.$]],
    off = {"You draw upon the latent heat of the burning desert to fuel your feat and feel the fire within you extinguish.", "You draw upon the latent heat of the burning desert to fuel your feat."}},
#end

#if skills.loralaria then
  encore = { type = "loralaria",
    on = "With a deep breath, you ready yourself to play a rousing encore performance at a tempo accelerando.",
    def = "You let out a breath as your encore ends, returning your performance to normal tempo." },
  tempo = { type = "general",
    onr = [[^As you wind .+? up, the hands on its face begin to move slower and slower\. Suddenly, a flurry of bright yellow sparks spray out of .+?, and you feel your musical aptitude take on a new dimension\.$]],
    onshow = function ()
      return defences.gettime("tempo", 60) end,
    off = "Your enhanced sense of music fades from your mind as quickly as it came."},
#end

#if skills.starhymn then
  encore = { type = "starhymn",
    on = "With a deep breath, you ready yourself to play a rousing encore performance at a tempo accelerando.",
    def = "You let out a breath as your encore ends, returning your performance to normal tempo." },
  crusadercanto = { type = "starhymn",
    def = "You have an aura of holy crusading flames."},
  tempo = { type = "general",
    onr = [[^As you wind .+? up, the hands on its face begin to move slower and slower\. Suddenly, a flurry of bright yellow sparks spray out of .+?, and you feel your musical aptitude take on a new dimension\.$]],
    onshow = function ()
      return defences.gettime("tempo", 60) end,
    off = "Your enhanced sense of music fades from your mind as quickly as it came."},
#end

#if skills.wildarrane then
 -- disabled due to conflict with songstat same output; confuses 'def'
  ancestors = { type = "wildarrane",
    ondef = function () return "("..matches[2]..")" end,
    defr = [[^You are attended by the spirits? of (\w+) of your ancestors\.$]] },
  encore = { type = "wildarrane",
    on = "With a deep breath, you ready yourself to play a rousing encore performance at a tempo accelerando.",
    def = "You let out a breath as your encore ends, returning your performance to normal tempo." },
  tempo = { type = "general",
    onr = [[^As you wind .+? up, the hands on its face begin to move slower and slower\. Suddenly, a flurry of bright yellow sparks spray out of .+?, and you feel your musical aptitude take on a new dimension\.$]],
    onshow = function ()
      return defences.gettime("tempo", 60) end,
    off = "Your enhanced sense of music fades from your mind as quickly as it came."},
#end

#if skills.highmagic then
  geburah = { type = "highmagic",
    on = {"You are already basking in the Geburah sphere.", "Muttering the secret names of Geburah, you trace the glowing symbol of a sword before you. The sword enters your chest and you feel strength course through your veins."},
    off = "You feel the Geburah Sphere leave you."},
  netzach = { type = "highmagic",
    on = {"You are already basking in the Netzach Sphere.", "Muttering the secret names of Netzach, you trace the glowing symbol of a rose before you. You smile as the rose floats towards you and enters your chest, making your personality sparkle."},
    onshow = function ()
      return defences.gettime("netzach", 60) end,
    off = "You feel the Netzach Sphere leave you."},
  malkuth = { type = "highmagic",
    on = "Muttering the secret names of Malkuth, you trace glowing geometric patterns in the air which settle around you, grounding you to the earth."},
  yesod = { type = "highmagic",
    off = {"Muttering the secret names of Yesod, you trace a glowing circle in front of you. You step into the circle of energy, feeling your invisibility melt away with it.", "Your shroud dissipates and you return to the realm of perception."},
    on = "Muttering the secret names of Yesod, you trace a glowing circle in front of you. You step into the circle of energy, coming out of it cloaked in invisibility."
  },
  hod = { type = "highmagic",
    on = {"Muttering the secret names of Hod, you trace a glowing triangle before you. The triangle enters your forehead and clears your mind.", "You have already invoked the ritual of Hod."},
    def = "You are surrounded by the Hod Sphere.",
    off = {"A surge of energy floods your system, making you more alert.", "You no longer feel the ritual of Hod preparing you for a mental revival."}
  },
  shield = { type = "highmagic",
    on = {"Spreading your arms wide, you spin clockwise and visualize a circle of protection. A shimmering white orb springs up around you.", "Muttering words of power, you trace a cobalt blue pentagram in the air that remains hovering before you, protecting against assault."},
    off = {"Your movement causes your magical shield to dissipate.", "Your action causes the nearly invisible magical shield around you to fade away."}
  },
#end

#if skills.nihilism then
  barbedtail = { type = "nihilism",
    on = {"You bow your head in obeisance to the Demon Lords of Nil, and a jolt of pain shoots down your spine as a barbed tail thrusts itself out of your flesh, flailing with a life of its own.","You already have a barbed tail."}},
  channels = { type = "nihilism",
    on = {"Your channels are already open.", "You press your hands together and bow your head, concentrating upon opening up the aetheric channels to other planar entities."}},
  demonscales = { type = "nihilism", def = "You are covered with demon scales.",
    on = {"You bow your head in obeisance to the Demon Lords of Nil, and excruciating pain forces you onto the ground, writhing in agony. Bloody cracks appear on your skin as gleaming black plates of demonic scales burst forth.","You are already covered with demonic scales."}},
  wings = { type = "nihilism", def = "Bat-like wings sprout out of your back.",
    on = {"You already have wings.","You bow your head in obeisance to the Demon Lords of Nil and grunt in pain as wounds open up in your back, sprouting leathery bat-like wings."}},
#end

#if skills.ninjakari then
  byahkari = { type = "ninjakari" },
  grip = { type = "ninjakari" },
  grip = { type = "ninjakari",
    on = {"You concentrate on gripping tightly with your hands.", "You already have a firm grip."},
    off = {"You relax your grip.", "Your grip is already relaxed."}},
  --[[deflectright = { type = "ninjakari",
    on = "You prepare your right hand to deflect blows.",
    off = "You relax your hands."},
  deflectleft = { type = "ninjakari",
    on = "You prepare your left hand to deflect blows.",
    off = "You relax your hands."},]]
#end

#if skills.nekotai then
  grip = { type = "nekotai",
    on = {"You concentrate on gripping tightly with your hands.", "You already have a firm grip."},
    off = {"You relax your grip.", "Your grip is already relaxed."}},
  --[[deflectright = { type = "nekotai",
    on = "You prepare your right hand to deflect blows.",
    off = "You relax your hands."},
  deflectleft = { type = "nekotai",
    on = "You prepare your left hand to deflect blows.",
    off = "You relax your hands."},]]
  scorpiontail = { type = "nekotai",
    on = "A glowing scorpion's tail arcs overhead as you shift the weight in your legs."},
  scorpionspit = { type = "nekotai",
     defr = [[^You are ready to spit \w+\.$]],
     ondef = function () return matches[2] end},
  scorpionfury = { type = "nekotai",
    on = "Tapping into the energies of Grandmother Scorpion, you allow a low roiling anger to bubble up from deep within and build to a cold fury.",
    off = "Your scorpion fury subsides."},
  screeleft = {
    type = "nekotai",
    ondef = function () return matches[2] end,
    defr = [[^You have a dart with (\w+) under your left foot\.$]],
    on = "You have already placed a poison dart under your foot.",
    onr = [[^You carefully coat a dart with \w+ and bind it firmly under your left heel\.$]],
    tooltip = "Adds poison to a kick." },
  screeright = {
    type = "nekotai",
    ondef = function () return matches[2] end,
    defr = [[^You have a dart with (\w+) under your right foot\.$]],
    on = "You have already placed a poison dart under your foot.",
    onr = [[^You carefully coat a dart with \w+ and bind it firmly under your right heel\.$]],
    tooltip = "Adds poison to a kick." },
#end

#if skills.cosmic then
  cloak = { type = "cosmic",
    on = {"Weaving the cosmic threads into a cloak, you settle it upon your shoulders and feel somewhat more protected.","You are already cloaked."}},
  timeslip = { type = "cosmic",
    on = {"Touching upon cosmic probabilities, you weave a net of safety around yourself.","You already have cast a web of safety around yourself."}},
  nimbus = { type = "cosmic",
    def = "Cosmic Nimbus (cosmicnimbus) (indefinite).", -- system calls it nimbus, hence why brackets not recognised
    on = {"You are already surrounded with a cosmic nimbus.", "Drawing cosmic dust into a sphere, you slowly let it expand into a nimbus of glittering motes."}},
  waterwalk = { type = "cosmic",
    def = "Waterwalking (waterwalk) (indefinite).",
    defr = [[^Waterwalking \(waterwalk\) \(\d+ minutes\)\.$]],
    on = {"You pull a cosmic web down around your feet, and you sense that gravity will be your ally when entering water.", "You are already water walking."}},
#end

#if skills.necromancy then
  coldaura = { type = "necromancy", def = "You are surrounded by the cold of the grave.",
    on = {"You release the cold of the grave from your undead flesh.", "You are already releasing the frigid aura of the grave from your undead flesh."},
    off = {"You call the cold of the grave back to preserve your undead flesh.", "You are not surrounded by the cold of the grave."}},
  ghost = { type = "necromancy",
    on = {"Chanting words of power, you burn off your mortal shell in a blaze of dark fire and rise up from the ashes as a ghost.", "You have taken the form of a ghost and can not do that."},
    off = {"You concentrate and are once again Archlich master viscanti.", "You are already in Archlich master viscanti form."}},
  putrefaction = { type = "necromancy",
    on = {"You concentrate for a moment and your flesh begins to dissolve away, becoming slimy and wet.", "You have already melted your flesh. Why do it again?"},
    off = {"You concentrate briefly and your flesh is once again solid.", "Your flesh is already solid."}},
  lichdom = { type = "necromancy",
    def = {"You are a lich.", "You are an archlich."}},
#end

#if skills.runes then
  benignprophesy = { type = "runes",
    on = "Your heart flutters as the prophesy takes hold.",
    def = "You are under the effect of a benign prophesy.",
    off = "The prophesy's effect subsides." },
  runicamulet = { type = "runes",
    ondef = function () return "("..matches[2]..", "..matches[3].."mo)" end,
    defr = [[^You are protected from the (\w+) rune by a runic amulet which has (\w+) charges remaining\.$]],
    onr = [[^You slip into an amulet bearing the \w+ rune\.$]],
    offr = [[^You remove an amulet bearing the \w+ rune\.$]]
  },
#end

#if skills.druidry then
  twirlcudgel = { type = "druidry",
    on = "You twirl your cudgel before you, bringing forth an emerald shield that surrounds you."},
#end

#if skills.shamanism then
  walkingtrance = { type = "shamanism",
    on = {"You are already maintaining a subconscious trance.", "You pause for a moment in quiet contemplation, segmenting your mind with the intent to maintain a subconscious trance."},
    off = {"You allow your mind to relax and end your subconscious trance.", "You are not maintaining a subconscious trance."},
    def = "You are maintaining a state of subconscious trance.",
    },
  weatherguard = { type = "shamanism",
    def = "You are wearing a cloak to ward against the worst of weather.",
    on = {"You are already surrounded by an ethereal cloak against the effects of weather.", "You carefully draw a few strands of ethereal substance from the air around you, wrapping it over your shoulders like a cloak."}
  },
  claw = { type = "shamanism",
    on = "The vision grows hazy and indistinct until only the yellow eyes of the cat remain before too vanishing into nothingness. You resolve to learn from what you have seen.",
    offr = [[^Your (past|present|future) vision of the claw becomes hazy and (?:fades from your mind's eye|uncertain and you can no longer remember it in detail)\.$]],
    defr = [[^You are contemplating a (past|present|future) vision of the claw\.$]],
    ondef = function () return "("..matches[2]..")" end
  },
  bloom = { type = "shamanism",
    on = "The vision grows hazy and indistinct until only the vibrant red bloom of the rose remains before too vanishing into nothingness. You resolve to learn from what you have seen.",
    offr = [[^Your (past|present|future) vision of the bloom becomes hazy and (?:fades from your mind's eye|uncertain and you can no longer remember it in detail)\.$]],
    defr = [[^You are contemplating a (past|present|future) vision of the bloom\.$]],
    ondef = function () return "("..matches[2]..")" end
  },
  bone = { type = "shamanism",
    on = "The vision grows hazy and indistinct until only the black eye sockets of the skull remain before too vanishing into nothingness. You resolve to learn from what you have seen.",
    offr = [[^Your (past|present|future) vision of the bone becomes hazy and (?:fades from your mind's eye|uncertain and you can no longer remember it in detail)\.$]],
    tooltip = "Cripples three uncrippled limbs of the target if in present, or two if the trance is in past or future",
    defr = [[^You are contemplating a (past|present|future) vision of the bone\.$]],
    ondef = function () return "("..matches[2]..")" end
  },
  root = { type = "shamanism",
    on = "The vision grows hazy and indistinct until only the roots of the tree remain before too vanishing into nothingness. You resolve to learn from what you have seen.",
    offr = [[^Your (past|present|future) vision of the root becomes hazy and (?:fades from your mind's eye|uncertain and you can no longer remember it in detail)\.$]],
    defr = [[^You are contemplating a (past|present|future) vision of the root\.$]],
    ondef = function () return "("..matches[2]..")" end
  },
  sky = { type = "shamanism",
    on = "The vision grows hazy and indistinct until only the white blanket of cloud remains before too vanishing into nothingness. You resolve to learn from what you have seen.",
    offr = [[^Your (past|present|future) vision of the sky becomes hazy and (?:fades from your mind's eye|uncertain and you can no longer remember it in detail)\.$]],
    defr = [[^You are contemplating a (past|present|future) vision of the sky\.$]],
    ondef = function () return "("..matches[2]..")" end
  },
  land = { type = "shamanism",
    on = "The vision grows hazy and indistinct until only the path extending into the distance remains before too vanishing into nothingness. You resolve to learn from what you have seen.",
    offr = [[^Your (past|present|future) vision of the land becomes hazy and (?:fades from your mind's eye|uncertain and you can no longer remember it in detail)\.$]],
    tooltip = "Sends a variable amount of enemies flying one or multiple rooms - can only be done in  natural underground, forest, grasslands, path, valley, mountains, jungle, garden, trees, or farmlands",
    defr = [[^You are contemplating a (past|present|future) vision of the land\.$]],
    ondef = function () return "("..matches[2]..")" end
  },
  death = { type = "shamanism",
    on = "You see your vision of death with perfect clarity, and a swirling miasma of black death clings tightly to your flesh, ready to destroy your enemies.",
    off = "You lose focus on your vision of death and it dissolves from your mind's eye.",
    def = "You are maintaining a vision of death."
  },
  imprint = { type = "shamanism",
    def = "You have imprinted on a distant weather pattern." },
#end

#if skills.tracking then
  poisonexpert = { type = "tracking",
    on = {"You concentrate intently on your knowledge of tracking and prepare to deliver your poisons more efficiently.", "You are already focusing on your knowledge of tracking to provide increased poison delivery."},
    def = "You are focusing intently on delivering poisons more efficiently."},
#end

#if skills.aquamancy then
  liquidform = { type = "aquamancy",
    on = "You stand tall and arc your back, becoming one with the element of water. Your flesh shimmers and roils, and your body transmutes into a liquid form.",
    off = "You urge your waters to coalesce, rising up into a column of aquatic majesty from which you step into the flesh once more.",
    def = "Your body turns solid as your watery form morphs into flesh."},
  whirlpool = { type = "aquamancy",
    off = {"The water around you calms down, no longer spinning in a powerful whirlpool.", "You lower your hands to your side and drag them slowly through the water, churning up great eddies that disrupt the whirlpool and force it to dissipate."},
    on = "You spin quickly in a circle, causing a whirlpool to churn around you."},
  watershield = { type = "aquamancy",
    on = {"You raise your staff and a spiritshield of water forms around you.", "You are already protected by a spiritshield of water."}},
#end

#if skills.aquachemantics then
  surging = { type = "aquachemantics",
    on = "You drop several ingots of platinum into your amphora and focus upon the liquid reagents within, running your palm counter-clockwise along its lip. Elemental waters pour forth from the mouth of the amphora and you deftly grab a hold of them, twisting and shaping them into a surging globe.",
    off = "The surging globe floating around you pops.",
    defr = [[^You have a surging globe floating around you for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  boiling = { type = "aquachemantics",
    on = "You drop several ingots of platinum into your amphora and focus upon the liquid reagents within, running your palm counter-clockwise along its lip. Elemental waters pour forth from the mouth of the amphora and you deftly grab a hold of them, twisting and shaping them into a boiling globe.",
    off = "The boiling globe floating around you pops.",
    defr = [[^You have a boiling globe floating around you for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  buoyancy = { type = "aquachemantics",
    on = "You drop several ingots of platinum into your amphora and focus upon the liquid reagents within, running your palm counter-clockwise along its lip. Elemental waters pour forth from the mouth of the amphora and you deftly grab a hold of them, twisting and shaping them into a buoyancy globe.",
    off = "The buoyancy globe floating around you pops.",
    defr = [[^You have a buoyancy globe floating around you for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  chilled = { type = "aquachemantics",
    on = "You drop several ingots of platinum into your amphora and focus upon the liquid reagents within, running your palm counter-clockwise along its lip. Elemental waters pour forth from the mouth of the amphora and you deftly grab a hold of them, twisting and shaping them into a chilled globe.",
    off = "The chilled globe floating around you pops.",
    defr = [[^You have a chilled globe floating around you for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  peaceful = { type = "aquachemantics",
    on = "Dipping your hands into your amphora you pull forth a handful of liquid reagents, quivering and shimmering with elemental energy. Using platinum as a basis for the reaction, you mix the reagents and coat yourself in the product, creating a peaceful sheen.",
    off = "The peaceful sheen fades from your skin.",
    defr = [[^You are covered by a peaceful sheen for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  fervid = { type = "aquachemantics",
    on = "Dipping your hands into your amphora you pull forth a handful of liquid reagents, quivering and shimmering with elemental energy. Using platinum as a basis for the reaction, you mix the reagents and coat yourself in the product, creating a fervid sheen.",
    off = "The fervid sheen fades from your skin.",
    defr = [[^You are covered by a fervid sheen for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  virtuous = { type = "aquachemantics",
    on = "Dipping your hands into your amphora you pull forth a handful of liquid reagents, quivering and shimmering with elemental energy. Using platinum as a basis for the reaction, you mix the reagents and coat yourself in the product, creating a virtuous sheen.",
    off = "The virtuous sheen fades from your skin.",
    defr = [[^You are covered by a virtuous sheen for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  ardent = { type = "aquachemantics",
    on = "Dipping your hands into your amphora you pull forth a handful of liquid reagents, quivering and shimmering with elemental energy. Using platinum as a basis for the reaction, you mix the reagents and coat yourself in the product, creating an ardent sheen.",
    off = "The ardent sheen fades from your skin.",
    defr = [[^You are covered by an ardent sheen for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  novamist = { type = "aquachemantics",
    on = {"You run your palm across the lip of your amphora, drawing forth plumes of warm, soothing novamist which cling to your skin.", "You are already expelling that mist."},
    off = "Your novamist dissipates.",
    def = "You are expelling life-saving novamist." },
#end

#if skills.geochemantics then
  neckbolts = { type = "geochemantics",
    on = "Moulding the iron bars into thick bolts, you expel ferrous fumes from a nozzle on your iron tanks onto the metal. Carefully guiding the metal's reaction to empower your excorable force, you press the bolts into the sides of your neck. Your flesh yields readily to the pressure of the metal, each bolt quickly sinking into your neck until it is anchored against your spine. The metal warms beneath your hands as it fuses to your bone and your flesh adheres to the earthen presence.",
    defr = [[^You have neck bolts for another (\d+) months?\.$]],
    off = "Your neck bolts rust away to dust, any remaining metal absorbed into you.",
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  rustedspikes = { type = "geochemantics",
    on = "Moulding the iron bars into long spikes, you expel ferrous fumes from a nozzle on your iron tanks onto the metal. As the ferrous fumes wash over the iron, it grows rusted and jagged, bits flaking off partially to form smaller teeth along the spikes. You drive the sharp bases of the spikes into your elbows and knees, the metal anchoring itself deep within your joints. The metal warms beneath your hands as it fuses to your bone and your flesh adheres to the earthen presence.",
    defr = [[^You have implanted rusted spikes in your elbows and knees lasting another (\d+) months?\.$]],
    off = "Your rusted spikes splinter from the repeated stress, falling away and disintigrating.",
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  bonelacing = { type = "geochemantics",
    on = "You expel chemical fumes from a nozzle on your iron tanks onto some iron bars, which dissolves to fill up a massive syringe retrieved from the side of the tanks. Using a second nozzle, you expel ferrous fumes onto the liquid metal, reinforcing it against divinus attack. Grasping the syringe tightly, you slam it into your thigh, the needle coming to rest deep within your bone. Pressing down on the plunger, you feel the liquid metal force itself into the bone, filling it and solidifying. You shiver slightly at the exquisite feeling of the earth entering and becoming a part of you. You then repeat the process until your skeleton has been fully reinforced with the metallic bone lacing.",
    defr = [[^You have injected your bones with a metallic lace which will last (\d+) months?\.$]],
    off = "Your bone lacing breaks down with age and is absorbed into you completely.",
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  hydraulics = { type = "geochemantics",
    on = "You carefully manipulate the iron bars to construct a pair of hydraulic pumps. Expelling ferrous fumes from a nozzle on your iron tanks, you reinforce the structure of the hydraulics. More iron bars are dissolved into a dark, metallic liquid with a blast of chemical fumes, which you use to fill the cylinders of the hydraulics. Driving the ends of the hydraulics into the back of your legs, the metal comes to rest against your bone, fusing solidly to it in order to reinforce your musculature. Bending your legs slightly, you test the hydraulics, easily propelled upward by them.",
    defr = [[^You are walking around on hydraulic-supported legs for another (\d+) months?\.$]],
    off = "Your hydraulics crack open and fall apart, losing their anchoring in your legs.",
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  pollutedstuds = { type = "geochemantics",
    on = "Reaching behind you, you open a nozzle on your iron tanks and expel ferrous fumes onto a set of iron bars, forming them into a series of flat, rounded studs. Each of the studs is then exposed to a concentrated blast of taint fumes expelled from your iron tanks, taking on a sickly green-rust colour. You carefully apply each stud to your body, the metal melting into your flesh and fusing itself to you.",
    defr = [[^Thick, polluted studs fume lightly in a poisonous smog around you for another (\d+) months?\.$]],
    off = "Your polluted studs lose their cohesion to your body, falling out and disintigrating upon impact with the ground.",
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  steamoptics = { type = "geochemantics",
    on = "Treating the iron bars with chemical fumes expelled from your iron tanks, you carefully construct the steam optics, forming the iron into two grey-coloured spheres, each pocked with countless tinydimples formed by a final application of chemical fumes. You open a second nozzle, covering the spheres with the expelled taint fumes, and watch carefully as the metal takes on a glittery, silver sheen. Finally, you grit your teeth and turn your head to one side, opening a third aimed at your eye, expelling toxic fumes which dissolve the eye and leave behind only a mushy jelly to drip slowly down your face. Using the remains of your eye as a lubricant, you install the new silvered orb in its place before repeating the process for the other eye.",
    defr = [[^You have replaced your eyes with steam optics which will last another (\d+) months?\.$]],
    off = "Your steam optics fracture under the stress, leaving you sightless.",
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  filthpump = { type = "geochemantics",
    on = "You carefully fold the willing iron bars into two smaller tanks, which you fill with a combination of toxic and taint fumes expelled from your iron tanks. Attaching the new tanks to either side of your existing iron tanks, you retrieve a pump mechanism and several tubes. The pump is quickly attached to the new tanks and installed between them, the tubing fitted to long, curved iron attachments. These attachments are moulded with the aid of additional taint fumes, before being pressed against either side of your abdomen. The iron slides willingly into your body, and the filth pump begins to whir with a shriek. An odd sensation of pressure fills you as the toxic-taint fume mixture enters you on one side, combines with and enhances the natural, putrid contents of your body, and leaves your other side to begin filling the new tanks.",
    defr = [[^You have implanted a filth pump in your abdomen which will process waste for another (\d+) months?\.$]],
    off = "Your filth pump breaks down, motor screaming as it catches fire and is expelled from your body.",
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  cranialimplant = { type = "geochemantics",
    on = "You form a rough dome from flattening several bars of iron and fit it onto you head. The iron slowly melts under your will, fitting perfectly to the shape of your skull. Reaching behind you, you expel a precise combination of chemical and tainted fumes from your iron tanks onto the dome, its surface sizzling and bubbling as it takes on an undulating pattern. As the fumes take full effect on the metal, dark energy begins to arc between peaks on the domed surface. Placing the completed cranial plate upon your head,  you smell a chemical, burning stench as the plate dissolves and replaces a portion of your skull.",
    defr = [[^You have replaced part of your skull with a cranial plate lasting for another (\d+) months?\.$]],
    off = "Your cranial plate splinters and shatters, falling away.",
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
#end

#if skills.wyrdenwood then
  seeping = { type = "wyrdenwood",
    defr = [[^You are partially covered in seeping bark for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  fibrous = { type = "wyrdenwood",
    defr = [[^You are partially covered in fibrous bark for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  wyrden = { type = "wyrdenwood",
    defr = [[^You are partially covered in Wyrden bark for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  razor = { type = "wyrdenwood",
    defr = [[^You are partially covered in razor bark for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  deadened = { type = "wyrdenwood",
    defr = [[^Dark, deadened branches spread through your bough for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  clinging = { type = "wyrdenwood",
    defr = [[^Hooked, clinging branches spread through your bough for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  thorny = { type = "wyrdenwood",
    defr = [[^Gnarled, thorny branches spread through your bough for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  tangled = { type = "wyrdenwood",
    defr = [[^Twisting, tangled branches spread through your bough for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  crimsonmoss = { type = "wyrdenwood",
    def = "Your trunk is covered from bough to trunk in dripping crimson moss."},
#end

#if skills.paradigmatics then
  chaotesign = { type = "paradigmatics",
    def = "The chaote sign burns on your forehead.",
    on = {"Your forehead tingles and you take your hands away, knowing the chaote symbol has been made manifest.", "The sign already affects you.", "Forming the symbol of the nine pointed star within your mind's eye, you press your palms firmly against your forehead and whisper words of power. Your forehead tingles and you take your hands away, knowing the chaote symbol has been made manifest."},
    off = "The chaote sign on your forehead flares and absorbs all damage before disappearing."},
  gnosis = { type = "paradigmatics",
    def = "Your spirit is strengthened through a gnostic revelation.",
    on = "You close your eyes and search deep within yourself, finding the center of consciousness and raising it to touch upon the fabric of creation."},
  goodluck = { type = "paradigmatics",
    def = "You are enjoying a bout of good luck.",
    on = {"You imagine all the good and wonderful things that can happen to you, and make them manifest.", "You already feel lucky, punk."}},
  fusion = { type = "paradigmatics",
    def = "You have fused together your heart, mind and body.",
    on = {"You fuse together your heart, mind and body.", "Your heart, mind and body are already fused together."},
    mana = "lots",
    off = {"You release the fusion that holds your heart, mind and body together.", "You have fused together your heart, mind and body."}},
  reimagination = { type = "paradigmatics",
    nodef = true,
    defr = [[^You are reimagined with a powerful (strength|constitution|intellect|dexterity|charisma)\.$]],
    ondef = function () return "("..matches[2]..")" end},
  polarity = { type = "paradigmatics",
    def = "You have shifted your inner polarity.",
    on = {"You shift your inner polarity.", "Your polarity is already shifted."}},
  enthrall = { type = "paradigmatics",
    on = {"You surround yourself with the perception that your beauty cannot be resisted by those who desire you.", "You are already enthralling."},
    def = "You are enthralling to those who love you.",
    off = "You will no longer enthrall others." },
  chaosaura = {
    type = "paradigmatics",
    on = {"You draw upon your own perception of reality to distort the air around you, exuding a chaotic aura around your hands.", "You are already exuding a chaotic aura."},
    def = "You are exuding an aura of chaos." },
  visionflux = {
    on = "Placing your fingers on your temples, you close your eyes and allow your subconscious visions to rise up and merge with your conscious state. You open your eyes and allow your visions to touch those who would question the reality that you create for yourself.",
    def = "You are surrounded by vision flux.",
    off = "Your visions no longer flux." },
#end

#if skills.transmology then
  fleshwork = {
    type = "transmology",
    def = "Your flesh is prepared for mutations.",
    on = {"You hold the flesh of lovashi between the palms of you hands and begin to squeeze. As the flesh squirms and separates, you open yourself up and absorb it into your system.", "Your body is already prepared for transformation."}},
  channels = { type = "transmology",
    on = {"Your channels are already open.", "You press your hands together and bow your head, concentrating upon opening up the aetheric channels to other planar entities."}},
#end

#if skills.aeromancy then
  mancywalk = { type = "aeromancy",
    def = "You can walk on the winds.",
    on = {"You are already walking upon winds.", "You walk around in a small circle, allowing your presence to bond with the air around you."},
    tooltip = "Allows WINDWALK and DESCEND."},
  twirlstaff = { type = "aeromancy",
    def = "Your body is surrounded by a nimbus cloud.",
    on = {"You are already surrounded by a nimbus cloud.", "You twirl your staff and a nimbus of clouds forms around you, crackling with tiny bolts of lightning."},
    tooltip = "Reduces damage and causes damage on being attacked."},
#end

#if skills.telekinesis then
  forcefield = { type = "telekinesis", on = "You surround yourself with a telekinetic forcefield." },
  psychiclift = { type = "telekinesis",
    on = {"You adjust your mind and prepare to grasp your victims.", "You are already psychicly lifting slain corpses."},
    off = "You adjust your mind and no longer grasp at your victims."},
#end

#if skills.telepathy then
  interference = { type = "telepathy",
    ondef = function () return "("..matches[2]..")" end,
    onr = [[^You exude a psionic aura of interference for (\w+) damage\.$]],
    defr = [[^You are interfering with resistance to (\w+) damage\.$]] },
#end

#if skills.dreamweaving then
  dreamweavecontrol = { type = "dreamweaving",
    on = "You weave a mental shield around your body."},
#end

#if skills.tarot then
  enigma = { type = "tarot",
    on = "You fling the card at the ground, and an image of Tzaraziko the Enigmatic springs forth. She smiles at you cryptically and raises her dark crystal hand. A deep vibration passes through you, and she mysteriously vanishes in the blink of an eye.",
    off = "The Enigma passes away from your being." },
  fool = { type = "tarot",
    on = "You fling a tarot card upon the ground, and you hear the jingling of the bells of a jester.",
    off = "The jingling of the bells of a jester fall silent." },
  warrior = { type = "tarot",
    on = "You fling a tarot card upon the ground, and an image of Klangratch, the Axe of War rises up. He salutes you, and gives you a knowing wink, before fading from sight.",
    off = "The presence of the Warrior leaves you."},
  princess = { type = "tarot",
    on = "You fling a tarot card at the ground, and a fountain of sparkling flecks of colour erupt at your feet. An image of the Imperial Princess appears and touches your brow, leaving a strange feeling in its wake.",
    off = "You reach out and beseech the memory of the Imperial Princess, allowing her healing warmth to flow over you."},
  starleaper = { type = "tarot",
    on = {"The Starleaper already protects you.", "You fling a tarot card upon the ground, and an image of Shanth of the Quiet Mind rises up, circling around you so fast that he becomes nothing but a blur. His speed becomes so great that even the blur fades from sight, though you sense his presence protecting you.", "The last vestiges of the Starleaper's power leave your being.", "The residue of the Starleaper's power still thrums in your being."}},
  world = { type = "tarot",
    on = "You fling a tarot card upon the ground, which explodes on impact and expands into a bubble of green light that rises up and engulfs you. The image of Kiakoda rises up in your mind and the ground vibrates beneath your feet.",
    off = "The image of Kiakoda leaves your mind and the green glow around you fades away."},
  teacher = { type = "tarot",
    ondef = function () return matches[2] end,
    defr = [[^You are taught by D'varsha in (\w+)\.$]],
    onr = [[^You fling a tarot card at yourself, which transforms into the image of D'varsha, who then whispers the secrets of \w+ to you\. Though your mind expands, it is a struggle to retain this new
understanding\.$]],
    offr = [[^The memories of D'varsha the Teacher fade and you no longer retain the knowledge he taught you of \w+\.$]]},
#end

#if skills.hunting then
  camouflage = { type = "hunting", def = "You are camouflaged.",
    on = {"You use the natural environment around you to camouflage yourself, hiding from prying eyes.", "You are already camouflaged."},
    onr = [[^You begin silently to shadow \w+'s movements about the land\.$]],
    off = {"You are not camouflaged.", "You step forth from your hiding."}},
#end

#if skills.music then
  bardicpresence = { type = "music",
    on = {"With a charming flourish, you bow down deeply. As you rise up slowly, your ego swells with the presence of the bardic profession.", "You already have a bardic presence."},
    def = "You have a bardic presence."},
#end

#if skills.dramaturgy then
  etiquette = { type = "music",
    on = {"You smooth back your hair and flash your pearly whites.", "You are already displaying fine etiquette."},
    def = "You are displaying fine etiquette."},
  foppery = { type = "music",
    on = {"Smoothing your clothes, you stand proud in your foppery.", "You already proud in your foppery."},
    def = "You are standing proudly in your foppery."},
  jealousy = { type = "music",
    on = {"You obsess over those you lust after.", "You are already obsessed on those you lust after."},
    off = {"You stop obsessing over those you lust after.", "You are already not obsessing over those you lust after."},
    def = "You are jealous of those you are in lust with."},
  rebuff = { type = "music",
    on = {"You will rebuff those who move you.", "You are already rebuffing those who move you."},
    off = {"You stop rebuffing those who move you.", "You are already not rebuffing those who move you."},
    def = "You are poised to rebuff those who move you."},
#end

#if skills.ecology then
  transmigration = { type = "ecology" },
#end

#if skills.psychometabolism then
  suspendedanimation = { type = "psychometabolism",
    on = "You shut down all your body's functions, and place yourself in suspended animation.",
    off = "Feeling gradually comes back to your limbs as awareness of your surroundings returns."},
  biocurrents = { type = "psychometabolism",
    on = "You psionically generate an electrical current which runs through your body.",
    def = "Your body is charged with electrical currents."},
  bonedensity = { type = "psychometabolism",
    on = "You compress the density of your bones to help prevent them from breaking."},
  doublepain = { type = "psychometabolism",
    on = "You tune your body to inflict greater pain."},
  introspection = { type = "psychometabolism",
    on = {"You split your mind's focus, allowing a part of it to introspect constantly and boost your regenerative capabilities.", "You are already introspectively boosting your regeneration."},
    off = "You snap your head up as you break your meditation.",
    def = "You are maintaining a constant state of introspection, boosting your regeneration."},
  energycontainment = { type = "psychometabolism",
    on = "You reconfigure your nervous system to contain and disperse elemental energies."},
  enhancementstrength = { type = "psychometabolism",
    on = "You psionically enhance the strength of your body.",
    def = "Your strength is psionically enhanced."},
  enhancementdexterity = { type = "psychometabolism",
    on = "You psionically enhance the speed of your body.",
    def = "Your dexterity is psionically enhanced."},
  enhancementspread = { type = "psychometabolism",
    on = "You psionically enhance your body, spread through your offensive abilities and speed.",
    def = "Your strength and dexterity are psionically enhanced."},
  gliding = { type = "psychometabolism",
    on = "You focus your mind on the soles of your feet, adjusting their density to glide upon any surface."},
  ironskin = { type = "psychometabolism",
    on = "You focus your mind on your skin, feeling it thicken and becoming as hard as iron."},
  mindfield = { type = "psychometabolism",
    on = {"You wrap a psionic field around your mind to discharge a psychic backlash if someone attempts to scry you.", "Your mind is already wrapped in a field to discharge a psychic backlash.", "You wrap a psionic field around your mind to discharge a psychic backlash if someone attempts to scry you."},
    off = "Your mind is already wrapped in a field to discharge a psychic backlash."},
  lifedrain = { type = "psychometabolism" },
  pheromones = { type = "psychometabolism",
    on = "You force your glands open and release pheromones invisibly into the air."},
  forcedsymmetry = { type = "psychometabolism",
    def = "Your body is tuned to symetrically spread wounds.",
    on = "You psionically tune your body to spread wounds."},
  psiregeneration = { type = "psychometabolism",
    on = "You prepare your body to regenerate itself."},
  bloodboil = { type = "psychometabolism",
    def = "Your blood is boiling.",
    on = "You force your veins to widen and increase the temperature of your blood, boiling it in rapid cycles through your arteries."},
#end

#if skills.psionics then
  biofeedbackmagic = { type = "psionics",
    on = "You create a biofeedback loop within your mind to protect against magic."},
  biofeedbackfire = { type = "psionics",
    on = "You create a biofeedback loop within your mind to protect against fire." },
  biofeedbackcold = { type = "psionics",
    on = "You create a biofeedback loop within your mind to protect against cold."},
  biofeedbackelectric = { type = "psionics",
    on = "You create a biofeedback loop within your mind to protect against electric." },
  secondsight = { type = "psionics",
    specialskip = function ()
      return defc.trueblind
    end },
  bodydensity = { type = "psionics",
    on = {"You concentrate on forcing your body to become more dense.", "You have already become more dense."}},
  ironwill = { type = "psionics",
    on = {"With great concentration, you focus all thoughts upon your inner self.", "You have locked that channel and will not be able to use it until you release your lock."}},
  mindbar = { type = "psionics",
    on = {"You raise a mental bar around your mind.", "You already have a mental bar around your mind."}},
  psiarmour = { type = "psionics",
    specialskip = function ()
      return defc.psisense
    end,
    on = {"You mentally send a psychic field that surrounds your body.", "You mentally raise a psychic field that surrounds your body."},
    off = "You relax your mind and feel the Substratus channel opening again."},
  psisense = { type = "psionics",
    specialskip = function ()
      return defc.psiarmour
    end,
    on = {"You open up your mind to sense psionic activity around you.", "You are already sensing for psionic activity."},
    off = "You close your mind to sensing psionic activity."},
#end

#if skills.tahtetso then
  block = { type = "tahtetso"},
  grip = { type = "tahtetso",
    on = {"You concentrate on gripping tightly with your hands.", "You already have a firm grip."},
    off = {"You relax your grip.", "Your grip is already relaxed."}},
  --[[deflectright = { type = "tahtetso",
    on = "You prepare your right hand to deflect blows.",
    off = "You relax your hands."},
  deflectleft = { type = "tahtetso",
    on = "You prepare your left hand to deflect blows.",
    off = "You relax your hands."},]]
#end

#if skills.illusions then
  blur = { type = "illusions",
    on = {"You distort the light around yourself until your body becomes somewhat blurred.", "You are already blurred."},
    off = "You come back into focus as the blur illusion vanishes."},
  reflection = { type = "illusions",
    on = "You weave a glamour and mold it until it becomes a reflection of yourself.",
    on_only = "This spell may only be used to cast one reflection on someone. If he or she already has one, it may not be used.",
    off = "One of your reflections has been destroyed! You have 0 left."},
  invisibility = { type = "illusions",
    on = {"You bend light around yourself until you are rendered invisible.", "You are already invisible."},
    off = "You become visible once more."},
  changeself = { type = "illusions",
    on = "You are already that race.",
    onr = [[^You weave a glamour around yourself, which solidifies into the form of .+\.$]],
    offr = [[^Your illusion of being \w+ fades away\.$]],
    defr = [[^You are under an illusion to look \w+\.$]]},
#end

#if skills.crow then
  bonenose = { type = "crow",
    on = {"You already have bone nose painted on your face.", "Ceremoniously, you dab some purple tint upon your face, creating the pattern of a bone nose."},
    off = {"You wipe some paint off your face.", "You do not have that face paint upon yourself.", "You have no face paints to wipe off."}},
  perch = { type = "crow",
    on = "You dig your talons into the branches here as you squat with shoulders hunched.",
    off = "You lose your perch."},
  spiderweb = { type = "crow",
    on = {"Ceremoniously, you dab some blue tint upon your face, creating the pattern of an intricate spiderweb.", "You already have spiderweb painted on your face."},
    off = {"You wipe some paint off your face.", "You do not have that face paint upon yourself.", "You have no face paints to wipe off."}},
  deathmask = { type = "crow",
    on = {"Ceremoniously, you dab some gold tint upon your face, creating the pattern of a gruesome deathmask.", "You already have deathmask painted on your face."},
    off = {"You wipe some paint off your face.", "You do not have that face paint upon yourself.", "You have no face paints to wipe off."}},
  carrionstench = { type = "crow", def = "You are stinking with the stench of carrion.",
    on = {"You swallow some air and allow it to brew in your stomach before belching it back up powerfully, bringing with it the strong and repugnant stench of carrion.", "You are already stinking up this room."},
    off = {"The stench of carrion coming from you abruptly fades away.", "You are not currrently stinking up this room."}},
  crowform = { type = "crow", def = "Your body is covered in black oily feathers.",
    on = {"You settle down in your nest and let a shell form around you. Great Crow comes to you in a dream, cawing at you and filling you with power. When the dream ends, you break out of your egg, feeling as though you are born anew.", "Great Crow has already blessed you."}},
  crowsfeet = { type = "crow", def = "Your face is painted with crow's feet.",
    on = {"Ceremoniously, you dab some yellow tint upon your face, creating the pattern of crow's feet.", "You already have crow's feet painted on your face."},
    off = {"You wipe some paint off your face.", "You do not have that face paint upon yourself.", "You have no face paints to wipe off."}},
  spy = { type = "crow", def = "Your nest is projecting visions to you.",
    on = {"You begin to pay attention to projections from your nest.", "You are already listening to projections from your nest."},
    off = {"You cease to pay attention to projections from your nest.", "You are not currently listening to projections from your nest."}},
  darkrebirth = { type = "crow", def = "Your soul is twined with a dark spirit that is waiting for your death.",
    on = {"You kneel down in the branches and lure a dark spirit to come to you with promises of a rebirth into the flesh. From out of the shadows crawls a spirit which swirls around in your nest, slowly collecting the carrion within. With a sudden screech, it rolls itself into a pulsating ball of blackened flesh that solidifies into a glistening black egg.", "You already have an egg prepared for your rebirth."}},
  darkspirit = { type = "crow", def = "Your flesh is bound with a dark spirit that protects you.",
    on = 'A glistening black egg suddenly cracks, releasing the dark spirit that you have lured to your nest. The spirit whispers into your ear, "It is my time for the flesh!" and wraps itself around you. Darkness envelops you for a brief moment, before fading away. You can feel the presence inside you, and a rasping laugh echoes from somewhere beyond.'},
#end

#if skills.stag then
  staghide = { type = "stag",
    on = {"You call upon the spirit of the stag to protect you, and your skin turns into a thick stag's hide.", "You are already covered with stag's hide."}},
  bolting = { type = "stag",
    on = {"You call upon the spirit of the stag to guide you. Your legs tingle as the stag pours his blessings on you.", "You already set to flee upon sighting an enemy."},
    off = {"You feel your legs settle down.", "You already are not set to flee upon sighting an enemy."}},
  greenman = { type = "stag",
    on = {"Ceremoniously, you dab some green tint upon your face, creating the pattern of an image of the greenman.", "You already have an image of the greenman painted on your face."},
  },
  trueheart = { type = "stag",
    on = {"Ceremoniously, you dab some yellow tint upon your face, creating the pattern of bright rays of sunshine.", "You already have an image of trueheart painted on your face."}
  },
  swiftstripes = { type = "stag",
    on = {"Ceremoniously, you dab some red tint upon your face, creating the pattern of stripes.", "You already have swift stripes painted on your face."} },
  lightningmask = { type = "stag", def = "Your face is painted with blue bolts of lightning.",
    on = {"Ceremoniously, you dab some blue tint upon your face, creating the pattern of lightning bolts.", "You already have lightning bolts painted on your face."},
    tooltip = "Speeds equilibrium recovery and slows balance recovery." },
  stagform = { type = "stag",
    on = {"You call upon Stag and throw wide your arms. You embrace the presence of Stag as he manifests and your heart thuds as antlers sprout upon your head.", "You have already taken the form of a stag."},
    def = "Your body has been blessed by the stag."},
#end

#if skills.wildewood then
  iron = { type = "wildewood",
    defr = [[^You are partially covered in a thick layer of iron bark for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  evergreen = { type = "wildewood",
    defr = [[^You are partially covered in a thick layer of evergreen bark for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  moonhart = { type = "wildewood",
    defr = [[^You are partially covered in a thick layer of moonhart bark for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  lead = { type = "wildewood",
    defr = [[^You are partially covered in a thick layer of lead bark for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  knobbled = { type = "wildewood",
    defr = [[^Large knobbled branches spread through your bough for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  gossamer = { type = "wildewood",
    defr = [[^Slender gossamer branches spread through your bough for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  flowering = { type = "wildewood",
    defr = [[^Wild flowering branches spread through your bough for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  mossy = { type = "wildewood",
    defr = [[^Verdant mossy branches spread through your bough for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  wildecall = { type = "wildewood",
    def = "Your Wilde call is reverberating through the forests of the First World.", },
#end

#if skills.aethercraft then
  covey = { type = "aethercraft", def = "You are in a covey with" },
  deepbond = { type = "aethercraft", def = "You have a deepbond with" },
#end

#if skills.moon then
  harvest = { type = "moon",
    nodef = true
  },
  drawdown = { type = "moon",
    on = "You form a triangle with your hands and frame the moon within. After whispering devotions to the moon, you lower your hands and feel the power of the moon suffuse your very spirit."},
  shine = { type = "moon",
    on = "Raising your hands over head, you beseech Mother Moon for her many blessings. A shaft of moonlight falls upon you, soaking into your skin and filling you with the throbbing cycle of phases."},
  aura = { type = "moon",
    on = "You dance to the spirit of the moon, asking for protection. A soft light suffuses you."},
  waxing = { type = "moon",
    def = "You are bathed in soft lunar light.",
    on = "You dance joyously to the spirit of the Moon and are bathed in a soft lunar light which suffuses your body.",
    off = "The soft lunar light suffusing your body fades away." },
#end

#if skills.sacraments then
  constitution = { type = "sacraments", def = "You are using your superior constitution to prevent nausea." },
  fervor = { type = "sacraments",
    on = {"You are already filled with religious fervor.", "You clasp your hands together and offer up fervent prayers to the Holy Supernals to guide your words and deeds. You feel a blaze of righteous fervor race through your veins, secure that the Light guides you."}
  },
  numen = { type = "sacraments",
    on = "A luminous spirit descends from the heavens and merges with your spirit. This Gift of the Light pulsates hotly within your bosom.",
    off = "The aura of numen fades away."},
  fitness = { type = "sacraments" },
  honour = { type = "sacraments" },
  purity = { type = "sacraments" },
  lustration = { type = "sacraments",
    def = "You are affected by the ritual of lustration.",
    on = {"You are already affected by the ritual of lustration.", "You cleanse your mortal frame through the chant of the Holy lustration, and a divine purity washes over your body.", "You cleanse your mortal frame through the chant of the Holy Lustration, and a divine purity washes over your body."},
    off = "The ritual of lustration surrounding you fades away.",
  },
  ablution = { type = "sacraments",
    def = "You are affected by the ritual of ablution.",
    on = {"You are already affected by the ritual of ablution.", "You cleanse your mortal frame through the chant of the Holy Ablution, and a divine purity washes over your body.", "You cleanse your mortal frame through the chant of the Holy Ablutions, and a divine purity washes over your body."},
    off = "The ritual of ablution surrounding you fades away.",
  },
  holylight = {
    type = "sacraments",
    nodef = true,
    ondef = function () return matches[2] end,
    defr = [[^You have (\d+) globes of Holy Light entwined with your soul\.$]],
  },
#end

#if skills.cosmic then
  soulguard = { type = "cosmic", def = {"Your soul is guarded against the ravages of the cosmos.", "Your inner worm is guarded against the ravages of the cosmos."},
    on = {"You weave a delicate lattice of energy around your body, sheltering your soul from the ravages of the cosmos.", "Your soul is already guarded against the ravages of the cosmos.", "Your inner worm is already guarded against the ravages of the cosmos."}},
#end

  vitality = { 
#if skills.athletics then
    type = "athletics",
#else
    type = "artifact",
#end
    on = {"Your body positively glows with health and vitality.", "You need to be fully healthy in both body and mind before you can call upon your vitality.", "Vitality already sings in your bloodstream.","You cannot call upon your vitality again so soon."},
    off = "A surge of rejuvenating energy floods your system, healing your wounds."},
#if skills.athletics then
  breathing = { type = "athletics",
    on = "You take a few deep breaths to prepare your body for a marathon workout."},
  resistance = { type = "athletics", on = "You call aloud and feel an aura of resistance shroud itself silently about you." },
  immunity = { type = "athletics",
    on = {"You close your eyes and grit your teeth, feeling the heat of the blood pumping through your veins.", "Your immune system is already charged."}},
  weathering = { type = "athletics",
    on = {"A brief shiver runs through your body.", "You are already attuned to the flows of weather."}},
  regeneration = { type = "athletics",
    on = {"You begin to concentrate on regeneration of your wounds.", "You are already regenerating."},
    def = "You are regenerating lost health.",
    off = {"You call a halt to the regenerative process.", "You are not attempting to regenerate lost health.", "You have no regenerative ability to boost."}},
  boosting = { type = "athletics",
    on = {"You call upon your inner strength to boost your health regeneration.", "Your regeneration is already boosted."},
    def = "Your regeneration is boosted."},
  surge = { type = "athletics",
    on = {"You pound your chest with your fists, and bellow fiercely. Your body expands to heroic proportions.", "Your body is already surged to maximum potential."},
    off = {"Your body is not under a surge.", "You relax the surge of power through your body, and dwindle to normal proportions."}},
  flex = { type = "athletics", on = "You flex your muscles, which bulge and pop in a spectacular display of your outstanding physique." },
  consciousness = { type = "athletics", def = "You are maintaining consciousness at all times.",
    on = "You will remain conscious at all times.",
    off = {"You will no longer concentrate on retaining full consciousness.", "You feel your grasp over your consciousness slip away with a wrenching feeling of sickness."}},
  constitution = { type = "athletics", def = "You are using your superior constitution to prevent nausea.",
    on = "You clench the muscles in your stomach, determined to assert your superior constitution."},
  adrenaline = { type = "athletics",
    on = "You are already speeded.",
    specialskip = function ()
      return defc.quicksilver
    end
  },
#end

#if skills.shofangi then
  bullrage = { type = "shofangi" },
  grip = { type = "shofangi",
    on = {"You concentrate on gripping tightly with your hands.", "You already have a firm grip."},
    off = {"You relax your grip.", "Your grip is already relaxed."}},
  --[[deflectright = { type = "shofangi",
    on = "You prepare your right hand to deflect blows.",
    off = "You relax your hands."},
  deflectleft = { type = "shofangi",
    on = "You prepare your left hand to deflect blows.",
    off = "You relax your hands."},]]
#end


#if skills.geomancy then
  earthpulse = { type = "geomancy",
  on = {"You raise your staff and feel the throbbing pulse of the tainted earth flow through your veins, increasing the magic of your spells.", "The throbbing pulse of the tainted earth already flows through your veins." }},
#end

#if skills.pyromancy then
  mancyproof = { type = "pyromancy",
    def = "You are proofed against fire.",
    on = "You rub your hands up and down your arms, lighting small fires that quickly spread and cover your entire body before quickly dying out."},
  flamering = { type = "pyromancy",
    def = "You are surrounded by a ring of flames.",
    on = "You slowly spin around, and dancing flames begin to blossom at your feet. When the flames are surging in a circle around you, you stomp your feet and the circle contracts into a blazing ring of fire."},
  cauterize = { type = "pyromancy",
    def = "You are bathed in soothing green flames which quickly cauterise your wounds.",
    on = "You raise your staff and soothing green flames travel over your body." },
#end

#if skills.aerochemantics then
  chemwalk = { type = "aerochemantics",
    def = "You can walk on the winds.",
    on = {"You are already walking upon winds.", "You walk around in a small circle, allowing your presence to bond with the air around you."},
    tooltip = "Allows WINDWALK and DESCEND."},
#end

#if skills.pyrochemantics then
  chemproof = { type = "pyrochemantics",
    def = "You are proofed against fire.",
    on = "You rub your hands up and down your arms, lighting small fires that quickly spread and cover your entire body before quickly dying out."},
  pyroaugmentorious = { type = "pyrochemantics",
    defr = [[^You have a pyroaugmentorius gadget for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  dampeners = { type = "pyrochemantics",
    defr = [[^You have electrical dampeners lasting another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  thermalpumps = { type = "pyrochemantics",
    defr = [[^You have cool thermal pumps which will last (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  goggles = { type = "pyrochemantics",
    defr = [[^You have haze-piercing goggles for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  scorching = { type = "pyrochemantics",
    defr = [[^You are surrounded by a haze of scorching smoke for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  hallucinatory = { type = "pyrochemantics",
    defr = [[^You are surrounded by a haze of hallucinatory smoke for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  pyretic = { type = "pyrochemantics",
    defr = [[^You are surrounded by a haze of pyretic smoke for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  fevered = { type = "pyrochemantics",
    defr = [[^You are surrounded by a haze of fevered smoke for another (\d+) months?\.$]],
    offline_defence = true,
    ondef = function () return "("..matches[2].."mo)" end },
  doping = { type = "pyrochemantics",
    on = {"You concentrate on your effluvia, doping them with a mind-dulling drug.", "Your effluvia are already impeding movement."},
    invisibledef = true,
    off = "You concentrate on your effluvia, clearing the mind-dulling drug from them." },
#end

#if skills.night then
  drink = { type = "night",
    on = {"You are already drinking of the darkness.", "You dip your hands into the surging shadows around you, letting your soul bond with the darkness so that you may drink deeply of its essence."}},
  garb = {
    type = "night",
    on = {"You hug yourself, causing shadows to fly out from your grip and swathe you like a clinging cloak.", "You are already wearing a garb of shadows."}
  },
  nightkiss = {
    type = "night",
    on = {"You have already been gifted with the embrace of Mother Night.", "You fall to the ground and implore Mother Night for her dark favour. A glittering wall of darkness sweeps up before you, and a shadowy female figure emerges. She bends down and kisses you on the forehead and you scream in a mixture of pain and ecstasy as her dark power infuses your very being."}
  },
#end

#if skills.totems then
  nature = {
    off = "You release the spirit of nature, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = {"You call upon all the spirits of Nature, and a whirlwind of power surrounds you, briefly lifting you from the ground. As every spirit embraces you, you shudder and tremble in delight.", "You are already bonded to all of Nature's spirits."}},
  squirrel = {
    off = "You release the spirit of squirrel, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = "You call upon the spirit of squirrel to provide sustenance for you. You cannot stifle a giggle as you are tickled by tiny paws running over your skin.",
    on_only = "You are already bonded with that totem spirit.",
    def = "The spirit of squirrel grants you the ability to forage."},
  night = {
    off = "You release the spirit of night, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = {"It must be night to bond with mother night.", "You call upon the spirit of mother night to hide you. Her dark presence makes your skin crawl."},
    on_only = "You are already bonded with that totem spirit.",
    def = "During the dark hours, the spirit of mother night will conceal you."},
  skunk = {
    off = "You release the spirit of skunk, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = "You call upon the spirit of skunk. You wrinkle your nose as his musky presence envelops you.",
    on_only = "You are already bonded with that totem spirit.",
    def = "The spirit of skunk grants you the dubious gift of stink."},
  sun = {
    off = "You release the spirit of sun, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = "You call upon the spirit of sun and a warm ray of sunlight infuses you with confidence.",
    on_only = "You are already bonded with that totem spirit.",
    def = "By the grace of the spirit of the sun, your ego shall replenish during the day."},
  rock = {
    off = "You release the spirit of rock, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = {"You must be standing in the mountains to bond with rock spirit.", "You call upon the spirit of the great rock to ground you to the earth, and you feel your feet become encased in clay."},
    on_only = "You are already bonded with that totem spirit.",
    def = "The spirit of rock will help root you to the earth."},
  moon = {
    off = "You release the spirit of moon, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = {"It must be night to bond with moon spirit.", "You call upon the spirit of moon and a soft shaft of moonlight beams down upon you, filling you with power."},
    on_only = "You are already bonded with that totem spirit.",
    def = "Under the night sky, your mana replenishes, a gift from the spirit of the moon."},
  crow = {
    off = "You release the spirit of crow, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = "You call upon the spirit of crow and feel oily black feathers caress your skin, making you shudder.",
    on_only = "You are already bonded with that totem spirit.",
    def = "Make others flee with the power of the spirit of crow."},
  tree = {
    off = "You release the spirit of tree, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = {"You must be in the presence of your commune's mystic tree to bond with tree spirit.", "You call upon the spirit of tree to heal you. A gentle breeze carries a rich and loamy scent which invigorates you."},
    on_only = "You are already bonded with that totem spirit.",
    def = "In the presence of mystic trees, be healed by virtue of the spirit of tree."},
  groundhog = {
    off = "You release the spirit of groundhog, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = "You call upon the spirit of groundhog to grant you the gift of burrowing. Your nostrils fill with the scent of earth and a claw brushes your cheek gently.",
    on_only = "You are already bonded with that totem spirit.",
    def = "Burrow through the ground with the spirit of groundhog."},
  trout = {
    off = "You release the spirit of trout, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = "You call upon the spirit of rainbow trout, and a fine spray of water cools your skin.",
    on_only = "You are already bonded with that totem spirit.",
    def = "You gain the ability to trueswim and breathe underwater by the spirit of trout."},
  wolf = {
    off = "You release the spirit of wolf, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = "You call upon the spirit of wolf to give you courage. As the power of Wolf infuses you, you let out a howl of the wild.",
    on_only = "You are already bonded with that totem spirit.",
    def = "Find courage within yourself by the spirit of wolf."},
  bear = {
    off = "You release the spirit of bear, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = "You call upon the spirit of bear and feel a powerful rush of strength course through your veins. You let loose a vigorous roar of exhilaration.",
    on_only = "You are already bonded with that totem spirit.",
    def = "The spirit of bear grants you great strength."},
  stag = {
    off = "You release the spirit of stag, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = "You call upon the spirit of stag and your scalp itches as invisible antlers sprout from your head.",
    on_only = "You are already bonded with that totem spirit.",
    def = "Run free and fast like the spirit of stag."},
  monkey = {
    off = "You release the spirit of monkey, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = "You call upon the spirit of monkey and surrender yourself to a sudden urge to drag your knuckles on the ground and whoop.",
    on_only = "You are already bonded with that totem spirit.",
    def = "The spirit of monkey grants you the ability to move about the trees."},
  horse = {
    off = "You release the spirit of horse, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = "You call upon the spirit of horse and an electrifying surge of energy ripples through your legs, forcing you to neigh loudly.",
    on_only = "You are already bonded with that totem spirit.",
    def = "Leap over obstacles by virtue of the spirit of horse."},
  river = {
    off = "You release the spirit of river, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = {"You must be swimming in a river or fresh water lake to bond with river spirit.", "You call upon the spirit of the river daughter and laugh joyously as water swirls over your body."},
    on_only = "You are already bonded with that totem spirit.",
    def = "While in the waters of a raging river, the spirit of river will heal you."},
  snake = {
    off = "You release the spirit of snake, silently thanking the spirit for bonding with you.",
    type = "totems",
    custom_def_type = "spiritbond",
    on = "You call upon the spirit of snake and feel cool silky coils winding over your skin.",
    on_only = "You are already bonded with that totem spirit.",
    def = "Resist venoms by virtue of the spirit of snake."},
#end

#if skills.nature then
  blend = {
    command = "nature blend on",
    type = "nature",
    -- mana = "lots", mana = "little",
    on = {"You kneel and place a palm on the ground, imploring nature to hide you from prying eyes.", "You are already blended into the foliage.", "You must be in the forests to blend into the foliage."},
    def = "You are blended in the foliage.",
    off = {"You step forth from your hiding.", "You are suddenly revealed!"},
    off_free = "You are not blended into the foliage.",
  },
  barkskin = {
    command = "nature barkskin",
    type = "nature",
    on = "You concentrate for a moment, and your skin becomes rough and thick like tree bark.",
    on_free = "Your skin is already covered in protective bark.",
    def = "You have skin covered in treebark.",
  },
  rooting = {
    command = "nature rooting",
    type = "nature",
    on = {"You thump the ground with your athame and feel a connection with the earth.", "You must be on dry ground to cast that.", "You thump the ground with your cudgel and feel a connection with the earth."},
    on_free = "You are already rooted.",
    def = "You are rooted."
  },
  torc = {
    command = "nature torc",
    invisibledef = true,
    type = "nature",
    onr = [[^You raise .+ up and make a circle in the air\. A radiant torc forms from the ether and settles around your neck\.$]],
    off = "A silver torc cracks and crumbles to dust.",
    tooltip = "Saves you 10% mana each time your mana is drained and adds +5 DMP"
  },
#end
})

-- nature spirits start line
#if skills.totems then
;(tempExactMatchTrigger or tempTrigger)('SPIRITS:', 'mm.defs.defspiritbondstart()');
#end



-- enable org-specific defs if any
defences.orgdefs = function ()
  if not conf.org or conf.org == "none" then return end

  if conf.org == "Glomdoring" then
    defs_data.nightsweats = { type = "general",
      offr = [[^Thin tendrils of shadow reach out from you to rake across the skin of \w+ as the nightsweats well from within\.$]],
      def = {"A strange surge is growing inside of you.", "You are prepared to make use of nightsweats coursing through your body."},
      tooltip = "Adds bleeding to damage done."
    }

#if not skills.night then
    defs_data.garb = {
      type = "general",
      def = "You are wearing a garb of shadows.",
      on = {"You hug yourself, causing shadows to fly out from your grip and swathe you like a clinging cloak.", "You are already wearing a garb of shadows."}
    }
#end
  elseif conf.org == "Gaudiguch" then
#if not skills.paradigmatics then
    defs_data.chaotesign = { type = "general",
      def = "The chaote sign burns on your forehead.",
      on = {"Your forehead tingles and you take your hands away, knowing the chaote symbol has been made manifest.", "The sign already affects you.", "Forming the symbol of the nine pointed star within your mind's eye, you press your palms firmly against your forehead and whisper words of power. Your forehead tingles and you take your hands away, knowing the chaote symbol has been made manifest.", "The sign already affects you."},
      tooltip = "5% damage reduction for 10 hits. Absorbs all damage and fades on 10th hit.",
      off = "The chaote sign on your forehead flares and absorbs all damage before disappearing."}
#end

    defs_data.firemead = { type = "general",
      def = {"A strange surge is growing inside of you.", "You are prepared to make use of firemead coursing through your body."},
      offr = [[^The fiery brew within your belly can be contained no more, and you belch out a cone of scorching flames at \w+\.$]],
      tooltip = "Gives an aura to the attacker that'll stun them whenever they try to sip health, mana or bromodes - up to three times"}
  elseif conf.org == "Serenwilde" then
    defs_data.moonwater = { type = "general",
      def = {"A strange surge is growing inside of you.", "You are prepared to make use of moonwater coursing through your body."},
      off = "A pale glow surrounds you as the moonwater soothes you.",
      tooltip = "Cures an affliction when you sip health, mana, or bromides"}
  elseif conf.org == "Celest" then
    defs_data.holywater = { type = "general",
      off = "A soft light momentarily surrounds you as the holy water protects you from harm.",
      def = {"A strange surge is growing inside of you.", "You are prepared to make use of holy water coursing through your body."},
      tooltip = "Resistance to damage."}
  elseif conf.org == "Magnagora" then
    defs_data.unholywater = { type = "general",
    def = "You are prepared to make use of unholy water coursing through your body." ,
    tooltip = "Does damage to those who damage you."}
  elseif conf.org == "Hallifax" then
#if not skills.aeonics then
    defs_data.mindclock = { type = "general",
      def = "Your mind's inner clock is synchronised with your body.",
      tooltip = "Chance to avoid aeon effects",
      on = {"You force your mind to synchronise with your body's inner clock.", "Your time clock is already active."}}
#end
    defs_data.quickening = { type = "general",
      def = "You are being quickened through time.",
      off = "You are no longer quickened through time.",
      on = {"You pause for the briefest of moments and bend time slightly about you, and everything but you slows down slightly."}}
    defs_data.cloudberry = { type = "general",
      def = {"A strange surge is growing inside of you.", "You are prepared to make use of cloudberry tea coursing through your body."},
      offr = [[^A rush of icy air leaves your pores and surrounds \w+ in a frigid cloud, turning (?:his|her) potions to slush\.$]],
      tooltip = "Gives an aura to the attacker that'll stun them whenever they try to sip health, mana or bromodes - up to three times"}
  end
end
signals.systemstart:connect(defences.orgdefs)

defences.urlify = function (self)
  local t = string.split(self, " ")
  for i = 1, #t do
    t[i] = string.title(t[i])
  end

  return table.concat(t, "_")
end

defences.infolinkify = function(def)
  if defs_data[def].tooltip and selectString(def, 1) ~= -1 then
    setLink([[mm.openURL("http://wiki.lusternia.com/Defenses#]] .. defences.urlify(def) .. [[")]], defs_data[def].tooltip)
  end
end

defences.complete_def = function(tbl)
  local name, def, defr, tooltip = tbl.name, tbl.def, tbl.defr, tbl.tooltip
  local name = name:lower()

  if not defs_data[name] then return end

  defs_data[name].def = def or defs_data[name].def
  defs_data[name].defr = defr or defs_data[name].defr
  defs_data[name].tooltip = tooltip or defs_data[name].tooltip
end

defences.complete_def({name = "Acquisitio", def = "Ritual of Acquisitio (acquisitio) (indefinite).",
  defr = [[^Ritual of Acquisitio \(acquisitio\) \(\d+ minutes\)\.$]],
  tooltip = "Pick up your kills, and random other things."})

defences.complete_def({name = "Adroitness", def = "You are moving at an increased rate of speed.", tooltip = "Allows you to move a few extra steps before receiving the 'Now, now, don't be so hasty!' message."})

defences.complete_def({name = "Aegis", defr = {[[^You have bound your lifeforce to shield (\w+)\.$]], [[^Your lifeforce is shielded by the aegis of (\w+)\.$]]}, tooltip = "Deflects damage from one person to another."})

defences.complete_def({name = "Aethersight", def = "You are sensing disruptions in the aether.", tooltip = "Reveals when you are scried or located."})

defences.complete_def({name = "Aggressive", def = "You are fighting with powerful blows.", tooltip = "Increases damage but decreases wounding."})

defences.complete_def({name = "Agility", def = "Your agility is enhanced.", tooltip = "Allows you to move a few extra steps before receiving the 'Now, now, don't be so hasty!' message."})

defences.complete_def({name = "Amberbeer", def = "Your pain is deadened by alcohol.", tooltip = "Deadens pain (reduces dmg done to you by ~4.5%)"})

defences.complete_def({name = "Ancestors", tooltip = "Reduces damage; also used for other Wildarrane skills."})

#if skills.celestialism then
defences.complete_def({name = "Wings", def = "Angelic wings sprout out of your back.", tooltip = "Allows flight."})
#end

defences.complete_def({name = "Antlers", def = "An Antlers sphere positively affects you.", tooltip = "Variable boost to dexterity."})
defences.complete_def({name = "Volcano", def = "A Volcano sphere positively affects you.", tooltip = "Reduces fire damage."})

defences.complete_def({name = "AromaticOil", tooltip = "Increases influence strength."})

defences.complete_def({name = "Presence", def = "Your confidence is bolstered by an Ascendant presence.", tooltip = "Weighed +1 to charisma, and ego regeneration."})

defences.complete_def({name = "Attune", tooltip = "Reduces damage in the specified environment."})

defences.complete_def({name = "aurasense", def = "You are sensing fluctuations in your healing auras.", tooltip = "Allows sensing when a shifted aura will dissipate."})

defences.complete_def({name = "Autumn", def = "You are followed by the autumn wind.", tooltip = "Increases experience gain by 10%"})

defences.complete_def({name = "Avoid", def = "You are carefully avoiding the next targeted blow.", tooltip = "Avoids the next attack targetted at you by another player, stripping the defense. Movement or aggresive action also strip the defense."})

defences.complete_def({name = "Awareness", def = "You are hyperaware of your surroundings.", tooltip = "Informs when an enemy enters the area."})

defences.complete_def({name = "Balancing", def = "You are balancing carefully.", tooltip = "Provides a chance to resist falling. When it works, the defense has a chance of being lost."})

defences.complete_def({name = "BarbedTail", def = "You have a barbed tail.", tooltip = "Can be used to sting people, afflicting with poisons."})

defences.complete_def({name = "Presence", def = "You have a bardic presence.", tooltip = "Weighted +2 to charisma."})

defences.complete_def({name = "Barkskin", def = "You have skin covered in treebark.", tooltip = "Reduces damage."})

defences.complete_def({name = "Beauty", def = "Beauty Enchantment (beauty) (indefinite).",
  defr = [[^Beauty Enchantment \(beauty\) \(\d+ minutes\)\.$]],
  tooltip = "Passive ego regeneration."})

defences.complete_def({name = "benignprophesy", def = "You are under the effect of a benign prophesy.", tooltip = "Increases maximum health."})

defences.complete_def({name = "BioCurrents", tooltip = "Electric attack when touched."})

defences.complete_def({name = "Biofeedbackmagic", def = "You are psionically resisting magic damage.", tooltip = "Reduces damage from magic attacks."})
defences.complete_def({name = "Biofeedbackfire", def = "You are psionically resisting fire damage.", tooltip = "Reduces damage from fire attacks."})
defences.complete_def({name = "Biofeedbackcold", def = "You are psionically resisting cold damage.", tooltip = "Reduces damage from cold attacks."})
defences.complete_def({name = "Biofeedbackelectric", def = "You are psionically resisting electric damage.", tooltip = "Reduces damage from electric attacks."})

defences.complete_def({name = "BlackTea", def = "Your vivaciousness is herbally heightened.", tooltip = "Blocks epilepsy, blackout, and clumsiness."})

defences.complete_def({name = "Blend", def = "You are blended in the foliage.", tooltip = "Shrouds your movement and actions while in forest."})

defences.complete_def({name = "Block", def = "You are effectively blocking all weapon attacks.", tooltip = "Blocks all weapon attacks."})

defences.complete_def({name = "Bloodrage", def = "You are gaining increased experience in your bloodrage.", tooltip = "Increased experience gain for one day, doubled in taint."})

defences.complete_def({name = "Blue", def = "You have empowered your blue chakra.", tooltip = "Prevents your communications from being overheard by other players."})

defences.complete_def({name = "Blur", def = "You are blurry.", tooltip = "Decreases your chance to be hit by melee attacks."})

defences.complete_def({name = "BodyDensity", def = "You are using your mind to make your body more dense.", tooltip = "Decreases the chances of being forcibly moved."})

defences.complete_def({name = "Bolting", def = "You will instantly bolt when an enemy approaches.", tooltip = "Move immediately if an enemy enters the room."})

defences.complete_def({name = "BoneDensity", def = "Your bones are hardened psionically.", tooltip = "50% chance to resist bone breaking."})

defences.complete_def({name = "Bonenose", def = "Your face is painted with a bone nose.", tooltip = "Chances of healing broken limbs."})

defences.complete_def({name = "Bracing", def = "You are braced to absorb damage.", tooltip = "Reduces damage."})

defences.complete_def({name = "Breathing", def = "Your body is prepared for a marathon workout.", tooltip = "Reduces endurance loss."})

defences.complete_def({name = "BullRage", def = "You are riled up by a bull rage.", tooltip = "Allows stacking all kata modifiers."})

defences.complete_def({name = "Bumblebee", def = "A Bumblebee sphere positively affects you.", tooltip = "Speeds focus body time."})

defences.complete_def({name = "BurningCenser", def = "A Burning Censer sphere positively affects you.", tooltip = "Reduces asphyxiation damage."})

defences.complete_def({name = "Byahkari", defr = [[^You are waving \w+ in a defensive pattern\.$]], tooltip = "Blocks attacks and counterattacks with unconsciousness."})

defences.complete_def({name = "Camouflage", def = {"You are blended in the foliage.", "You are camouflaged."}, tooltip = "Conceals most actions in natural terrains."})

defences.complete_def({name = "CarrionStench", def = "You are stinking with the stench of carrion.", tooltip = "Causes bleeding in enemies."})

defences.complete_def({name = "Celerity", def = "You are gifted with increased speed by the shield shrine.", tooltip = "Speeds balance and equilibrium recovery."})

defences.complete_def({name = "Changeself", def = [[^You are under an illusion to look \w+\.$]], tooltip = "Alters your honours and look descriptions to reflect another race, but does not fool all inspections."})

defences.complete_def({name = "Channels", def = "You have opened your aetheric channels to other planar entities.", tooltip = "Summoning does not consume equilibrium."})

defences.complete_def({name = "CharismaticAura", def = "You are compellingly charismatic.", tooltip = "Improves influence attack damage, and prevents disloyalty."})

defences.complete_def({name = "Cloak", def = "Your body and soul are cloaked.", tooltip = "Provides a chance to stop summoning, and reduces damage."})

defences.complete_def({name = "Cold Aura", def = "You are surrounded by the cold of the grave.", tooltip = "Causes enemies to freeze."})

defences.complete_def({name = "Concentrated", def = "You are fighting with focused strikes.", tooltip = "Increases wounding but decreases damage."})

defences.complete_def({name = "Consciousness", def = "You are maintaining consciousness at all times.", tooltip = "Prevents most forms of unconsciousness, though not sleeping."})

defences.complete_def({name = "Constitution", def = "You are using your superior constitution to prevent nausea.", tooltip = "Prevents the effect of the vomiting affliction."})

defences.complete_def({name = "Covey", defr = [[^You are in a covey with \w+\.$]], tooltip = "Links to the ship aether even when unlocked or off-ship."})

defences.complete_def({name = "crocodile", def = "A Crocodile sphere positively affects you.", tooltip = "Reduces physical damage."})

defences.complete_def({name = "Crotamine", def = "Your veins burn with immunity to deadly venoms.", tooltip = "Temporary immunity to certain poisons while crotamine's death is playing out."})

defences.complete_def({name = "Crowform", def = "Your body is covered in black oily feathers.", tooltip = "Grants the ability to fly, health regeneration while flying, resistance to being knocked from the air, more steps before the 'Now now, don't be hasty message' when flying, reduced power cost to eyepeck, a weighted +1 to intelligence, room for more carrion, a more powerful 'CAW' attack, the ability to heal health, mana, and ego when killing denizens, and a swoop attack."})

defences.complete_def({name = "Crowsfeet", def = "Your face is painted with crow's feet.", tooltip = "Detect dreamweavers."})

defences.complete_def({name = "CrowSpy", def = "Your nest is projecting visions to you.", tooltip = "Allows listening in on a location."})

defences.complete_def({name = "CrusaderCanto", def = "You have an aura of holy crusading flames.", tooltip = "Adds flame damage to damage."})

defences.complete_def({name = "Darkbeer", def = "Your aggression is stoked by alcohol.", tooltip = "Increases damage inflicted (by ~5.5%)"})

defences.complete_def({name = "DarkRebirth", def = "Your soul is twined with a dark spirit that is waiting for your death.", tooltip = "Be reborn from an egg on death."})

defences.complete_def({name = "DarkSpirit", def = "Your flesh is bound with a dark spirit that protects you.", tooltip = "The spirit protects you after rebirth."})

defences.complete_def({name = "Deathmask", def = "Your face is painted with a gruesome deathmask.", tooltip = "Gain reserves when you kill."})

defences.complete_def({name = "Deathsight", def = "Deathsight (deathsight) (indefinite).",
  defr = [[^Deathsight \(deathsight\) \(\d+ minutes\)\.$]],
   tooltip = "Shows when and where people die."})

defences.complete_def({name = "Deepbond", defr = [[^You have a deepbond with w+\.$]], tooltip = "Will conglutinate on the ship on death off the Prime Material Plane."})

defences.complete_def({name = "Deepcover", defr = [[^You are masquerading under deepcover as \w+\.$]], tooltip = "Makes you appear like someone else."})

defences.complete_def({name = "Defensive", def = "You are fighting defensively.", tooltip = "Increases effect of stances and decreases offense."})

defences.complete_def({name = "DemonScales", def = "You are covered with demon scales.", tooltip = "Reduces damage."})

#if skills.nihilism then
defences.complete_def({name = "Wings", def = "Bat-like wings sprout out of your back.", tooltip = "Allows flight."})
#end

defences.complete_def({name = "Dionamus", def = "You are blessed by the Spire of Dionamus.", tooltip = "Provides intermittent regeneration of health, mana, and ego."})

defences.complete_def({name = "Divine Fire", def = "You have wreathed yourself in divine fire.", tooltip = "Fully heals and cures on a tick, and prevents denizen attacks."})

defences.complete_def({name = "Dolphin", def = "A Dolphin sphere positively affects you.", tooltip = "Variable boost to intelligence."})

defences.complete_def({name = "Domoth Lesser Beauty", def = "You are under a Lesser Blessing of the Domotheos of Beauty.", tooltip = "Increased influence damage."})

defences.complete_def({name = "Domoth Major Beauty", def = "You are under a Major Blessing of the Domotheos of Beauty.", tooltip = "Triples power and culture gained from bringing in bards."})

defences.complete_def({name = "Domoth Minor Beauty", def = "You are under a Minor Blessing of the Domotheos of Beauty.", tooltip = "Weighted +2 to charisma."})

defences.complete_def({name = "Domoth Lsr Chaos", tooltip = "Regeneration of health, mana, or ego, randomly selected each Lusternian day."})

defences.complete_def({name = "Domoth Major Chaos", def = "You are under a Major Blessing of the Domotheos of Chaos.", tooltip = "Increased resistance to astral insanity."})

defences.complete_def({name = "dmth Minor Chaos", tooltip = "Weighted +3 to the indicated stat, randomly selected each Lusternian day."})

defences.complete_def({name = "Domoth Lesser Death", def = "You are under a Lesser Blessing of the Domotheos of Death.", tooltip = "Vengeance aura that attacks killers."})

defences.complete_def({name = "Domoth Major Death", def = "You are under a Major Blessing of the Domotheos of Death.", tooltip = "A permanent Catacombs of the Dead at the nexus."})

defences.complete_def({name = "Domoth Minor Death", def = "You are under a Minor Blessing of the Domotheos of Death.", tooltip = "Increased endurance and endurance regeneration."})

defences.complete_def({name = "Domoth Minor Harmony", tooltip = "Increased experience gain."})

defences.complete_def({name = "Domoth Major Harmony", def = "You are under a Major Blessing of the Domotheos of Harmony.", tooltip = "Doubles the amount of dross power you can draw."})

defences.complete_def({name = "Domoth Lesser Harmony", tooltip = "Decreased experience loss on death."})

defences.complete_def({name = "Domoth Lesser Justice", def = "You are under a Lesser Blessing of the Domotheos of Justice.", tooltip = "An aura that deals damage to attackers."})

defences.complete_def({name = "Domoth Major Justice", def = "You are under a Major Blessing of the Domotheos of Justice.", tooltip = "Increases the damage of discretionary powers that cause damage."})

defences.complete_def({name = "Domoth Minor Justice", def = "You are under a Minor Blessing of the Domotheos of Justice.", tooltip = "Increased willpower and willpower regeneration."})

defences.complete_def({name = "Domoth Lesser Knowledge", def = "You are under a Lesser Blessing of the Domotheos of Knowledge.", tooltip = "Resistance to magic damage."})

defences.complete_def({name = "Domoth Major Knowledge", def = "You are under a Major Blessing of the Domotheos of Knowledge.", tooltip = "Triples power and culture gained from bringing in scholars."})

defences.complete_def({name = "Domoth Minor Knowledge", def = "You are under a Minor Blessing of the Domotheos of Knowledge.", tooltip = "Weighted +2 to intelligence."})

defences.complete_def({name = "Domoth Lesser Life", def = "You are under a Lesser Blessing of the Domotheos of Life.", tooltip = "Decreased damage from all attacks."})

defences.complete_def({name = "Domoth Major Life", def = "You are under a Major Blessing of the Domotheos of Life.", tooltip = "Health regeneration in non-enemy territory on the Prime plane."})

defences.complete_def({name = "Domoth Minor Life", def = "You are under a Minor Blessing of the Domotheos of Life.", tooltip = "Weighted +2 to constitution."})

defences.complete_def({name = "Domoth Lesser War", def = "You are under a Lesser Blessing of the Domotheos of War.", tooltip = "Increased damage on all attacks."})

defences.complete_def({name = "Domoth Major War", def = "You are under a Major Blessing of the Domotheos of War.", tooltip = "20% increase in the level of guards."})

defences.complete_def({name = "Domoth Minor War", def = "You are under a Minor Blessing of the Domotheos of War.", tooltip = "Weighted +2 to strength."})

defences.complete_def({name = "DoublePain", def = "You are psionically tuned to inflict pain.", tooltip = "Increases wounding inflicted."})

defences.complete_def({name = "Draconis", def = "You are surrounded by numinous dragon scales.", tooltip = "Protection against magical damage."})

defences.complete_def({name = "Dragon", def = "A Dragon sphere positively affects you.", tooltip = "Reduces magical damage."})

defences.complete_def({name = "Drawdown", def = "The moon has been drawn closer to you.", tooltip = "Provides mana regeneration, a weighted +1 to intelligence, damage resistance, a bonus to weapon stats, and a moonburst attack."})

defences.complete_def({name = "DreamweaveControl", def = "You are in complete control of your waking mind.", tooltip = "Prevents sleep and the need for sleep."})

defences.complete_def({name = "Drink", def = "You are drinking deep of shadows.", tooltip = "Passive health regeneration and affliction curing in shadows."})

defences.complete_def({name = "Drunkard", def = "You are acting drunker than you actually are.", tooltip = "Appear more drunk."})

defences.complete_def({name = "EarthPulse", def = "You are attuned to the earth's pulse.", tooltip = "Increases magical damage."})

defences.complete_def({name = "Eavesdrop", def = "You are listening in on another conversation.", tooltip = "Listens to conversations in an adjoining room."})

defences.complete_def({name = "Ego Blessing", def = "You have an ego blessing.", tooltip = "Increases ego."})
defences.complete_def({name = "Divine Ego Blessing", def = "You have a divine ego blessing.", tooltip = "Increases ego."})

defences.complete_def({name = "Elasticity", def = "You are concentrating on providing your muscles with increased elasticity.", tooltip = "Reduces damage incurred by melee attacks not targeted at a particular body part."})

defences.complete_def({name = "EnergyContainment", def = "Your body can contain elemental energies.", tooltip = "Reduces damage from cold, fire, and electricity."})

defences.complete_def({name = "Engage", defr = [[^You have engaged \w+\.$]], tooltip = "A chance to strike the target if they flee."})

defences.complete_def({name = "Enrage", def = "You are enraged at the inferior races.", tooltip = "Weighted +2 to strength, and a chance of attacking non-taurians."})

defences.complete_def({name = "Elementshield", def = "You are shielded from the elements.", tooltip = "Reduces damage."})

defences.complete_def({name = "Encore", def = "You are performing an encore.", tooltip = "Doubles speed of song performance."})

defences.complete_def({name = "Enhancementstrength", def = "Your strength is psionically enhanced.", tooltip = "Weighted +2 to strength or dexterity, or +1 to each."})
defences.complete_def({name = "Enhancementdexterity", def = "Your dexterity is psionically enhanced.", tooltip = "Weighted +2 to strength or dexterity, or +1 to each."})
defences.complete_def({name = "Enhancementspread", def = "Your strength and dexterity are psionically enhanced.", tooltip = "Weighted +2 to strength or dexterity, or +1 to each."})

defences.complete_def({name = "Enigma", def = "The Enigma is upon you.", tooltip = "Adds a second random tarot card to all flings."})

defences.complete_def({name = "Faerie", tooltip = "Allows flight."})

defences.complete_def({name = "Falling", def = "You are protected against falling suddenly.", tooltip = "Provides a chance to fall without taking damage, with increased chance of success as you increase your [[Acrobatics]] skill."})

defences.complete_def({name = "FearAura", def = "You are shrouded in veils of nightmare.", tooltip = "Periodically causes fear to enemies."})

defences.complete_def({name = "Fervor", def = "You are filled with an intense religious fervor.", tooltip = "Increases damage against those suffering from inquisition effects."})

defences.complete_def({name = "Fire", def = "Your insides are warmed by a fire potion.", tooltip = "Protection against cold damage."})

defences.complete_def({name = "Fitness", def = "You are utilising your bodily control to make yourself more fit.", tooltip = "Speeds endurance recovery."})

defences.complete_def({name = "Flight", def = "You are soaring high above the ground.", tooltip = "You're flying."})

defences.complete_def({name = "Food", tooltip = "Weighted +1 to the affected stat."})

defences.complete_def({name = "Fool", defr = [[^A fool will mask your next \w+ tarot flings\.$]], tooltip = "Conceals the effect of tarot flings."})

defences.complete_def({name = "ForceField", def = "You have a forcefield protecting you from harm.", tooltip = "Diverts health damage to ego."})

defences.complete_def({name = "Fortuna", def = "You are reaping the gifts of Fortuna.", tooltip = "Weighted +1 to a randomly selected stat for one Lusternian day."})

defences.complete_def({name = "Frost", def = "You are tempered against fire damage.", tooltip = "Protection against fire damage."})

defences.complete_def({name = "Galvanism", def = "You are more ready to handle electric currents.", tooltip = "Protection against electrical damage."})

defences.complete_def({name = "Geburah", def = "You are surrounded by the Geburah Sphere.", tooltip = "Weighted +1 to strength."})

defences.complete_def({name = "Genderbend", def = {"You are playing the part of a male.", "You are playing the part of a female."}, tooltip = "Appear as the opposite gender."})

defences.complete_def({name = "Ghost", def = "As an insubstantial ghost, you are immune to many attacks.", tooltip = "Insubstantiality provides immunity to most effects."})

defences.complete_def({name = "Glacier", def = "A Glacier sphere positively affects you.", tooltip = "Reduces cold damage."})

defences.complete_def({name = "Glamour", defr = [[^You have taken on a glamour of \w+\.$]], tooltip = "Makes you appear to be another person in some actions and perceptions."})

defences.complete_def({name = "Gliding", def = "You can glide upon any surface.", tooltip = "Allows gliding over water and other surfaces."})

defences.complete_def({name = "Grappling", defr = [[^You are grappling \w+ with your (?:left|right) arm\.$]], tooltip = "Traps the victim and prepares for certain attacks."})

defences.complete_def({name = "GreatPentagram", def = "You are protecting the immediate area with a great pentagram.", tooltip = "Prevents most means of entering the room."})

defences.complete_def({name = "Greenman", def = "Your face is painted with the image of the greenman.", tooltip = "Recover willpower and endurance faster."})

defences.complete_def({name = "GreenTea", def = "Your movements are herbally heightened.", tooltip = "Blocks paralysis, weakness, and rigormortis."})

defences.complete_def({name = "Grip", def = "Your hands are gripping your wielded items tightly.", tooltip = "Prevents many things that unwield or drop wielded items."})

defences.complete_def({name = "Red ", def = "The pull of the earth roots you more firmly to the ground.", tooltip = "Resists summons."})

defences.complete_def({name = "Malkuth", def = "The pull of the earth roots you more firmly to the ground.", tooltip = "Resists summons."})

defences.complete_def({name = "Halo", def = "You are glowing with a radiant halo.", tooltip = "Reduces damage."})

defences.complete_def({name = "Handstand", def = "You are standing on your hands.", tooltip = "Resists most attacks, and reduces power cost for handsprings."})

defences.complete_def({name = "Harvest", def = "Your soul is blessed under the harvest moon.", tooltip = "Increased experience gain."})

defences.complete_def({name = "HealingAura", tooltip = "Passive, periodic healing or curing of certain afflictions."})

defences.complete_def({name = "Health Blessing", def = "You have a health blessing.", tooltip = "Increases health."})
defences.complete_def({name = "Divine Health Blessing", def = "You have a divine health blessing.", tooltip = "Increases health."})

defences.complete_def({name = "Breath", def = "You are holding your breath.", tooltip = "Prevents asphyxiation attacks."})

defences.complete_def({name = "HexAura", def = "You are surrounded by an aura of hexes.", tooltip = "Draws hexes with you as you move."})

defences.complete_def({name = "HexControl", def = "You are controlling your hexes.", tooltip = "Hexes will not fire automatically on entry of an enemy."})

defences.complete_def({name = "HexSense", def = "You are sensing the status of your hexes.", tooltip = "Notifies you if an enemy walks into one of your hexes."})

defences.complete_def({name = "Honour", def = "You are surrounded by the aura of honour.", tooltip = "Regeneration of health, mana, and ego for Sacraments students in the room."})

defences.complete_def({name = "Hyperactive", def = "You are hyperactive and moving very quickly.", tooltip = "Halves balance recovery time."})

defences.complete_def({name = "Hyperventilate", def = "You are hyperventilating to control your breathing.", tooltip = "Reduces asphyxiation damage."})

defences.complete_def({name = "Illithoid", def = "You are empowered by the Avatar of Illith.", tooltip = "Unweighted +1 to dexterity, intelligence, and charisma."})

defences.complete_def({name = "IllusorySelf", def = "You are accompanied by an illusory glamour.", tooltip = "Intercepts damage."})

defences.complete_def({name = "Immunity", def = "You have tempered your bloodstream to reject poisons.", tooltip = "A chance to reject poison, stripping the defense."})

defences.complete_def({name = "Infiltrate", defr = [[^You are infiltrating the communications of \w+\.$]], tooltip = "Allows hearing city/commune and guild aethers."})

defences.complete_def({name = "Inner Serpent", defr = [[^Your inner serpent is bloated with \w+ ego\.$]], tooltip = "Increases ego."})

defences.complete_def({name = "Insomnia", def = "You have insomnia, and cannot easily go to sleep.", tooltip = "Prevents being put to sleep."})

defences.complete_def({name = "Invisibility", def = "You are invisible.", tooltip = "Conceals most actions."})

defences.complete_def({name = "Ironskin", def = "Your skin is as hard as iron.", tooltip = "Greatly reduces physical damage."})

defences.complete_def({name = "IronWill", def = "You are regenerating mental strength with iron will.", tooltip = "Speeds ego and willpower recovery."})

defences.complete_def({name = "Kafe", def = "You have ingested the kafe bean and are feeling extremely energetic.", tooltip = "Allows quick awakening."})

--[[defences.complete_def({name = "Deflectright", def = "You are deflecting blows with your right hand.", tooltip = "Reduces damage on that side."})
defences.complete_def({name = "Deflectleft", def = "You are deflecting blows with your left hand.", tooltip = "Reduces damage on that side."})]]

defences.complete_def({name = "Kephera", def = "You are empowered by the Kephera Queen of Queens.", tooltip = "Unweighted +1 to dexterity, intelligence, and charisma."})

defences.complete_def({name = "Kingdom", def = "Kingdom Enchantment (kingdom) (indefinite).",
  defr = [[^Kingdom Enchantment \(kingdom\) \(\d+ minutes\)\.$]],
  tooltip = "Reduces bleeding on a tick."})

defences.complete_def({name = "Kite", def = "You are flying a kite.", tooltip = "Alerts to when people fly above."})

defences.complete_def({name = "Lawyerly", def = "You are carrying yourself with a lawyerly demeanor.", tooltip = "Boosts pettifoggery."})

defences.complete_def({name = "Levitation", def = "Levitation (levitate) (indefinite).",
  defr = [[^Levitation \(levitate\) \(\d+ minutes\)\.$]], 
  tooltip = "Prevents harm from most falls."})
defences.complete_def({name = "Levitate", def = "Levitation (levitate) (indefinite).",
  defr = [[^^Levitation \(levitate\) \(\d+ minutes\)\.$]],
  tooltip = "Prevents harm from most falls."})

defences.complete_def({name = "Lichdom", def = {"You are a lich.", "You are an archlich."}, tooltip = "Increased strength by night, decreased by day; regeneration at night; cold touch; reduced power for contagion and prevents it being blown away."})

defences.complete_def({name = "Lifedrain", def = "Your nervous system is psionically primed to drain sustenance.", tooltip = "Absorb the health of another and cure wounds through your physical touch."})

defences.complete_def({name = "Limber", def = "You are extremely limber.", tooltip = "Weighted +3 to dexterity."})

defences.complete_def({name = "Lion", def = "A Lion sphere positively affects you.", tooltip = "Variable boost to charisma."})

defences.complete_def({name = "Lipread", def = "You are lipreading to overcome deafness.", tooltip = "Allows hearing says even when deaf."})

defences.complete_def({name = "LiquidForm", def = "You are a morass of liquid.", tooltip = "Heals most afflictions and makes you impervious to damage; allows you to 'ENGULF' others to heal them."})

defences.complete_def({name = "Maestoso", def = "You are maintaining a maestoso.", tooltip = "Prevents curing auric afflictions."})

defences.complete_def({name = "Mana Blessing", def = "You have a mana blessing.", tooltip = "Increases mana."})
defences.complete_def({name = "Divine Mana Blessing", def = "You have a divine mana blessing.", tooltip = "Increases mana."})

defences.complete_def({name = "Masquerade", defr = [[^You are masquerading as \w+\.$]], tooltip = "Makes you appear like someone else."})

defences.complete_def({name = "Maw", def = "You are wearing a magic maw of burrowing.", tooltip = "Allows burrowing."})

defences.complete_def({name = "Mercy", def = "Mercy Enchantment (mercy) (indefinite).",
  defr = [[^Mercy Enchantment \(mercy\) \(\d+ minutes\)\.$]], 
  tooltip = "Passive health regeneration."})

defences.complete_def({name = "Metawake", def = "You are concentrating on maintaining distance from the dreamworld.", tooltip = "Completely prevents sleep at the cost of a mana drain."})

defences.complete_def({name = "MindBar", def = "You have raised a mental bar to shield your mind from assault.", tooltip = "Reduces damage from psychic attacks."})

defences.complete_def({name = "MindField", def = "You will discharge a psychic lash on those who scry.", tooltip = "Causes damage on scrying."})

defences.complete_def({name = "Mislead", defr = [[^You are preparing to mislead to the \w+\.$]], tooltip = "Next movement will appear to go in the wrong direction."})

defences.complete_def({name = "aura", def = "You have the aura of the moon protecting you.", tooltip = "Reduces damage from magical attacks."})

defences.complete_def({name = "Moonchilde", def = "You are a Moonchilde.", tooltip = "Weighted +1 to charisma, regeneration off prime, allows joining moon covens, and allows teleporting to the Moon Bubble."})

defences.complete_def({name = "shine", defr = [[^You are shining with the light of the .+\.$]], tooltip = "Various benefits depending on the phase of the moon."})

defences.complete_def({name = "Moonwater", tooltip = "Health, mana, and ego potions will strip afflictions."})

defences.complete_def({name = "Mounted", tooltip = "Allows access to many Beastmastery skills."})

defences.complete_def({name = "Netzach", def = "You are surrounded by the Netzach Sphere.", tooltip = "Weighted +1 to charisma."})

defences.complete_def({name = "Nightkiss", def = "Mother Night has given her favour to you.", tooltip = "Provides reduced power cost to gather shadows, a weighted +1 to intelligence, damage resistance, a bonus to weapon stats, and a nightkiss attack."})

defences.complete_def({name = "Nightsight", def = "Your vision is heightened to see in the dark.", tooltip = "Allows unrestricted vision at night."})

defences.complete_def({name = "Nightwraith", def = "You are a Nightwraith.", tooltip = "Weighted +1 to dexterity, regeneration off prime, allows joining night covens, and allows teleporting to the Night Bubble."})

defences.complete_def({name = "Ninini", defr = [[^You have \w+ wrapped around your \w+\.$]], tooltip = "Improves unarmed offense or body defense."})

defences.complete_def({name = "Numbness", def = "You are temporarily numbed to damage.", tooltip = "Temporarily reduces damage, though 40% of it is dealt when the numbness wears off."})

defences.complete_def({name = "Numen", def = "You are surrounded by the aura of numen.", tooltip = "Halves damage for twenty seconds."})

defences.complete_def({name = "Obliviousness", def = "You are oblivious to your surroundings.", tooltip = "Reduces spam in group combat."})

defences.complete_def({name = "Omniscience", def = "You are omnisciently listening to the aetheric winds.", tooltip = "Allows hearing and speaking on aethers from anywhere, even aetherbubbles."})

defences.complete_def({name = "OolongTea", def = "Your passion is herbally heightened.", tooltip = "Blocks recklessness, peace, and pacifism."})

defences.complete_def({name = "Orange", def = "You have empowered your orange chakra.", tooltip = "Halves accrual of hunger."})

defences.complete_def({name = "Penumbra", def = "You have evoked the ritual of penumbra.", tooltip = "Gives a weighted +2 charisma, ego regeneration, and the appearance of youth."})

defences.complete_def({name = "Perch", def = "You are perched here like a crow.", tooltip = "Prevents movement."})

defences.complete_def({name = "Perfection", def = "Perfection Enchantment (perfection) (indefinite).",
  defr = [[^Perfection Enchantment \(perfection\) \(\d+ minutes\)\.$]],
  tooltip = "Passive mana regeneration."})

defences.complete_def({name = "Performance", def = "You are in performance mode.", tooltip = "Provides ego regeneration and mana drain, and allows other [[Dramatics]] skills."})

defences.complete_def({name = "PhantomArmour", def = "You are surrounded by phantom armour.", tooltip = "Reduces psychic damage and provides a chance of blackout on the attacker."})

defences.complete_def({name = "Phased", def = "Phased slightly out of reality, you are effectively untouchable.", tooltip = "Immune to most effects."})

defences.complete_def({name = "Pheromones", def = "You have released pheromones.", tooltip = "Causes lust in others."})

defences.complete_def({name = "Phial", def = "You are glowing with holy light.", tooltip = "Adds fire, sun allergy, or vapours to attacks."})

defences.complete_def({name = "Planarbond", def = "You have an empathic planarbond to distant aetherwaves.", tooltip = "Attunes the ship's crew to distant aethers while the ship is sailing."})

defences.complete_def({name = "Immune", defr = {[[^You are training to be immune from (\w+)\.$]], [[^You are immune from (\w+)\.$]]}, tooltip = "Immunity to one poison."})

defences.complete_def({name = "Populus", def = "You are filled with exuberance.", tooltip = "Weighted +1 to charisma."})

defences.complete_def({name = "Powermask", def = "You have a powermask hiding your actions.", tooltip = "Prevents some actions from showing your name on power logs."})

defences.complete_def({name = "Princess", def = "You are able to beseech the Princess.", tooltip = "Cures some afflictions as well as health, mana, and ego when beseeched."})

defences.complete_def({name = "Prismatic Barrier", def = "You are standing within a prismatic barrier.", tooltip = "Protects against nearly all attacks."})

defences.complete_def({name = "Protection", def = "You have an aura of protection around you.", tooltip = "Protects against selected demesne effects."})

defences.complete_def({name = "PsiArmour", def = "You are protected by psionic armour.", tooltip = "Reduces damage."})

defences.complete_def({name = "PsiRegeneration", def = "Your body is regenerating psionically.", tooltip = "Damage regeneration."})

defences.complete_def({name = "PsiSense", def = "You are sensing psionic activity.", tooltip = "Reveals what psionic channels are being used by others present."})

defences.complete_def({name = "PsiShield", def = "You are protected by a psionic barrier.", tooltip = "Protects against psionic attacks."})

defences.complete_def({name = "PsychicLift", def = "You are preparing to psychically lift your victims.", tooltip = "Automatically pick up your kills."})

defences.complete_def({name = "Purity", def = "Your body is purified.", tooltip = "Damage resistance."})

defences.complete_def({name = "Puissance", def = "Your next blow will be of puissant strength.", tooltip = "Increases damage of the next attack."})

defences.complete_def({name = "Putrefaction", def = "You are bathed in the glorious protection of decaying flesh.", tooltip = "Resistance to weapon attacks, and a steady health drain."})

defences.complete_def({name = "Quickening", def = "Your mind has been quickened.", tooltip = "Speeds equilibrium recovery considerably for a short time."})

defences.complete_def({name = "QuickeningAura", def = "Your healing ability is extraordinarily quickened.", tooltip = "Halves equilibrium loss from healing."})

defences.complete_def({name = "Quicksilver", def = "Your sense of time is heightened, and your reactions are speeded.", tooltip = "Prevents one affliction of aeon, and provides an increase to the chance of being missed by melee attacks."})

defences.complete_def({name = "Rage", def = "You have called down the destructive powers of the moon.", tooltip = "Allows coven-based ranged attacks."})

defences.complete_def({name = "Rebounding", def = "You are protected from hand-held weapons with an aura of rebounding.", tooltip = "Rebounds melee attacks on the attacker."})

defences.complete_def({name = "Reflection", def = "You are surrounded by one reflection of yourself.", tooltip = "Protects against the next attack."})

defences.complete_def({name = "Regeneration", def = "You are regenerating lost health.", tooltip = "Grants a 2/8 boost to health regeneration"})

defences.complete_def({name = "Boosting", def = "Your regeneration is boosted.", tooltip = "Health regeneration with a constant mana drain. Boosting increases the health regained."})

defences.complete_def({name = "Resistance", def = "You are resisting magical damage.", tooltip = "Reduction of damage from magical sources."})

defences.complete_def({name = "Review", def = "You are reviewing performances of others.", tooltip = "Identifies the source of impersonation and similar Dramatics concealments."})

defences.complete_def({name = "Ringwalk", defr = [[^Your inner stag is walking the ring around \w+\.$]], tooltip = "Prevents enemies from leaving."})

defences.complete_def({name = "Rooting", def = "You are rooted.", tooltip = "Resists summons."})

defences.complete_def({name = "Rubeus", def = "You are filled with the wrath of Rubeus.", tooltip = "Prevents pacifism, lover's effects, shyness, lust, and fear."})

defences.complete_def({name = "RunicAmulet", tooltip = "Chance to block the affliction associated with that rune."})

defences.complete_def({name = "Saintly", def = "You are carrying yourself with a saintly demeanor.", tooltip = "Boosts pontification."})

defences.complete_def({name = "ScorpionFury", def = "You are riled up by a scorpion rage.", tooltip = "Allows stacking nekcree, shocree, and creehai modifiers."})

defences.complete_def({name = "ScorpionSpit", tooltip = "Preparation to spit a poison."})

defences.complete_def({name = "ScorpionTail", def = "You are poised for a scorpion tail's strike.", tooltip = "Your next dodge will be followed by a sweep kick."})

defences.complete_def({name = "Screen", def = "You are screening your belongings against prying eyes.", tooltip = "Prevents people from seeing your inventory."})

defences.complete_def({name = "Selfishness", def = "You are feeling quite selfish.", tooltip = "Prevents dropping or giving things away, and thus, most theft."})

defences.complete_def({name = "garb", def = "You are wearing a garb of shadows.", tooltip = "Reduces damage from magical attacks and poisons."})

defences.complete_def({name = "Shadow Shroud", def = "You are wearing a magic shroud.", tooltip = "Conceals most actions."})

defences.complete_def({name = "Mindfield Arti", def = "You will discharge a psychic lash from a powerful artifact on those who scry.", tooltip = "damages those who scry you"})

defences.complete_def({name = "Shield", def = "You are surrounded by a nearly invisible magical shield.", tooltip = "Protection against most attacks."})

defences.complete_def({name = "ShrineCure", def = "You are surrounded by a divine aura of curing.", tooltip = "Cures afflictions periodically."})

defences.complete_def({name = "ShrineHeal", def = "You are being healed by the power of a healing shrine.", tooltip = "Heals health, mana, and ego periodically."})

defences.complete_def({name = "ShrineProtection", def = "You are protected by the shield shrine.", tooltip = "Makes it more likely melee attacks will miss, and reduces damage from some attacks."})

defences.complete_def({name = "trueblind", def = "The world is seen through your sixth sense.", tooltip = "Allows sight even when blind (thus allowing blindness to protect against visual attacks)."})

defences.complete_def({name = "Skull", def = "A Skull sphere positively affects you.", tooltip = "Variable boost to constitution."})

defences.complete_def({name = "Sneak", def = "You are sneaking around in the shadows.", tooltip = "Conceals movement and some actions."})

defences.complete_def({name = "Sober", def = "You are acting more sober than you actually are.", tooltip = "Appear less drunk."})

defences.complete_def({name = "Spider", def = "A Spider sphere positively affects you.", tooltip = "Speeds writhing and contortion time."})

defences.complete_def({name = "Spiderweb", def = "Your face is painted with an intricate spiderweb.", tooltip = "Dodge entanglements."})

defences.complete_def({name = "Stagform", def = "Your body has been blessed by the stag.", tooltip = "Grants health regeneration, more steps before the 'Now now, don't be hasty message', a weighted +1 dexterity, and a gore attack."})

defences.complete_def({name = "Staghide", def = "You have the hide of the stag protecting your body.", tooltip = "Reduces damage."})

defences.complete_def({name = "Stance", tooltip = "Protects certain parts of the body against melee attacks."})

defences.complete_def({name = "Starleaper", def = "You are protected by the Starleaper.", tooltip = "Automatically flee from attacks."})

defences.complete_def({name = "Stigmata", def = "You are marked with the stigmata.", tooltip = "Automatically converts health to mana."})

defences.complete_def({name = "Stoneskin", def = "Your skin is coated with supple granite.", tooltip = "Reduces damage."})

defences.complete_def({name = "Flex", def = "Your muscles are flexed for increased strength.", tooltip = "Weighted +3 to strength."})

defences.complete_def({name = "Surge", def = "Your essence is surging into your body.", tooltip = "Increases health and maximum health and reduces mana."})

defences.complete_def({name = "SuspendedAnimation", def = "You are in suspended animation.", tooltip = "Puts you out of phase, replenishes health/mana/ego, cures ailments, boosts health/mana/ego."})

defences.complete_def({name = "Swiftstripes", def = "Your face is painted with red stripes.", tooltip = "Speeds balance recovery and slows equilibrium recovery."})

defences.complete_def({name = "Symmetry", def = "Your body is tuned to symetrically spread wounds.", tooltip = "Limb wounding is spread evenly to both sides."})

defences.complete_def({name = "Teacher", tooltip = "One-day boost to the indicated skill."})

defences.complete_def({name = "Tempo", def = "You are demonstrating increased musical aptitude.", tooltip = "Increases song duration."})

defences.complete_def({name = "Terror", def = "You have called down the terror of Mother Night.", tooltip = "Allows coven-based ranged attacks."})

defences.complete_def({name = "Thirdeye", def = "You are viewing the world through the third eye.", tooltip = "Allows sensing locations in WHO and seeing shrouded people in rooms."})

defences.complete_def({name = "regal aura", def = "You are surrounded by a regal aura.", tooltip = "Weighted +2 to charisma."})

defences.complete_def({name = "Timeslip", def = "You are touching upon cosmic probabilities.", tooltip = "Avoids the next attack."})

defences.complete_def({name = "Transmigration", def = "Your soul is bonded to an animal spirit, ready for transmigration.", tooltip = "Transmigrate to your familiar on death."})

defences.complete_def({name = "TripleFlash", def = "You are dancing chaotically about, avoiding blows.", tooltip = "Dodge all targetted attacks."})

defences.complete_def({name = "truedeaf", def = "Sounds are heard through your true hearing.", tooltip = "Allows hearing even when deaf (thus allowing deafness to protect against audible attacks). Also prevents the dizziness side effect of deafness."})

defences.complete_def({name = "Trueheart", def = "Your face is painted with yellow rays of sunshine.", tooltip = "A chance to resist compulsion."})

defences.complete_def({name = "TrueTime", def = "You are slightly protected against shifting time.", tooltip = "Reduces effect of the Aeon affliction."})

defences.complete_def({name = "TwinCrystals", def = "A Twin Crystals sphere positively affects you.", tooltip = "Reduces psychic damage."})

defences.complete_def({name = "TwirlCudgel", def = "You are deflecting physical attacks.", tooltip = "+10 DMP against physical damage."})

defences.complete_def({name = "Veil", def = "You are veiled from detection.", tooltip = "Prevents almost all forms of detection."})

defences.complete_def({name = "Vendetta", def = "You are carrying a vendetta against the infidels.", tooltip = "Increases damage against order enemies."})

defences.complete_def({name = "Vitae", def = "The power of the elixir vitae flows through your veins.", tooltip = "Instant resurrection without defenses and with reduced experience loss on death."})

defences.complete_def({name = "Vitality", def = "You will call upon your fortitude in need.", tooltip = "Restores a lot of health when it gets down too low."})

defences.complete_def({name = "VitalityAura", def = "You are radiating a healing vitality.", tooltip = "Restores health when it gets too low because of healing others."})

defences.complete_def({name = "Warrior", def = "You are assisted by the Warrior.", tooltip = "Aggressive tarot flings will be accompanied by damage."})

defences.complete_def({name = "Waterbreathe", def = "Water Breathing (waterbreathe) (indefinite).",
  defr = [[^Water Breathing \(waterbreathe\) \(\d+ minutes\)\.$]],
  tooltip = "Allows breathing underwater."})

defences.complete_def({name = "WaterShield", def = "You are protected by the power of the water spiritshield.", tooltip = "Resistance to electric damage."})

defences.complete_def({name = "Waterwalk", def = "Waterwalking (waterwalk) (indefinite).",
  defr = [[^Waterwalking \(waterwalk\) \(\d+ minutes\)\.$]],
  tooltip = "Allows walking on water."})

defences.complete_def({name = "Waylay", defr = [[^You are setup to waylay \w+\.$]], tooltip = "Will attack and possibly trap the target on entry to the same room."})

defences.complete_def({name = "Weathering", def = "Your body is weathering the storm of life a little better.", tooltip = "Weighted +1 to constitution."})

defences.complete_def({name = "Whirlpool", def = "You are swirling with a whirlpool of churning water.", tooltip = "Draws people towards you."})

defences.complete_def({name = "Whisper", def = "You are speaking in whisper mode.", tooltip = "Prevents infiltration or eavesdropping."})

defences.complete_def({name = "WhiteTea", def = "Your insight is herbally heightened.", tooltip = "Blocks stupidity, deadening, and dementia."})

defences.complete_def({name = "World", defr = [[^You are strengthened by the power of Kiakoda for \w+ more tarot flings\.$]], tooltip = "Makes tarot flings break shields."})

defences.complete_def({name = "Wounded", def = "You are acting more wounded than you actually are.", tooltip = "Appear more wounded."})

defences.complete_def({name = "Yellow ", def = "You have empowered your yellow chakra.", tooltip = "Adds a 1/5 boost to health for a time"})

defences.complete_def({name = "Yesod", def = "Your actions are cloaked in secrecy.", tooltip = "Conceals most actions."})

defences.complete_def({name = "Yoyo", def = "You are carrying a noisy clockwork yoyo.", tooltip = "Pick up your kills, and random other things."})

defences.complete_def({name = "Zealotry", def = "You are carrying yourself with the demeanor of a zealot.", tooltip = "Boosts passion."})

defences.complete_def({name = "nimbus", def = "Cosmic Nimbus (cosmicnimbus) (indefinite).",
  defr = [[^Cosmic Nimbus \(cosmicnimbus\) \(\d+ minutes\)\.$]],
  tooltip = "+10DMP for Cosmic resistance"})

-- for def, deft in defs_data:pairs() do
--   echof("skillset: %s, buff name: %s, def line: %s", (tostring(deft.type) or "(not available)"), (tostring(def) or "(none)"), (type(deft.def == "string") and tostring(deft.def) or "(not availabe)"))
-- end


-- def setup & def-related controllers

-- used in 'mmshow' to get the list of available defences
defences.print_def_list = function ()
  local t = {}; for defmode, _ in pairs(defdefup) do t[#t+1] = defmode end
  table.sort(t)

  -- echo each def mode: defence (-),
  for i = 1, #t do
    local defmode = t[i]

    if defmode ~= defs.mode then
      setFgColor(unpack(getDefaultColorNums))
      setUnderline(true) echoLink(defmode, 'mm.defs.switch("'..defmode..'", true)', 'Switch to '..defmode..' defences mode', true) setUnderline(false)
    else
      fg"a_darkgreen"
      setUnderline(true) echoLink(defmode, 'mm.defs.switch("'..defmode..'", true)', 'Currently in this defence mode. Click to redo defup', true) setUnderline(false)
    end

    if sys.deffing and defmode == defs.mode then
      echo(" (currently deffing)")
    end

    echo" ("
    fg"orange_red"setUnderline(true) echoLink('-', 'mm.delete_defmode("'..defmode..'", true)', 'Delete '..defmode.. ' defences mode', true) setUnderline(false) setFgColor(unpack(getDefaultColorNums))
    echo")"

    if i == #t then echo " " else
      echo", "
    end
  end

  -- then an add the (+ add new), if we can
  if printCmdLine then
    echo("(")
    fg"a_darkgreen" setUnderline(true) echoLink("+ add new", 'printCmdLine("mm create defmode ")', "Create a new defences mode", true) setUnderline(false) setFgColor(unpack(getDefaultColorNums))
    echo(")")
  end

  echo"\n"
end

defences.get_def_list = function ()
  local s = oneconcat(defdefup)

  if sys.deffing then
    s = string.gsub(s, "("..defs.mode..")", "(currently deffing) <0,250,0>%1" .. getDefaultColor())
  else
    s = string.gsub(s, "("..defs.mode..")", "<0,250,0>%1" .. getDefaultColor())
  end
  return s
end

function defs.switch(which, echoback)
  local sendf; if echoback then sendf = echof else sendf = errorf end

  if not which then
    sendf("To which mode do you want to switch to?") return
  end

  if not defdefup[which] then
    sendf("%s defence mode doesn't exist - the list is: %s", which, oneconcat(defdefup)) return
  end

  defs.mode = which
  rift.precache = rift.precachedata[defs.mode]
  sys.deffing = true
  startStopWatch(defences.defup_timer)

  make_gnomes_work()
  defupfinish()
end

defupfinish = function ()
  if not sys.deffing then return end

  if sk.have_defup_defs() then
    sys.deffing = false
    local time = stopStopWatch(defences.defup_timer)
    local timestring

    if time > 60 then
      timestring = string.format("%dm, %.1fs", math.floor(time/60), time%60)
    else
      timestring = string.format("%.1fs", time)
    end

    echo"\n"
    echof("Ready for combat! (%s defences mode, took %s)", defs.mode, (timestring == "0.0s" and "no time" or timestring))
    raiseEvent("m&m done defup", defs.mode)
    showprompt()
  end
end

function defs.keepup(which, status, mode, echoback, reshow)
  local sendf; if echoback then sendf = echof else sendf = sendf end

  if not mode then mode = defs.mode end

  if not mode then
    sendf("We aren't in any defence mode yet - switch to one first.")
    return
  end

  if defkeepup[mode][which] == nil then
    sendf("%s isn't a defence you can keepup.", which)
    return
  end

  -- if we were given an explicit option...
  if type(status) == "string" then
    status = convert_string(status)
  end

  -- if it's invalid or wasn't given to us, toggle
  if status == nil then
    if defkeepup[mode][which] then status = false
    else status = true end
  end

  defkeepup[mode][which] = status

  if echoback then
    if defkeepup[mode][which] then
      mm.echof("Will keep %s up.", which)
    else
      mm.echof("Won't keep %s up anymore.", which)
    end
  end

  make_gnomes_work()

  if reshow then show_keepup() echo"\n" end
end

function defs.defup(which, status, mode, echoback, reshow)
  local sendf; if echoback then sendf = echof else sendf = errorf end

  if not mode then mode = defs.mode end

  if not mode then
    sendf("We aren't in any defence mode yet - switch to one first.")
    return
  end

  if defdefup[mode][which] == nil then
    sendf("%s isn't a defence you can defup.", which)
    return
  end

  -- if we were given an explicit option...
  if type(status) == "string" then
    status = convert_string(status)
  end

  -- if it's invalid or wasn't given to us, toggle
  if status == nil then
    if defdefup[mode][which] then status = false
    else status = true end
  end

  defdefup[mode][which] = status

  if echoback then
    if defdefup[mode][which] then
      echof("Will put %s up in %s mode.", which, mode)
    else
      echof("Won't put %s up anymore in %s mode.", which, mode)
    end
  end

  if not conf.keepup and status == true then
    echof("Keepup needs to be on, though.")
  end

  if reshow then show_defup() echo"\n" end
end


function create_defmode(which, echoback)
  local sendf; if echoback then sendf = echof end

  assert(which, "Which defences mode do you want to create?", sendf)
  assert(not (defdefup[which] and defkeepup[which]), which .. " defences mode already exists.", sendf)

  defdefup[which] = {}
  defkeepup[which] = {}

  for k,v in defs_data:pairs() do

    defdefup[which][k] = false
    defkeepup[which][k] = false

  end

  rift.precachedata[which] = {}
  for _,herb in pairs(rift.curativeherbs) do
    rift.precachedata[which][herb] = 0
  end

  if echoback then
    sendf("Defences mode created. You may now do mmdefs %s!", which)
    printCmdLine("mmdefs "..which)
  end
end

function rename_defmode(which, newname, echoback)
  local sendf; if echoback then sendf = echof end

  assert(which, "Which defences mode do you want to rename?", sendf)
  assert(defdefup[which] and defkeepup[which], which .. " defences mode doesn't exist.", sendf)
  assert(newname, "To which name do you want to rename " .. which .. " to?", sendf)

  defdefup[which], defdefup[newname] = defdefup[newname], defdefup[which]
  defkeepup[which], defkeepup[newname] = defkeepup[newname], defkeepup[which]
  rift.precachedata[which], rift.precachedata[newname] = rift.precachedata[newname], rift.precachedata[which]
end

function delete_defmode(which, echoback)
  local sendf; if echoback then sendf = echof end

  assert(which, "Which defences mode do you want to delete?", sendf)
  assert(defdefup[which] and defkeepup[which], which .. " defences mode doesn't exist.", sendf)
  assert(which ~= defs.mode, "You're currently in " .. which .. " defmode already - switch to another one first, and then delete this one.", sendf)

  defdefup[which], defkeepup[which], rift.precachedata[which] = nil, nil, nil

  if math.random(1, 10) == 1 then
    echof("Deleted '%s' defences mode.", which)
  else
    echof("Deleted '%s' defences mode. Forever!", which) end
end



function defload()
  local defdefup_t, defkeepup_t = {}, {}
  local defup_path, keepup_path = getMudletHomeDir() .. "/m&m/defup+keepup/defup", getMudletHomeDir() .. "/m&m/defup+keepup/keepup"

  if lfs.attributes(defup_path) then table.load(defup_path, defdefup_t) end
  if lfs.attributes(keepup_path) then table.load(keepup_path, defkeepup_t) end
  if lfs.attributes(getMudletHomeDir() .."/m&m/defup+keepup/ignored_defences") then table.load(getMudletHomeDir() .."/m&m/defup+keepup/ignored_defences", sk.ignored_defences) end

  if lfs.attributes(getMudletHomeDir() .."/m&m/defup+keepup/offline_defences") then
    local t = {}
    table.load(getMudletHomeDir() .."/m&m/defup+keepup/offline_defences", t)

    for i = 1, #t do
      defences.got(t[i])
    end

  end

  return defdefup_t, defkeepup_t
end

signals.relogin:connect(function()
  -- reset defs at login
  local t = {}
  for def, status in pairs(defc) do
    if status then t[#t+1] = defc end
  end

  for i = 1, #t do
    defc[t[i]] = nil
    raiseEvent("m&m lost def", t[i])
  end
end)

signals.saveconfig:connect(function ()
  table.save(getMudletHomeDir() .. "/m&m/defup+keepup/defup", defdefup)
  table.save(getMudletHomeDir() .. "/m&m/defup+keepup/keepup", defkeepup)
  table.save(getMudletHomeDir() .. "/m&m/defup+keepup/ignored_defences", sk.ignored_defences)

  local t = {}
  for k,v in defs_data:pairs() do if v.offline_defence and defc[k] then t[#t+1] = k end end
  table.save(getMudletHomeDir() .. "/m&m/defup+keepup/offline_defences", t)
end)

function sk.sanitize(self)
  return string.gsub(self, " ", "_")
end

function sk.desanitize(self)
  return string.gsub(self, "_", " ")
end

signals.systemstart:connect(function ()
  local defdefup_t, defkeepup_t = {}, {}
  defdefup_t, defkeepup_t = defload()

  -- create blank defup modes
  for k,v in pairs(defdefup_t) do
    defdefup[k] = defdefup[k] or {}
    defkeepup[k] = defkeepup[k] or {}
  end

  -- local tempExactMatchTriggerOld = tempExactMatchTrigger
  -- local function tempExactMatchTrigger(...)
  --   local values = {...}
  --   local id = tempExactMatchTriggerOld(...)
  --   print("creating: ", values[1], " id is: ", id)
  --   if id and exists(id, "trigger") > 0 then
  --     -- print"trigger made ok"
  --   else
  --     local args = {...}
  --     print("Failed to create a trigger for: ".. args[1])
  --   end

  --   if values[1] == "The world is seen through your sixth sense." then
  --     mm.thattrigger = id
  --     print("that trigger: ", mm.thattrigger)
  --   end
  -- end


  for k,v in defs_data:pairs() do
    -- sort into def types if applicable
    if v.custom_def_type then
      defences.custom_types[v.custom_def_type] = defences.custom_types[v.custom_def_type] or {}
      defences.custom_types[v.custom_def_type][k] = true
    end

    if v.onr and type(v.onr) == "table" then
      for n,m in ipairs(v.onr) do
        tempRegexTrigger(m, 'mm.defs.got_' .. sk.sanitize(k) .. '()')
      end
    elseif v.onr then
      tempRegexTrigger(v.onr, 'mm.defs.got_' .. sk.sanitize(k) .. '()')
    end

    if v.on and type(v.on) == "table" then
      for n,m in ipairs(v.on) do
        (tempExactMatchTrigger or tempTrigger)(m, 'mm.defs.got_' .. sk.sanitize(k) .. '()')
      end
    elseif v.on then
      (tempExactMatchTrigger or tempTrigger)(v.on, 'mm.defs.got_' .. sk.sanitize(k) .. '()')
    end

    if v.on_only and type(v.on_only) == "table" then
      for n,m in ipairs(v.on_only) do
        (tempExactMatchTrigger or tempTrigger)(m, 'mm.defs.gotonly_' .. sk.sanitize(k) .. '()')
      end
    elseif v.on_only then
      (tempExactMatchTrigger or tempTrigger)(v.on_only, 'mm.defs.gotonly_' .. sk.sanitize(k) .. '()')
    end

    if v.on_free then (tempExactMatchTrigger or tempTrigger)(v.on_free, 'mm.defs.got_' .. sk.sanitize(k) .. '()') end

    if v.offr and type(v.offr) == "string" then
        tempRegexTrigger(v.offr, 'mm.defs.lost_' .. sk.sanitize(k) .. '()')
    elseif v.offr then
      for n,m in ipairs(v.offr) do
        tempRegexTrigger(m, 'mm.defs.lost_' .. sk.sanitize(k) .. '()')
      end
    end

    if v.off and type(v.off) == "string" then
        (tempExactMatchTrigger or tempTrigger)(v.off, 'mm.defs.lost_' .. sk.sanitize(k) .. '()')
    elseif v.off then
      for n,m in ipairs(v.off) do
        (tempExactMatchTrigger or tempTrigger)(m, 'mm.defs.lost_' .. sk.sanitize(k) .. '()')
      end
    end

    -- this is EXACTLY for substring
    if v.offs and type(v.offs) == "string" then
        tempTrigger(v.offs, 'mm.defs.lost_' .. sk.sanitize(k) .. '()')
    elseif v.offs then
      for n,m in ipairs(v.offs) do
        tempTrigger(m, 'mm.defs.lost_' .. sk.sanitize(k) .. '()')
      end
    end

    if v.off_free then (tempExactMatchTrigger or tempTrigger)(v.off_free, 'mm.defs.lost_' .. sk.sanitize(k) .. '()') end

    if v.def and type(v.def) == "table" then
      for n,m in ipairs(v.def) do
        (tempExactMatchTrigger or tempTrigger)(m, 'mm.defs.def_' .. sk.sanitize(k) .. '()')
      end
    elseif v.def then
      (tempExactMatchTrigger or tempTrigger)(v.def, 'mm.defs.def_' .. sk.sanitize(k) .. '()')
    end

    if v.defr and type(v.defr) == "table" then
      for n,m in ipairs(v.defr) do
        tempRegexTrigger(m, 'mm.defs.def_' .. sk.sanitize(k) .. '()')
      end
    elseif v.defr then
      tempRegexTrigger(v.defr, 'mm.defs.def_' .. sk.sanitize(k) .. '()')
    end

    if not defs["got_" .. k] then
      if dict[k] then
        -- find a balance to use. rely on the fact that defs only have 1 balance in them
        local bal
        for kk,vv in pairs(dict[k]) do if type(vv) == "table" and kk ~= "gone" then bal = kk break end end
        if bal then
          defs["got_" .. k] = function ()
            if not v.custom_def_type then checkaction(dict[k][bal]) else checkaction(dict[k][bal], true) end
            if actions[k .. "_" .. bal] then
              lifevision.add(actions[k .. "_" .. bal].p)
            end
          end
        end
      end

      if not defs["got_" .. k] then
        defs["got_" .. k] = function ()
          defences.got(k)
        end
      end
    end

    if v.on_only and not defs["gotonly_" .. k] then
      if dict[k] then
        -- rely on the fact that defs only have 1 item in them
        local bal
        for kk,vv in pairs(dict[k]) do
          if type(vv) == "table" and kk ~= "gone" then bal = kk break end
        end
        defs["gotonly_" .. k] = function ()
          checkaction(dict[k][bal], false)
          if actions[k .. "_" .. bal] then
            lifevision.add(actions[k .. "_" .. bal].p)
          end
        end
      else
        defs["gotonly_" .. k] = function ()
          defences.got(k)
        end
      end
    end

    if not defs["lost_" .. sk.sanitize(k)] then
      if dict[k] and dict[k].gone then
        defs["lost_" .. k] = function ()
          checkaction(dict[k].gone, true)
          if actions[k .. "_gone"] then
            lifevision.add(actions[k .. "_gone"].p)
          end
        end
      else
        defs["lost_" .. k] = function ()
          defences.lost(k)
        end
      end
    end

    -- handle def_ functions for the def list
    if not v.nodef and not v.custom_def_type then
      defs["def_"..sk.sanitize(k)] = function ()

        if not v.ondef then
          defences.def_def_list[k] = true
        else
          defences.def_def_list[k] = v.ondef()
        end

        deleteLine()
      end
    elseif not v.nodef and v.custom_def_type then
      defs["def_"..sk.sanitize(k)] = function ()
        defences.got(k)
      end
    else
      defs["def_"..sk.sanitize(k)] = function ()

      -- only accept the def line if we know that we're parsing the def list currently. Otherwise, there's a case with SS songs where the line shows up the same both in def and songlist
        if not actions.defcheck_physical then return end

        deleteLine()
        if not v.ondef then
          defences.nodef_list[sk.sanitize(k)] = true
        else
          defences.nodef_list[sk.sanitize(k)] = v.ondef()
        end
      end
    end

    -- fill up our defences.def_types
    if v.type then
      defences.def_types[v.type] = defences.def_types[v.type] or {}
      defences.def_types[v.type][#defences.def_types[v.type]+1] = k
    end

    -- create blanks for defup and keepup
    if not v.nodef then
      for mode,modet in pairs(defdefup) do
        defdefup[mode][k] = false
        defkeepup[mode][k] = false
      end
    end


    if v.type then
      sk.ignored_defences[v.type] = sk.ignored_defences[v.type] or {status = false, t = {}}
      sk.ignored_defences[v.type].t[k] = sk.ignored_defences[v.type].t[k] or false
      sk.ignored_defences_map[k] = v.type
    end
  end

  update(defdefup, defdefup_t)
  update(defkeepup, defkeepup_t)

  -- remove skillsets from ignorelist that we don't have, for people that change
  for skillset, _ in pairs(sk.ignored_defences) do
    if skillset ~= "general" and skillset ~= "enchantment" and skillset ~= "artifact" and not me.skills[skillset] then
      sk.ignored_defences[skillset] = nil
    end
  end


  -- simple way of removing all and adding per line
  for name, data in pairs(defences.custom_types) do
    defs["def"..name.."start"] = function()
      for def, _ in pairs(defences.custom_types[name]) do
        defences.lost(def)
      end
    end
  end
end)

function defs.defprompt()
  setTriggerStayOpen("m&m defences start", 0)

  if not actions.defcheck_physical then return end
  show_current_defs()

  if not emptyphp(defences.nodef_list) then
    echof("Additional defences:")
    local count = 1
    for def, value in defences.nodef_list:pairs() do
      if value == true then
        decho(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %-23s", sk.desanitize(def)))
        defences.infolinkify(sk.desanitize(def))
      else
        decho(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %-23s", sk.desanitize(def) .. " " .. tostring(value)))
      end

      if count % 3 == 0 then echo("\n") end
      count = count + 1
    end

    count = 1 echo("\n")
  end

  defences.nodef_list = phpTable ()
  defences.def_def_list = {}
end

function defs.defstart()
  checkaction(dict.defcheck.physical)
  if actions.defcheck_physical then
    deleteLine()
  end
end

function defs.defline()
  if actions.defcheck_physical then
    deleteLine()
    tempLineTrigger(1, 1, 'selectString(line, 1) replace""')
    lifevision.add(actions.defcheck_physical.p)
  end
end

process_defs = function ()
  for defn, deft in pairs(defc) do
    -- clear ones we don't have
    if defc[defn] and not defences.def_def_list[defn] and not (defs_data[defn] and (defs_data[defn].invisibledef or defs_data[defn].custom_def_type)) then
      if dict[defn] and dict[defn].gone then
        checkaction(dict[defn].gone, true)
        lifevision.add(actions[defn.."_gone"].p)
      elseif defc[defn] then
        defences.lost(defn)
      end
    -- elseif defc[defn] and defences.def_def_list[defn] and not defs_data[defn].custom_def_type then -- if we do have it, remove from def list
    --   defences.def_def_list[defn] = nil
    --   debugf("%s cleared from def_def_list", defn)
    end
  end

  -- add left over ones
  for j,k in pairs(defences.def_def_list) do
    local bal
    for kk,vv in pairs(dict[j] or {}) do if type(vv) == "table" and kk ~= "gone" then bal = kk break end end
    if bal and dict[j][bal].oncompleted then
        dict[j][bal].oncompleted(k)
    elseif not defc[j] then
      defences.got(j)
    end
  end

  defs.defprompt()
end

-- prints out a def table
local function show_defs(tbl, linkcommand, cmdname)
  local count = 1

  local olddechoLink = dechoLink
  local function dechoLink(text, command, hint)
    olddechoLink(text, command, hint, true)
  end

  local function show_em(name, what)
    if name and not (sk.ignored_defences[name] and sk.ignored_defences[name].status) then echof("%s defences:", name:title()) end

    for c,def in ipairs(what) do
      local disabled = ((sk.ignored_defences[name] and sk.ignored_defences[name].status) and true or (sk.ignored_defences[sk.ignored_defences_map[def]].t[def]))

      -- for when it's not ticked off
      if not disabled and not tbl[def] and not defences.nodef_list[def] then
        if (count % 3) ~= 0 then
          if not linkcommand or not dechoLink then
            decho(string.format("<153,204,204>[ ] %-23s", def))
          else
            dechoLink(string.format("<153,204,204>[ ] %-23s", def), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Add %s to %s", def, cmdname))
          end
        else
          if not linkcommand or not dechoLink then
            decho(string.format("<153,204,204>[ ] %s", def))
          else
            dechoLink(string.format("<153,204,204>[ ] %s", def), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Add %s to %s", def, cmdname))
          end
        end
      -- for when it is ticked off
      elseif not disabled then
        if (count % 3) ~= 0 then
          if not defs_data[def].mana then
            if type(defences.nodef_list[def]) == "string" then
              if not linkcommand or not dechoLink then
                decho(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %-23s", def.." ("..defences.nodef_list[def]..")"))
              else
                dechoLink(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %-23s", def.." ("..defences.nodef_list[def]..")"), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Remove %s from %s", def, cmdname))
              end
              defences.nodef_list[def] = nil
            elseif type(defences.def_def_list[def]) == "string" then
              if not linkcommand or not dechoLink then
                decho(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %-23s", def.." "..defences.def_def_list[def]))
              else
                dechoLink(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %-23s", def.." "..defences.def_def_list[def]), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Remove %s from %s", def, cmdname))
              end
              defences.def_def_list[def] = nil
            elseif defs_data[def].onshow then
              if not linkcommand or not dechoLink then
                decho(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %-23s", def.." ("..defs_data[def].onshow()..")"))
              else
                dechoLink(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %-23s", def.." ("..defs_data[def].onshow()..")"), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Remove %s from %s", def, cmdname))
              end
            else
              if not linkcommand or not dechoLink then
                decho(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %-23s", def))
              else
                dechoLink(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %-23s", def), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Remove %s from %s", def, cmdname))
              end
            end
          elseif defs_data[def].mana == "little" then
            if not linkcommand or not dechoLink then
              decho(string.format("<153,204,204>[<0,0,140>m<153,204,204>] %-23s", def))
            else
              dechoLink(string.format("<153,204,204>[<0,0,140>m<153,204,204>] %-23s", def), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Remove %s from %s", def, cmdname))
            end
          else
            if not linkcommand or not dechoLink then
              decho(string.format("<153,204,204>[<0,0,204>M<153,204,204>] %-23s", def))
            else
              dechoLink(string.format("<153,204,204>[<0,0,204>M<153,204,204>] %-23s", def), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Remove %s from %s", def, cmdname))
            end
          end
        else
          if not defs_data[def].mana then
            if type(defences.nodef_list[def]) == "string" then
              if not linkcommand or not dechoLink then
                decho(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %s", def.." ("..defences.nodef_list[def]..")"))
              else
                dechoLink(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %s", def.." ("..defences.nodef_list[def]..")"), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Remove %s from %s", def, cmdname))
              end
              defences.nodef_list[def] = nil
            elseif type(defences.def_def_list[def]) == "string" then
              if not linkcommand or not dechoLink then
                decho(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %s", def.." "..defences.def_def_list[def]))
              else
                dechoLink(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %s", def.." "..defences.def_def_list[def]), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Remove %s from %s", def, cmdname))
              end
              defences.def_def_list[def] = nil
            elseif defs_data[def].onshow then
              if not linkcommand or not dechoLink then
                decho(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %s", def.." ("..defs_data[def].onshow()..")"))
              else
                dechoLink(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %s", def.." ("..defs_data[def].onshow()..")"), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Remove %s from %s", def, cmdname))
              end
            else
              if not linkcommand or not dechoLink then
                decho(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %s", def))
              else
                dechoLink(string.format("<153,204,204>[<0,204,0>X<153,204,204>] %s", def), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Remove %s from %s", def, cmdname))
              end
            end
          elseif defs_data[def].mana == "little" then
            if not linkcommand or not dechoLink then
              decho(string.format("<153,204,204>[<0,0,140>m<153,204,204>] %s", def))
            else
              dechoLink(string.format("<153,204,204>[<0,0,140>m<153,204,204>] %s", def), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Remove %s from %s", def, cmdname))
            end
          else
            if not linkcommand or not dechoLink then
              decho(string.format("<153,204,204>[<0,0,204>M<153,204,204>] %s", def))
            else
              dechoLink(string.format("<153,204,204>[<0,0,204>M<153,204,204>] %s", def), string.format("%s('%s', nil, nil, false, true)", linkcommand, def), string.format("Remove %s from %s", def, cmdname))
            end
          end
        end
      end
      if not linkcommand or not dechoLink then defences.infolinkify(def) end

      if not disabled and count % 3 == 0 then echo("\n") end
      if not disabled then count = count + 1 end
    end

    if count %3 ~= 1 then echo("\n") end; count = 1
  end

  setFgColor(153,204,204)
  local underline = setUnderline; _G.setUnderline = function () end

  show_em(nil, defences.def_types.general)
  show_em("Artifact\\Curio", defences.def_types.artifact)

  for j,k in pairs(defences.def_types) do
    if j ~= "general" and j ~= "artifact" then show_em (j, k) end
  end

  _G.setUnderline = underline
end

function show_current_defs()
  mm.echof("Your current defences (%d):", (function ()
    local count = 0
    for k,v in pairs(defc) do if v then count = count + 1 end end
    for k,v in defences.nodef_list:pairs() do
      if v then count = count + 1 end end
    return count
  end)())
  show_defs(defc)
end

function show_defup()
  mm.echof("%s defup defences (click to toggle):", defs.mode:title())
  show_defs(defdefup[defs.mode], "mm.defs.defup", "defup")
end

function show_keepup()
  mm.echof("%s keepup defences (click to toggle):", defs.mode:title())
  show_defs(defkeepup[defs.mode], "mm.defs.keepup", "keepup")
end

-- can't just check if we need and don't have, because some might have conflicts.
-- hence, just check isadvisable; this checks it for us and skips conflicts.
-- check have defup on prompt so it's not called many times.
function sk.have_defup_defs()
  local waitingon = {}
  for def,deft in defs_data:pairs() do
    if not (deft.specialskip and deft.specialskip()) and defdefup[defs.mode][def] and not defc[def] and not deft.nodef and not ignore[def] then
      waitingon[#waitingon+1] = def
    end
  end

  -- sort them according to aspriority
  table.sort(waitingon,
    function(a,b)
      if dict[a] and dict[b] and dict[a].physical and dict[b].physical then
        return dict[a].physical.aspriority > dict[b].physical.aspriority
      end
    end)

  if #waitingon > 0 then return false, waitingon
  else return true end
end;


-- custom def loss
(function ()

local teas = {
  blacktea = {"epilepsy", "vapors", "clumsiness", "blackout"},
  oolongtea = {"pacifism", "recklessness", "peace"},
  greentea = {"paralysis", "weakness", "rigormortis"},
  whitetea = {"stupidity", "deadening", "dementia"}
}

for tea, tea_data in pairs(teas) do
  for _, aff in pairs(tea_data) do
    defs[tea.."_"..aff] = function ()
      -- if we were afflicted by an unknown or a relevant aff above us, ignore it
      -- by deleting the <whatever>_aff from the actions and lifevision queues.

      -- idea a) add <tea> action as removing the said aff if we don't have it on us atm!
      --          otherwise we just kill tea balance
      if not affs[aff] then
        checkaction(dict[tea].gone, true)
        lifevision.add(actions[tea.."_gone"].p, nil, aff)
      elseif actions.unknownany_aff then
        checkaction(dict[tea].gone, true)
        lifevision.add(actions[tea.."_gone"].p, nil, "unknownany")
      elseif actions.unknownmental_aff then
        checkaction(dict[tea].gone, true)
        lifevision.add(actions[tea.."_gone"].p, nil, "unknownmental")
      else
        checkaction(dict[tea].gone, true)
        lifevision.add(actions[tea.."_gone"].p)
      end
    end
  end

  defs["got_" .. tea] = function ()
    checkaction(dict[tea].misc)
    if actions[tea .. "_misc"] then
      lifevision.add(actions[tea .. "_misc"].p)
    end
  end
end

end)();

function ignoreskill(skill, newstatus, echoback)
  local skill = skill:lower()

  -- first, check if this is a group we're disabling as a whole
  if sk.ignored_defences[skill] then
    sk.ignored_defences[skill].status = newstatus
    if echoback then showhidelist() end
    return
  end

  -- otherwise, loop through all skillsets, looking for the skill
  for _, group in pairs(sk.ignored_defences) do
    for skills, _ in pairs(group.t) do
      if skills == skill then
        group.t[skill] = newstatus
        if echoback then showhidelist() end
        return
      end
    end
  end
end

function showhidelist()
  local enabled_c, disabled_c = "<242,218,218>", "<156,140,140>"

  -- adds in the link with a proper tooltip
  local function makelink(skill, sign, groupstatus)
    if sign == "+" then
      echoLink(sign, [[mm.ignoreskill("]]..skill..[[", false, true)]],
        string.format("Click to start showing " .. skill.."%s", groupstatus and " (won't do anything since the group is disabled, though)" or ""), true)
    elseif sign == "-" then
      echoLink(sign, [[mm.ignoreskill("]]..skill..[[", true, true)]],
        string.format("Click to hide " .. skill.."%s", groupstatus and " (won't do anything since the group is disabled, though)" or ""), true)
    else
      echo " "
    end

    return ""
  end

  local count = 1
  -- shows a specific defences group
  local function show_em(name, what)
    decho(string.format("%s%s %s defences:\n",
      (what.status and disabled_c or enabled_c),
      makelink(name, (what.status and "+" or "-")),
      name:title()))

    -- loops through all defences within the group
    for def,disabled in pairs(what.t) do
      -- if the whole group is disabled, then all things inside it should be as well
      local skill_color = (what.status and true or disabled)

      if count % 3 == 1 then echo"  " end
      if (count % 3) ~= 0 then
        decho(string.format("%s%s %-23s",
          (skill_color and disabled_c or enabled_c),
          makelink(def, (disabled and "+" or "-"), what.status),
          def))
      else
        decho(string.format("%s%s %s",
          (skill_color and disabled_c or enabled_c),
          makelink(def, (disabled and "+" or "-"), what.status),
          def))
      end

      if count % 3 == 0 then echo("\n") end
      --~ if count % 3 ~= 1 then echo("  ") end
      count = count + 1
    end

    if count %3 ~= 1 then echo("\n") end
    count = 1
  end

  echof("Select which skillsets or skills to show in defence display lists:")
  show_em("general", sk.ignored_defences.general)
  show_em("artifact", sk.ignored_defences.artifact)

  local function f()
    for j,k in pairs(sk.ignored_defences) do
      if j ~= "general" and j ~= "artifact" then show_em (j, k) end
    end
  end

  local s,m = pcall(f)
  if not s then echof("Your Mudlet version doesn't seem to be new enough to display this; please update to latest (http://forums.mudlet.org/viewtopic.php?f=5&t=1874)") end
end

