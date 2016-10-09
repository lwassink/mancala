class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @cups = Array.new(14) { Array.new }
    @name1 = name1
    @name2 = name2
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    positions = (0..5).to_a + (7..12).to_a
    positions.each do |pos|
      @cups[pos] += [:stone, :stone, :stone, :stone]
    end
  end

  def valid_move?(start_pos)
    raise "Invalid starting cup" unless start_pos.between?(1,12)
  end

  def make_move(start_pos, current_player_name)
    stones = [:stone] * @cups[start_pos].length
    @cups[start_pos] = []
    idx = start_pos

    until stones.empty?
      idx = (idx + 1) % 14
      @cups[idx] += [stones.pop] unless skip(idx, current_player_name)
    end

    next_turn(idx, current_player_name)
  end

  def skip(idx, name)
    (idx == 13 && name == @name1) ||
      (idx == 6 && name == @name2)
  end

  def next_turn(ending_cup_idx, name)
    current_cup = (name == @name1 ? 6 : 13 )

    if ending_cup_idx == current_cup
      :prompt
    elsif @cups[ending_cup_idx].length > 1
      ending_cup_idx
    else
      :switch
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def cups_empty?
    if @cups[0..5].all?(&:empty?) || @cups[7..12].all?(&:empty?)
      true
    else
      false
    end
  end

  def winner
    return :draw if @cups[6] == @cups[13]

    if @cups[6].length < @cups[13].length
      @name2
    else
      @name1
    end
  end
end

