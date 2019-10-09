--- clock divider
-- in1: clock input
-- in2: division selector (see divs)
-- out1-4: divided outputs

-- choose your clock divisions
divs = { {5,7,11,13} -- -5V
       , {3,5,7,11}
       , {2,3,5,7} -- 0V
       , {2,4,8,16}
       , {4,8,16,32} -- +5V
       }

-- private vars
count = {1,1,1,1}
function init()
    input[1].mode('change')
    input[2].mode('none')
    for n=1,4 do
        output[n].slew = 0.001
    end

end

input[1].change = function(s)
    sel = math.floor(input[2].volts/2 + 3.5)
    if sel > 5 then sel = 5 elseif sel < 1 then sel = 1 end
    if s then
        for n=1,4 do
            count[n] = (count[n] % divs[sel][n])+1
            output[n].volts = count[n] <= (divs[sel][n]/2) and 5 or 0
        end
    end
end
