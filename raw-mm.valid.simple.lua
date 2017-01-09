-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.


for i,j in ipairs({"firstdegreeburn", "seconddegreeburn", "thirddegreeburn", "fourthdegreeburn", "paralysis", "tangle", "roped", "transfixed", "shackled", "inlove", "powersink", "stupidity", "arteryleftarm", "arteryleftleg", "arteryrightarm", "arteryrightleg", "clumsiness", "recklessness", "relapsing", "aeon", "confusion", "slickness", "shyness", "paranoia", "anorexia", "vertigo", "vestiphobia", "scabies", "damagedhead", "dizziness", "missingleftear", "missingrightear", "sunallergy", "sensitivity", "hallucinating", "epilepsy", "crotamine", "hypersomnia", "weakness", "dysentery", "vomiting", "hypochondria", "rigormortis", "masochism", "vapors", "asthma", "dementia", "concussion", "hemiplegyleft", "hemiplegyright", "pox", "opengut", "piercedleftarm", "piercedleftleg", "piercedrightarm", "piercedrightleg", "ablaze", "worms", "gluttony", "justice", "pacifism", "healthleech", "brokenjaw", "fracturedskull", "vomitblood", "fracturedleftarm", "fracturedrightarm", "brokenchest", "crushedchest", "brokennose", "collapsedlungs", "agoraphobia", "tendonleft", "tendonright", "brokenleftwrist", "brokenrightwrist", "addiction", "haemophilia", "impatience", "disloyalty", "claustrophobia", "peace", "daydreaming", "narcolepsy", "puncturedaura", "puncturedchest", "puncturedlung", "blacklung", "eyepeckleft", "eyepeckright", "throatlock", "leglock", "omniphobia", "disembowel", "slitthroat", "openchest", "slicedleftbicep", "slicedleftthigh", "slicedrightbicep", "slicedrightthigh", "crackedleftelbow", "crackedleftkneecap", "crackedrightelbow", "crackedrightkneecap", "scalped", "illuminated", "clampedleft", "clampedright", "succumb", "mud", "papaxihealth", "papaximana", "papaxiego", "burstorgans", "omen", "heretic", "infidel", "bubble", "fleshstone", "taintsick", "sap", "treebane", "stars", "phantom", "darkmoon", "fear", "blackout", "drunk", "deadening", "loneliness", "dissonance", "binah", "thornlashedleftarm", "thornlashedleftleg", "thornlashedrightarm", "thornlashedrightleg", "thornlashedhead", "darkseed", "gunk", "egovice", "manabarbs", "powerspikes", "achromaticaura", "gashedcheek", "laceratedleftarm", "laceratedleftleg", "laceratedrightarm", "laceratedrightleg", "laceratedunknown", "rupturedstomach", "severedspine", "shatteredjaw", "severedphrenic", "snappedrib", "furrowedbrow", "crushedwindpipe", "afterimage", "earache", "rainbowpattern", "crushedleftfoot", "crushedrightfoot", "slicedtongue", "shortbreath", "chestpain", "dislocatedleftarm", "dislocatedleftleg", "dislocatedrightarm", "dislocatedrightleg", "shatteredleftankle", "shatteredrightankle", "scrambledbrain", "hemiplegylower", "twistedleftarm", "twistedleftleg", "twistedrightarm", "twistedrightleg", "trembling", "truss", "void", "homeostasis", "bedevil", "aurawarp", "prone", "crippledleftarm", "crippledleftleg", "crippledrightarm", "crippledrightleg", "mangledleftarm", "mangledleftleg", "mangledrightarm", "mangledrightleg", "amputatedleftarm", "amputatedleftleg", "amputatedrightarm", "amputatedrightleg",  "clotleftshoulder", "clotlefthip", "clotrightshoulder", "clotrighthip", "enfeeble", "stiffhead", "stiffchest", "stiffgut", "stiffrightarm", "stiffleftarm", "insomnia", "shivering", "frozen", "lovepotion", "attraction", "grapple", "numbedhead", "numbedchest", "numbedgut", "numbedleftarm", "numbedleftleg", "numbedrightarm", "numbedrightleg", "batbane", "herbbane", "snakebane", "powersap", "collapsedleftnerve", "collapsedrightnerve", "choke", "illusorywounds", "crucified", "disrupt", "stun", "sleep", "pinlegright", "pinlegleft", "scarab", "ectoplasm", "jinx", "ninshihead", "ninshichest", "ninshigut", "ninshilarm", "ninshirarm", "ninshilleg", "ninshirleg", "possibleclot", "impale", "slicedforehead", "onevessel", "twovessels", "threevessels", "fourvessels", "fivevessels", "sixvessels", "sevenvessels", "eightvessels", "ninevessels", "tenvessels", "elevenvessels", "twelvevessels", "thirteenplusvessels", "batbane", "snakebane", "herbbane", "cloudcoils", "unknowncrippledleg", "slightinsanity", "moderateinsanity", "majorinsanity", "massiveinsanity", "missingrightarm", "missingleftarm", "missingrightleg", "missingleftleg", "maestoso", "inquisition", "hypnoticpattern", "deaf", "blind", "dreamer", "badluck", "pitted", "paregenlegs", "paregenchest", "thoughtstealer", "sightstealer", "mucous", "sluggish", "unknowncrippledarm", "greywhispers", "minortimewarp", "moderatetimewarp", "majortimewarp", "massivetimewarp", "timeechoes", "oracle", "rubycrystal", "gore", "hoisted", "voyria", "pinlegunknown", "retardation", "avengingangel", "mildallergy", "strongallergy", "severeallergy", "incapacitatingallergy", "darkfate", "damagedskull", "damagedthroat","damagedorgans","internalbleeding","damagedleftarm","damagedrightarm","damagedleftleg","damagedrightleg","mutilatedleftarm","mutilatedrightarm","mutilatedleftleg","mutilatedrightleg","echoes","unknownlucidity","unknownsteam","unknownwafer","unknownice","anesthesia","bentaura", "completelyaurawarped","massivelyaurawarped","aurawarped","moderatelyaurawarped","slightlyaurawarped"}) do
valid["simple" .. j] = function ()
  checkaction(dict[j].aff, true)
  lifevision.add(actions[j .. "_aff"].p)
