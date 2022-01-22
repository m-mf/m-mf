-- m&mf (c) 2010-2015 by Vadim Peretokin
-- m&mf (c) 2022 by Steingrim

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

function mm_ignore_misc_ext_patch_on()
  -- mmf misc things to let ac handle.
  mm.ignore.diag = true
  mm.ignore.magicwrithe = true
  mm.ignore.rewield = true
  mm.ignore.riding = true
  -- mm legacy code uses trueblind name for sixthsense
  -- mm.ignore.trueblind = true
  -- mm.ignore.truedeaf = true
  -- mmf affs, mmf afflictions.
  mm.echof("mmf is now ignoring misc actions!")
  mm.echof("  diag, magicwrithe, rewield, and >>riding<<")
  mm.echof("  - use mmignore riding, etcetera to toggle.")
end
  
function mm_ignore_defs_ext_patch_on()
  -- mmf defs, mmf defenses, mmf defences
  mm.ignore.fire = false
  mm.ignore.frost = false
  mm.ignore.galvanism = false
  --mm.ignore.quicksilver = false
  --mm.ignore.reflection = false
  mm.echof("mmf is now ignoring defences!")
  mm.echof("  fire, frost, galvanism, quicksilver")  
end
  
function mm_ignore_affs_ext_patch_on()
  mm.echof("mmf is now ignoring afflictions!")
  -- mmf misc things to let ac handle.
  mm.ignore.diag = true
  mm.ignore.magicwrithe = true
  mm.ignore.ablaze = true
  mm.ignore.achromaticaura = true
  mm.ignore.addiction = true
  -- todos: mmf
  -- confusing will this stop aeon checks in movement etc?
  -- aeon handling will have to be rewritten at some point.
  mm.ignore.aeon = true
  mm.ignore.afterimage = true
  mm.ignore.agoraphobia = true
  mm.ignore.anesthesia = true
  mm.ignore.anorexia = true
  mm.ignore.arteryleftarm = true
  mm.ignore.arteryleftleg = true
  mm.ignore.arteryrightarm = true
  mm.ignore.arteryrightleg = true
  mm.ignore.asthma = true
  mm.ignore.attraction = true
  mm.ignore.aurawarp = true
  mm.ignore.aurawarped = true
  mm.ignore.avengingangel = true
  mm.ignore.badluck = true
  mm.ignore.batbane = true
  mm.ignore.bedevil = true
  mm.ignore.bentaura = true
  mm.ignore.bicepleft = true
  mm.ignore.bicepright = true
  mm.ignore.binah = true
  mm.ignore.blacklung = true
  mm.ignore.blackout = true
  -- todos: mmf
  -- wasn't in this list originally
  -- possibly a knighthood def.
  -- mm.ignore.bleeder = true
  mm.ignore.bleeding = true
  mm.ignore.blind = true
  mm.ignore.bolding = true
  mm.ignore.brokenchest = true
  mm.ignore.brokenjaw = true
  mm.ignore.brokenleftwrist = true
  mm.ignore.brokennose = true
  mm.ignore.brokenrightwrist = true
  mm.ignore.bruising = true
  mm.ignore.bubble = true
  mm.ignore.burstorgans = true
  mm.ignore.checkdamagedthroat = true
  mm.ignore.checkparalysis = true
  mm.ignore.checkslickness = true
  mm.ignore.checkslitthroat = true
  mm.ignore.checkslows = true
  mm.ignore.checkthroatlock = true
  mm.ignore.chestpain = true
  mm.ignore.choke = true
  mm.ignore.clampedleft = true
  mm.ignore.clampedright = true
  mm.ignore.claustrophobia = true
  mm.ignore.cleanse = true
  mm.ignore.clotlefthip = true
  mm.ignore.clotleftshoulder = true
  mm.ignore.clotrighthip = true
  mm.ignore.clotrightshoulder = true
  mm.ignore.cloudcoils = true
  mm.ignore.clumsiness = true
  mm.ignore.collapsedleftnerve = true
  mm.ignore.collapsedlungs = true
  mm.ignore.collapsedrightnerve = true
  mm.ignore.completelyaurawarped = true
  mm.ignore.concussion = true
  mm.ignore.confusion = true
  mm.ignore.crackedleftelbow = true
  mm.ignore.crackedleftkneecap = true
  mm.ignore.crackedrightelbow = true
  mm.ignore.crackedrightkneecap = true
  mm.ignore.crackedunknownkneecap = true
  mm.ignore.crippledleftarm = true
  mm.ignore.crippledleftleg = true
  mm.ignore.crippledrightarm = true
  mm.ignore.crippledrightleg = true
  mm.ignore.criticalchest = true
  mm.ignore.criticalgut = true
  mm.ignore.criticalhead = true
  mm.ignore.criticalleftarm = true
  mm.ignore.criticalleftleg = true
  mm.ignore.criticalrightarm = true
  mm.ignore.criticalrightleg = true
  mm.ignore.crotamine = true
  mm.ignore.crucified = true
  mm.ignore.crushedchest = true
  mm.ignore.crushedleftfoot = true
  mm.ignore.crushedrightfoot = true
  mm.ignore.crushedwindpipe = true
  mm.ignore.damagedhead = true
  mm.ignore.damagedleftarm = true
  mm.ignore.damagedleftleg = true
  mm.ignore.damagedorgans = true
  mm.ignore.damagedrightarm = true
  mm.ignore.damagedrightleg = true
  mm.ignore.damagedskull = true
  mm.ignore.damagedthroat = true
  mm.ignore.darkfate = true
  mm.ignore.darkmoon = true
  mm.ignore.darkseed = true
  mm.ignore.daydreaming = true
  mm.ignore.deadening = true
  mm.ignore.deaf = true
  mm.ignore.deathmarkfive = true
  mm.ignore.deathmarkfour = true
  mm.ignore.deathmarkone = true
  mm.ignore.deathmarkthree = true
  mm.ignore.deathmarktwo = true
  mm.ignore.defcheck = true
  mm.ignore.dementia = true
  mm.ignore.diag = true
  mm.ignore.disembowel = true
  mm.ignore.dislocatedleftarm = true
  mm.ignore.dislocatedleftleg = true
  mm.ignore.dislocatedrightarm = true
  mm.ignore.dislocatedrightleg = true
  mm.ignore.disloyalty = true
  mm.ignore.disrupt = true
  mm.ignore.dissonance = true
  mm.ignore.dizziness = true
  -- allows parry
  mm.ignore.doparry = false
  mm.ignore.doprecache = true
  -- turn off stancing
  -- due to changes stancing needs a redo
  mm.ignore.dostance = true
  mm.ignore.dreamer = true
  mm.ignore.drunk = true
  mm.ignore.dysentery = true
  mm.ignore.earache = true
  mm.ignore.echoes = true
  mm.ignore.ectoplasm = true
  mm.ignore.egovice = true
  mm.ignore.eightvessels = true
  mm.ignore.elevenvessels = true
  mm.ignore.enfeeble = true
  mm.ignore.epilepsy = true
  mm.ignore.eyepeckleft = true
  mm.ignore.eyepeckright = true
  mm.ignore.fear = true
  mm.ignore.fillcoltsfoot = true
  mm.ignore.fillfaeleaf = true
  mm.ignore.fillmyrtle = true
  mm.ignore.fillsteam = true
  mm.ignore.firstdegreeburn = true
  mm.ignore.fivevessels = true
  mm.ignore.fourplusclots = true
  mm.ignore.fourthdegreeburn = true
  mm.ignore.fourvessels = true
  mm.ignore.fracturedleftarm = true
  mm.ignore.fracturedrightarm = true
  mm.ignore.fracturedskull = true
  mm.ignore.frozen = true
  mm.ignore.furrowedbrow = true
  mm.ignore.gashedcheek = true
  mm.ignore.givewarning = true
  mm.ignore.gluttony = true
  mm.ignore.gore = true
  mm.ignore.gotbalance = true
  mm.ignore.grapple = true
  mm.ignore.greywhispers = true
  mm.ignore.gunk = true
  mm.ignore.haemophilia = true
  mm.ignore.hallucinating = true
  mm.ignore.healego = true
  mm.ignore.healhealth = true
  mm.ignore.healmana = true
  mm.ignore.healspring = true
  mm.ignore.healthleech = true
  mm.ignore.heavychest = true
  mm.ignore.heavygut = true
  mm.ignore.heavyhead = true
  mm.ignore.heavyleftarm = true
  mm.ignore.heavyleftleg = true
  mm.ignore.heavyrightarm = true
  mm.ignore.heavyrightleg = true
  mm.ignore.hemiplegyleft = true
  mm.ignore.hemiplegylower = true
  mm.ignore.hemiplegyright = true
  mm.ignore.herbbane = true
  mm.ignore.heretic = true
  mm.ignore.hoisted = true
  mm.ignore.homeostasis = true
  mm.ignore.hypersomnia = true
  mm.ignore.hypnoticpattern = true
  mm.ignore.hypochondria = true
  mm.ignore.illuminated = true
  mm.ignore.illusorywounds = true
  mm.ignore.impale = true
  mm.ignore.impatience = true
  mm.ignore.incapacitatingallergy = true
  mm.ignore.infidel = true
  mm.ignore.inlove = true
  mm.ignore.inquisition = true
  mm.ignore.internalbleeding = true
  mm.ignore.jinx = true
  mm.ignore.justice = true
  mm.ignore.laceratedleftarm = true
  mm.ignore.laceratedleftleg = true
  mm.ignore.laceratedrightarm = true
  mm.ignore.laceratedrightleg = true
  mm.ignore.laceratedunknown = true
  mm.ignore.leglock = true
  mm.ignore.lightchest = true
  mm.ignore.lightcoltsfoot = true
  mm.ignore.lightfaeleaf = true
  mm.ignore.lightgut = true
  mm.ignore.lighthead = true
  mm.ignore.lightleftarm = true
  mm.ignore.lightleftleg = true
  mm.ignore.lightmyrtle = true
  mm.ignore.lightpipes = false
  mm.ignore.lightrightarm = true
  mm.ignore.lightrightleg = true
  mm.ignore.lightsteam = false
  mm.ignore.loneliness = true
  mm.ignore.lovepotion = true
  mm.ignore.lovers = true
  mm.ignore.maestoso = true
  mm.ignore.magicwrithe = true
  mm.ignore.majorinsanity = true
  mm.ignore.majortimewarp = true
  mm.ignore.manabarbs = true
  mm.ignore.mangledleftarm = true
  mm.ignore.mangledleftleg = true
  mm.ignore.mangledrightarm = true
  mm.ignore.mangledrightleg = true
  mm.ignore.masochism = true
  mm.ignore.massiveinsanity = true
  mm.ignore.massivelyaurawarped = true
  mm.ignore.massivetimewarp = true
  mm.ignore.mediumchest = true
  mm.ignore.mediumgut = true
  mm.ignore.mediumhead = true
  mm.ignore.mediumleftarm = true
  mm.ignore.mediumleftleg = true
  mm.ignore.mediumrightarm = true
  mm.ignore.mediumrightleg = true
  mm.ignore.mildallergy = true
  mm.ignore.minortimewarp = true
  mm.ignore.missingleftarm = true
  mm.ignore.missingleftear = true
  mm.ignore.missingleftleg = true
  mm.ignore.missingrightarm = true
  mm.ignore.missingrightear = true
  mm.ignore.missingrightleg = true
  mm.ignore.moderateinsanity = true
  mm.ignore.moderatelyaurawarped = true
  mm.ignore.moderatetimewarp = true
  mm.ignore.mucous = true
  mm.ignore.mud = true
  mm.ignore.mutilatedleftarm = true
  mm.ignore.mutilatedleftleg = true
  mm.ignore.mutilatedrightarm = true
  mm.ignore.mutilatedrightleg = true
  mm.ignore.narcolepsy = true
  mm.ignore.ninevessels = true
  mm.ignore.numbedchest = true
  mm.ignore.numbedgut = true
  mm.ignore.numbedhead = true
  mm.ignore.numbedleftarm = true
  mm.ignore.numbedleftleg = true
  mm.ignore.numbedrightarm = true
  mm.ignore.numbedrightleg = true
  mm.ignore.octave = true
  mm.ignore.omen = true
  mm.ignore.omniphobia = true
  mm.ignore.oneclot = true
  mm.ignore.onevessel = true
  mm.ignore.openchest = true
  mm.ignore.opengut = true
  mm.ignore.oracle = true
  mm.ignore.pacifism = true
  mm.ignore.papaxiego = true
  mm.ignore.papaxihealth = true
  mm.ignore.papaximana = true
  mm.ignore.paralysis = true
  mm.ignore.paranoia = true
  mm.ignore.paregenchest = true
  mm.ignore.paregenlegs = true
  mm.ignore.peace = true
  mm.ignore.phantom = true
  mm.ignore.piercedleftarm = true
  mm.ignore.piercedleftleg = true
  mm.ignore.piercedrightarm = true
  mm.ignore.piercedrightleg = true
  mm.ignore.pinlegleft = true
  mm.ignore.pinlegleft2 = true
  mm.ignore.pinlegright = true
  mm.ignore.pinlegright2 = true
  mm.ignore.pinlegunknown = true
  mm.ignore.pitted = true
  mm.ignore.powercure = true
  mm.ignore.powersap = true
  mm.ignore.powersink = true
  mm.ignore.powerspikes = true
  mm.ignore.pox = true
  mm.ignore.prone = true
  mm.ignore.puncturedaura = true
  mm.ignore.puncturedchest = true
  mm.ignore.puncturedlung = true
  mm.ignore.rainbowpattern = true
  mm.ignore.recklessness = true
  mm.ignore.relapsing = true
  -- retardation perhaps needs a review to
  -- determine if it can be enabled.
  -- I suspect it won't work well without
  -- m&m turning off ssc and being fixed to
  -- where it can heal by itself.
  mm.ignore.retardation = true
  mm.ignore.rigormortis = true
  mm.ignore.roped = true
  mm.ignore.rubycrystal = true
  mm.ignore.rupturedstomach = true
  mm.ignore.sacrifice = true
  mm.ignore.scabies = true
  mm.ignore.scalped = true
  mm.ignore.scarab = true
  mm.ignore.scrambledbrain = true
  mm.ignore.seconddegreeburn = true
  mm.ignore.sensitivity = true
  mm.ignore.sevenvessels = true
  mm.ignore.severeallergy = true
  mm.ignore.severedphrenic = true
  mm.ignore.severedspine = true
  mm.ignore.shackled = true
  mm.ignore.shatteredjaw = true
  mm.ignore.shatteredleftankle = true
  mm.ignore.shatteredrightankle = true
  mm.ignore.sheatheclaw = true
  mm.ignore.shivering = true
  mm.ignore.shortbreath = true
  mm.ignore.shyness = true
  mm.ignore.sightstealer = true
  mm.ignore.sixvessels = true
  mm.ignore.sleep = true
  mm.ignore.slicedforehead = true
  mm.ignore.slicedleftbicep = true
  mm.ignore.slicedleftthigh = true
  mm.ignore.slicedrightbicep = true
  mm.ignore.slicedrightthigh = true
  mm.ignore.slicedtongue = true
  mm.ignore.slickness = true
  mm.ignore.slightinsanity = true
  mm.ignore.slightlyaurawarped = true
  mm.ignore.slitthroat = true
  mm.ignore.sluggish = true
  mm.ignore.snakebane = true
  mm.ignore.snappedrib = true
  mm.ignore.stars = true
  mm.ignore.stiffchest = true
  mm.ignore.stiffgut = true
  mm.ignore.stiffhead = true
  mm.ignore.stiffleftarm = true
  mm.ignore.stiffrightarm = true
  mm.ignore.stolebalance = true
  mm.ignore.strongallergy = true
  mm.ignore.stun = true
  mm.ignore.stupidity = true
  mm.ignore.succumb = true
  mm.ignore.sunallergy = true
  mm.ignore.taintsick = true
  mm.ignore.tangle = true
  mm.ignore.tendonleft = true
  mm.ignore.tendonright = true
  mm.ignore.tendonunknown = true
  mm.ignore.tenvessels = true
  mm.ignore.thirddegreeburn = true
  mm.ignore.thirteenplusvessels = true
  mm.ignore.thornlashedhead = true
  mm.ignore.thornlashedleftarm = true
  mm.ignore.thornlashedleftleg = true
  mm.ignore.thornlashedrightarm = true
  mm.ignore.thornlashedrightleg = true
  mm.ignore.thoughtstealer = true
  mm.ignore.threeclots = true
  mm.ignore.threevessels = true
  mm.ignore.throatlock = true
  mm.ignore.timeechoes = true
  mm.ignore.transfixed = true
  mm.ignore.treebane = true
  mm.ignore.trembling = true
  mm.ignore.truss = true
  mm.ignore.twelvevessels = true
  mm.ignore.twistedleftarm = true
  mm.ignore.twistedleftleg = true
  mm.ignore.twistedrightarm = true
  mm.ignore.twistedrightleg = true
  mm.ignore.twoclots = true
  mm.ignore.twovessels = true
  mm.ignore.vapors = true
  mm.ignore.vertigo = true
  mm.ignore.vestiphobia = true
  mm.ignore.vines = true
  mm.ignore.void = true
  mm.ignore.vomitblood = true
  mm.ignore.vomiting = true
  mm.ignore.weakness = true
  mm.ignore.worms = true
