--- digital analog shift register
-- four stages of delay for an incoming cv
-- in1: cv to delay
-- in2: trigger to capture input & shift
-- out1-4: newest to oldest output
-- ii: 6 stages of ASR via just friends

-- public params
public{slew = 0.001}:xrange(0.001, 0.5):action(function(v) for n=1,4 do output[n].slew = v end end)
public{ii_dest = 'none'}:options{'none','jf','wsyn'}
    :action(function(e) if e=='jf' then ii.jf.mode(1) end end) -- enable synthesis mode
public{ii_velo = 2}:range(0.1, 5)

-- global state
reg = {0,0,0,0,0,0}

function make_notes(r)
  for n=1,4 do
    output[n].volts = r[n]
  end
  if public.ii_dest ~= 'none' then
    local count = (public.ii_dest == 'jf') and 6 or 4
    for n=1,count do
      ii[public.ii_dest].play_note(r[n], public.ii_velo)
    end
  end
end

input[2].change = function()
  make_notes(reg) -- send old values first
  table.remove(reg)
  table.insert(reg, 1, input[1].volts) -- insert at start to force rotation
end

function init()
  input[2]{ mode      = 'change'
          , direction = 'rising'
          }
end
