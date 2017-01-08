-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

local empty = {}

empty.eat_pennyroyal = function()
  sk.lostbal_herb()
  removeaff({"confusion", "dementia", "hallucinating", "paranoia", "scrambledbrain", "stupidity", "void", "slightinsanity", "moderateinsanity", "majorinsanity", "massiveinsanity"})
end

empty.eat_galingale = function()
  sk.lostbal_herb()
  removeaff({"addiction", "gluttony", "inlove"})
end

empty.eat_horehound = function()
  sk.lostbal_herb()
  removeaff({"achromaticaura", "bedevil", "dissonance", "egovice", "healthleech", "manabarbs", "powerspikes", "recklessness", "minortimewarp", "moderatetimewarp", "majortimewarp", "massivetimewarp"})
end

empty.eat_kafe = function()
  sk.lostbal_herb()
  defences.got("kafe")
  removeaff({"daydreaming", "narcolepsy"})
end

empty.eat_calamus = function()
  sk.lostbal_herb()
  removeaff("slickness")
end

empty.sip_lucidity = function()
  sk.lostbal_lucidity()
  removeaff({"epilepsy", "paranoia", "sensitivity", "confusion", "recklessness", "hallucinating", "clumsiness", "stupidity", "addiction", "anorexia", "massiveinsanity","majorinsanity","moderateinsanity","slightinsanity","unknownlucidity"})
end

empty.eat_wafer = function()
  sk.lostbal_wafer()
  removeaff({"paralysis", "haemophilia", "powersap", "scabies", "dysentery", "pox", "vomiting", "rigormortis", "taintsick", "asthma","clotleftshoulder","clotrightshoulder","clotlefthip","clotrighthip","unknownwafer"})
end

empty.eat_earwort = function()
  sk.lostbal_herb()
  defences.got("truedeaf")
  removeaff("attraction")
end

empty.eat_kombu = function()
  sk.lostbal_herb()
  removeaff({"clumsiness", "deadening", "dizziness", "epilepsy", "omniphobia", "vapors"})
end

empty.eat_coltsfoot = function()
  sk.lostbal_herb()
end

empty.eat_sparkleberry = function()
  sk.lostbal_herb()
end

empty.eat_marjoram = function()
  sk.lostbal_herb()
  removeaff({"bicepleft", "bicepright", "dislocatedleftarm", "dislocatedleftleg", "dislocatedrightarm", "slicedrightbicep", "slicedleftbicep", "opengut","dislocatedrightleg", "gashedcheek", "puncturedchest", "rigormortis","slicedtongue", "slicedleftthigh", "slicedrightthigh", "weakness",  "missingleftear", "missingrightear", "stiffhead", "stiffchest", "stiffgut", "stiffrightarm", "stiffleftarm", "openchest"})
end

empty.eat_myrtle = function()
  sk.lostbal_herb()
  defences.got("truedeaf")
  defences.got("trueblind")
  removeaff({"sensitivity", "vertigo", "blind"})
end

empty.eat_faeleaf = function ()
  sk.lostbal_herb()
  defences.got("trueblind")
end

empty.eat_reishi = function()
  sk.lostbal_herb()
  removeaff({"aeon", "aurawarp", "jinx", "justice", "puncturedaura", "pacifism", "peace", "powersink", "succumb"})
end

empty.eat_wormwood = function()
  sk.lostbal_herb()
  removeaff({"agoraphobia", "claustrophobia", "hypochondria", "vestiphobia"})
end

empty.eat_yarrow = function()
  sk.lostbal_herb()
  removeaff({"slicedforehead",  "clotleftshoulder", "clotlefthip", "clotrightshoulder", "clotrighthip", "arteryleftleg", "arteryrightleg", "arteryleftarm", "arteryrightarm", "laceratedleftarm", "laceratedrightarm", "laceratedrightleg", "laceratedleftleg", "laceratedunknown", "relapsing", "haemophilia"})
end

empty.smoke_coltsfoot = function()
  removeaff({"anorexia", "impatience", "loneliness", "masochism", "shyness"})
end

