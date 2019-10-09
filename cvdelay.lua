--- control voltage delay
-- input1: CV to delay
-- input2: 0v = capture, 5v = loop
-- output1-4: delay equaly spaced delay taps

LENGTH = 100 -- sets loop time
-- closer to LENGTH is shorter, closer to 0 is longer
taps = { 1
       , 26
       , 51
       , 76
       }

--private vars
bucket = {}
write = 1
function init()
    input[1].mode( 'stream', 0.01 ) -- 100Hz fastest stable
    for n=1,4 do output[n].slew = 0.01 end
    for n=1,LENGTH do bucket[n] = 0 end
end

input[1].stream = function(v)
    c = input[2].volts / 4.5
    c = (c < 0) and 0 or c
    c = (c > 1) and 1 or c
    bucket[write] = v + c*(bucket[write] - v)
    write = (write % LENGTH) + 1
    for n=1,4 do
        taps[n] = (taps[n] % LENGTH) + 1
        output[n].volts = bucket[math.floor(taps[n])]
    end
end
