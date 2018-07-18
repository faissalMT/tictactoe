# frozen_string_literal: true

module UseCase
  class PlacePiece
    EMPTY_BOARD = [[nil, nil, nil].freeze,
                   [nil, nil, nil].freeze,
                   [nil, nil, nil].freeze].freeze

    def initialize(board_gateway:)
      @board_gateway = board_gateway
    end

    def execute(coordinates:)
      x, y = coordinates

      board = fetch_board
      piece = next_piece(board.last_piece)

      grid = board.state
      grid[y][x] = piece

      @board_gateway.save(Domain::Board.new(grid, piece))
    end

    private

    def fetch_board
      board = @board_gateway.board
      board = Domain::Board.new(EMPTY_BOARD.dup.map(&:dup)) if board.nil?
      board
    end

    def next_piece(last_piece)
      if last_piece == :X
        :O
      elsif last_piece == :O
        :X
      end
    end
  end
end
