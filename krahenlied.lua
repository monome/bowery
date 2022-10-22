---krahenlied
--a poetry sequencer for crow, just friends, and w/tape
--input 1: clock
--outputs 1 & 3: v/8
--outputs 2 & 4: AR envelopes
--begin by giving your poem a title in druid using the title function (i.e., typing title followed by your title in quotes), like so:
--title "Christabel"
--this will start the clocks running and create an initial sequence
--continue by updating the sequence in druid by typing text followed by a new line of poetry in quotes — e.g.,
--text "'Tis the middle of night by the castle clock,"
--note: it's probably best to reset crow after using this script and before using another one or using this one again. Not doing so can lead to crashes
  text_string = "aaaaaa"
  function remap(ascii)
    ascii = ascii % 32 + 1
    return ascii
  end
  function processString(s)
    local tempScalar = {}
    for i = 1, #s do
      table.insert(tempScalar,remap(s:byte(i)))
    end
    return tempScalar
  end
  function jfmap(ascii)
    ascii = ascii % 5 + 1
    return ascii
  end
  function jfscaling(j)
    local tempScalar = {}
    for i = 1, #j do
     table.insert(tempScalar,jfmap(j:byte(i)))
    end
    return tempScalar
  end
  s = sequins(processString(text_string))
  j = sequins(jfscaling(text_string))
  function set()
    s:settable(processString(text_string))
    j:settable(jfscaling(text_string))
  end
  function title(str)
    text_string = str
    set()
    coro_id = clock.run(notes_event)
              clock.run(other_event)
              clock.run(jfa_event)
              clock.run(jfb_event)
              clock.run(jfc_event)
              clock.run(jfd_event)
              clock.run(jfe_event)
              clock.run(jff_event)
              clock.run(run_event)
              clock.run(quantize_event)
              clock.run(with_event)
              clock.run(rev_event)
              clock.run(looper)
  end
  function text(str)
    text_string = str
    set()
  end
  function init()
    input[1].mode('clock')
    bpm = clock.tempo  
    ii.jf.mode(1)
    ii.jf.run_mode(1)
    ii.jf.tick(bpm)
    ii.wtape.timestamp(1)
    ii.wtape.freq(0)
    ii.wtape.play(1)
  end
  function notes_event()
    while true do
      clock.sync(s()/s:step(2)())
      output[1].volts = s:step(3)()/12
      output[1].slew = s:step(4)()/300
      output[2].action = ar(s:step(5)()/20, s:step(6)()/20, j:step(7)(), 'linear')
      output[2]()
    end
  end
  function other_event()
    while true do
      clock.sync(s:step(8)()/s:step(9)())
      output[3].volts = s:step(10)()/12
      output[3].slew = s:step(11)()/300
      output[4].action = ar(s:step(12)()/20, s:step(13)()/20, j:step(14)(), 'linear')
      output[4]()
    end
  end
  function jfa_event()
    while true do
      clock.sync(s:step(15)()/s:step(16)())
      ii.jf.play_voice(1, s:step(17)()/12, j:step(18)())
    end
  end
  function jfb_event()
    while true do
      clock.sync(s:step(19)()/s:step(20)())
      ii.jf.play_voice(2, s:step(21)()/12, j:step(22)())
    end  
  end
  function jfc_event()
    while true do
      clock.sync(s:step(23)()/s:step(24)())
      ii.jf.play_voice(3, s:step(25)()/12, j:step(26)())
    end
  end
  function jfd_event()
    while true do
      clock.sync(s:step(27)()/s:step(28)())
      ii.jf.play_voice(4, s:step(29)()/12, j:step(30)())
    end
  end
  function jfe_event()
    while true do
      clock.sync(s:step(31)()/s:step(32)())
      ii.jf.play_voice(5, s:step(33)()/12, j:step(34)())
    end
  end
  function jff_event()
    while true do
      clock.sync(s:step(35)()/s:step(36)())
      ii.jf.play_voice(6, s:step(37)()/12, j:step(38)())
    end
  end
  function run_event()
    while true do
      clock.sync(s:step(39)()/s:step(40)())
      ii.jf.run(j:step(41)())
    end
  end
  function quantize_event()
    while true do
      clock.sync(s:step(42)()/s:step(43)())
      ii.jf.quantize(s:step(44)())
    end
  end
  function with_event()
    while true do
      clock.sync(s:step(45)()/s:step(46)())
      ii.wtape.speed(s:step(47)(), s:step(48)())
    end
  end
  function rev_event()
    while true do
      clock.sync(s:step(49)()/s:step(50)())
      ii.wtape.reverse()
    end
  end
  function looper()
    while true do
      clock.sync(s:step(51)()/s:step(52)())
      ii.wtape.loop_start()
      clock.sync(s:step(53)()/s:step(54)())
      ii.wtape.loop_end()
        if s:step(55)() < 17 then
          for i = 1,j:step(56)() do 
            clock.sync(s:step(57)()/s:step(58)())
            ii.wtape.loop_scale(s:step(59)()/s:step(60)())
            for i = 1,j:step(61)() do
              clock.sync(s:step(62)()/s:step(63)())
              ii.wtape.loop_next(s:step(64)()-s:step(65)())
            end 
          end
        elseif s:step(55)() >= 17 then
          for i = 1,j:step(66)() do
            clock.sync(s:step(67)()/s:step(68)())
            ii.wtape.loop_next(s:step(69)()-s:step(70)())
            for i = 1,j:step(71)() do
              clock.sync(s:step(72)()/s:step(73)())
              ii.wtape.loop_scale(s:step(74)()/s:step(75)())
            end
          end
        end
      clock.sync(s:step(76)()/s:step(77)())
      ii.wtape.loop_active(0)
        for i = 1,s:step(78)() do
          clock.sync(s:step(79)()/s:step(80)())
          ii.wtape.seek((s:step(81)()*300)-(s:step(82)()*300))
        end
        for i = 1,j:step(83)() do
          clock.sync(s:step(84)()/s:step(85)())
          ii.wtape.loop_active(1)
          if s:step(86)() < 17 then
            for i = 1,j:step(87)() do 
              clock.sync(s:step(88)()/s:step(89)())
              ii.wtape.loop_scale(s:step(90)()/s:step(91)())
              for i = 1,j:step(92)() do
                clock.sync(s:step(93)()/s:step(94)())
                ii.wtape.loop_next(s:step(95)()-s:step(96)())
              end 
            end
          elseif s:step(86)() >= 17 then
            for i = 1,j:step(97)() do
              clock.sync(s:step(98)()/s:step(99)())
              ii.wtape.loop_next(s:step(100)()-s:step(101)())
              for i = 1,j:step(102)() do
                clock.sync(s:step(103)()/s:step(104)())
                ii.wtape.loop_scale(s:step(105)()/s:step(106)())
              end
            end
          end
          clock.sync(s:step(107)()/s:step(108)())
          ii.wtape.loop_active(0)
          for i = 1,s:step(109)() do
            clock.sync(s:step(110)()/s:step(111)())
            ii.wtape.seek((s:step(112)()*300)-(s:step(113)()*300))
          end
        end
    end
  end
