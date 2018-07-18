# frozen_string_literal: true

class InMemoryBoardGateway
  def save(board)
    @board = board
  end

  attr_reader :board
end
