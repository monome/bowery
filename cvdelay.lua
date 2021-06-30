--- control voltage delay
-- input1: CV to delay
-- input2: 0v = capture, 5v = loop (continuous)
-- output1-4: delay equaly spaced delay taps

LENGTH = 1000 -- max loop time. MUST BE CONSTANT

public.add('tap1', 250, {1,LENGTH,'slider'})
public.add('tap2', 500, {1,LENGTH,'slider'})
public.add('tap3', 750, {1,LENGTH,'slider'})
public.add('tap4', LENGTH, {1,LENGTH,'slider'})
public.add('loop', 0.0, {0,1,'slider'})

bucket = {}
write = 1
cv_mode = 0

function init()
    input[1].mode('stream', 0.001) -- 1kHz
    for n=1,4 do output[n].slew = 0.002 end -- smoothing at nyquist
    for n=1,LENGTH do bucket[n] = 0 end -- clear the buffer
end

function peek(tap)
    local ix = (math.floor(write - tap - 1) % LENGTH) + 1
    return bucket[ix]
end

function poke(v, ix)
    local c = (input[2].volts / 4.5) + public.loop
    c = (c < 0) and 0 or c
    c = (c > 1) and 1 or c
    bucket[ix] = v + c*(bucket[ix] - v)
end

input[1].stream = function(v)
    output[1].volts = peek(public.tap1)
    output[2].volts = peek(public.tap2)
    output[3].volts = peek(public.tap3)
    output[4].volts = peek(public.tap4)
    poke(v, write)
    write = (write % LENGTH) + 1
end