empty.smoke_myrtle = function()
  removeaff({"crushedwindpipe", "piercedleftarm", "piercedleftleg", "piercedrightarm", "piercedrightleg", "hemiplegylower", "hemiplegyleft", "hemiplegyright", "severedphrenic"})
end

empty.smoke_steam = function()
  removeaff({"egovice", "manabarbs", "achromaticaura", "powerspikes", "disloyalty", "pacifism", "illuminated", "healthleech", "aeon", "slickness", "massivetimewarp","moderatetimewarp","majortimewarp","minortimewarp","unknownsteam", "slightlyaurawarped", "moderatelyaurawarped", "aurawarped", "massivelyaurawarped", "completelyaurawarped"})
end

empty.applyarnica_head = function()
  removeaff({"brokennose", "crushedwindpipe", "fracturedskull"})
end

empty.applyarnica_chest = function()
  removeaff({"brokenchest", "snappedrib"})
end

empty.applyarnica_arms = function()
  removeaff({"fracturedleftarm", "fracturedrightarm"})
end

empty.applyarnica_legs = function()
  removeaff({"crushedleftfoot", "crushedrightfoot"})
end

empty.sip_antidote = function()
  removeaff ({"powersap", "crotamine"})
end

empty.focus_mind = function()
  removeaff({"epilepsy", "dizziness", "confusion", "anorexia", "agoraphobia", "recklessness", "masochism", "loneliness", "shyness", "paranoia", "pacifism", "stupidity", "vertigo", "void", "weakness", "addiction", "claustrophobia", "vestiphobia", "slightinsanity", "moderateinsanity", "majorinsanity", "massiveinsanity", "hallucinating", "inlove", "minortimewarp", "moderatetimewarp", "majortimewarp", "massivetimewarp", "impatience"})
end

empty.focus_body = function()
  removeaff({"paralysis", "throatlock", "leglock"})
end

empty.focus_spirit = function ()
  if math.random(1,2) == 1 then return end

  removeaff {"omen", "papaxiego", "papaximana", "papaxihealth", "taintsick", "illuminated", "treebane"}
end

empty.writhe = function()
  removeaff({"impale", "crucified", "vines", "transfixed", "clampedleft", "clampedright", "hoisted", "roped", "shackled", "grapple", "truss", "tangle", "thornlashedleftarm", "thornlashedleftleg", "thornlashedrightarm", "thornlashedrightleg", "thornlashedhead", "pinlegright", "pinlegleft", "pinlegunknown", "gore", "pinlegright2", "pinlegleft2"})
end

empty.writhe_entangle = function()
  removeaff({"vines", "tangle", "pinlegright", "pinlegleft", "pinlegunknown"})
end

empty.apply_liniment = function ()
  sk.lostbal_salve ()
  removeaff({"scabies", "pox", "sunallergy", "fourthdegreeburn", "thirddegreeburn", "seconddegreeburn", "firstdegreeburn"})
end

empty.noeffect_melancholic_chest = function()
  removeaff({"blacklung", "puncturedlung", "asthma", "shortbreath", "trembling"})
end

empty.noeffect_melancholic_head = function()
  removeaff({"dizziness", "vapors", "sensitivity"})
end

empty.smoke_faeleaf = function()
  removeaff("cloudcoils")
end

empty.noeffect_mending_legs = function()
  dict.unknowncrippledleg.count = 0
  removeaff({"twistedleftleg", "twistedrightleg", "crippledrightleg", "crippledleftleg", "unknowncrippledleg"})
end

empty.noeffect_mending_arms = function()
  dict.unknowncrippledarm.count = 0
  removeaff({"twistedleftarm", "twistedrightarm", "crippledrightarm", "crippledleftarm", "brokenrightwrist", "brokenleftwrist", "unknowncrippledarm"})
end

empty.noeffect_mending_head = function()
  removeaff({"slitthroat", "brokenjaw", "fracturedskull"})
end

empty.noeffect_ice_head = function()
  removeaff({"damagedskull","damagedthroat"})
end

empty.noeffect_ice_chest = function()
  removeaff({"collapsedlungs","crushedchest"})
end

