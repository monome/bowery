--- emulating a small subset of Cold Mac

-- bank of functions
-- args: input
-- output: transformed version of input
last_integral = 0
last_input = 0
function clamp(v,min,max)
  return math.max( math.min(v,max), min )
end

myfns =
{ function (v) return v end
, function (v) return -v end
, function (v) return math.ceil(v,0) end
, function (v) return math.floor(v,0) end
, function (v) return math.abs(v) end
, function (v) return v + ((v>0) and -5 or 5) end
, function (v) return 1/v end
, function (v)
    last_integral = clamp( last_integral + 0.01*v, -5, 5 )
    return last_integral
  end
, function (v)
    local out = v - last_input
    last_input = v
    return out
  end
}

function init()
  input[1].mode('stream',0.01)
  for i=1,4 do output[i].slew = 0.01 end
end

input[1].stream = function(v)
  local i = math.ceil(input[2].volts +6)
  output[1].volts = myfns[i](v)
  output[2].volts = myfns[i-3](v)
  output[3].volts = myfns[i-2](v)
  output[4].volts = myfns[i-1](v)
end










function wrap(v)
  return v
  --if v>3 then return v-4
  --elseif v<-2 then return v+3
  --end
end



-- chaos functions (gingerbreadman)
-- cart2pol pol2cart

-- math functions
-- time functions (integrator, differentiator)
last_x = 0.0
last_y = 0
function ginger(v)
  last_x = last_x + v -- CV control
  local x = 1 - last_y + math.abs(last_x)
  local y = last_x
  -- change the algorithm with x & y
  last_x = x
  last_y = y
  -- shape the output without affecting the algo
  return wrap(x), wrap(y)
end


