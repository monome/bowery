--- napsack: sketchaide
-- engine: w/tape
-- 

LAYERS = 32
LOOPS = 8
SPEEDS = {1/1, 2/3, 3/4, 4/3, 9/8, 11/16}
PULSES = 32
TEMPO = 140

origin = 0
loop = -1
sa = {}
loopsec = 1 -- seconds per loop
layer = 1

function next_loop()
    loop = loop + 1
    if loop == LOOPS then
        ii.wtape.record(0)
        ii.wtape.play(0)
        sa:stop()
        ii.wtape.timestamp(origin) -- return to start!
        -- TERMINATES SESSION
    else
        print("loop: "..loop+1)
        -- TODO randomize speed
        ii.wtape.speed(1)
        sa.time = loopsec / PULSES
    end
end

function next_layer()
    layer = layer + 1
    print(" layer: "..layer%LAYERS)
    if layer % LAYERS == 0 then
        next_loop()
    else
        ii.wtape.timestamp(origin + loop * loopsec)
    end
end

function next_step(c)
    if c % PULSES == 0 then next_layer() end
    output[1]()
end

function init()
    ii.wtape.get 'timestamp'
    sa = metro.init()
    sa.event = next_step 
    output[1].action = pulse()

    loopsec = PULSES * 60 / (4*TEMPO)
    print('total session time: '..loopsec*LAYERS*LOOPS/60 ..'mins')
end

ii.wtape.event = function(e, v)
    if e.name == 'timestamp' then
        origin = v
        ii.wtape.loop_active(0)
        ii.wtape.play(1)
        ii.wtape.record(1)
        next_loop()
        sa:start()
    end
end
