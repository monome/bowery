--- gingerbread man chaotic attractor
-- input1: clock
-- input2: offset
-- output1: X1
-- output2: Y1
-- output3: X2
-- output4: Y2

-- TODO view in x-y mode
function init()
  input[1]{ mode      = 'change'
          , direction = 'rising'
          }
end

-- two instances
gs = { {x=0,y=0}
     , {x=0,y=0}
     }

function make_bread(g, xoff, yoff)
  local x1 = g.x
  g.x = 0.5 - g.y + math.abs(x1) + xoff
  g.y = x1 + yoff
  if g.x > 5 then g.x = 5.0 end
  if g.y > 5 then g.y = 5.0 end
end

input[1].change = function()
  make_bread(gs[1], input[2].volts, 0)
  make_bread(gs[2], 0, input[2].volts)
  for n=1,2 do
    output[n*2-1].volts = gs[n].x
    output[n*2].volts = gs[n].y
  end
end
