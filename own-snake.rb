require 'ruby2d'
set :background => "green"
set :fps_cap => 14
#background: black, snake: green, food: red, color: white
#window: height => 480... width => 640...
GRID = 20
GRID_WIDTH = Window.width / GRID
GRID_HEIGHT = Window.height / GRID

Text.new("Welcome to the snake game!", color: "red")

class Snake
    attr_writer :current_direction
    attr_reader :current_direction
    def initialize
        @snake_position = [[3,6], [3,7], [3,8], [3,9]]
        @current_direction = "down"
        @moving = true
    end

    def draw 
        @snake_position.each do |e|
            Square.new(
                x: e[0] * GRID, y: e[1] * GRID,
                color: "black",
                size: GRID - 1
            )
        end
    end

    def movements(direction)
        case direction
        when "down"
            @snake_position << modulus(end_element[0], end_element[1] + 1)
        when "up"
            @snake_position << modulus(end_element[0], end_element[1] - 1)
        when "left"
            @snake_position << modulus(end_element[0] - 1, end_element[1])
        when "right"
            @snake_position << modulus(end_element[0] + 1, end_element[1])
        end
    end

    def snake_hit_itself?
        @snake_position.length != @snake_position.uniq.length
    end

    def finished
        @moving = false
    end

    def move_direction
        if @moving
            @snake_position.shift
            movements(@current_direction)
        end
    end

    def grow
        movements(@current_direction)
    end

    def x 
        end_element[0]
    end

    def y
        end_element[1]
    end

    def modulus(x, y)
        [x % GRID_WIDTH, y % GRID_HEIGHT]
    end

    private

    def end_element
        @snake_position[-1]
    end
end

class Game 
    def initialize 
        @score = 0
        @food_x = rand(GRID_WIDTH)
        @food_y = rand(GRID_HEIGHT)
        @finished = false
    end

    def draw_food
        Square.new(
            x: @food_x * GRID, y: @food_y * GRID, size: GRID, color: "red"
        )
        Text.new(text, color: "black", x: 10, y: 10)
    end

    def text
        if @finished
            text = "GAME OVER! YOUR FINAL SCORE IS #{@score}. 'R' to Restart, 'E' to Exit."
        else
            text = "Your current score: #{@score}"
        end
    end

    def finished 
        @finished = true
    end

    def finished?
        @finished
    end

    def food_got_hit
        @score += 1
        @food_x = rand(GRID_WIDTH)
        @food_y = rand(GRID_HEIGHT)
    end

    def food_got_hit_check?(x, y)
        x == @food_x && y == @food_y
    end
end

snake = Snake.new()
game = Game.new()

update do
    clear 
    snake.draw
    snake.move_direction
    game.draw_food
    if game.food_got_hit_check?(snake.x, snake.y)
        game.food_got_hit
        snake.grow
    end

    if snake.snake_hit_itself?
        game.finished
        snake.finished
    end
end

on :key_down do |event|
    if ['up', 'down', 'left', 'right'].include?(event.key)
        if (snake.current_direction == "down" or snake.current_direction == "up")
            if event.key == "right"
                snake.current_direction = event.key
            elsif event.key == "left"
                snake.current_direction = event.key
            end
        elsif (snake.current_direction == "left" or snake.current_direction == "right")
            if event.key == "up"
                snake.current_direction = event.key
            elsif event.key == "down"
                snake.current_direction = event.key
            end   
        end
    end

    if game.finished?
        case event.key
        when 'r'
            snake = Snake.new()
            game = Game.new()
        when 'space'
            snake = Snake.new()
            game = Game.new()
        when 'e'
            exit()
        else
            game.finished?
        end
    end
end




show