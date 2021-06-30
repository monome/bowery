--- wsyn example sequencer

w = ii.wsyn

function init()
    metro[1].event = notes
    metro[1].time = 0.3
    metro[1]:start()
    metro[2].event = inotes
    metro[2].time = 0.37
    metro[2]:start()

    w.ar_mode(1)
    w.fm_index(0.0)
    w.fm_ratio(3,2)
    w.fm_env(0)
    w.patch(3,0)
    w.ramp(0)
    w.curve(1)
    w.lpg_time(-3)

    output[2].action = { to(5,0), to(5,0.02), to(0,0) }
end

-- some scales
FLAT = {-10,3,10,14,20}
TH   = {-12,4,11,14,21}
THUN = {-12,4,6,14,23}
CHOO = {-5,6,17,18}

nns = TH -- assign a scale

octave = 0
cycle = 1
which = 1
WHICH_LEN = #nns
function notes()
    for n=1,1 do -- play 2 notes at once
        which = (which+1) % #nns + 1
        --which = which % #nns; which = which + 1
        --ii.wsyn.play_note(nns[which]/12,0.5)
        note = -2 + octave + nns[which]/12
        output[1].volts = note
        output[3].volts = note
        output[2]()
    end
    cycle = cycle + 1
    if cycle > 13 then
        cycle = 1
        octave = 1-octave
    end
end

function inotes()
    which = (which+3) % #nns + 1
    output[1].volts = nns[which]/12 -1
    output[2]()

    for n=1,2 do -- play 2 notes at once
        --which = (which+3) % #nns + 1
        --ii.wsyn.play_note(0,0.5)
    end
end
