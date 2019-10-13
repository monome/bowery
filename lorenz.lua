-- Lorenz Attractor
-- s wolk 2019.10.13
-- Input 1 resets the attractor to the {x,y,z} coordinates stored in Lorenz.origin.
-- Input 2 controls the speed of the attractor.
-- Output 1 is the x-coordinate (by default)
-- Output 2 is the y-coordinate (by default)
-- Output 3 is the z-coordinate (by default)
-- Output 4 is a weighted sum of x and y (by default)
-- The config table allows you to deactivate the attractor for outputs and take direct control.
-- The weights table allows you to specify the weight of each variable for each output.

config = {'on','on','on','on'}
weights = {{1,0,0},{0,1,0},{0,0,1},{0.33,0.33,0}}
Lorenz = {}
Lorenz.origin = {.01,0,0}
Lorenz.sigma = 10
Lorenz.rho = 28
Lorenz.beta = 8/3
Lorenz.state = {.01,0,0}
Lorenz.steps = 1
Lorenz.dt = 0.001

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

function Lorenz:start()
	self.metro:start()
end

function Lorenz:stop()
	self.metro:stop()
end

function Lorenz:reset()
	for i = 1,3 do self.state[i] = self.origin[i] end
end

Lorenz.metro = metro.init{event = function(c) Lorenz:process() end, count = -1, time = 0.001}

updateEvent = function(c)
	for i=1,4 do
		local sum = 0
		for j=1,3 do
			sum = sum+weights[i][j]*Lorenz.state[j]
		end
		local scaledSum = 10*(sum+25)/80 - 5
		if config[i] == 'on' then output[i].volts = scaledSum end

	end
end

AttractorsMetro = metro.init{event = updateEvent, count = -1, time =0.001}

input[1].change = function(s)
	Lorenz:reset()
end

input[2].stream = function(volts)
	Lorenz.dt = math.exp((volts-1)/3)/1000-0.00005
end

function init()
	Lorenz:reset()
	Lorenz:start()
	AttractorsMetro:start()
	input[1].mode('change', 1,0.1,'rising')
	input[2].mode('stream',0.001)
	print('Lorenz Attractor loaded')
end

