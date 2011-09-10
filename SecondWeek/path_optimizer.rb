require 'green_shoes'
require 'matrix'

def p(text)
  Kernel::p text if /^debug$/i === ARGV[0]
end

class Route
	attr_accessor :pheromone
	attr_reader :length, :nodes
	
	def initialize(context, from, to)
		@nodes = [from, to]
		@nodes.each{|n| n.add_route self}

		context.strokewidth 3; context.stroke context.black
		@route = context.line @nodes[0].pos[0], @nodes[0].pos[1], @nodes[1].pos[0], @nodes[1].pos[1]
		@length = (@nodes[0].pos - @nodes[1].pos)[0] + (@nodes[0].pos - @nodes[1].pos)[1]

		textX = @nodes[0].pos[0] + (@nodes[1].pos[0] - @nodes[0].pos[0])/2
		textY = @nodes[0].pos[1] + (@nodes[1].pos[1] - @nodes[0].pos[1])/2
		@level = context.para '', width:100, height:20, left:textX, top:textY

		@pheromone = 30
		update_gui
	end

	def pheromone_evaporation()
    @pheromone -= 1
	end
	
	def update_gui()
		@level.text = @pheromone
	end
	
	def to_s()
	 "Route(#{object_id}){Length:#{length}, Pheromone:#{@pheromone}, Nodes:#{@nodes.inject(''){|x0,x| "#{x0}#{x.object_id}, "}}}"
	end
end

class Node
	@@number = 0
	
	attr_accessor :node
	attr_reader :radius, :current_status, :routes, :pos
	
	def initialize(context, x, y)
		@@number += 1
		@status = {normal:context.yellow, source:context.blue, food:context.red}
		@radius = 20
		
		context.nostroke
		@node = context.oval left:(x-@radius), top:(y-@radius), radius:@radius
		@pos = Vector[x,y]

		@name = context.para @@number, width:100, height:20, left:x, top:y
		change_status
	end
	
	def pos=(x, y)
		@node.left, @node.top = x - @node.width/2, y - @node.height/2
		@pos = Vector[@node.left+@node.width/2, @node.top+@node.height/2]
	end

	def add_route(route)
		(@routes||=[]) << route
	end

	def change_status() 
		if @@number == 1 or @current_status == :source then
			@current_status = :source
		else
			allowed_status = @status.keys - [:source]
			@current_status = allowed_status.rotate[allowed_status.index(@current_status || :food)]
		end
		@node.style fill:@status[@current_status]
		@name.text = @name.text # put text in front of the fill
	end

	def to_s()
   "Node(#{object_id}){Type:#{@current_status}, Position:#{@pos}, Routes:#{@routes.inject(''){|x0,x| "#{x0}#{x.object_id}, "}}}"
  end
end

class Ant
	attr_accessor :genes
	attr_reader :lost_counter, :food_collected, :target_node

	def initialize(nest, *parents)
		@genes = [rand(11)-5,rand(11)-5,rand(11)-5, rand(11)-5]
		@genes.size.times {|g| @genes[g] = parents.flatten[rand(parents.size)].genes[g]} if parents.any?
		mutation if rand(20) == 0

		@food_collected, @lost_counter, @current_route, @explored_nodes = 0, 0, nil, []
		@nest = nest
		teleport_to_nest
	end
	
	def on_the_road?()
		!! @current_route
	end
	
	def walk()
		@distance_remaining -= 10 if @current_route
		if @distance_remaining <= 0 then
			@current_route, @distance_remaining = nil, 0
		end
	end

	def leave_food()
		@have_food, @explored_nodes = false, []
		@food_collected += 1
		remember @nest
	end
	
	def carrying_food?
		@have_food
	end
	
	def pick_food()
		@have_food = true
	end

	def next_route
		candidate_routes = []
		@target_node.routes.inject(-1000) do |max, r| 
      t = tendency(r)
      p "Tendency to Route #{r}: #{t}"
			if t > max then
				candidate_routes = [r]
				max = t
			elsif t == max then
				candidate_routes << r
			end
			max
		end
		chosen_route = candidate_routes.rotate(@genes[3]).first
		@current_route, @distance_remaining = chosen_route, chosen_route.length
		@target_node = (chosen_route.nodes - [@target_node]).first
		remember @target_node
		p "Route to #{@target_node}"
		put_pheromone
	end

  def to_s
   "Ant(#{object_id}){Genes#{@genes}, Food Collected:#{@food_collected}, Lost Counter:#{@lost_counter}, Target Node:#{@target_node}, Current Route:#{@current_route}, Remaining: #{@distance_remaining}, Have Food:#{@have_food}, Memory:{#{@explored_nodes}}}"
  end
	
	def back_to_nest()
		current_node = @explored_nodes.pop
		p @explored_nodes
		p "I'm in #{current_node}"
		p "I must return to #{@explored_nodes.last}"
		@current_route = nil
		while @current_route.nil?
			@target_node = @explored_nodes.last
			@current_route = route_between current_node, @target_node
			@explored_nodes.pop unless @current_route
		end

		@target_node = @explored_nodes.last
		@distance_remaining = @current_route.length
		put_pheromone
	end

	private

	def route_between(node1, node2)
		route = nil
		node1.routes.each {|r| route = r if r.nodes.include? node2}
		route
	end

	def tendency(route)
		@genes[0] * Math::sin(@genes[1] * route.pheromone + @genes[2])
	end

	def put_pheromone()
		if @have_food then
			p "I'm marking the road #{@current_route} with pheromone"
			@current_route.pheromone += 100 * (@food_collected + 1)
		else
			@current_route.pheromone += 1
		end
	end

	def mutation()
		@genes[rand(@genes.size)] = rand(11)-5;
	end

	def remember(node)
		if @explored_nodes.member? node then
			@lost_counter += 1
		else
			@explored_nodes << node
		end
	end
	
	def teleport_to_nest()
		@target_node = @nest
		remember @target_node
		@current_route, @distance_remaining = nil, 0
	end
