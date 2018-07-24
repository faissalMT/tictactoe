# frozen_string_literal: true

class SimulatorAdapter
  def initialize(place_piece:, get_empty_cells:, undo_piece:, check_game_status:)
    @get_empty_cells = get_empty_cells
    @place_piece = place_piece
    @undo_piece = undo_piece
    @check_game_status = check_game_status
   end

  def check_status(piece)
    status = @check_game_status.execute({})
    if status[:status] != :incomplete
      :lose if status[:winner] != piece
    end
    # TODO: This should return a :win sometimes
  end

  def place_piece(coordinates)
    @place_piece.execute(coordinates: coordinates)
  end

  def undo_piece(coordinates)
    @undo_piece.execute(coordinates: coordinates)
   end

  def empty_cells
    @get_empty_cells.execute
  end
end
