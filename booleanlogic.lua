--- boolean logic
-- out1: 1 AND 2
-- out2: 1 OR 2
-- out3: 1 XOR 2
-- out4: true on 1rising, false on 2rising

g = {false, false}
flipflop = false
function init()
    for n=1,2 do
        input[n].mode('change')
        g[n] = input[n].volts > 1.0
    end
    for n=1,4 do output[n].slew = 0.001 end
end

function xor(a,b)
    return (a and not b) or (not a and b)
end

function logic( chan, state )
    g[chan] = state
    if state then flipflop = (chan == 1) and true or false end

    output[1].volts = (g[1] and g[2]) and 5 or 0
    output[2].volts = (g[1] or g[2]) and 5 or 0
    output[3].volts = xor( g[1], g[2] ) and 5 or 0
    output[4].volts = flipflop and 5 or 0
end

input[1].change = function(s)
    logic(1,s)
end
input[2].change = function(s)
    logic(2,s)
end
