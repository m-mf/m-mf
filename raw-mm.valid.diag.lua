-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

function valid.diagnose_start()
  checkaction(dict.diag.physical)
  if actions.diag_physical then
    lifevision.add(actions.diag_physical.p)
  else -- if we didn't send diagnose, don't accept output!
    setTriggerStayOpen("m&m diag", 0)
   end
end


local whitelist = {}
for _,limb in ipairs({"rightarm", "leftarm", "leftleg", "rightleg", "chest", "gut", "head"}) do
    for _, level in ipairs({"light", "medium", "heavy", "critical"}) do
      whitelist[level..limb] = true
    end
end
whitelist.pitted = true
whitelist.lovers = true
whitelist.retardation = true

function valid.diagnose_end()
  -- godfeelings?
  if not diag_list.afflictions then return end
  diag_list.afflictions = nil

  -- clear ones we don't have
  for affn, afft in pairs(affs) do
    if not diag_list[affn] and not whitelist[affn] then
#if DEBUG_diag then
      debugf("removed %s, don't actually have it.", affn)
#end
      if dict[affn].count then dict[affn].count = 0 end
      removeaff(affn)
    elseif not whitelist[affn] then -- if we do have the aff, remove from diag list, so we don't add it again
      diag_list[affn] = nil
    end
  end

  -- add left over ones
  for j,k in pairs(diag_list) do
#if DEBUG_diag then
    if not dict[j].aff then debugf("m&mf: invalid %s in diag end", j) end
#end
    -- skip defs
    if defc[j] == nil then
      checkaction(dict[j].aff, true)
      if type(k) == "number" and not dict[j].count then
        for amount = 1, k do lifevision.add(actions[j .. "_aff"].p) end
      elseif type(k) == "number" and dict[j].count then
        lifevision.add(actions[j .. "_aff"].p, nil, k)
      else
        lifevision.add(actions[j .. "_aff"].p)
      end
    end
  end

  -- special handling for insomnia
  if not diag_list.insomnia then
    defs.lost_insomnia()
  end

  affsp = {} -- potential affs
  signals.aeony:emit()
  setTriggerStayOpen("m&m diag", 0)
  diag_list = {}
end

