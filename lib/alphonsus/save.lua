--[[
Save — persist Lua tables to the LÖVE save directory (uses lume serialize).

Setup (main.lua):
  Save = require("lib.alphonsus.save")

Load or create on first run:
  local data = Save.read()
  if data and data.text then
      self.text = data.text
  else
      self.text = "hello world"
      Save.write({ text = self.text })
  end

Other helpers:
  Save.delete()  -- remove save file
  Save.path()    -- full path, e.g. for debugging
  Save.filename  -- default: "save.dat"
]]

local Save = {}

Save.filename = "save.dat"

function Save.write(data)
    return love.filesystem.write(Save.filename, "return " .. _.serialize(data))
end

function Save.read()
    if not love.filesystem.getInfo(Save.filename) then
        return nil
    end

    local chunk, loadErr = love.filesystem.load(Save.filename)
    if not chunk then
        return nil, loadErr
    end

    local ok, result = pcall(chunk)
    if not ok then
        return nil, result
    end

    return result
end

function Save.delete()
    if love.filesystem.getInfo(Save.filename) then
        return love.filesystem.remove(Save.filename)
    end
    return true
end

function Save.path()
    return love.filesystem.getSaveDirectory() .. "/" .. Save.filename
end

return Save
