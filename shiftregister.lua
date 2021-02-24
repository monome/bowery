--- digital analog shift register
-- four stages of delay for an incoming cv
-- in1: cv to delay
-- in2: trigger to capture input & shift
-- out1-4: newest to oldest output
-- ii: 6 stages of ASR via just friends

reg = {}
reg_LEN = 4

q = {}
function init()
    for n=1,4 do
        output[n].slew = 0
    end
    input[1].mode('none')
    input[2]{ mode      = 'change'
            , direction = 'rising'
            }
    for i=1,reg_LEN do
        reg[i] = input[1].volts
    end
    ii.jf.mode(1)
    metro[1].event = iiseq
    metro[1].time  = 0.005
    metro[1]:start()
end

-- hack to allow 6note polyphony by staggering with metro
function iiseq()
    if #q > 0 then
        ii.jf.play_note(table.remove(q),2)
    end
end

function update(r)
    for n=1,4 do
        output[n].volts = r[n]
    end
    for n=1,6 do
        table.insert(q, r[n]) -- queue a note for i2c transmission
    end
end

input[2].change = function()
    capture = input[1].volts
    table.remove(reg)
    table.insert(reg, 1, input[1].volts)
    update(reg)
end
