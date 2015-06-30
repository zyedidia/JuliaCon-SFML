type Platform
	sprite::Sprite
	has_collided::Bool
	winning::Bool

	function Platform(sprite)
		new(sprite, false, false)
	end
end

function update(platform::Platform)
	if platform.has_collided
		move(platform.sprite, Vector2f(0, 5))
	end
end

function draw(window::RenderWindow, platform::Platform)
	draw(window, platform.sprite)
end
