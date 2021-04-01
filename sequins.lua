--- sequins module idea

-- quantize input into n-steps
-- define / construct / select a sequence (scale/arpeggio)
-- output is an indexed element of sequence, plus an octave remainder

-- index & octave are created from quantized input & step controls
-- input.ix + input.octave * octave_skip
-- where octave_skip is an offset of n-steps to apply once per octave (default 0, can be negative)

-- step increments the index by n-steps, wrapping to the octave, and discarding remainder
-- thus it cycles through the sequence before repeating.
-- n could be set by a random source, which is sampled on each 'step' trigger
-- if this randomness is attenuated it can perform a 'drunk walk'
-- if this randomness is added to an offset, it can 'drunk walk' in a direction

-- output adds these quant.ix and step.ix elements together, with a wrap, accumulating into octave
-- output[2] & [3] pulse when the sequence rolls over down/up respectively

--- tested and sounding nice, but is super dependent on the content of skal.
-- next is obviously the interface for configuring skal with the interval based builder
-- there is a clear 'melody folding' action happening, but should try the reducing-range style of mangrove

skal = {0,2,4,7,9}
quantskip = 0 -- integer steps per octave
stepn = 1

function init()
    input[1].mode('scale',skal)
    input[2].mode('change',1,0.1,'rising')
end

quantix = 0
quantoct = 0
input[1].scale = function(s)
    quantoct = s.octave
    -- TODO check if it's 1-based?
    quantix = s.index + (s.octave * quantskip)
    apply()
end

stepix = 0
input[2].change = function()
    stepix = stepix + stepn
    while stepix < 0 do
        stepix = stepix + #skal
        output[2](pulse())
    end
    while stepix >= #skal do
        stepix = stepix - #skal
        output[3](pulse())
    end
    apply()
end

function apply()
    local ix = stepix + quantix
    local oct = quantoct

    while ix < 0 do
        ix = ix + #skal
        oct = oct - 1
    end
    while ix >= #skal do
        ix = ix - #skal
        oct = oct + 1
    end

    output[1].volts = oct + skal[ix+1]/12
    output[4](ar())
end
