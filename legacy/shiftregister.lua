--- digital analog shift register
-- four stages of delay for an incoming cv
-- input 1: cv to delay
-- input 2: trigger to capture input & shift
-- output 1-4: newest to oldest output
-- ii: 6 stages of ASR via just friends

-- public params
jf_active = true
jf_velocity = 2

-- global state
reg = {0,0,0,0,0,0}

function init()
    input[2]{ mode      = 'change'
            , direction = 'rising'
            }
    if jf_active then
        ii.jf.mode(1)
    end
end

function update(r)
    for n=1,4 do
        output[n].volts = r[n]
    end
    if jf_active then
        for n=1,6 do
            ii.jf.play_note(r[n], jf_velocity)
        end
    end
end

input[2].change = function()
    table.remove(reg)
    table.insert(reg, 1, input[1].volts) -- insert at start to force rotation
    update(reg)
end