end

module Menu
	def show_menu()
		flow  width:140, height:600 do
			background black
			flow height:25 do
				para fg('Iterations: ',white), 		width:90, height:20
				@menu_interations = edit_line 		width:50, height:20
        #@menu_interations.text = '1'
				
				button 'Start!',									width:1.0, height:20 do
					start(@menu_interations.text.to_i)
				end
				para
				@menu_turn = para fg(strong('Turn: '),white), 						width:90, height:20
				@menu_population = para fg(strong('Pop.: '),white), 			width:90, height:20
				@menu_food_collected = para fg(strong('Food:  '),white), 	width:90, height:20
			end
		end
	end
end

module Interation
	def enable_interation
		click do |b,x,y|
			add_node_event(x,y) if b==1 and x > 140
		end
	end
	
	private

	def add_node_event(x, y)
		@begin_route = nil
		node = Node.new(self, x, y)
		node.node.click do |b,x,y|
			if b==3 then
				add_route_event(node)
			elsif b==2 then
				change_status_event(node)
			end
		end
		if @nodes.empty? then
			node.change_status 
			@nest = node
		end
		@nodes << node
	end

	def add_route_event(node)
		if @begin_route and @begin_route != node then
			@routes << Route.new(self, @begin_route, node)
			@begin_route = nil
		else
			@begin_route = node
		end
	end

	def change_status_event(node)
		node.change_status
		@food = (node.current_status == :food ? node : nil)
	end
end

module Civilization
	SELECTION_EPOCH_TO_EACH = 30
	def load_environment
		@food_collected, @delivered_time, @epoch = 0, 0, 0
		@nodes  ||= []; @routes ||= []; @colony ||= []
	end

	def restart()
		@colony.each {|ant| ant.teleport_to_nest}
		@routes.each {|r| r.pheromone = 30}
	end

	def start(interactions)
		load_environment
		(rand(10)+5).times {@colony << Ant.new(@nest)}

		@animation = animate do
			@thread = Thread.new{next_turn} unless @thread and @thread.alive?
			update_gui
			if @epoch >= interactions then
				@animation.stop
				sleep 0.001 while @thread.alive?
				update_gui true
			end
		end
	end

	def next_turn
		@epoch += 1
		natural_selection if (@epoch % SELECTION_EPOCH_TO_EACH).zero?

		@colony.each do |ant|
			if ant.on_the_road? then
        p ant.to_s + 'on the road'
				ant.walk
			elsif ant.target_node == @nest and ant.carrying_food? then
				p ant.to_s + 'in nest with food'
        ant.leave_food
				@food_collected += 1
				delivered_time = @epoch
			elsif ant.target_node == @food and not ant.carrying_food? then
				p ant.to_s + 'in food without food'
        ant.pick_food
			elsif ant.carrying_food? then
				p ant.to_s + 'with food'
        ant.back_to_nest
			else
        p ant.to_s + 'choose route'
				ant.next_route
			end
		end

		evaporate
	end

	def update_gui(all=false)
		@menu_turn.text = fg(stroke('Turn: ') + fg(@epoch, yellow),white)
		@menu_population.text = fg(stroke('Pop.: ') + fg(@colony.size, yellow),white)
		@menu_food_collected.text = fg(stroke('Food: ') + fg(@food_collected, yellow),white)

		@routes.each{|r| r.update_gui} if (@epoch % 10).zero? or all
	end

	private

	def evaporate()
		@routes.each {|r| r.pheromone_evaporation}
	end

	def natural_selection()
		@colony << Ant.new(@nest, best_explorers)
		@colony << Ant.new(@nest, best_workers)
		kill_losers
		migration
	end

	def best_ants(&condition_blk)
		male = @colony.inject &condition_blk
		females = @colony.dup
		females.delete(male)
		female = females.inject &condition_blk
		[male, female]
	end

	def best_explorers()
		best_ants {|a1,a2| (a1.lost_counter <= a2.lost_counter)? a1 : a2}
	end

	def best_workers()
		best_ants {|a1,a2| (a1.food_collected > a2.food_collected)? a1 : a2}
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
	load_environment
	enable_interation
end
