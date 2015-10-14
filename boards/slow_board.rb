require_relative "board"

class SlowBoard < Board
  I=InvalidPlacementError

  def initialize
    @P=?.*9
  end

  def load(m)
    @P=m
  end

  def mark_turn(m,p)
    raise(I)if@P[p-1]!='.';@P[p-1]= m
  end

  def finished?
    !@P['.']
  end

  def winner
    %w[x o].find{|m|@P=~/^.{3}*#{m}{3}/||@P=~/#{m}...#{m}...#{m}/||@P=~/..#{m}.#{m}.#{m}../||@P=~/#{m}.{2}#{m}.{2}#{m}/}
  end

private

  def board_in_2d
    @P.chars.each_slice(3)
  end
end
