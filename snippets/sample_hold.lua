--- sample & hold
-- in1: clock pulse
-- in2: input voltage to sample
-- out1: input2 voltage sampled on each input1 pulse

function in2_to_out1()
    output[1].volts = input[2].volts
end

function init()
    -- turn on 'change' mode for input 1
    input[1].mode('change')

    -- assign input[1]'s 'change' handler
    -- the function in1_to_out1 will be called on each input pulse
    input[1].change = in2_to_out1
end



--- simplified form
-- note how input[1].mode is called without parens. this is standard lua syntax for string literal fn args
-- second we inline in2_to_out1 to set the .change event directly
function init()
    input[1].mode 'change'
    input[1].change = function() output[1].volts = input[2].volts end
end
