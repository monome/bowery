--- gingerbread man chaotic attractor
-- input1: clock
-- input2: offset
-- output1: X
-- output2: Y

function init()
    input[1]{ mode      = 'change'
            , direction = 'rising'
            }
end

-- two instances
gs = { {x=0,y=0}
     , {x=0,y=0}
     }

function make_bread(g, n)
    if n==1 then
        g.x = g.x + input[2].volts
    else
        g.y = g.y + input[2].volts
    end
    local x1 = g.x
    g.x = 0.5 - g.y + math.abs(x1)
    g.y = x1
    if g.x > 5 then g.x = 5.0 end
    if g.y > 5 then g.y = 5.0 end
end

input[1].change = function()
    for n=1,2 do
        make_bread(gs[n], n)
        output[n*2-1].volts = gs[n].x
        output[n*2].volts = gs[n].y
    end
end
