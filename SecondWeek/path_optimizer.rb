require 'green_shoes'
require 'matrix'

class Route
	attr_reader :length, :nodes
	def initialize(context, from, to)
		@nodes = [from, to]
		from.add_route self
		to.add_route self
		context.strokewidth 3; context.stroke context.black
		@route = context.line @nodes[0].pos[0], @nodes[0].pos[1], @nodes[1].pos[0], @nodes[1].pos[1]
		@length = (@nodes[0].pos - @nodes[1].pos)[0] + (@nodes[0].pos - @nodes[1].pos)[1]

		textX = @nodes[0].pos[0] + (@nodes[1].pos[0] - @nodes[0].pos[0])/2
		textY = @nodes[0].pos[1] + (@nodes[1].pos[1] - @nodes[0].pos[1])/2
		@level = context.para 'sss', width:100, height:20, left:textX, top:textY
		pheromonessssssss = 30
	end
	def pheromone_evaporation()
		pheromonessssssss -= 1
	end
	def pheromonessssssss=(value)
		p 'aaaaaaa'
		@pheromone = value
		@level.text = value
	end
end

class Node
	attr_accessor :node
	attr_reader :radius, :current_status, :routes
	def initialize(context, x, y)
		@status = {normal:context.black, source:context.blue, food:context.red}
		@radius = 10
		@current_status = :normal
		context.nostroke; context.fill @status[@current_status]
		@node = context.oval left:(x-@radius), top:(y-@radius), radius:@radius
		@pos = Vector[x,y]
	end
	def pos()
		@pos
	end
	def pos=(x, y)
		@node.left, @node.top = x - @node.width/2, y - @node.height/2
		@pos = Vector[@node.left+@node.width/2, @node.top+@node.height/2]
	end
	def add_route(route)
		(@routes||=[]) << route
	end
	def pos=(vector)
		pos= vector[0], vector[1]
	end
	def change_status() 
		@current_status = @status.keys.rotate[@status.keys.index(@current_status)]
		@node.style fill:@status[@current_status]
	end
end

class Ant
	attr_accessor :genes
	attr_reader :lost_counter, :food_collected, :target_node
	def initialize(nest, *parents)
		@genes = [rand(11)-5,rand(11)-5,rand(11)-5] #direction_choice, pheromone acceptance, 
		@genes.size.times {|g| @genes[g] = parents[rand(parents.size)].genes[g]} if parents.any?
		mutation if rand(20) == 0

		@food_collected = 0
		@explored_nodes =[]
		@lost_counter = 0
		@current_route = nil
		@nest = nest
		teleport_to_nest
	end
	def on_the_road?()
		!! @current_route
	end
	def walk()
		@distance_remaining -= 10 if @current_route
		if @distance_remaining <= 0 then
			@distance_remaining = 0
			@current_route = nil
		end
	end
	def back_to_nest()
		curr_node = @explored_nodes.pop
		@current_route = curr_node.routes.inject(nil){|r0,r| r.nodes.include? @explored_nodes.last ? r : r0}
		@distance_remaining = next_route.length
		put_pheromone
	end
	def leave_food()
		@have_food = false
		@food_collected += 1
		@explored_nodes =[]
		remember @nest
	end
	def carrying_food?
		@have_food
	end
	def pick_food()
		@have_food = true
	end
	def next_route
		route = nil
		@target_node.routes.inject(-1) do |c, r| 
			t = tendency(r)
			if t > c then
				route = r
				t 
			else
				c
			end
		end
		@current_route = route
		@target_node = (route.nodes - [@target_node]).first
		put_pheromone
	end
	private
	def tendency(route)
		@genes[0] * Math::sin(@genes[1] * route.pheromone + @genes[2])
	end
	def put_pheromone()
		if @have_food then
			@current_route.pheromone += 100 * (@food_collected + 1)
		else
			@current_route.pheromone += 1
		end
	end
	def mutation()
		@genes[rand(3)] = rand(11)-5;
	end
	def remember(node)
		@explored_nodes << node unless @explored_nodes.member? node
	end
	def teleport_to_nest()
		@target_node = @nest
		@current_route = nil
		remember @nest
		@distance_remaining = 0
	end
end

module Menu
	def show_menu()
		flow  width:140, height:600 do
			background black
			flow height:25 do
				para fg('Population: ',white), 	width:90, height:20
				@p = edit_line 									width:50, height:20
			end
			background black
			flow height:25 do
				para fg('Iterations: ',white), 	width:90, height:20
				@i = edit_line 									width:50, height:20
			end
			background black
			flow do
				button 'Start!',								width:1.0, height:20 do
					start(10, 1000)
				end
			end
		end
	end
end

module Interation
	def enable_interation
		click do |b,x,y|
			if b==1 then #add a node
				@begin_Route = nil
				node = Node.new(self, x, y)
				node.node.click do |b,x,y|
					if b==3 then #add a Route
						if @begin_Route then
							Route.new(self, @begin_Route, node)
							@begin_Route = nil
						else
							@begin_Route = node
						end
					elsif b==2 then
						node.change_status
						@food = (node.current_status == :food ? node : nil)
					end
				end
				if @nodes.empty? then
					node.change_status 
					@nest = node
				end
				@nodes << node
			end
		end
	end
end

module Civilization
	SELECTION_EPOCH_TO_EACH = 30
	def load_environment
		@nest = nil
		@food = nil

		@epoch = 0
		@food_collected = 0
		@delivered_time = 0

		@nodes = []
		@routes = []
		@colony = []
		@nextNaturalSelectionIn = 100
	end

	def restart()
		@colony.each {|ant| ant.teleport_to_nest(@nest)}
		@routes.each {|r| r.pheromone = 30}
	end

	def start(population, interactions)
		load_environment
		(rand(9)+1).times {|t| @colony << Ant.new(@nest)}

		@interaction = 0
		@animation = animate 10 do

			@animation.stop if @interaction == interactions
		end
	end

	def next_turn
		@epoch += 1
		natural_selection if @epoch % SELECTION_EPOCH_TO_EACH

		@colony.each do |ant|
			if ant.on_the_road? then
				ant.walk
			elsif ant.target_node == @nest and ant.carrying_food? then
				ant.leave_food
				@food_collected += 1
				delivered_time = @epoch
			elsif ant.target_node == @food and not ant.carrying_food? then
				ant.pick_food
			elsif ant.carrying_food? then
				ant.back_to_nest
			else
				ant.next_route
			end
		end

		@routes.each {|r| r.pheromone_evaporation}
	end

	def natural_selection()
		@colony << Ant.new(@nest, best_explorers)
		@colony << Ant.new(@nest, best_workers)
		kill_losers
		migration
	end

	def best_explorers()
		male = @colony.inject {|a1,a2| (a1.lost_counter <= a2.lost_counter)? a1 : a2}
		female = @colony.delete(male).inject {|a1,a2| (a1.lost_counter <= a2.lost_counter)? a1 : a2}
		[male, female]
	end

	def best_workers()
		male = @colony.inject {|a1,a2| (a1.food_collected > a2.food_collected)? a1 : a2}
		female = @colony.delete(male).inject {|a1,a2| (a1.food_collected > a2.food_collected)? a1 : a2}
		[male, female]
	end

	def kill_losers()
		@colony.each{|ant| @colony.delete ant if ant.lost_counter > 5}
	end

	def migration()
		Ant.new(@nest)
	end
end

Shoes.app title:'Route Optimizer', width:800, height:600 do
	extend Menu
	extend Civilization
	extend Interation

	background '#753' .. '#420'
	show_menu
	enable_interation
	load_environment


end