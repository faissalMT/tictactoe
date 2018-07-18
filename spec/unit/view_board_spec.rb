# frozen_string_literal: true

describe UseCase::ViewBoard do
  let(:board_gateway) { double(board: board) }
  let(:view_board) do
    described_class.new(board_gateway: board_gateway)
  end

  subject do
    view_board.execute({})[:board]
  end

  context 'given a board with one piece placed' do
    let(:board) do
      Domain::Board.new
    end

    it 'can render current gamestate' do
      is_expected.to eq(
        [[:X, nil, nil],
         [nil, nil, nil],
         [nil, nil, nil]]
      )
    end
  end

  context 'given no board' do
    let(:board) { nil }

    it 'can start a game with an empty board' do
      is_expected.to eq([
                          [nil, nil, nil],
                          [nil, nil, nil],
                          [nil, nil, nil]
                        ])
    end
  end
end