end
  
function mm_ignore_help()
  mm.echof("******************")
  mm.echof("  mm ignore help  ")
  mm.echof("******************")
  mm.echof("  Defenses: MMF is now ignoring defences!")
  mm.echof("  Ignoring defs means that <b>even</b> if you add them")
  mm.echof("  to a defup/keepup setting they will not fire.")
  mm.echof("  toggle syntax:")
  mm.echof("  mmignore fire|frost|galvanism|quicksilver|reflection.")
  mm.echof("  - this is okay as they'll be added to server-side autocuring.")
  mm.echof("")
  mm.echof("  *Recomended you mmignore trueblind & mmignore truedeaf.")
  mm.echof("")
  mm.echof("  SYNTAX:")
  mm.echof("   mmignoreall or mm ignoreall <on|off|def|affs|all>")
  mm.echof("")
  mm.echof("******************")
end
  
 function mm_ignore_ext_patch_on()
  mm_ignore_misc_ext_patch_on()
  mm_ignore_defs_ext_patch_on()
  mm_ignore_affs_ext_patch_on()
  mm.echof("mmf is now ignoring all")
end

install.ids = install.ids or {}

-- same name as conf
-- function to say have/don't have
local installdata = {
  stance = {
    command = "ab combat",
    other = {
      pattern = [[^You have gained the following abilities in Combat:$]],
      script = [[
        mm.deleteAllP()
        if mm.abcombattrigs then return end

        mm.abcombattrigs = {}
        for _, k in pairs{"legs", "left", "right", "arms", "gut", "chest", "head", "lower", "middle", "upper", "vitals"} do
          mm.abcombattrigs[#mm.abcombattrigs+1] = tempRegexTrigger("^" .. string.title(k), [=[
            mm.config.set("stanceskill", "]=]..k..[=[", false)
            mm.abcombatresult = true
          ]=])
        end

        -- replace w/ tempLuaTrigger
        tempTimer(0.02, [=[
            if mm.abcombattrigs then for _, v in ipairs(mm.abcombattrigs) do killTrigger(tostring(v)) end; mm.abcombattrigs = nil end
            if not mm.abcombatresult then
              mm.echof("Don't have any stance skills, so <250,0,0>won't%s be using stance.", mm.getDefaultColor())
              mm.sp_config.stance_skills = {}
            else
              mm.abcombatresult = nil
              mm.config.set("stanceskill", mm.sp_config.stance_skills[#mm.sp_config.stance_skills], false)
            end
            mm.installclear("stance")
        ]=])
      ]]
    }
  },
#if skills.knighthood then
  parry = {
    command = "ab knighthood shieldparry",
    gmcp = {group = "knighthood", name = "shieldparry"},
    yes = {
      pattern = [[^KNIGHTHOOD - SHIELDPARRY$]],
      script = [[
        mm.installclear("parry")
        mm.conf.parry = true
        tempLineTrigger(1, 6, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Have parry, so <0,250,0>will%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    },
    no = {
      pattern = [[^The shieldparry ability in the Knighthood skill is unknown to you\.$]],
      script = [[
        mm.installclear("parry")
        mm.conf.parry = false
        tempLineTrigger(1, 1, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Don't have parry, so <250,0,0>won't%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    }
  },
#else
  parry = {
    command = "ab combat shieldparry",
    gmcp = {group = "combat", name = "shieldparry"},
    yes = {
      pattern = [[^COMBAT - SHIELDPARRY$]],
      script = [[
        mm.installclear("parry")
        mm.conf.parry = true
        tempLineTrigger(1, 8, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Have parry, so <0,250,0>will%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    },
    no = {
      pattern = [[^The shieldparry ability in the Combat skill is unknown to you\.$]],
      script = [[
        mm.installclear("parry")
        mm.conf.parry = false
        tempLineTrigger(1, 1, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Don't have parry, so <250,0,0>won't%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    }
  },
#end
  stratagem = {
    command = "ab combat stratagem",
    gmcp = {group = "combat", name = "stratagem"},
  },
#if skills.lowmagic then
  green = {
    command = "ab lowmagic green",
    gmcp = {group = "lowmagic", name = "green"},
    yes = {
      pattern = [[^LOWMAGIC - GREEN$]],
      script = [[
        mm.installclear("green")
        mm.conf.green = true
        tempLineTrigger(1, 4, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Have green, so <0,250,0>will%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    },
    no = {
      pattern = [[^The green ability in the Lowmagic skill is unknown to you\.$]],
      script = [[
        mm.installclear("green")
        mm.conf.green = false
        tempLineTrigger(1, 1, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Don't have green, so <250,0,0>won't%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    }
  },
  summer = {
    command = "ab lowmagic summer",
    gmcp = {group = "lowmagic", name = "summer"},
    yes = {
      pattern = [[^LOWMAGIC - SUMMER$]],
      script = [[
        mm.installclear("summer")
        mm.conf.summer = true
        tempLineTrigger(1, 4, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Have Summer, so <0,250,0>will%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    },
    no = {
      pattern = [[^The summer ability in the Lowmagic skill is unknown to you\.$]],
      script = [[
        mm.installclear("summer")
        mm.conf.summer = false
        tempLineTrigger(1, 1, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Don't have summer, so <250,0,0>won't%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    }
  },
#end
#if skills.highmagic then
  gedulah = {
    command = "ab highmagic gedulah",
    gmcp = {group = "highmagic", name = "gedulah"},
    yes = {
      pattern = [[^HIGHMAGIC - GEDULAH$]],
      script = [[
        mm.installclear("gedulah")
        mm.conf.gedulah = true
        tempLineTrigger(1, 6, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Have gedulah, so <0,250,0>will%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    },
    no = {
      pattern = [[^The gedulah ability in the Highmagic skill is unknown to you\.$]],
      script = [[
        mm.installclear("gedulah")
        mm.conf.gedulah = false
        tempLineTrigger(1, 1, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Don't have gedulah, so <250,0,0>won't%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    }
  },
  tipheret = {
    command = "ab highmagic tipheret",
    gmcp = {group = "highmagic", name = "tipheret"},
    yes = {
      pattern = [[^HIGHMAGIC - TIPHERET$]],
      script = [[
        mm.installclear("tipheret")
        mm.conf.tipheret = true
        tempLineTrigger(1, 6, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Have tipheret, so <0,250,0>will%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    },
    no = {
      pattern = [[^The tipheret ability in the Highmagic skill is unknown to you\.$]],
      script = [[
        mm.installclear("tipheret")
        mm.conf.tipheret = false
        tempLineTrigger(1, 1, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Don't have tipheret, so <250,0,0>won't%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    }
  },
#end
  focusbody = {
    command = "ab discipline focusbody",
    gmcp = {group = "discipline", name = "focusbody"},
    yes = {
      pattern = [[^DISCIPLINE - FOCUSBODY$]],
      script = [[
        mm.installclear("focusbody")
        mm.conf.focusbody = true
        tempLineTrigger(1, 4, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Have focus body, so <0,250,0>will%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    },
    no = {
      pattern = [[^The focusbody ability in the Discipline skill is unknown to you\.$]],
      script = [[
        mm.installclear("focusbody")
        mm.conf.focusbody = false
        tempLineTrigger(1, 1, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Don't have focus body, so <250,0,0>won't%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    }
  },
  focusmind = {
    command = "ab discipline focusmind",
    gmcp = {group = "discipline", name = "focusmind"},
    yes = {
      pattern = [[^DISCIPLINE - FOCUSMIND$]],
      script = [[
        mm.installclear("focusmind")
        mm.conf.focusmind = true
        tempLineTrigger(1, 4, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Have focus mind, so <0,250,0>will%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    },
    no = {
      pattern = [[^The focusmind ability in the Discipline skill is unknown to you\.$]],
      script = [[
        mm.installclear("focusmind")
        mm.conf.focusmind = false
        tempLineTrigger(1, 1, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Don't have focus mind, so <250,0,0>won't%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    }
  },
  focusspirit = {
    command = "ab discipline focusspirit",
    gmcp = {group = "discipline", name = "focusspirit"},
    yes = {
      pattern = [[^DISCIPLINE - FOCUSSPIRIT$]],
      script = [[
        mm.installclear("focusspirit")
        mm.conf.focusspirit = true
        tempLineTrigger(1, 4, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Have focus spirit, so <0,250,0>will%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    },
    no = {
      pattern = [[^The focusspirit ability in the Discipline skill is unknown to you\.$]],
      script = [[
        mm.installclear("focusspirit")
        mm.conf.focusspirit = false
        tempLineTrigger(1, 1, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Don't have focus spirit, so <250,0,0>won't%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    }
  },
  rockclimbing = {
    command = "ab environment rockclimbing",
    gmcp = {group = "environment", name = "rockclimbing"},
    yes = {
      pattern = [[^ENVIRONMENT - ROCKCLIMBING$]],
      script = [[
        mm.installclear("rockclimbing")
        mm.conf.rockclimbing = true
        tempLineTrigger(1, 4, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Have rock climbing, so <0,250,0>will%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    },
    no = {
      pattern = [[^The rockclimbing ability in the Environment skill is unknown to you\.$]],
      script = [[
        mm.installclear("rockclimbing")
        mm.conf.rockclimbing = false
        tempLineTrigger(1, 1, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Don't have rock climbing, so <250,0,0>won't%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    }
  },
  scrollid = {
    command = "ii scroll of healing",
    item = true,
    other = {
      pattern = [[^You are wielding:$]],
      script = [[
        mm.deleteAllP()
        mm.scrollidtrig = tempRegexTrigger([=[^"scroll(\d+)" +a Scroll of Healing$]=],
          [=[
            tempTimer(0.02, [==[
              if not mm.conf.scrollid then
                mm.config.set("scrollid", ]==]..matches[2]..[==[, true) end
              if not mm.conf.scroll then
                mm.config.set("scroll", true, true) end
              mm.installclear("scrollid")
            ]==])
            killTrigger(mm.scrollidtrig)
          ]=])
      ]]
    }
  },
  autorecharge = {
    command = "ii energy cube",
    item = true,
    other = {
      pattern = [[^You are wielding:$]],
      script = [[
        mm.deleteAllP()
        mm.autorechargetrig = tempRegexTrigger([=[^"cube\d+" +an energy cube$]=],
          [=[
            tempTimer(0.02, [==[
              if not mm.conf.autorecharge then
                mm.config.set("autorecharge", true, true)
                mm.installclear("autorecharge")
              end
            ]==])
          ]=])
      ]]
    }
  },
  magictome = {
    command = "ii bar of golden magictome",
    item = true,
    other = {
      pattern = [[^You are wielding:$]],
      script = [[
        mm.deleteAllP()
        mm.scrollidtrig = tempRegexTrigger([=[^"tome\d+" +a magic tome$]=],
          [=[
            tempTimer(0.02, [==[
              mm.config.set("magictome", true, true)
              mm.installclear("magictome")
            ]==])
          ]=])
      ]]
    }
  },
  soap = {
    command = "ii bar of golden soap",
    item = true,
    other = {
      pattern = [[^You are wielding:$]],
      script = [[
        mm.deleteAllP()
        mm.scrollidtrig = tempRegexTrigger([=[^"soap\d+" +a bar of golden soap$]=],
          [=[
            tempTimer(0.02, [==[
              mm.config.set("soap", true, true)
              mm.installclear("soap")
            ]==])
          ]=])
      ]]
    }
  },
  insomnia = {
    command = "ab discipline insomnia",
    gmcp = {group = "discipline", name = "insomnia"},
    yes = {
      pattern = [[^DISCIPLINE - INSOMNIA$]],
      script = [[
        mm.installclear("insomnia")
        mm.conf.insomnia = true
        tempLineTrigger(1, 4, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Have insomnia, so <0,250,0>will%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    },
    no = {
      pattern = [[^The insomnia ability in the Discipline skill is unknown to you\.$]],
      script = [[
        mm.installclear("insomnia")
        mm.conf.insomnia = false
        tempLineTrigger(1, 1, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Don't have insomnia, so <250,0,0>won't%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    }
  },
  clot = {
    command = "ab discipline clotting",
    gmcp = {group = "discipline", name = "clotting"},
    yes = {
      pattern = [[^DISCIPLINE - CLOTTING$]],
      script = [[
        mm.installclear("clot")
        mm.conf.clot = true
        tempLineTrigger(1, 4, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Have clotting, so <0,250,0>will%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    },
    no = {
      pattern = [[^The clotting ability in the Discipline skill is unknown to you\.$]],
      script = [[
        mm.installclear("clot")
        mm.conf.clot = false
        tempLineTrigger(1, 1, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Don't have clotting, so <250,0,0>won't%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    }
  },
#if skills.acrobatics then
  contort = {
    command = "ab acrobatics contortion",
    gmcp = {group = "acrobatics", name = "contortion"},
    yes = {
      pattern = [[^ACROBATICS - CONTORTION$]],
      script = [[
        mm.installclear("contort")
        mm.conf.contort = true
        tempLineTrigger(1, 4, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Have contort, so <0,250,0>will%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    },
    no = {
      pattern = [[^I know of no skill called "Contort\."$]],
      script = [[
        mm.installclear("contort")
        mm.conf.contort = false
        tempLineTrigger(1, 1, [=[deleteLine()]=])
        selectString(line, 1) replace ""
        mm.echof("Don't have contort, so <250,0,0>won't%s be using it whenever possible.", mm.getDefaultColor())
      ]]
    }
  },
#end
}

function installclear(what)
  if type(install.ids[what]) == "table" then

    for _, id in pairs(install.ids[what]) do
      killTrigger(id)
      install.ids[what][_] = nil
    end
    install.ids[what] = nil

  else
    install.ids[what] = nil
  end

  if installtimer then killTimer(installtimer) end
  tempTimer(5+getNetworkLatency(), function ()
    if next(install.ids) then
      for thing, _ in pairs(install.ids) do
        if config_dict[thing] and config_dict[thing].type == "boolean" then
          config.set(thing, false, true)
        end

        installclear(thing)
      end
    end

    installtimer = nil

    if not next(install.ids) and not install.installing_system then
      echo"\n"
      echof("auto-configuration done. :) question time!")
      echo"\n"
      install.ask_install_questions()
    end
  end)
end

function installstart(fresh)
  if fresh and not sk.installwarning then
    echof("Are you really sure you want to wipe everything (all remove all non-default defence modes, clear basic+combat defup/keepup to blank, remove all configuration options)? If yes, do mminstall fresh again.")
    if selectString("really", 1) ~= -1 then setUnderline(true) resetFormat() end
    sk.installwarning = true
    return
  elseif fresh and sk.installwarning then
    local s, m = os.remove(getMudletHomeDir() .. "/m&m")
    if not s then echof("Couldn't remove m&mf folder because of: %s", m) end

    defdefup = {
      basic = {},
      combat = {},
    }

    defkeepup = {
      basic = {},
      combat = {},
    }

    echof("Vacuumed everything up!")
    sk.installwarning = nil
  end

  for _, skill in pairs(install.ids) do
    for _, id in pairs(skill) do
      installclear(id)
    end
  end

  install.ids = {}
  local ids = install.ids

  if not sys.enabledgmcp then
    for skill, skilldata in pairs(installdata) do
      ids[skill] = {}
      if skilldata.yes then ids[skill][#ids[skill]+1] = tempRegexTrigger(skilldata.yes.pattern, skilldata.yes.script) end
      if skilldata.no then ids[skill][#ids[skill]+1] = tempRegexTrigger(skilldata.no.pattern, skilldata.no.script) end
      if skilldata.other then ids[skill][#ids[skill]+1] = tempRegexTrigger(skilldata.other.pattern, skilldata.other.script) end
      send(skilldata.command, false)
    end
  else
    for skill, skilldata in pairs(installdata) do
      if skilldata.gmcp then
        sendGMCP("Char.Skills.Get "..yajl.to_string(skilldata.gmcp))
        ids[skill] = true
      end
    end

    sendGMCP("Char.Skills.Get "..yajl.to_string{group = "combat"})
    sendGMCP("Char.Items.Inv")
    signals.gmcpcharskillsinfo:unblock(install.checkskillgmcp)
    signals.gmcpcharitemslist:unblock(install.checkinvgmcp)
    signals.gmcpcharskillslist:unblock(install.checkcombat)
  end

  if sys.enabledgmcp then
    echof("Starting auto-configuration - going to detect which skills and pipes you've got.")
    printCmdLine("Please wait, doing auto-configuration...")
    echo"\n"
  else
    echof("Please enable GMCP in Mudlet settings and restart before installing.")

    signals.gmcpcharskillsinfo:block(install.checkskillgmcp)
    signals.gmcpcharitemslist:block(install.checkinvgmcp)
    signals.gmcpcharskillslist:block(install.checkcombat)

    install.installing_system = false

    for _, skill in pairs(install.ids) do
      for _, id in pairs(skill) do
        installclear(id)
      end
    end

    install.ids = {}

    return
  end

  send("config prompt remove linebreak", true)
  send("config wrapwidth 0", true)

  -- defaults/reset
  for name, tbl in config_dict:iter() do
    if tbl.installstart then tbl.installstart() end
  end
  pipes.coltsfoot.id, pipes.faeleaf.id, pipes.myrtle.id, pipes.steam.id = 0,0,0,0

  if sys.enabledgmcp then
    local city = gmcp.Char.Status.city:match("^(%w+)")
    if city then config.set("org", city, true) end
  end
end

-- logic: set relevant conf's to nil, go through a table of specific ones - if one is nil, ask the relevant question for it. inside alias to toggle it, call install again.

install.ask_install_questions = function ()
  if install.installing_system then return end

  install.installing_system = true
  install.check_install_step()
end

install.check_install_step = function()
  for name, tbl in config_dict:iter() do
    if tbl.installcheck and conf[name] == nil then
      echo "\n"
      tbl.installcheck()
      conf_printinstallhint(name)

      if printCmdLine then
        printCmdLine("mmconfig "..name.." ")
      end

      return end
  end

  install.installing_system = false
  signals.gmcpcharskillsinfo:block(install.checkskillgmcp)
  signals.gmcpcharitemslist:block(install.checkinvgmcp)
  signals.gmcpcharskillslist:block(install.checkcombat)
  echo"\n"
  echof("All done installing! Congrats.")
  signals.saveconfig:emit()

  decho(getDefaultColor().."If you'd like, you can also optionally setup the ")
  echoLink("stance / parry", 'mm.sp.setup()', 'stance/parry')
  decho(getDefaultColor().." system and the ")
  echoLink("herb precache", 'mm.showprecache()', 'herb precache')
  decho(getDefaultColor().." system. You can adjust the ")
  echoLink("echo colours", 'mm.config.showcolours()', 'echo colours')
  decho(getDefaultColor().." as well!")
  echo "\n"
  echof("I'd recommend that you at least glimpse through my docs as well so you sort of know what are you doing :)")

  tempTimer(math.random(1,2), function ()
    echo"\n"
    echof("Oh, and one last thing - QQ, restart Mudlet and login again, so all changes can take effect properly.")
  end)
end

function install.checkskillgmcp()
  local t = _G.gmcp.Char.Skills.Info
  if t.skill == "clotting" then t.skill = "clot" end
  if t.skill == "shieldparry" then t.skill = "parry" end

  if t.info == "" then
    conf[t.skill] = false
    echof("Don't have %s, so <250,0,0>won't%s be using it whenever possible.", t.skill, getDefaultColor())
  else
    conf[t.skill] = true
    echof("Have %s, so <0,250,0>will%s be using it whenever possible.", t.skill, getDefaultColor())
  end

  installclear(t.skill)
end
signals.gmcpcharskillsinfo:connect(install.checkskillgmcp)
signals.gmcpcharskillsinfo:block(install.checkskillgmcp)

function install.checkinvgmcp()
  local t = _G.gmcp.Char.Items.List
  if not t.location == "inv" then return end

  -- feh! Easier to hardcode it for such a miniscule amount of items.
  -- If list enlarges, fix appopriately.
  for _, it in pairs(t.items) do
    if it.name == "a Scroll of Healing" then
      config.set("scrollid", it.id, true)
      config.set("scroll", true, true)
    elseif it.name == "an energy cube" then
      config.set("autorecharge", true, true)
    elseif it.name == "a bar of golden soap" then
      config.set("soap", true, true)
    elseif it.name == "a magic tome" then
      config.set("magictome", true, true)
    elseif string.find(it.name, "%f[%a]pipe%f[%A]") then
      if not (it.icon == "lamp" or it.name == "a smoke wreathed pipe" or it.name == "a shimmering, silver bubble pipe") then
        local r = pipe_assignid(it.id)
        if r then echof("Set the %s pipe id to %d.", r, it.id) end
      end
    end
  end


  installclear("scrollid")
  installclear("autorecharge")
  installclear("soap")
end
signals.gmcpcharitemslist:connect(install.checkinvgmcp)
signals.gmcpcharitemslist:block(install.checkinvgmcp)

function install.checkcombat()
  local t = _G.gmcp.Char.Skills.List
  if t.group ~= "combat" then return end

  config.set("stanceskill", "none", false)
	--[[
    for _, k in ipairs{"vitals", "upper", "middle", "lower", "head", "chest", "gut", "arms", "right", "left", "legs"} do
    if contains(t.list, k:title()) then
      config.set("stanceskill", k, false)
      break
    end
	end
	]]--

  installclear("stance")
end
signals.gmcpcharskillslist:connect(install.checkcombat)
signals.gmcpcharskillslist:block(install.checkcombat)

mm_ignore_misc_ext_patch_on()
sendAll("ac mod slushqueue push fire", "ac mod slushqueue push frost", "ac mod slushqueue push frost", false)
