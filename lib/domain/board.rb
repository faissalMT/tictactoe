# frozen_string_literal: true

module Domain
  class Board
    def initialize(state = [[:X, nil, nil],
                            [nil, nil, nil],
                            [nil, nil, nil]],
                   last_piece = :O)
      @state = state
      @last_piece = last_piece
    end

    def piece_at(x, y)
      @state[y][x]
    end

    attr_reader :last_piece

    attr_reader :state
  end
end
