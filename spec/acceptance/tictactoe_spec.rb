# frozen_string_literal: true

describe 'a game of Tic Tac Toe' do
  let(:board_gateway) { InMemoryBoardGateway.new }

  def place_piece
    UseCase::PlacePiece.new(board_gateway: board_gateway)
  end

  def view_board
    UseCase::ViewBoard.new(board_gateway: board_gateway)
  end

  subject do
    view_board.execute({})[:board]
  end

  it 'it can start a game with an empty board' do
    is_expected.to eq([
                        [nil, nil, nil],
                        [nil, nil, nil],
                        [nil, nil, nil]
                      ])
  end

  it 'Is able to switch between players' do
    place_piece.execute(coordinates: [0, 0])
    place_piece.execute(coordinates: [1, 1])
    is_expected.to eq([
                        [:X, nil, nil],
                        [nil, :O, nil],
                        [nil, nil, nil]
                      ])
  end

  it 'the AI plays after the user automatically' do
    place_piece.execute(coordinates: [0, 0])
    is_expected.to eq([
                        [:X, nil, nil],
                        [nil, :O, nil],
                        [nil, nil, nil]
                      ])
  end
end
