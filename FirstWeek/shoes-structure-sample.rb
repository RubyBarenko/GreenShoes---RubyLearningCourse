class Calculator
	attr_reader :total

	def initialize
		@total = 0
	end

	def self.add(number)
		total += number
	end
end

Shoes.app do
	@calc = Calculator.new
	@number = edit_line
	button "Add" do
		@calc.add(@number.text.to_i)
		alert("Your total so far is #{@calc.total}")
	end
end
