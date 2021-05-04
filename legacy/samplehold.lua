--- sample & hold
-- in1: sampling clock
-- in2: input voltage
-- out1: s&h random
-- out2: s&h input
-- out3: s&h input (quantized chromatically)
-- out4: s&h input+random nudge (quantized chromatically)

function init()
    input[1]{ mode      = 'change'
            , direction = 'rising'
            }
end

input[1].change = function()
    r = math.random() * 10.0 - 5.0
    v = input[2].volts
    output[1].volts = r
    output[2].volts = v
    output[3].volts = math.floor(v*12)/12
    output[4].volts = math.floor(r + v*12)/12
end
