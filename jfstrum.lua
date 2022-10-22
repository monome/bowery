---strum sequencer for just friends, w/syn, and crow

s = sequins

a = s{0,3,8,5,12,15,s{19,24,31}}
b = s{1,2,3,-1}
c = s{0,3,8,s{3,5,0,5}}

output[1].slew = .1
output[2].action = ar(1.25,1.5,5)

ii.wsyn.patch(1,1)
ii.wsyn.patch(2,2)

note = function()
    ii.jf.play_note(a()/12, 3)
end

withnote = function()
    ii.wsyn.play_note(a:step(b())()/12, 1)
end

strum = function()
    t = 0.1
    tm = 1.15
    for i=1,9 do
        note()
        clock.sleep(t)
        t = t * tm
    end
end

with = function()
    wt = 0.1
    wtm = 1.2
    for i=1,3 do
        withnote()
        clock.sleep(t)
        t = wt * wtm
    end
end

bass = function()
    output[1].volts = c()/12
    output[2]()
end

rep = function()
    while true do
        clock.run(strum)
        clock.run(with)
        clock.run(bass)
        clock.sleep(5)
    end
end

clock.run(rep)
