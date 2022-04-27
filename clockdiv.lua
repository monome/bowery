--- clock divider
-- in1: clock input
-- in2: division selector (see divs)
-- out1-4: divided outputs

function newdiv()
  for n=1,4 do
    output[n].clock_div = windows[win_ix][n]
  end
end

-- choose your clock divisions
windows = {
  public{win1 = {5, 7, 11, 13}}:action(newdiv),
  public{win2 = {3, 5, 7 , 11}}:action(newdiv),
  public{win3 = {2, 3, 5 , 7 }}:action(newdiv),
  public{win4 = {2, 4, 8 , 16}}:action(newdiv),
  public{win5 = {4, 8, 16, 32}}:action(newdiv),
}
win_ix = 3

function init()
  input[1].mode('clock',1/4)
  input[2].mode('window', {-3,-1,1,3})
  for n=1,4 do
    output[n]:clock(public.win3[n])
  end
end

input[2].window = function(win, dir)
  win_ix = win
  newdiv(windows[win])
end
