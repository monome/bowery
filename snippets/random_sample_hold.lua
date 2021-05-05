--- random sample & hold
-- in1: clock pulse
-- out1: random voltage updated on each clock pulse

function random_volts()
    -- generate a random voltage between 0 and 1
    r = math.random()

    -- increase range from (0 .. 1) up to (0 .. 10)
    rr = r * 10

    -- shift range downward to centre around 0V
    rrr = rr - 5

    -- set output[1] to the random voltage (-5V .. +5V)
    output[1].volts = rrr
end

function init()
    -- turn on 'change' mode for input 1
    input[1].mode('change')

    -- assign input[1]'s 'change' handler
    -- the function random_volts will be called on each input pulse
    input[1].change = random_volts
end



--- simplified form
-- note how input[1].mode is called without parens. this is standard lua syntax for string literal fn args
-- second we inline random_volts by using an anonymous function
function init()
    input[1].mode 'change'
    input[1].change = function() output[1].volts = math.random() * 10 - 5 end
end
