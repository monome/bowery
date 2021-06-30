--- lorenz attractor
-- sam wolk 2019.10.13
-- in1 resets the attractor to the {x,y,z} coordinates stored in the Lorenz.origin table
-- in2 controls the speed of the attractor
-- out1 is the x-coordinate (by default)
-- out2 is the y-coordinate (by default)
-- out3 is the z-coordinate (by default)
-- out4 is a weighted sum of x and y (by default)
-- the weights table allows you to specify the weight of each axis for each output.

weights = {{1,0,0}, {0,1,0}, {0,0,1}, {0.33,0.33,0}}

Lorenz = {
  origin = {.01,0,0},
  sigma = 10,
  rho = 28,
  beta = 8/3,
  state = {.01,0,0},
  steps = 1,
  dt = 0.001,
}

function Lorenz:process(steps,dt)
  steps = steps or self.steps
  dt = dt or self.dt
  for i=1,steps do
    local dx = self.sigma*(self.state[2]-self.state[1])
    local dy = self.state[1]*(self.rho-self.state[3])-self.state[2]
    local dz = self.state[1]*self.state[2]-self.beta*self.state[3]
    self.state[1] = self.state[1]+dx*dt
    self.state[2] = self.state[2]+dy*dt
    self.state[3] = self.state[3]+dz*dt
  end
end

function Lorenz:reset()
  for i=1,3 do self.state[i] = self.origin[i] end
end

updateOutputs = function()
  for i=1,4 do
    local sum = 0
    for j=1,3 do
      sum = sum+weights[i][j]*Lorenz.state[j]
    end
    output[i].volts = 10*(sum+25)/80 - 5
  end
end

input[1].change = function(s)
  Lorenz:reset()
end

input[2].stream = function(volts)
  Lorenz.dt = math.exp((volts-1)/3)/1000-0.00005
end

function init()
  Lorenz:reset()
  input[1].mode('change', 1,0.1,'rising')
  input[2].mode('stream',0.001)
  clock.run( function()
    while true do
      Lorenz:process()
      updateOutputs()
      clock.sleep(0.001)
    end
  end)
end

