# frozen_string_literal: true

module UseCase
  class AiPlay
    def initialize(board_gateway:)
      @board_gateway = board_gateway
    end

    def execute(*)
      piece_placer = PlacePiece.new(board_gateway: @board_gateway)
      piece_placer.execute(coordinates: [1, 1])
    end
  end
end