#for i,j in ipairs({"firstdegreeburn", "seconddegreeburn", "thirddegreeburn", "fourthdegreeburn", "paralysis", "tangle", "roped", "transfixed", "shackled", "inlove", "powersink", "stupidity", "arteryleftarm", "arteryleftleg", "arteryrightarm", "arteryrightleg", "clumsiness", "recklessness", "relapsing", "aeon", "confusion", "slickness", "shyness", "paranoia", "anorexia", "vertigo", "vestiphobia", "scabies", "damagedhead", "dizziness", "missingleftear", "missingrightear", "sunallergy", "sensitivity", "hallucinating", "epilepsy", "crotamine", "hypersomnia", "weakness", "dysentery", "vomiting", "hypochondria", "rigormortis", "masochism", "vapors", "asthma", "dementia", "concussion", "hemiplegyleft", "hemiplegyright", "pox", "opengut", "piercedleftarm", "piercedleftleg", "piercedrightarm", "piercedrightleg", "ablaze", "worms", "gluttony", "justice", "pacifism", "healthleech", "brokenjaw", "fracturedskull", "vomitblood", "fracturedleftarm", "fracturedrightarm", "brokenchest", "crushedchest", "brokennose", "collapsedlungs", "agoraphobia", "tendonleft", "tendonright", "brokenleftwrist", "brokenrightwrist", "addiction", "haemophilia", "impatience", "disloyalty", "claustrophobia", "peace", "daydreaming", "narcolepsy", "puncturedaura", "puncturedchest", "puncturedlung", "blacklung", "eyepeckleft", "eyepeckright", "throatlock", "leglock", "omniphobia", "disembowel", "slitthroat", "openchest", "slicedleftbicep", "slicedleftthigh", "slicedrightbicep", "slicedrightthigh", "crackedleftelbow", "crackedleftkneecap", "crackedrightelbow", "crackedrightkneecap", "scalped", "illuminated", "clampedleft", "clampedright", "succumb", "mud", "papaxihealth", "papaximana", "papaxiego", "burstorgans", "omen", "heretic", "infidel", "bubble", "fleshstone", "taintsick", "sap", "treebane", "stars", "phantom", "darkmoon", "fear", "blackout", "drunk", "deadening", "loneliness", "dissonance", "binah", "thornlashedleftarm", "thornlashedleftleg", "thornlashedrightarm", "thornlashedrightleg", "thornlashedhead", "darkseed", "gunk", "egovice", "manabarbs", "powerspikes", "achromaticaura", "gashedcheek", "laceratedleftarm", "laceratedleftleg", "laceratedrightarm", "laceratedrightleg", "rupturedstomach", "severedspine", "shatteredjaw", "severedphrenic", "snappedrib", "furrowedbrow", "crushedwindpipe", "afterimage", "earache", "rainbowpattern", "crushedleftfoot", "crushedrightfoot", "slicedtongue", "shortbreath", "chestpain", "dislocatedleftarm", "dislocatedleftleg", "dislocatedrightarm", "dislocatedrightleg", "shatteredleftankle", "shatteredrightankle", "scrambledbrain", "hemiplegylower", "twistedleftarm", "twistedleftleg", "twistedrightarm", "twistedrightleg", "trembling", "truss", "void", "homeostasis", "bedevil", "aurawarp", "prone", "crippledleftarm", "crippledleftleg", "crippledrightarm", "crippledrightleg", "mangledleftarm", "mangledleftleg", "mangledrightarm", "mangledrightleg", "missingleftarm", "missingleftleg", "missingrightarm", "missingrightleg", "clotleftshoulder", "clotlefthip", "clotrightshoulder", "clotrighthip", "enfeeble", "stiffhead", "stiffchest", "stiffgut", "stiffrightarm", "stiffleftarm", "insomnia", "shivering", "frozen", "lovepotion", "attraction", "grapple", "numbedhead", "numbedchest", "numbedgut", "numbedleftarm", "numbedleftleg", "numbedrightarm", "numbedrightleg", "batbane", "herbbane", "snakebane", "powersap", "collapsedleftnerve", "collapsedrightnerve", "choke", "illusorywounds", "crucified", "disrupt", "stun", "sleep", "pinlegright", "pinlegleft", "scarab", "ectoplasm", "jinx", "ninshihead", "ninshichest", "ninshigut", "ninshilarm", "ninshirarm", "ninshilleg", "ninshirleg", "possibleclot", "impale", "slicedforehead", "pitted", "batbane", "snakebane", "herbbane", "deaf", "blind","onevessel", "twovessels", "threevessels", "fourvessels", "fivevessels", "sixvessels", "sevenvessels", "eightvessels", "ninevessels", "tenvessels", "elevenvessels", "twelvevessels", "thirteenplusvessels", "inquisition", "hypnoticpattern", "dreamer", "badluck", "deathmarkone", "deathmarktwo", "deathmarkthree", "deathmarkfour", "deathmarkfive", "thoughtstealer", "sightstealer", "slightinsanity", "moderateinsanity", "majorinsanity", "massiveinsanity", "mucous", "sluggish", "greywhispers", "minortimewarp", "moderatetimewarp", "majortimewarp", "massivetimewarp", "timeechoes", "oracle", "rubycrystal", "gore", "impaled", "avengingangel", "afflictions", "mildallergy", "strongallergy", "severeallergy", "incapacitatingallergy", "darkfate", "damagedthroat","damagedskull","damagedorgans","internalbleeding","damagedleftarm","damagedleftleg","damagedrightarm","damagedrightleg","mutilatedleftarm","mutilatedleftleg","mutilatedrightarm","mutilatedrightleg", "echoes","anethesia","bentaura", "slightlyaurawarped", "moderatelyaurawarped", "aurawarped", "massivelyaurawarped", "completelyaurawarped"}) do
function valid.diag_$(j)()
  diag_list.$(j) = true

  if ignore.$(j) then
    echo(" (currently ignored)")
  end
end

#end

function valid.diag_cloudcoils()
  diag_list.cloudcoils = tonumber(matches[2])
end

function valid.diag_bleeding()
  diag_list.bleeding = tonumber(multimatches[2][2])
end


function valid.diag_bruising()
  diag_list.bruising = tonumber(multimatches[2][2])
end

function valid.diag_rubycrystal()
  diag_list.rubycrystal = tonumber(multimatches[2][2])
end
