--- analog shift register
-- in1: clock input
-- in2: signal to be sampled
-- out1-4: 4 most recent sampled values

-- this is a table where we store the most recent sampled values
-- initialize it to 0V for all 4 channels
register = {0,0,0,0}

function shift_reg()
    -- before we read in the new value, we output the currently stored values
    -- 'for' will iterate over all values between 1 and 4
    -- each time the for loop repeats, the value 'n' will be set to the iteration number
    for n=1,4 do
        -- this line will be called 4 times, with n set to 1, then 2, then 3, then 4
        -- we grab the nth element of the 'register' table, and set the nth output to that voltage
        output[n].volts = register[n]
    end

    -- now we rotate the shift-register and insert the new value
    -- table.remove will drop the last element of the table (the oldest value)
    table.remove(register)

    -- now we insert the current value of input[2]
    -- the 2nd argument '1' means that the new value will be put on the front of the list
    -- this causes all other values to be 'pushed' down the line
    table.insert(register, 1, input[2].volts)
end

function init()
    -- configure input1 into 'change' mode
    -- the 2nd & 3rd arguments are 'threshold' and 'hysteresis', both of which are default values
    -- the last argument 'rising' means the .change event will only occur when input1 rises
    -- using 'rising' is typical when the input is a trigger, while 'both' is used for gates
    input[1].mode('change', 1.0, 0.1, 'rising')

    -- every time a rising-edge is detected on input1, shift_reg will be called
    input[1].change = shift_reg
end



--- simplified form
-- in lua, if calling a function with a single table argument, you can omit the surrounding parens
-- calling input[1] with a literal table allows setting the 'mode' with named variables
reg = {0,0,0,0}
function init()
    input[1]{ mode = 'change', direction = 'rising' }
    input[1].change = function()
        for n=1,4 do output[n].volts = reg[n] end
        table.remove(reg)
        table.insert(reg, 1, input[2].volts)
    end
end
