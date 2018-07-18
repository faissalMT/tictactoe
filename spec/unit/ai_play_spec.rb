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
    ai_play.execute({})
    expect(board_gateway.board.state).to eq(
      [[nil, nil, nil],
       [nil, :X, nil],
       [nil, nil, nil]]
    )
  end

  xit 'can play itself for two turns' do
    ai_play.execute({})
    expect(board_gateway.board.state).to eq(
      [[:O, nil, nil],
       [nil, :X, nil],
       [nil, nil, nil]]
    )
  end
end
