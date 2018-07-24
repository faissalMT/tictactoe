# frozen_string_literal: true

module UseCase
  class CheckGameStatus
    POSSIBLE_WINS = [[%i[A A A].freeze,
                      [nil, nil, nil].freeze,
                      [nil, nil, nil].freeze].freeze,
                     [[nil, nil, nil].freeze,
                      %i[A A A].freeze,
                      [nil, nil, nil].freeze].freeze,
                     [[nil, nil, nil].freeze,
                      [nil, nil, nil].freeze,
                      %i[A A A].freeze].freeze,
                     [[:A, nil, nil].freeze,
                      [:A, nil, nil].freeze,
                      [:A, nil, nil].freeze].freeze,
                     [[nil, :A, nil].freeze,
                      [nil, :A, nil].freeze,
                      [nil, :A, nil].freeze].freeze,
                     [[nil, nil, :A].freeze,
                      [nil, nil, :A].freeze,
                      [nil, nil, :A].freeze].freeze,
                     [[nil, nil, :A].freeze,
                      [nil, :A, nil].freeze,
                      [:A, nil, nil].freeze].freeze,
                     [[:A, nil, nil].freeze,
                      [nil, :A, nil].freeze,
                      [nil, nil, :A].freeze].freeze].freeze
    def initialize(board_gateway:)
      @board_gateway = board_gateway
    end

    def execute(*)
      grid_full = true
      %i[X O].each do |piece|
        POSSIBLE_WINS.each do |winning_state|
          matches = 0
          winning_state.zip(@board_gateway.board.state).each do |winning_row, board_row|
            winning_row.zip(board_row).each do |winning_cell, board_cell|
              matches += 1 if winning_cell == :A && board_cell == piece
              grid_full = false if board_cell.nil?
            end
          end
          next unless matches == 3
          return { status: :win, winner: piece }
        end
      end
      if grid_full
        { status: :tie }
      else
        { status: :incomplete }
      end
    end
  end
end
