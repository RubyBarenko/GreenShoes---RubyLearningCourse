class Collision
	def self.collided_rect?(circle, rect)
		if circle.top + circle.width >= rect.top && circle.top <= rect.top + rect.height then
			if circle.left >= rect.left && circle.left + circle.width <= rect.left + rect.width then
				return true;
			end
		end
		false
	end
end

Shoes.app(title:"colision", width:400, weight:400) do
	background black
	stroke rgb 0.8, 0.8, 0.5
	fill rgb 0.3, 0.3, 0.0

	@rect = rect(top:300, left:140, width:120, height:40)
	@circle = oval(top:0, left:0, radius:2)

	p0=[]
	motion do |x,y|
		@circle.move x,y
		p0 = x,y if p0.empty?
		line(p0[0],p0[1],x,y)
		p0 = x,y
		if Collision.collided_rect?(@circle, @rect) then
			@rect.style fill :red
		else
			@rect.style fill :yellow
		end
	end
end