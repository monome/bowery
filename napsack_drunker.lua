--- napsack: drunker
-- engine: w/syn

sequence = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
seqix = 1
seqlen = 16
vv = 0

function next_step()
    sequence[seqix] = sequence[seqix] + vv -- store
    ii.wsyn.play_note(quant(sequence[seqix]), 2) -- play previous note on w/syn
    seqix = (seqix % seqlen) + 1 -- rotate right
end

function quant(v)
    return math.floor(v*12 + (1/24)) / 12
end

input[2].stream = function(v)
    if v < 0.2 and v > -0.2 then vv = 0 -- create NULL region around 0V
    else vv = v/5 end -- reduce range to +/-1V
    output[1].volts = quant(sequence[seqix] + vv) -- CV output changes immediately
end

function init()
    input[1].mode('change', 1.0, 0.1, 'rising')
    input[1].change = next_step
    input[2].mode('stream', 0.001)
end
