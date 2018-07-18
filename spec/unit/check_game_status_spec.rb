# frozen_string_literal: true

describe UseCase::CheckGameStatus do
  let(:board_gateway) do
    Class.new do
      def save(board)
        @board = board
      end

      attr_reader :board
    end.new
  end

  let(:game_status_checker) { described_class.new }
  it 'determines a win for a winning board' do
    winning_board = [
      %i[O O X],
      %i[X X X],
      %i[O X O]
    ]

    board_gateway.save(winning_board)
    expect(game_status_checker.execute(board_gateway: board_gateway)[:status]).to eq(:win)
  end
end
