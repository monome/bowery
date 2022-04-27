--- sequential switch
-- in1: signal
-- in2: switch
-- out1-4: i1 sent through sequentially

-- user settings
public{mode = 'hold'}:options{'hold','zero'} -- when switch closes, should hold last value?

-- private
dest = 1

function init()
  input[1]{ mode = 'stream'
          , time = 0.001
          }
  input[2]{ mode = 'change'
          , direction = 'rising'
          }
  for n=1,4 do
    output[n].slew = 0.001 -- interpolate at the stream rate
  end
end

input[1].stream = function(v)
  output[dest].volts = v
end

input[2].change = function()
  if public.mode == 'zero' then output[dest].volts = 0 end
  dest = (dest % 4)+1 -- rotate channel
end
