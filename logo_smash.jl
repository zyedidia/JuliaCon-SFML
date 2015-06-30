import Chipmunk
Cp = Chipmunk
import SFML
Sf = SFML

# I am not using the Debug Draw in this example because it is slower than doing the rendering yourself, and I need the best performance in this example.

function sf_vec(cpvect)
	Sf.Vector2f(cpvect.x, -cpvect.y)
end

const image_width = 188;
const image_height = 35;
const image_row_length = 24;

image_bitmap = [15,-16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,-64,15,63,-32,-2,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,31,-64,15,127,-125,-1,-128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,127,-64,15,127,15,-1,-64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,-1,-64,15,-2,
	31,-1,-64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,-1,-64,0,-4,63,-1,-32,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,1,-1,-64,15,-8,127,-1,-32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	1,-1,-64,0,-8,-15,-1,-32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,-31,-1,-64,15,-8,-32,
	-1,-32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,-15,-1,-64,9,-15,-32,-1,-32,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,31,-15,-1,-64,0,-15,-32,-1,-32,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,63,-7,-1,-64,9,-29,-32,127,-61,-16,63,15,-61,-1,-8,31,-16,15,-8,126,7,-31,
	-8,31,-65,-7,-1,-64,9,-29,-32,0,7,-8,127,-97,-25,-1,-2,63,-8,31,-4,-1,15,-13,
	-4,63,-1,-3,-1,-64,9,-29,-32,0,7,-8,127,-97,-25,-1,-2,63,-8,31,-4,-1,15,-13,
	-2,63,-1,-3,-1,-64,9,-29,-32,0,7,-8,127,-97,-25,-1,-1,63,-4,63,-4,-1,15,-13,
	-2,63,-33,-1,-1,-32,9,-25,-32,0,7,-8,127,-97,-25,-1,-1,63,-4,63,-4,-1,15,-13,
	-1,63,-33,-1,-1,-16,9,-25,-32,0,7,-8,127,-97,-25,-1,-1,63,-4,63,-4,-1,15,-13,
	-1,63,-49,-1,-1,-8,9,-57,-32,0,7,-8,127,-97,-25,-8,-1,63,-2,127,-4,-1,15,-13,
	-1,-65,-49,-1,-1,-4,9,-57,-32,0,7,-8,127,-97,-25,-8,-1,63,-2,127,-4,-1,15,-13,
	-1,-65,-57,-1,-1,-2,9,-57,-32,0,7,-8,127,-97,-25,-8,-1,63,-2,127,-4,-1,15,-13,
	-1,-1,-57,-1,-1,-1,9,-57,-32,0,7,-1,-1,-97,-25,-8,-1,63,-1,-1,-4,-1,15,-13,-1,
	-1,-61,-1,-1,-1,-119,-57,-32,0,7,-1,-1,-97,-25,-8,-1,63,-1,-1,-4,-1,15,-13,-1,
	-1,-61,-1,-1,-1,-55,-49,-32,0,7,-1,-1,-97,-25,-8,-1,63,-1,-1,-4,-1,15,-13,-1,
	-1,-63,-1,-1,-1,-23,-49,-32,127,-57,-1,-1,-97,-25,-1,-1,63,-1,-1,-4,-1,15,-13,
	-1,-1,-63,-1,-1,-1,-16,-49,-32,-1,-25,-1,-1,-97,-25,-1,-1,63,-33,-5,-4,-1,15,
	-13,-1,-1,-64,-1,-9,-1,-7,-49,-32,-1,-25,-8,127,-97,-25,-1,-1,63,-33,-5,-4,-1,
	15,-13,-1,-1,-64,-1,-13,-1,-32,-49,-32,-1,-25,-8,127,-97,-25,-1,-2,63,-49,-13,
	-4,-1,15,-13,-1,-1,-64,127,-7,-1,-119,-17,-15,-1,-25,-8,127,-97,-25,-1,-2,63,
	-49,-13,-4,-1,15,-13,-3,-1,-64,127,-8,-2,15,-17,-1,-1,-25,-8,127,-97,-25,-1,
	-8,63,-49,-13,-4,-1,15,-13,-3,-1,-64,63,-4,120,0,-17,-1,-1,-25,-8,127,-97,-25,
	-8,0,63,-57,-29,-4,-1,15,-13,-4,-1,-64,63,-4,0,15,-17,-1,-1,-25,-8,127,-97,
	-25,-8,0,63,-57,-29,-4,-1,-1,-13,-4,-1,-64,31,-2,0,0,103,-1,-1,-57,-8,127,-97,
	-25,-8,0,63,-57,-29,-4,-1,-1,-13,-4,127,-64,31,-2,0,15,103,-1,-1,-57,-8,127,
	-97,-25,-8,0,63,-61,-61,-4,127,-1,-29,-4,127,-64,15,-8,0,0,55,-1,-1,-121,-8,
	127,-97,-25,-8,0,63,-61,-61,-4,127,-1,-29,-4,63,-64,15,-32,0,0,23,-1,-2,3,-16,
	63,15,-61,-16,0,31,-127,-127,-8,31,-1,-127,-8,31,-128,7,-128,0,0]

