--- timeline sequencer
-- aka 'function tracker'

-- out1: pitch
-- out2: volume
-- out3: filter cf

scale = {0,6,11,-12,-1,4,0,0,7,6,4,1}
scaleIX = 1
function next_note()
  local n = scale[scaleIX]/12
  scaleIX = scaleIX%#scale + 1
  return n
end

function make_note()
  output[1].volts = next_note()
  output[2]( ar(0.008, 1) )
end
function shift_pitch()
  output[1].slew = 0.1
  output[1].volts = next_note()
end
function fsweepup_note()
  output[3].slew = 0.5
  output[3].volts = 5
  make_note()
end
function fsweepdown()
  output[3].slew = 2.0
  output[3].volts = 0
end
function wobble_glissando()
  output[3]( lfo() )
  output[1].slew = 0.1
  output[1].volts = next_note()
end
function ratchet3()
  output[2]( times( 3, { to(5,0.07), to(0,0.02) }))
end
function rapid_notes()
  output[1].slew = 0.005
  output[1]( loop{ to( next_note, 0.1 ) } )
end

function init()
  output[3].slew = 2
  ii.jf.mode(1)
  ii.jf.run_mode(1)

  metro[1].time = 1
  metro[1].event = timeline_step
  metro[1]:start()
  timeline_step() -- call instantly
end

-- timeline helpers
function timeline_step()
  timeline[line][2]()                   -- call the action!
  local dur = timeline[line][1]         -- grab current timestamp
  line = line +1                        -- next line
  if not timeline[line] then return end -- stop if at end
  dur = timeline[line][1] - dur         -- compare timestamp delta
  if dur == 0 then                      -- multiple simultaneous timestamps
    timeline_step()                       -- just recurse
  else metro[1].time = dur end            -- or wait until next time
end

line = 1 -- track which line is active

-- time  -- action
timeline =
{ { 0  , function() end } -- start point (do nothing)
, { 0  , make_note }
, { 0.4, fsweepdown }
, { 1.3, fsweepup_note }
, { 1.8, wobble_glissando }
, { 2.1, shift_pitch }
, { 2.4, ratchet3 }
, { 2.7, wobble_glissando }
, { 3.5, rapid_notes }
, { 4.7, wobble_glissando }
, { 5  , function() line = 1 end } -- jump to start
}
