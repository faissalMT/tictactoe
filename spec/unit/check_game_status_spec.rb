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

    board_gateway.save(Domain::Board.new(winning_board))
    expect(game_status_checker.execute(board_gateway: board_gateway)[:status]).to eq(:win)
  end

  it 'determines a tie for a tying board' do
    tying_board = [
      %i[X O X],
      %i[X O X],
      %i[O X O]
    ]

    board_gateway.save(Domain::Board.new(tying_board))
    expect(game_status_checker.execute(board_gateway: board_gateway)[:status]).to eq(:tie)
  end

  it 'determines the correct winner for a board' do
    winning_board = [
      %i[O O X],
      %i[X O X],
      %i[X O O]
    ]

    board_gateway.save(Domain::Board.new(winning_board))
    expect(game_status_checker.execute(board_gateway: board_gateway)[:winner]).to eq(:O)
  end

  it 'determines the correct status for an incomplete game' do
    incomplete_board = [
      [nil, nil, nil],
      %i[X O X],
      %i[X O O]
    ]

    board_gateway.save(Domain::Board.new(incomplete_board))
    expect(game_status_checker.execute(board_gateway: board_gateway)[:status]).to eq(:incomplete)
  end
end
