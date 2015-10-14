require_relative "board"

class FastBoard < Board
  I=InvalidPlacementError
  W=[448,56,7,292,146,73,273,84]
  P=[0,1,2,4,8,16,32,64,128,256]

  def initialize
    @x=@o=0
  end

  def load(i)
    @x=@o=n=0;i.chars{|m|v=P[n+=1];m==?x&&@x+=v;m==?o&&@o+=v}
  end

  def mark_turn(m, p)
    v=P[p];raise(I)if(@x|@o)&v>0;m==?x&&@x+=v;m==?o&&@o+=v
  end

  def finished?
    @x|@o==511
  end

  def winner
    if W.any?{|v|@x&v==v};'x'
    elsif W.any?{|v|@o&v==v};'o'
    end
  end

private

  def board_in_2d
    P[1,9].map{|v|if@o&v>0;?o;elsif @x&v>0;?x;else " ";end}.each_slice(3)
  end
end
