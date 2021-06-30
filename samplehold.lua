--- sample & hold
-- in1: sampling clock
-- in2: input to sample
-- out1: random sample
-- out2: sampled input

function init()
    input[1].mode('change',1,0.1,'rising')
end

input[1].change = function()
    output[1].volts = math.random() * 10.0 - 5.0
    output[2].volts = input[2].volts
end
