--- transpose
-- in1: input signal to transpose
-- out1: in1 transposed by 2 octaves

-- this is a global variable, representing our transposition amount
-- the number '2' means 2V in crow, which will translate to 2 octaves
-- try changing it from the druid REPL
transpose = 2

-- note the argument 'v' which will represent input[1]'s voltage
function transpose_in1_to_out1(v)
    -- transposing is as simple as adding the 'transpose' value to our input voltage
    -- note how we store the result of the addition back into v, overwriting it's value
    v = v + transpose

    -- apply the transposed voltage to output1
    output[1].volts = v
end

function init()
    -- turn on 'stream' mode for input 1
    -- 0.001 sets the sample-rate of the input. 0.001s is 1ms or 1kHz
    -- this is the fastest supported stream rate 
    input[1].mode('stream', 0.001)

    -- assign input[1]'s 'stream' handler
    -- the function transpose_in1_to_out1 will be called every sample
    input[1].stream = transpose_in1_to_out1
end



--- REPL interaction
-- the transpose amount can be changed by updating the 'transpose' variable
-- transpose = 1 -- set to 1V up
-- transpose = -1 -- set to 1V down
-- transpose = 3/12 -- transpose up by 3 semitones (note: an octave is 12 semitones)



--- simplified form
function init()
    input[1].mode('stream', 0.001)
    input[1].stream = function(v) output[1].volts = v + transpose end
end
