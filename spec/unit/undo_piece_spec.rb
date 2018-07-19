# frozen_string_literal: true

describe UseCase::UndoPiece do
  let(:board_gateway) do
    Class.new do
      def save(board)
        @board = board
      end

      attr_reader :board
    end.new
  end

  let(:undo_piece) do
    described_class.new(board_gateway: board_gateway)
  end

  it 'Undoes a piece from the board' do
    board_gateway.save(Domain::Board.new([[nil, :O, nil],
                                          [nil, nil, nil],
                                          [nil, nil, nil]], :O))

    undo_piece.execute(coordinates: [1, 0])

    expect(board_gateway.board.state).to eq([[nil, nil, nil],
                                             [nil, nil, nil],
                                             [nil, nil, nil]])
  end

  it 'undoes a piece from a filled board' do
    board_gateway.save(Domain::Board.new([%i[X O X],
                                          %i[O X X],
                                          %i[X O O]], :O))

    undo_piece.execute(coordinates: [0, 1])

    expect(board_gateway.board.state).to eq([%i[X O X],
                                             [nil, :X, :X],
                                             %i[X O O]])
  end

  it 'correctly undoes the setting of last_piece for :O' do
    board_gateway.save(Domain::Board.new([%i[X O X],
                                          %i[O X X],
                                          %i[X O O]], :O))
    undo_piece.execute(coordinates: [1, 2])
    expect(board_gateway.board.last_piece).to eq(:X)
  end

  it 'correctly undoes the setting of last_piece for :X' do
    board_gateway.save(Domain::Board.new([%i[X O X],
                                          %i[O X X],
                                          %i[X X O]], :X))
    undo_piece.execute(coordinates: [1, 2])
    expect(board_gateway.board.last_piece).to eq(:O)
  end
end
