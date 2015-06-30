importall SFML

const mode = get_desktop_mode()

const window_width = Int(mode.width)
const window_height = Int(mode.height)

const gravity = Vector2f(0, 0.5)
const maxspeed = 17/2560 * window_width
const jump_height = 22/1440 * window_height

const blue_platform_texture = Texture("img/blueplatform.png")
const red_platform_texture = Texture("img/redplatform.png")
const middleplayer_texture = Texture("img/middleplayer.png")
set_smooth(middleplayer_texture, true)

const rightplayer_texture = Texture("img/rightplayer.png")
set_smooth(rightplayer_texture, true)

const cloud_texture = Texture("img/cloud.png")
set_smooth(cloud_texture, true)

include("util.jl")
include("platform.jl")
include("player.jl")

function main()
	settings = ContextSettings()
	settings.antialiasing_level = 2
	window = RenderWindow(mode, "Jump", settings, window_fullscreen)

	set_framerate_limit(window, 60)
	event = Event()

	score = RenderText()
	set_position(score, Vector2f(0, 0))
	set_charactersize(score, 40)
	set_color(score, SFML.red)

	view = get_default_view(window)

	texture_size = get_size(middleplayer_texture)

	playersprite = Sprite()
	set_texture(playersprite, middleplayer_texture)
	set_origin(playersprite, Vector2f(texture_size.x / 2, texture_size.y / 2))
	set_scale(playersprite, Vector2f(0.25, 0.25))

	player = Player(playersprite)

	platforms = Platform[]
	clouds = Sprite[]

	function resetgame()
		set_position(player.sprite, Vector2f(window_width / 2, -window_height / 2))
		player.velocity = Vector2f(0, 0)

		texture_size = get_size(red_platform_texture)
		cloud_texture_size = get_size(cloud_texture)

		empty!(platforms)
		empty!(clouds)

		for i = -10:100
			platformsprite = Sprite()
			set_texture(platformsprite, red_platform_texture)
			set_origin(platformsprite, Vector2f(texture_size.x / 2, texture_size.y / 2))
			set_scale(platformsprite, Vector2f(rand(2:5), 0.5))
			set_position(platformsprite, Vector2f(rand(0:window_width), -175*i))
			platform = Platform(platformsprite)
			if i == 100
				platform.winning = true
			end
			push!(platforms, platform)

			if i % 5 == 0
				cloud = Sprite()
				set_texture(cloud, cloud_texture)
				set_origin(cloud, Vector2f(cloud_texture_size.x / 2, cloud_texture_size.y / 2))
				set_position(cloud, Vector2f(rand(0:window_width), -175*i + rand(-100:100)))
				push!(clouds, cloud)
			end
		end
		win = false
	end
	resetgame()

	music = Music("music.ogg")

	set_loop(music, true)
	play(music)

	win = false

	while isopen(window)
		while pollevent(window, event)
			if get_type(event) == EventType.CLOSED
				close(window)
			end
		end

		if is_key_pressed(KeyCode.RETURN)
			sleep(0.1)
			resetgame()
		end

		update(player)
		set_center(view, Vector2f(window_width / 2, get_position(player.sprite).y))

		if !win
			set_string(score, "Score: $(Int(round(-get_position(player.sprite).y / 100)))\t\t\t\tPress enter to play again")
			set_position(score, Vector2f(0, get_center(view).y - window_height/2 + 20))
		else
			set_string(score, "You win!\nPress enter to play again")
			set_position(score, Vector2f(window_width/2, get_center(view).y))
		end

		set_view(window, view)
		clear(window, Color(0, 204, 255))

		for i = 1:length(clouds)
			draw(window, clouds[i])
		end

		for i = 1:length(platforms)
			update(platforms[i])
			if collide(player, platforms[i]) && platforms[i].winning
				win = true
			end
			draw(window, platforms[i])
		end

		draw(window, player)
		draw(window, score)

		display(window)
	end
end

main()
