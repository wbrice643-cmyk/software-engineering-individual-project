AREA = [
  [0,  3, 'J', 0, 0],
  [0,  0,  0, -4, 0],
  [0,  0,  2,  0, 0],
  [0,  0, -3,  0, 0],
  ['j', 2,  1,  0, 0],
  [0, -2,  0,  0, 'J']
]

CELL_BLANK = 0

# Display a powerup are using the puts function to output results.
def display_area(area)
  return if area.empty?

  width = area[0].length
  puts '-' * (width + 2)
  0.upto(area.length - 1) do |y|
    row_printable = []
    (0..width - 1).each do |x|
      cell = area[y][x]
      # formats string so as to align column values
      row_printable << format(' % <cell>1i ', cell: cell) if cell.is_a? Integer
      row_printable << format(' %<cell>2c ', cell: cell) if !cell.is_a? Integer
    end
    puts "|#{row_printable.join('')}|"
  end
  puts '-' * (width + 2)
end

def signum(v)
  return 1 if v.positive?
  return -1 if v.negative?
	0
end

def find_char(area,c)
  result = [-1,-1]
  0.upto (area.length-1) do |y|
    0.upto (area[0].length-1) do |x|
      if area[y][x] == c && result[1]==-1
        result = [x,y]
      elsif area[y][x] == c && result[0]!=-1
        result = [-1, -2]
      end
    end
  end
  return result
end

def valid_area(area)
  if area[0][0].is_a?(String) && area[0][0].downcase != area[0][0]
    return false
  end
  0.upto (area.length - 1) do |y|
    0.upto (area[0].length - 1) do |x|
      if area[y][x].is_a?(String) && area[y][x].downcase != area[y][x]
        if find_char(area,area[y][x].downcase)[0] == -1
          return false
        end
      elsif area[y][x].is_a?(String) && area[y][x].upcase != area[y][x]
        if find_char(area,area[y][x].upcase)[1] == -1
          return false
        end
      end
    end
  end
  true
end

def path_to(area,from_x, from_y, x,y)
  cost = [(x-from_x).abs,(y-from_y).abs].max
  if !valid_area(area) || x<0 || y<0 || from_x<0 || from_y<0 || x>area[0].length-1 || from_x>area[0].length-1 || y>area.length-1 || from_y>area.length-1
	  return -1
  end
  (0...cost-1).each do 
    from_x+=signum(x - from_x)
    from_y+=signum(y - from_y)
    if area[from_y][from_x] != 0
      return -1
    end
  end
  return cost
end

def find_paths(area,from_x, from_y, energy)
  choices = []
  0.upto (area.length-1) do |y|
    0.upto (area[0].length-1) do |x|
      if from_x != x || y!=from_y
        if x==0 && y==0 && path_to(area,from_x,from_y,x,y) != -1 && path_to(area,from_x,from_y,x,y) <= energy
          if area[y][x].is_a?(Integer)
            return [[0,0,energy-path_to(area,from_x,from_y,x,y)+area[y][x]]]
          else
            return [[0,0,energy-path_to(area,from_x,from_y,x,y)]]
          end
        elsif path_to(area,from_x,from_y,x,y) != -1 && path_to(area,from_x,from_y,x,y) <= energy && area[y][x]!=0
          if area[y][x].is_a?(String) && area[y][x].downcase != area[y][x]
            endLocation = find_char(area,area[y][x].downcase)
            if endLocation[0]==0 && endLocation[1]==0
              return [0,0,energy-path_to(area,from_x,from_y,x,y)]
            else
              choices << [endLocation[0],endLocation[1],energy-path_to(area,from_x,from_y,x,y)]
            end
          elsif area[y][x].is_a?(Integer)
            if energy >= path_to(area,from_x,from_y,x,y)-area[y][x]
             choices << [x,y,energy-path_to(area,from_x,from_y,x,y)+area[y][x]]
            end
          else
            choices << [x,y,energy-path_to(area,from_x,from_y,x,y)]
          end
        end
      end
    end
  end
	return choices
end

def make_moves(area,from_x,from_y,energy,moves_left)
  if from_x == 0 && from_y == 0
    return true
  elsif moves_left <= 0 || energy <= 0
    return false
  end
  choices=find_paths(area,from_x,from_y,energy)
  (0..choices.length-1).each do |i|
    if make_moves(area,choices[i][0],choices[i][1],choices[i][2],moves_left-1)
      return true
    end
  end
  false
end

if __FILE__ == $PROGRAM_NAME
	display_area(AREA)
end


# 11-12-2025 changed formatting
# 11-12-2025 make moveds function complete
# 10-12-2025 completed find paths function
# 09-12-2025 completed path to function
# 08-12-2025 completed valid area function
# 08-12-2025 completed find_char function
# 08-12-2025 completed signum function
# 05-12-2025 adding power up area
# 05-12-2025 Delete README.md
# 05-12-2025 add README