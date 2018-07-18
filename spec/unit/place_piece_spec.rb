# frozen_string_literal: true

describe UseCase::PlacePiece do
  let(:place_piece) do
    described_class.new(board_gateway: board_gateway)
  end

  let(:board_gateway) { spy(board: nil) }

  it 'places the first move as an X in the correct position' do
    place_piece.execute(coordinates: [0, 0])

    expect(board_gateway).to have_received(:save) do |board|
      expect(board.piece_at(0, 0)).to eq(:X)
    end
  end

  it 'does not place items in the wrong place' do
    place_piece.execute(coordinates: [0, 0])

    expect(board_gateway).to have_received(:save) do |board|
      expect(board.piece_at(1, 1)).not_to eq(:X)
    end
  end

  it 'places an piece in the middle' do
    place_piece.execute(coordinates: [1, 1])

    expect(board_gateway).to have_received(:save) do |board|
      expect(board.piece_at(1, 1)).to eq(:X)
    end
  end

  context do
    let(:board_gateway) do
      Class.new do
        def save(board)
          @board = board
        end

        attr_reader :board
      end.new
    end

    it 'stores the last piece on the board' do
      place_piece.execute(coordinates: [0, 0])
      board = board_gateway.board

      expect(board.last_piece).to eq(:X)
    end

    it 'stores the last piece after multiple pieces were placed on the board' do
      place_piece.execute(coordinates: [0, 0])
      place_piece.execute(coordinates: [2, 2])
      board = board_gateway.board

      expect(board.last_piece).to eq(:O)
    end

    it 'alternates between :X and :O when placing pieces' do
      place_piece.execute(coordinates: [0, 0])
      place_piece.execute(coordinates: [1, 1])

      board = board_gateway.board

      expect(board.piece_at(0, 0)).to eq(:X)
      expect(board.piece_at(1, 1)).to eq(:O)
    end
  end
end
