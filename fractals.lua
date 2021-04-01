--- fractals. an exploration of tempo-modulated delay lines

ii.wdel.feedback(4.7)
d = ii.wdel

function init()
    d.rate(0.5)
    d.time(0.01)
    d.mod_amount(0)
    d.mix(5)
    d.lowpass(3)

    output[2].action = ar(0.01,3)
    --output[1].scale( {0,7} )
    --output[1].volts = -2
    --output[1]( loop{ to( 2, 3 )
    --               , to( -2, 0 )
    --               })

    metro[1].time = 0.2
    metro[1].event = next_note
    metro[1]:start()

    metro[2].time = 0.2
    metro[2].event = sequence
    metro[2]:start()
end

--sk = {0,2,4,6,7,9,11}
sk = {0,2,4}
--sk = {-24,6,2}
skix = 1
nshift = 0
function next_note(c)
    d.freq( (nshift + sk[skix])/12 )
    skix = (skix % #sk) +1
end

function play(tet,amp)
    nshift = tet
    output[1].volts = tet/12
    output[2]()
end

cq =
{ 0
, ''
, ''
, 6
, ''
, -12
, ''
, ''
}
cqix = 1
function sequence()
    local cc = cq[cqix]
    if type(cc) == 'number' then
        play(cc)
    end
    cqix = cqix % #cq +1
end
