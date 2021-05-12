--- boids
-- t gill 190925
-- inspired by http://www.vergenet.net/~conrad/boids/pseudocode.html
-- in1: influence center
-- in2: influence acceleration
-- out1-4: slewed voltage

-- TODO refine ranges & apply 'expo' where appropriate
public{follow = 0.75}:range(0, 1) -- input=1, free=0. influence of input[1] over centre of mass
public{pull = 0.5}:range(0, 1)  -- pull boids toward their centre of mass
public{avoid = 0.1}:range(0, 1)  -- voltage difference under which boids repel
public{sync = 1/20}:range(0, 1) -- amount by which boids copy each other's direction
public{limit = 0.05}:range(0, 0.3) -- limit boids instantaneous movement to reduce over-correction
public{timing = 0.02}:xrange(0.001, 0.2) -- timestep for simulation
  :action(function(v) for n=1,4 do output[n].slew = v*2 end end) -- calc speed TODO use Hz not seconds?

boids = {}
COUNT = 4 -- only first 4 are output

-- artificially provide a 'centre-of-mass'
function centring(b,c)
  return (c - b.p) * public.pull
end

function avoidance(bs,b)
  local v = 0
  for n=1,COUNT do
    if bs[n] ~= b then -- ignore self
      local d = bs[n].p - b.p
      if math.abs(d) < public.avoid then
        v = v - d/2
      end
    end
  end
  return v
end

function syncing(bs,b)
  local v = 0
  for n=1,COUNT do
    if bs[n] ~= b then -- ignore self
      v = v + bs[n].v
    end
  end
  v = v / (COUNT-1)
  return (v - b.v) * public.sync
end

function findcentre(bs,c)
  local m = 0
  for n=1,COUNT do
    m = m + bs[n].p
  end
  m = m/COUNT
  return m + public.follow*(c-m)
end

function move( bs, n, c, v )
  local b = bs[n]
  b.v = b.v + centring(b, findcentre(bs, c))
            + avoidance(bs, b)
            + syncing(bs, b)
  if b.v > public.limit then b.v = public.limit
  elseif b.v < -public.limit then b.v = -public.limit end
  b.v = b.v * v
  b.p = b.p + b.v
  return b
end

function init_boids()
  local bs = {}
  for n=1,COUNT do
    bs[n] = { p = math.random()*3.0 - 1.0
            , v = 0
            }
  end
  return bs
end

function boids_run(c)
  local boids = init_boids()
  local c = 0
  while true do
    c = (c % COUNT)+1 -- round-robin calculation
    boids[c] = move( boids, c, input[1].volts, (input[2].volts+5.0)/5.0 )
    if c <= 4 then output[c].volts = boids[c].p end -- apply updated voltage to output
    clock.sleep(public.timing / COUNT) -- TODO try sleep(0) for maximum speed?
  end
end

function init()
  for n=1,4 do public.view.output[n]() end -- visualize location of all 4 boids 
  clock.run(boids_run)
end
