# frozen_string_literal: true

describe 'a game of Tic Tac Toe' do
  let(:board_gateway) { InMemoryBoardGateway.new }

  def place_piece
    UseCase::PlacePiece.new(board_gateway: board_gateway)
  end

  def view_board
    UseCase::ViewBoard.new(board_gateway: board_gateway)
  end

  def get_empty_cells
    UseCase::GetEmptyCells.new(board_gateway: board_gateway)
  end

  def ai_play
    UseCase::AiPlay.new(
      minimax: Minimax.new,
      piece_placer: place_piece,
      get_empty_cells: get_empty_cells,
      simulator: SimulatorAdapter.new(
        get_empty_cells: get_empty_cells,
        place_piece: place_piece,
        undo_piece: UseCase::UndoPiece.new(board_gateway: board_gateway),
        check_game_status: UseCase::CheckGameStatus.new(board_gateway: board_gateway)
      )
    )
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

  it 'the AI plays after the user automatically', focus: true do
    place_piece.execute(coordinates: [0, 0])
    ai_play.execute({})
    is_expected.to eq([
                        [:X, nil, nil],
                        [nil, :O, nil],
                        [nil, nil, nil]
                      ])
  end
end
