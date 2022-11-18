---alphabet sequencer
--start playback for outputs 1-4 with start_playing() 
--start playback on just friends with start_jf() 
--start playback on w/syn with start_with() 
--or start eveything at once with start_everything() 
--stop playback on outputs 1-4 with stop_playing() 
--stop playback on just friends with stop_jf() 
--stop playback on w/syn with stop_with
--or stop everything at once with stop_everything()
--try updating the sequins!
--see comments below for which sequins do what
s = sequins
a = s{4, 6, 4, s{6, 8, 1, 11}} -- voice 1 pitch
b = s{2, 2, 2, 2, 2, 2} -- voice 1 timing
c = s{4, 1, 6, 1, 6} -- voice 2 pitch
d = s{2, 2, 2, 2, 2, 2} -- voice 2 timing
e = s{4, 6, 4, s{11, 1, 8}} -- just friends voice 1 pitch
f = s{1/16, 1/16, 1/4, 1/4} -- just friends voice 1 timing
g = s{2, 3, 2, 2, 3, 2, 3} -- just friends voice 1 level
h = s{4, 6, 4, s{8, 1, 11}} -- just friends voice 2 pitch
i = s{1/4, 1/4, 1/8, 1/16} -- just friends voice 2 timing
j = s{2, 2, 3, 2, 2, 3, 2} -- just friends voice 2 level
k = s{6, 4, 6, 11, 8, 11} -- just friends voice 3 pitch
l = s{1/2, 1/4, 1/2, 1/16} -- just friends voice 3 timing
m = s{2, 3, 2, 2, 3, 3, 2} -- just friends voice 3 level
x = s{4, 6, 1, s{11, 6, 11, 8, 6, 11, 8, 6}} -- w/syn pitch
y = s{1/2, 1/2, 2, 1.5, 1/2} -- w/syn timing
z = s{2, 2, 3, 2, 2, 3, 2, 2} -- w/syn level
function init()
  input[1].mode('clock')
  bpm = clock.tempo  
  ii.jf.mode(1)
  ii.jf.run_mode(1)
  ii.jf.tick(bpm)
  ii.wsyn.ar_mode(1)
  ii.wsyn.voices(4)   
end
function start_playing()
  coro_1 = clock.run(notes_event)
  coro_2 = clock.run(other_event)
end
function start_jf()
  coro_3 = clock.run(jfa_event)
  coro_4 = clock.run(jfb_event)
  coro_5 = clock.run(jfc_event)
end
function start_with()
  coro_6 = clock.run(with_event)
end
function start_everything()
  coro_1 = clock.run(notes_event)
  coro_2 = clock.run(other_event)
  coro_3 = clock.run(jfa_event)
  coro_4 = clock.run(jfb_event)
  coro_5 = clock.run(jfc_event)
  coro_6 = clock.run(with_event)
end
function stop_playing()
  clock.cancel(coro_1)
  clock.cancel(coro_2)
end
function stop_jf()
  clock.cancel(coro_3)
  clock.cancel(coro_4)
  clock.cancel(coro_5)
end
function stop_with()
  clock.cancel(coro_6)
end
function stop_everything()
  clock.cancel(coro_1)
  clock.cancel(coro_2)
  clock.cancel(coro_3)
  clock.cancel(coro_4)
  clock.cancel(coro_5)
  clock.cancel(coro_6)
end
function notes_event()
  while true do
    clock.sync(b())
    output[1].volts = a()/12
    output[1].slew = .1
    output[2].action = ar(1, 1, 5, 'lin')
    output[2]()
  end
end
function other_event()
  while true do
    clock.sync(d())
    output[3].volts = c()/12
    output[3].slew = .1
    output[4].action = ar(1, 1, 5, 'lin')
    output[4]()
  end
end
function jfa_event()
  while true do
    clock.sync(f())
    ii.jf.play_note(e()/12, g())
  end
end
function jfb_event()
  while true do
    clock.sync(i())
    ii.jf.play_note(h()/12, j())
  end  
end
function jfc_event()
  while true do
    clock.sync(l())
    ii.jf.play_note(k()/12, m())
  end
end
function with_event()
  while true do
    clock.sync(y())
    ii.wsyn.play_note(x()/12, z())
  end
end
