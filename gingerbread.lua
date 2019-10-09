--- gingerbread man chaotic attractor
-- input1: clock
-- output1: X
-- output2: Y

function init()
    -- startup things
    input[1]{ mode      = 'change'
            , direction = 'rising'
            }
    output[1].slew = 0
    output[2].slew = 0
end

-- two instances
gs = { {x=0,y=0}
     , {x=0,y=0}
     }
input[1].change = function()
    for n=1,2 do
        x1 = gs[n].x
        if n==1 then
            x1 = x1 + input[2].volts
        else
            gs[n].y = gs[n].y + input[2].volts
        end
        gs[n].x = 0.5 - gs[n].y + math.abs(x1)
        gs[n].y = x1
        if gs[n].x > 5 then gs[n].x = 5.0 end
        if gs[n].y > 5 then gs[n].y = 5.0 end
        output[n*2-1].volts = gs[n].x
        output[n*2].volts = gs[n].y
    end
end
