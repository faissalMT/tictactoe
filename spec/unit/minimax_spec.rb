# frozen_string_literal: true

describe Minimax do
  def win(coordinates)
    { score: 10, coordinates: coordinates, children: [] }
  end

  def lose(coordinates)
    { score: -10, coordinates: coordinates, children: [] }
  end

  def tie(coordinates)
    { score: 0, coordinates: coordinates, children: [] }
  end

  def move(coordinates, *children)
    {
      score: 0,
      coordinates: coordinates,
      children: children
    }
  end

  def expect_best_move_to_be(expected, moves)
    best_move = minimax.best_move(moves)

    expect(best_move).to eq(expected)
  end

  let(:minimax) { Minimax.new }

  it 'can maximise the last move' do
    expect_best_move_to_be(
      [0, 0],
      [win([0, 0])]
    )
  end

  it 'can maximise a different move' do
    expect_best_move_to_be(
      [1, 1],
      [win([1, 1])]
    )
  end

  it 'can maximise from two terminus moves' do
    expect_best_move_to_be(
      [0, 1],
      [
        lose([1, 1]),
        win([0, 1])
      ]
    )
  end

  it 'can maximise with one possible win, one deep' do
    expect_best_move_to_be(
      [0, 1],
      [
        tie([1, 1]),
        move([0, 1], win([1, 2]))
      ]
    )
  end

  it 'can maximise with one possible win, one deep and a win at current depth' do
    expect_best_move_to_be(
      [1, 1],
      [
        win([1, 1]),
        move([0, 1], win([1, 2]))
      ]
    )
  end

  it 'can maximise with one possible win, one deep' do
    expect_best_move_to_be(
      [0, 1],
      [
        tie([1, 1]),
        move([0, 2], tie([1, 2])),
        move([0, 1], win([1, 2]))
      ]
    )
  end

  it 'can maximise with multiple possible wins' do
    expect_best_move_to_be(
      [1, 1],
      [
        move([1, 1], win([2, 2])),
        move([0, 2], tie([1, 2])),
        move([0, 1], win([1, 2]))
      ]
    )
  end

  it 'can maximise with wins at different levels' do
    expect_best_move_to_be(
      [0, 1],
      [
        move([0, 2], move([0, 0], tie([1, 2]))),
        move([0, 1], move([1, 2], win([1, 2])))
      ]
    )
  end

  it 'can maximise with wins at different levels with various children' do
    expect_best_move_to_be(
      [0, 2],
      [
        move([0, 2], move([0, 0], tie([1, 2]), win([2, 2]))),
        move([0, 1], move([1, 2], move([1, 2], win([1, 1]))))
      ]
    )
  end

  it 'can maximise with wins at different levels with many children' do
    expect_best_move_to_be(
      [0, 0],
      [
        move([0, 1], move([1, 2], lose([1, 1]), lose([1, 1]), win([0, 0]))),
        move([0, 0], move([0, 0], move([1, 1], win([2, 2]))))
      ]
    )
  end

  it 'can maximise while reducing possible losses' do
    expect_best_move_to_be(
      [0, 2],
      [
        move([0, 1], win([1, 1]), lose([1, 0])),
        move([0, 2], win([2, 2]))
      ]
    )
  end

  it 'chooses the quickest route to a win' do
    expect_best_move_to_be(
      [0, 0],
      [
        move([0, 2], move([1, 0], win([1, 1]))),
        move([0, 0], win([0, 1]))
      ]
    )
  end
end
