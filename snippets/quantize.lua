--- quantize
-- in1: input signal to quantize
-- out1: in1 quantized to my_scale
-- out2: generates a trigger pulse every time a new note occurs

-- my_scale is a global variable, representing our chosen scale
-- the curly braces {} create a table (aka list) of values
-- numbers in the table represent semitones
my_scale = {0,2,4,7,9} -- this is a major pentatonic scale

function new_note(s)
    -- s is a table representing the new quantized note that has occured
    -- the simplest way to use the table is with the .volts key
    -- this gives a voltage that can be sent directly to an output as a voltage
    output[1].volts = s.volts

    -- call output[2]'s assigned action
    -- this will use the 'pulse' function that was assigned in init
    output[2]()
end

function init()
    -- turn on 'scale' mode for input 1
    -- the second argument is a table of 'notes' to quantize to
    input[1].mode('scale', my_scale)

    -- assign input[1]'s 'scale' handler
    -- the function new_note will be called every time a new note occurs
    input[1].scale = new_note

    -- configure output[2] such that when it is called, it will generate a trigger pulse
    output[2].action = pulse()
end



--- REPL interaction
-- to update the scale you must reconfigure the input mode:
-- input[1].mode('scale', {0,3,6,9}) -- set to a diminished7th arpeggio



--- simplified form
function init()
    input[1].mode('scale', {0,2,4,7,9})

    input[1].scale = function(s)
        output[1].volts = s.volts
        output[2]()
    end

    output[2].action = pulse()
end
