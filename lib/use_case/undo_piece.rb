# frozen_string_literal: true

module UseCase
  class UndoPiece
    def initialize(board_gateway:)
      @board_gateway = board_gateway
    end

    def execute(coordinates:)
      y = coordinates[1]
      x = coordinates[0]

      grid = @board_gateway.board.state
      grid[y][x] = nil
      @board_gateway.save(Domain::Board.new(grid, previous_piece(@board_gateway.board.last_piece)))
    end

    private

    def previous_piece(last_piece)
      if last_piece == :X
        :O
      elsif last_piece == :O
        :X
      end
    end
  end
end
