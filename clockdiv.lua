--- clock divider
-- in1: clock input
-- in2: division selector (see divs)
-- out1-4: divided outputs

function newdiv(tab)
  for n=1,4 do
    output[n].clock_div = tab[n]
  end
end

-- choose your clock divisions
public.add('win1', {5,7,11,13}, newdiv)
public.add('win2', {3,5,7,11}, newdiv)
public.add('win3', {2,3,5,7}, newdiv)
public.add('win4', {2,4,8,16}, newdiv)
public.add('win5', {4,8,16,32}, newdiv)

WINDOWS = {public.win1, public.win2, public.win3, public.win4, public.win5}

function init()
  input[1].mode('clock',1/4)
  input[2].mode('window', {-3,-1,1,3})
  for n=1,4 do
    output[n]:clock(public.win3[n])
  end
end

input[2].window = function(win, dir)
  newdiv(WINDOWS[win])
end
