# frozen_string_literal: true

module UseCase
  class AiPlay
    def initialize(board_gateway:, piece: :O)
      @board_gateway = board_gateway
      @piece = next_piece(board_gateway.board.last_piece)
      @game_status_getter = UseCase::CheckGameStatus.new
      @empty_cell_getter = UseCase::GetEmptyCells.new
      @piece_placer = UseCase::PlacePiece.new(board_gateway: board_gateway)
      @piece_undoer = UseCase::UndoPiece.new(board_gateway: board_gateway)
    end

    def execute(*)
      @piece_placer.execute(coordinates: minimax(@board_gateway)[:move])
    end

    private

    def next_piece(last_piece)
      if last_piece == :X
        :O
      elsif last_piece == :O
        :X
      end
    end

    def minimax(board_gateway)
      empty_cells = @empty_cell_getter.execute(board_gateway: board_gateway)
      game_status = @game_status_getter.execute(board_gateway: board_gateway)

      if game_status[:status] == :win
        if game_status[:winner] == @piece
          return { score: 1 }
        else
          return { score: -1 }
        end
      elsif game_status[:status] == :tie
        return { score: 0 }
      end

      moves = []
      empty_cells.each do |free_space|
        @piece_placer.execute(coordinates: free_space)
        moves.append(move: free_space, score: minimax(board_gateway)[:score])
        @piece_undoer.execute(coordinates: free_space)
      end

      if board_gateway.board.last_piece == @piece
        moves.max_by { |x| x[:score] }
      else
        moves.min_by { |x| x[:score] }
      end
    end
  end
end
