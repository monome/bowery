--- boids
-- t gill 190925
-- inspired by http://www.vergenet.net/~conrad/boids/pseudocode.html
-- in1: influence center
-- in2: influence acceleration
-- out1-4: slewed voltage

-- params
follow = 0.75 -- input=1, free=0
pull   = 0.5  -- to centre
avoid  = 0.1  -- V threshold
sync   = 1/20 -- dir attraction
limit  = 0.05 -- max volts per timestep

timing = 0.02 -- calc speed

boids = {}
count = 4

-- artificially provide a 'centre-of-mass'
function centring(b,c)
  return (c - b.p) * pull
end

function avoidance(bs,b)
  v = 0
  for n=1,count do
    if bs[n] ~= b then -- ignore self
      d = bs[n].p - b.p
      if math.abs(d) < avoid then
        v = v - d/2
      end
    end
  end
  return v
end

function syncing(bs,b)
  v = 0
  for n=1,count do
    if bs[n] ~= b then -- ignore self
      v = v + bs[n].v
    end
  end
  v = v / (count-1)
  return (v - b.v) * sync
end

function findcentre(bs,c)
  m = 0
  for n=1,count do
    m = m + bs[n].p
  end
  m = m/count
  return m + follow*(c-m)
end

function move( bs, n, c, v )
  mass = findcentre(bs,c)
  b = bs[n]
  v1 = centring(b,mass)
  v2 = avoidance(bs,b)
  v3 = syncing(bs,b)
  b.v = b.v + v1 + v2 + v3
  if b.v > limit then b.v = limit
  elseif b.v < -limit then b.v = -limit end
  b.v = b.v * v
  b.p = b.p + b.v
  return b
end

function draw( b, n, v )
  output[n].slew  = v*1.1
  output[n].volts = b.p
end

-- round-robin calculation
function step(c)
  c = (c % count)+1
  accel = input[2].volts
  draw( boids[c], c, timing )
  boids[c] = move( boids, c, input[1].volts, (accel+5.0)/5.0 )
end

function init_boids()
  local bs = {}
  for n=1,count do
    bs[n] = { p = math.random()*3.0 - 1.0
            , v = 0
            }
  end
  return bs
end

function init()
  boids = init_boids()
  mover = metro.init{ event = step
                    , time  = timing/count
                    , count = -1
                    }
  mover:start()
end
