# CubiPlayer

CubiPlayer is [MineOS](https://github.com/IgorTimofeev/MineOS/) library that provides non-blocking playing queue for OpenFM radio and convenient interface to interract with it.

# API
## Constructor
### CubiPlayer.**player**( radio )
| Type | Parameter | Description |
| ------ | ------ | ------ |
| *component* | radio | OpenFM radio component from **Component** library |

## Structures

### **track**
| Type | Parameter | Description |
| ------ | ------ | ------ |
| *string* | name | Name of the track |
| *string* | url | Direct url to audio stream/file that OpenFM supports |
| *int* | duration | Duration of the track in seconds |
### *Example:*
```lua
local track = {
  ["name"]     = "Whales & ggnoaa - Paranoia",
  ["url"]      = "https://api-2.datmusic.xyz/dl/d831d992/bf3e8e7c",
  ["duration"] = 185
}
```


## Methods
### player:**getQueue**()
#### *Returns table with all tracks in queue*


### player:**getCurrent**()
#### *Returns track that currently playing*


### player:**addTrack**( track )
| Type | Parameter | Description |
| ------ | ------ | ------ |
| *table* | track | Track object to add in queue |
#### *Adds new track to end of queue*


### player:**removeTrack**( index )
| Type | Parameter | Description |
| ------ | ------ | ------ |
| *int* | index | Track index in queue to delete |
#### *Removes track with specified index from queue*


### player:**shiftTrack**()
#### *Shifts first track from queue*


### player:**setVol**( volume )
| Type | Parameter | Description |
| ------ | ------ | ------ |
| *int* | volume | Value of volume to set on OpenFM radio |
#### *Sets OpenFM radio volume to specified value*


### player:**play**()
#### *Starts playback*


### player:**pause**()
#### *Pauses playback*


### player:**stop**()
#### *Stop playback, removes all tracks from queue, stops polling event*


### player:**prev**()
#### *Go to previous track in queue*



### player:**next**()
#### *Go to next track in queue*


## Events


### player.**onNextTrack**
#### *Calls when CubiPlayer starts play next track*


### player.**onTrackEnds**
#### *Calls when track is over*


### player.**onEnd**
#### *Calls when queue is over, or called player:stop()*


# Practical Example
```lua
local GUI = require("GUI")
local component = require("Component")
local cp = require("CubiPlayer")

-- Check if radio connected
if not component.isAvailable("openfm_radio") then
	GUI.alert("This program requires an OpenFM Radio")
	return
end

-- Create new player instance
local player = cp.player(component.openfm_radio)

-- Set callback function on event that calls when player stops
player.onEnd = function()
  GUI.alert("Playing queue is over!")
  return
end

-- Create track objects
local track1 = {
  ["name"]     = "Whales & ggnoaa - Paranoia",
  ["url"]      = "https://api-2.datmusic.xyz/dl/d831d992/bf3e8e7c",
  ["duration"] = 185
}

local track2 = {
  ["name"]     = "Kobaryo - Galaxy Friends",
  ["url"]      = "https://api-2.datmusic.xyz/dl/bd9b3ea5/c4730495",
  ["duration"] = 240
}

-- Add tracks to playing queue
player:addTrack(track1)
player:addTrack(track2)

-- Start playback
player:play()
```