empty.noeffect_ice_gut = function()
  removeaff({"damagedorgans","internalbleeding"})
end

empty.noeffect_ice_leftarm = function()
  removeaff({"damagedleftarm","mutilatedleftarm"})
end

empty.noeffect_ice_rightarm = function()
  removeaff({"damagedrightarm","mutilatedrightarm"})
end

empty.noeffect_ice_leftleg = function()
  removeaff({"damagedleftleg","mutilatedleftleg"})
end

empty.noeffect_ice_rightleg = function()
  removeaff({"damagedrightleg","mutilatedrightleg"})
end

empty.cleanse = function()
  removeaff({"ectoplasm", "mud", "sap", "slickness", "deathmarkone", "deathmarktwo", "deathmarkthree", "deathmarkfour", "deathmarkfive", "gunk", "mucous"})
end

empty.sip_phlegmatic = function()
  removeaff({"void", "powersink", "aeon", "shyness", "weakness"})
end

empty.sip_allheale = function()
  removeaff({"blackout", "chestpain", "clumsiness", "paranoia", "gluttony", "vertigo", "agoraphobia", "vestiphobia", "dizziness", "claustrophobia", "vapors", "recklessness", "epilepsy", "peace", "dementia", "addiction", "stupidity", "jinx", "healthleech", "sensitivity", "succumb", "arteryleftleg", "arteryleftarm", "arteryrightleg", "arteryrightarm", "slicedforehead", "opengut", "slicedleftthigh", "slicedrightthigh", "missingleftear", "missingrightear", "puncturedchest", "relapsing", "slickness", "laceratedleftarm", "laceratedrightarm", "laceratedrightleg", "laceratedleftleg", "laceratedunknown", "inlove", "achromaticaura", "slicedtongue", "clotleftshoulder", "clotrightshoulder", "clotrighthip", "clotlefthip", "gashedcheek", "weakness", "hallucinating", "rigormortis", "scrambledbrain", "openchest", "pacifism", "void", "confusion", "egovice", "manabarbs", "powerspikes", "achromaticaura", "slicedleftbicep", "slicedrightbicep", "bleeding", "puncturedaura",  "brokennose", "crushedleftfoot", "crushedrightfoot", "snappedrib", "fracturedleftarm", "fracturedrightarm", "crotamine", "healthleech", "powersap", "vomiting", "haemophilia", "weakness", "worms", "ablaze", "vomitblood", "dysentery", "scalped", "disloyalty", "shivering", "frozen", "dysentery", "furrowedbrow", "shyness", "confusion", "lovepotion", "sensitivity", "dizziness", "brokenjaw", "slitthroat", "pox", "scabies", "asthma", "blacklung", "puncturedlung", "crippledrightarm", "crippledleftarm", "crippledrightleg", "crippledleftleg", "fracturedskull", "sunallergy", "twistedleftleg", "twistedrightleg", "twistedleftarm", "twistedrightarm", "brokenrightwrist", "brokenleftwrist", "trembling", "shortbreath", "firstdegreeburn", "masochism", "impatience", "anorexia", "crushedwindpipe", "piercedleftleg", "piercedrightleg", "piercedleftarm", "piercedrightarm", "hemiplegyleft", "hemiplegyright", "hemiplegylower", "severedphrenic", "loneliness", "shyness", "cloudcoils", "loneliness", "masochism", "pacifism", "paranoia", "recklessness", "shyness", "stupidity", "vertigo", "void", "weakness", "addiction", "agoraphobia", "anorexia", "claustrophobia", "confusion", "dizziness", "epilepsy", "vestiphobia", "hallucinating", "treebane", "illuminated", "mud", "sap", "slickness", "slightinsanity", "moderateinsanity", "majorinsanity", "massiveinsanity", "healhealth", "hypersomnia", "brokenchest", "daydreaming", "narcolepsy", "insomnia", "fear", "minortimewarp", "moderatetimewarp", "majortimewarp", "massivetimewarp", "oracle", "collapsedlungs", "hypochondria", "severedspine", "paralysis", "healego", "healmana", "avengingangel", "omniphobia", "aurawarp"})
end