end
end

valid.simplebleeding = function (amount)
  if conf.gmcpvitals then return end
#if skills.psychometabolism then
  if defc.bloodboil and conf.bloodboil and (stats.currentego > sys.egouse) then return end
#end

  if not conf.preclot then return end

  checkaction(dict.bleeding.aff, true)
  if actions.bleeding_aff then
    lifevision.add(actions.bleeding_aff.p, nil, dict.bleeding.count + (amount or 200))
  end
end

valid.simplebruising = function (amount)
  if conf.gmcpvitals then return end
#if skills.psychometabolism then
  if defc.bloodboil and conf.bloodboil and (stats.currentego > sys.egouse) then return end
#end

  if not conf.preclot then return end

  checkaction(dict.bruising.aff, true)
  if actions.bruising_aff then
    lifevision.add(actions.bruising_aff.p, nil, dict.bruising.count + (amount or 200))
  end
end

valid.simplelovers = function (name)
  assert(name)

  if (conf.autoreject == "white" and me.lustlist[name]) or (conf.autoreject == "black" and not me.lustlist[name]) then return end

  checkaction(dict.lovers.aff, true)
  lifevision.add(actions.lovers_aff.p, nil, name)
end

valid.gaudiwinbutton = function()
    gaudiWinTimer1 = tempTimer(10, [[cecho("\n<red>You've activated the super duper secret auto win button for members of Gaudiguch.")]])
    gaudiWinTimer2 = tempTimer(15, [[cecho("\n<red>If you are not a member of Gaudiguch, please restart your system, or everything will be deleted.")]])
    gaudiWinTimer3 = tempTimer(20, [[cecho("\n<red>If you are a member of Gaudiguch, remember the following phrases and you'll always end up on top.")]])
    gaudiWinTimer4 = tempTimer(25, [[cecho("\n<red>Live and Learn.")]])
    gaudiWinTimer5 = tempTimer(27, [[cecho("\n<red>  Will to Live!")]])
    gaudiWinTimer6 = tempTimer(29, [[cecho("\n<red>    Even in Victory, We can improve")]])
    gaudiWinTimer7 = tempTimer(31, [[cecho("\n<red>      Death matters not")]])
    gaudiWinTimer8 = tempTimer(33, [[cecho("\n<red>        Can't win if you don't try")]])
    gaudiWinTimer9 = tempTimer(35, [[cecho("\n<red>          Everyone is useful!")]])
    gaudiWinTimer10 = tempTimer(37, [[cecho("\n<red>            Freeeeeddddddooooooommmmmm!!")]])
    gaudiWinTimer11 = tempTimer(45, [[cecho("\n<red>This has been a friendly announcement of your friendly neighborhood developer. If you are not a member of Gaudiguch, don't worry, your system will not be deleted. Hope you enjoyed!")]])
end

valid.simplestun = function (amount)
  checkaction(dict.stun.aff, true)
  lifevision.add(actions.stun_aff.p, nil, amount)
  if sys.sync and conf.attemptearlystun and amount then
    if earlystunTimer then killTimer(earlystunTimer) end
    local time = 1
    if mm.defc.truetime then
      time = 0.9
    end
    earlystunTimer = tempTimer(amount-(time-getNetworkLatency()), [[mm.valid.stun_woreoff()]])
  end
end

valid.simpleunknownany = function (number)
  assert(not number or tonumber(number), "mm.valid.simpleunknownany: how many affs do you want to add? Must be a number")

  local have_pflag = pflags.p
  sk.onprompt_beforeaction_add("unknownany", function ()
    if not have_pflag and pflags.p then
      valid.simpleparalysis()
    end
  end)

  checkaction(dict.unknownany.aff, true)
  lifevision.add(actions.unknownany_aff.p, nil, number)

  -- to check if we got reckless!
  if stats.currenthealth ~= stats.maxhealth then
    dict.unknownany.reckhp = true end
  if stats.currentmana ~= stats.maxmana then
    dict.unknownany.reckmana = true end
  if stats.currentego ~= stats.maxego then
    dict.unknownany.reckego = true end
end

valid.simpleunknownmental = function (number)
  assert(not number or tonumber(number), "mm.valid.simpleunknownany: how many affs do you want to add? Must be a number")

  checkaction(dict.unknownmental.aff, true)
  lifevision.add(actions.unknownmental_aff.p, nil, number)

  -- to check if we got reckless!
  if stats.currenthealth ~= stats.maxhealth then
    dict.unknownmental.reckhp = true end
  if stats.currentmana ~= stats.maxmana then
    dict.unknownmental.reckmana = true end
  if stats.currentego ~= stats.maxego then
    dict.unknownmental.reckego = true end
end

for _,name in ipairs({"rightarm", "leftarm", "leftleg", "rightleg", "chest", "gut", "head"}) do
  for _,status in pairs({"light", "medium", "heavy", "critical"}) do
    valid["simple"..status..name] = function (amount)
      checkaction(dict[status..name].aff, true)
      if actions[status..name.."_aff"] then
        lifevision.add(actions[status..name.."_aff"].p, nil, amount)
      end
    end
  end
end
