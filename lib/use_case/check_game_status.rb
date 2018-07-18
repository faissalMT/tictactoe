# frozen_string_literal: true

module UseCase
  class CheckGameStatus
    def initialize; end

    def execute(board_gateway:)
      if board_gateway.board == [
        %i[O O X],
        %i[X X X],
        %i[O X O]
      ]
        { status: :win }
      end
    end
  end
end
