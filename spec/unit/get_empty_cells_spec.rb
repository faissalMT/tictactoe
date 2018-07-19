# frozen_string_literal: true

describe UseCase::GetEmptyCells do
  let(:board_gateway) do
    Class.new do
      def save(board)
        @board = board
      end

      attr_reader :board
    end.new
  end

  let(:get_empty_cells) { described_class.new }

  it 'getting cells for an empty grid should return all coordinates' do
    empty_state = [[nil, nil, nil],
                   [nil, nil, nil],
                   [nil, nil, nil]]

    board_gateway.save(Domain::Board.new(empty_state))
    expect(get_empty_cells.execute(board_gateway: board_gateway)).to eq(
      [[0, 0], [1, 0], [2, 0],
       [0, 1], [1, 1], [2, 1],
       [0, 2], [1, 2], [2, 2]]
    )
  end

  it 'getting cells for a full grid of :X should return an empty array' do
    full_state = [
      %i[X X X],
      %i[X X X],
      %i[X X X]
    ]
    board_gateway.save(Domain::Board.new(full_state))
    expect(get_empty_cells.execute(board_gateway: board_gateway)).to eq([])
  end

  it 'getting cells for a full grid of :O should return an empty array' do
    full_state = [
      %i[O O O],
      %i[O O O],
      %i[O O O]
    ]
    board_gateway.save(Domain::Board.new(full_state))
    expect(get_empty_cells.execute(board_gateway: board_gateway)).to eq([])
  end

  it 'getting cells for an assorted grid should be correct' do
    mixed_state = [
      [:X, :O, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
    board_gateway.save(Domain::Board.new(mixed_state))
    expect(get_empty_cells.execute(board_gateway: board_gateway)).to eq([[2, 0],
                                                                         [0, 1], [1, 1], [2, 1],
                                                                         [0, 2], [1, 2], [2, 2]])
  end
end
