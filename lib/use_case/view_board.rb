# frozen_string_literal: true

module UseCase
  class ViewBoard
    def initialize(board_gateway:)
      @board_gateway = board_gateway
    end

    EMPTY_BOARD = [[nil, nil, nil],
                   [nil, nil, nil],
                   [nil, nil, nil]].freeze

    def execute(*)
      {
        board: board? ? board : EMPTY_BOARD
      }
    end

    private

    def board
      @board_gateway.board.state
    end

    def board?
      !@board_gateway.board.nil?
    end
  end
end
