--- mixing
-- in1: signal 1
-- in2: signal 2
-- out1: signal 1 transposed by signal 2

-- note the argument 'v' which will represent input[1]'s voltage
function add_ins_to_out1(v)
    -- here we assign the output 1 voltage to the addition of input 1 and 2
    output[1].volts = v + input[2].volts

    -- note: we could use `input[1].volts` instead of 'v' above
end

function init()
    -- turn on 'stream' mode for input 1
    -- 0.001 sets the sample-rate of the input. 0.001s is 1ms or 1kHz
    -- this is the fastest supported stream rate 
    input[1].mode('stream', 0.001)

    -- assign input[1]'s 'stream' handler
    -- the function add_ins_to_out1 will be called every sample
    input[1].stream = add_ins_to_out1
end



--- simplified form
function init()
    input[1].mode('stream', 0.001)
    input[1].stream = function(v) output[1].volts = v + input[2].volts end
end
