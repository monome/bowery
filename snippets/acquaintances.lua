--- just friends for crow

-- in1: frequency
-- in2: intone
-- out1-4: lfos


iratio = {1,3,5,7} -- harmonic indices for intone control
SHAPE = 'sine' -- waveshape of oscillators
offset = 0 -- octave offset of frequency. 0 means 0V = 1second

function init()
    input[1].mode('stream',0.001)
    input[1].stream = update_speeds
    for n=1,4 do
        output[n]( lfo( dyn{freq=1}, 5, SHAPE )) -- start all at 1hz, immediately updated by stream
    end
end

function update_speeds(v)
    local freq = math.exp(2, -(v+offset))
    local intone = math.min(5, math.max(-5, input[2].volts / 5))
    if intone >= 0 then
        for n=1,4 do
            output[n].dyn.freq = freq/(1 + intone*(iratio[n]-1))
        end
    else
        for n=1,4 do
            output[n].dyn.freq = freq*(1 - intone*(iratio[n]-1))
        end
    end
end