settings = Sf.ContextSettings()
settings.antialiasing_level = 3
window = Sf.RenderWindow(Sf.VideoMode(800, 600), "Logo smash", settings, Sf.window_defaultstyle)
Sf.set_framerate_limit(window, 60)

event = Sf.Event()

function make_ball(x, y)
	body = Cp.Body(1.0, Inf);
	Cp.set_position(body, Cp.Vect(x + 400, y - 300));

	shape = Cp.CircleShape(body, 0.95, Cp.Vect(0, 0));
	Cp.set_elasticity(shape, 0.0);
	Cp.set_friction(shape, 0.0);
	push!(bodies, body)

	circle = Sf.CircleShape()
	Sf.set_radius(circle, 0.95)
	Sf.set_origin(circle, Sf.Vector2f(0.95, 0.95))
	Sf.set_fillcolor(circle, Sf.red)
	push!(circles, circle)

	shape
end

circles = Sf.CircleShape[]
bodies = Cp.Body[]
function get_pixel(x, y)
	(image_bitmap[((x>>3) + y*image_row_length) + 1]>>(~x&0x7)) & 1;
end

function init()
	space = Cp.Space()

	# The space will contain a very large number of similary sized objects.
	# This is the perfect candidate for using the spatial hash.
	# Generally you will never need to do this.
	Cp.use_spatial_hash(space, 2, 10000);

	bodycount = 0
	for y = 0:image_height-1
		for x = 0:image_width-1
			if get_pixel(x, y) == 0 continue end
			
			x_jitter = 0.05*rand();
			y_jitter = 0.05*rand();
			
			shape = make_ball(2*(x - image_width/2 + x_jitter), 2*(image_height/2 - y + y_jitter));
			Cp.add_body(space, Cp.get_body(shape))
			Cp.add_shape(space, shape)

			bodycount += 1;
		end
	end
	body = Cp.add_body(space, Cp.Body(1e9, Inf));
	Cp.set_position(body, Cp.Vect(-1000 + 350, -10 - 300));
	Cp.set_velocity(body, Cp.Vect(400, 0));

	shape = Cp.add_shape(space, Cp.CircleShape(body, 8.0, Cp.Vect(0, 0)));
	Cp.set_elasticity(shape, 0.0);
	Cp.set_friction(shape, 0.0);

	circle = Sf.CircleShape()
	Sf.set_radius(circle, 8)
	Sf.set_origin(circle, Sf.Vector2f(8, 8))
	Sf.set_fillcolor(circle, Sf.blue)
	push!(circles, circle)
	push!(bodies, body)

	bodycount += 1;
	println("$bodycount bodies")

	space
end

space = init()

while Sf.isopen(window)
	while Sf.pollevent(window, event)
		if Sf.get_type(event) == Sf.EventType.CLOSED
			Sf.close(window)
		end
	end

	Cp.step(space, 1/60)

	Sf.clear(window, Sf.white)
	for i = 1:length(circles)
		circle = circles[i]
		Sf.set_position(circle, sf_vec(Cp.get_position(bodies[i])))
		Sf.draw(window, circle)
	end
	Sf.display(window)
end
