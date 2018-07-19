# frozen_string_literal: true

describe UseCase::AiPlay do
  let(:board_gateway) do
    Class.new do
      def save(board)
        @board = board
      end

      attr_reader :board
    end.new
  end
  let(:ai_play) { described_class.new(board_gateway: board_gateway) }

  it 'can place a piece' do
    board_gateway.save(Domain::Board.new([[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]))
    ai_play.execute({})
    expect(board_gateway.board.state).to eq(
      [[nil, nil, nil],
       [nil, :X, nil],
       [nil, nil, nil]]
    )
  end

  it 'can play itself for two turns' do
    board_gateway.save(Domain::Board.new([[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]))
    ai_play.execute({})
    ai_play.execute({})
    expect(board_gateway.board.state).to eq(
      [[:O, nil, nil],
       [nil, :X, nil],
       [nil, nil, nil]]
    )
  end

  it 'correctly makes a move in response to an existing board' do
    board_gateway.save(Domain::Board.new([[nil, nil, nil], [nil, nil, :X], [nil, nil, nil]], :X))
    ai_play.execute({})
    expect(board_gateway.board.state).to eq(
      [[nil, nil, :O],
       [nil, nil, :X],
       [nil, nil, nil]]
    )
  end
end
