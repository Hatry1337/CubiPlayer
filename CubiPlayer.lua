local system = require("System")
local event = require("Event")
local GUI = require("GUI")
---------------------------------------------------------------------------------------------------


local CubiPlayer = {
  HANDLER_INTERVAL = 1
}


---------------------------------------------------------------------------------------------------

local function tCopy(obj)
  if type(obj) ~= 'table' then return obj end
  local res = {}
  for k, v in pairs(obj) do res[tCopy(k)] = tCopy(v) end
  return res
end


---------------------------------------------------------------------------------------------------

local function playerGetQueue(player)
  return tCopy(player.queue)
end

local function playerGetCurrTrack(player)
  return tCopy(player.current)
end

local function playerAddTrack(player, track)
  table.insert(player.queue, track)
end

local function playerRemoveTrack(player, n)
  player.queue[n] = nil
  local j = 0
  for i = 0, #player.queue do
    if player.queue[i] ~= nil then
      j=j+1
      player.queue[j] = player.queue[i]
    end
  end
  player.queue[j+1] = nil
end

local function playerShiftTrack(player)
  player.queue[1] = nil
  for k, v in pairs(player.queue) do
    player.queue[k] = nil
    player.queue[k - 1] = v
  end
end

local function playerSetVolume(player, volume)
  for i = 1, 9 do
    player.radio.volDown()
  end
  for i = 1, volume do
    player.radio.volUp()
  end
end

local function playerPlay(player)
  if not player.isPlaying and player.bgEvent == nil then
    player.isPlaying = true
    player.started = system.getTime()
    player.bgEvent = event.addHandler(function()
      if player.isPlaying then
        if player.current == nil then
          if player.queue[1] == nil then
            if player.onEnd ~= nil then
              player:onEnd()
            end
            player:stop()
            return
          else
            player.current = player.queue[1]
            player:shiftTrack()
            player.started = system.getTime()
            player.radio.setScreenText(player.current.name)
            player.radio.setURL(player.current.url)
            player.radio.stop()
            player.radio.start()
            if player.onNextTrack ~= nil then
              player:onNextTrack()
            end
          end
        end
        if player.started + player.current.duration <= system.getTime() then
          table.insert(player.previous, tCopy(player.current))
          player.current = nil
          if player.onTrackEnds ~= nil then
              player:onTrackEnds()
          end
        end
      end
    end, CubiPlayer.HANDLER_INTERVAL)
  end
end

local function playerPause(player)
  player.radio.stop()
  player.isPlaying = false
  if player.bgEvent ~= nil then
    event.removeHandler(player.bgEvent)
  end
end

local function playerStop(player)
  if player.bgEvent ~= nil then
    event.removeHandler(player.bgEvent)
  end
  player.radio.stop()
  player.isPlaying = false
  player.current = nil
  player.queue = {}
  player.previous = {}
  if player.onEnd ~= nil then
    player:onEnd()
  end
end

local function playerPrev(player)
  table.insert(player.queue, 1, tCopy(player.current))
  if #player.previous ~= 0 then
    table.insert(player.queue, 1, tCopy(player.previous[#player.previous]))
    player.previous[#player.previous] = nil
  end
  player.current = nil
end

local function playerNext(player)
  table.insert(player.previous, tCopy(player.current))
  player.current = nil
end


function CubiPlayer.player(fm)
  local player = {
    previous = {},
    queue = {},
    isPlaying = false,
    radio = fm
  }
  player.getQueue = playerGetQueue
  player.getCurrent = playerGetCurrTrack
  player.addTrack = playerAddTrack
  player.removeTrack = playerRemoveTrack
  player.shiftTrack = playerShiftTrack
  player.setVol = playerSetVolume
  player.play = playerPlay
  player.pause = playerPause
  player.stop = playerStop
  player.prev = playerPrev
  player.next = playerNext
  return player
end



---------------------------------------------------------------------------------------------------

return CubiPlayer
