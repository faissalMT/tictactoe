# frozen_string_literal: true

module UseCase
  class AiPlay
    def initialize(minimax:, piece_placer:, get_empty_cells:, simulator:)
      @piece_placer = piece_placer
      @minimax = minimax
      @get_empty_cells = get_empty_cells
      @simulator = simulator
      # TODO: Fix this hardcoding so the AI can dynamically choose its piece based on who last played
      @piece = :O
    end

    def execute(*)
      @piece_placer.execute(
        coordinates: @minimax.best_move(
          tree_builder(@get_empty_cells.execute)
        )
      )
    end

    private

    def tree_builder(cells)
      return [] if cells.nil?

      cells.map do |cell|
        score = 10
        status = @simulator.check_status(@piece)
        if status == :tie
          score = 0
        elsif status == :lose
          score = -10
        elsif :incomplete
          score = 0
        end

        @simulator.place_piece(cell)
        node = { score: score,
                 coordinates: cell,
                 children: tree_builder(@simulator.empty_cells) }
        @simulator.undo_piece(cell)
        node
      end
    end
  end
end
