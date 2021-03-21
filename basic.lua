--- basic.lua

-- public variables
-- public.add('time', 1.1)
public.add('time', 1.1, {0.1,10}, function(v) metro[1].time = v end)
public.add('seq', {1,2,3,4}) -- create a table set
public.seq.select(1) -- enter the table
public.add('level',0,{-5,5,'slider'}, function(v) output[1].volts = v end)
public.add('a',32)
public.add('b',1111)
public.add('c',343)

function init()
  metro[1].time = 1
  metro[1].event = sh
  metro[1]:start()
end

function sh()
  public.level = public.seq.step() -- advance sequence on each step
end

-- public.time = 3.2