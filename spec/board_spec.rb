# Change this to your subclassed file
require_relative "../boards/board"

RSpec.describe Board do
  subject(:board) { Board.new } # Change this to your board class

  specify '#finished' do
    board.load 'xoxo.ooox'
    expect(board).not_to be_finished

    board.load 'xoxoxooox'
    expect(board).to be_finished
  end

  specify '#winner' do
    board.load("ooo......"); expect(board.winner).to eq 'o'
    board.load("...xxx..."); expect(board.winner).to eq 'x'
    board.load("......ooo"); expect(board.winner).to eq 'o'
    board.load("x..x..x.."); expect(board.winner).to eq 'x'
    board.load(".o..o..o."); expect(board.winner).to eq 'o'
    board.load("..x..x..x"); expect(board.winner).to eq 'x'
    board.load("o...o...o"); expect(board.winner).to eq 'o'
    board.load("..x.x.x.."); expect(board.winner).to eq 'x'

    board.load("x.o.xxx.."); expect(board.winner).to be_nil
    board.load("..ooo...."); expect(board.winner).to be_nil
    board.load("oo.oo...."); expect(board.winner).to be_nil
    board.load("o.o...o.o"); expect(board.winner).to be_nil
    board.load("oxoxoxxox"); expect(board.winner).to be_nil
  end

  specify '#mark_turn' do
    board.load 'xoxo.ooox'
    board.mark_turn "x", 5

    expect(board).to be_finished
    expect(board.winner).to eq 'x'
  end

  specify '#mark_turn (invalid placement)' do
    board.load 'x........'

    expect { board.mark_turn "x", 1 }.to raise_error Board::InvalidPlacementError
  end

end
