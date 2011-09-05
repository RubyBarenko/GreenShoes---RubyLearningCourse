require 'green_shoes'
require 'matrix'

class Route
	attr_accessor :from_node, :to_node, :pheromone
	attr_reader :length
	def initialize(context, from, to)
		@nodes = [from, to]
		@pheromone = 0
		context.strokewidth 3; context.stroke context.black
		@route = context.line @nodes[0].pos[0], @nodes[0].pos[1], @nodes[1].pos[0], @nodes[1].pos[1]
		@length = (@nodes[0].pos - @nodes[1].pos)[0] + (@nodes[0].pos - @nodes[1].pos)[1]
	end
	def pheromone_evaporation()
		pheromone -= 1;
	end
end

class Node
	attr_accessor :node
	attr_reader :radius, :current_status
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
	def initialize(*parents)
		@have_food = nil
		@food_collected = 0
		@genes = [rand(11)-5,rand(11)-5,rand(11)-5] #direction_choice, pheromone acceptance, 
		@genes.size.times {|g| @genes[g] = parents[rand(parents.size)].genes[g]} if parents.any?
		@explored_Routes =[]
	end
	def choose_route_tendency(route)
		route.pheromone
	end
	def walk()
	end
	def leave_food()

	end
	def pick_food()
	end
	def put_pheromone(route)
		route.pheromone += 1
	end
end

module Menu
	def show_menu()
		flow  width:140, height:600 do
			background black
			flow height:25 do
				para fg('Population: ',white), 	width:90, height:20
				p = edit_line 									width:50, height:20
			end
			background black
			flow height:25 do
				para fg('Iterations: ',white), 	width:90, height:20
				i = edit_line 									width:50, height:20
			end
			background black
			flow do
				button 'Start!',								width:1.0, height:20 do
					start(p, i)
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
	def load_environment
		@nest = nil
		@food = nil
		@nodes = []
		@routes = []
		@colony = []
		@nextNaturalSelectionIn = 100
		def next_turn()
		end
	end

	def start(population, interactions)
		load_environment
		population.times {|t| @colony << Ant.new(@nest)}

		@interaction = 0
		@animation = animation 10 do

			@animation.stop if @interaction == interactions
		end
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