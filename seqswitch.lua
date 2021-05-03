--- sequential switch
-- in1: signal
-- in2: switch
-- out1-4: i1 sent through sequentially

-- user settings
hold       = true -- when switch closes, should hold last value?
samplerate = 0.05 -- 1ms

-- private
dest = 1

function init()
    input[1]{ mode = 'stream'
            , time = samplerate
            }
    input[2]{ mode = 'change'
            , direction = 'rising'
            }
    for n=1,4 do
        output[n].slew = samplerate
        output[n].volts = 0
    end
end

input[1].stream = function(v)
    output[dest].volts = v
end

input[2].change = function()
    old = dest
    dest = (dest % 4)+1 -- rotate channel
    if not hold then output[old].volts = 0 end
end
