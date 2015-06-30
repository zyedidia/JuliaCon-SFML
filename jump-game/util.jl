function +(vec1::Vector2f, vec2::Vector2f)
	Vector2f(vec1.x + vec2.x, vec1.y + vec2.y)
end

function *(vec1::Vector2f, vec2::Vector2f)
	Vector2f(vec1.x * vec2.x, vec1.y * vec2.y)
end

function corners(rect::FloatRect)
	((rect.left, rect.top + rect.height), (rect.left + rect.width, rect.top))
end
