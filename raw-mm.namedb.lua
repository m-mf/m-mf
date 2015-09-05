-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

pl.dir.makepath(getMudletHomeDir() .. "/m&m/namedb")

-- load the highlightignore list
signals.systemstart:connect(function ()
  local conf_path = getMudletHomeDir() .. "/m&m/config/highlightignore"

  if lfs.attributes(conf_path) then
    local t = {}
    local ok, msg = pcall(table.load, conf_path, t)
    if ok then
	    me.highlightignore = me.highlightignore or {} -- make sure it's initialized
	    update(me.highlightignore, t)
	else
		os.remove(conf_path)
		tempTimer(10, function()
		  echof("Your NameDB highlights ignored file got corrupted for some reason - I've deleted it so the system can load other stuff OK. You'll need to re-do all the names to ignore highlighting, though. (%q)", msg)
		end)
	end
  end
end)
signals.saveconfig:connect(function () me.highlightignore = me.highlightignore or {}; table.save(getMudletHomeDir() .. "/m&m/config/highlightignore", me.highlightignore) end)


-- save the ndb.conf.orgpolitics list
signals.saveconfig:connect(function () ndb.conf.orgpolitics = ndb.conf.orgpolitics or {}; table.save(getMudletHomeDir() .. "/m&m/namedb/orgpolitics", ndb.conf.orgpolitics) end)

signals.saveconfig:connect(function () db.__conn["namedb"]:execute("VACUUM") end)
