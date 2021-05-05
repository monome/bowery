--- clock divider
-- in1: input clock
-- out1: clock divided output

function init()
    -- set input1 to clock mode to drive the internal 'clock' system
    -- the second argument '1' means that each trigger pulse equals 1 beat
    input[1].mode('clock', 1)

    -- set output1 to clock output mode
    -- the argument '4' will output a clock pulse once every 4 beats
    -- note: this value can be a fraction (eg 1/4) to set the output clock faster than input
    -- the ':' represents a 'method' call. for now just remember that clock needs this
    output[1]:clock(4)
end


--- REPL interaction
-- update the output clock-division by setting the output's .clock_div key
-- output[1].clock_div = 1/4


--- simplified form
function init()
    input[1].mode('clock', 1)
    output[1]:clock(4)
end
