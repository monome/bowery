--- napsack: stretch
-- engine: w/tape
-- granular playback with dynamic tape speed
-- in1: set granulization rate (how long between grains). higher V = faster (more frequent)
-- in2: set speed of motion 
-- out1: sawtooth ramp (0..5V) per grain

timestamp = 0
speed = 1.0 -- introspection for visualization
gt = {} -- 'grain timer'

function gt_step()
    gt.time = math.pow(2, -input[1].volts/3 - 2)
    step_mult = input[2].volts/5
    timestamp = timestamp + gt.time * step_mult
    ii.wtape.timestamp(timestamp)

    output[1]{to(5,gt.time), to(0,0)} -- sawtooth per grain
    output[2]{to(5,gt.time/2,'sine'), to(0,gt.time/2,'sine')} -- hann window function
end

function init()
    ii.wtape.get 'timestamp'
    gt = metro.init()
    gt.event = gt_step 
    gt.time = 0.1
    gt:start()

    -- for future visualization
    bg = metro.init()
    bg.event = function() ii.wtape.get 'speed' end
    bg:start()
end

ii.wtape.event = function(e, v)
    if e.name == 'timestamp' then timestamp = v
    elseif e.name == 'speed' then speed = v end
end
