# frozen_string_literal: true

module UseCase
  class GetEmptyCells
    def initialize(board_gateway:)
      @board_gateway = board_gateway
    end

    def execute
      empty_cells = []
      @board_gateway.board.state.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          empty_cells.append([x, y]) if cell.nil?
        end
      end
      empty_cells
    end
  end
end
