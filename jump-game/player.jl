type Player
	sprite::Sprite
	velocity::Vector2f
end

function Player(sprite)
	Player(sprite, Vector2f(0, 0))
end

function handle_keys(player::Player)
	if is_key_pressed(KeyCode.LEFT)
		player.velocity.x = -maxspeed
		set_texture(player.sprite, rightplayer_texture)
		set_scale(player.sprite, Vector2f(-0.25, 0.25))
	elseif is_key_pressed(KeyCode.RIGHT)
		player.velocity.x = maxspeed
		set_texture(player.sprite, rightplayer_texture)
		set_scale(player.sprite, Vector2f(0.25, 0.25))
	else
		player.velocity.x = 0
		set_texture(player.sprite, middleplayer_texture)
		set_scale(player.sprite, Vector2f(0.25, 0.25))
	end
end

function update_pos(player::Player)
	player.velocity += gravity
	move(player.sprite, player.velocity)
	pos = get_position(player.sprite)
	xpos = pos.x
	if pos.x > window_width
		xpos = 0
	elseif pos.x < 0
		xpos = window_width
	end

	set_position(player.sprite, Vector2f(xpos, pos.y))
end

function update(player::Player)
	handle_keys(player)
	update_pos(player)
end

function collide(player::Player, box::Platform)
	if intersects(get_globalbounds(player.sprite), get_globalbounds(box.sprite)) && player.velocity.y >= 5
		box.has_collided = true
		player.velocity.y = -jump_height
		set_texture(box.sprite, blue_platform_texture)
		return true
	end
	return false
end

function draw(window::RenderWindow, player::Player)
	draw(window, player.sprite)
end
