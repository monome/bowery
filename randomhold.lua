--- random hold
-- in1: sampling clock
-- out1: random sample

function init()
    input[1].mode('change',1,0.1,'rising')
end

input[1].change = function()
    output[1].volts = math.random() * 10.0 - 5.0
end
