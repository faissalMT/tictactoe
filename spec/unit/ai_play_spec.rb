# frozen_string_literal: true

describe UseCase::AiPlay do
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

  def minimax_stub(best_move)
    double(best_move: best_move)
  end

  def execute_ai
    ai_player.execute({})
  end

  def ai_player
    described_class.new(
      minimax: @minimax,
      piece_placer: @piece_placer,
      get_empty_cells: @get_empty_cells,
      simulator: @simulator
    )
  end

  before 'setup placeholders' do
    @minimax = spy
    @piece_placer = spy
    @get_empty_cells = spy
    @simulator = spy(empty_cells: [])
  end

  it 'can make the best move specified by minimax (example 1)' do
    @minimax = minimax_stub([1, 2])

    execute_ai

    expect(@piece_placer).to(
      have_received(:execute).with(coordinates: [1, 2])
    )
  end

  it 'can make the best move specified by minimax (example 2)' do
    @minimax = minimax_stub([0, 2])

    execute_ai

    expect(@piece_placer).to(
      have_received(:execute).with(coordinates: [0, 2])
    )
  end

  it 'minimax is aware of possible moves (example 1)' do
    @get_empty_cells = double(execute: [[1, 1]])

    execute_ai

    expect(@minimax).to(
      have_received(:best_move).with(
        [win([1, 1])]
      )
    )
  end

  it 'minimax is aware of possible moves (example 2)' do
    @get_empty_cells = double(execute: [[2, 2]])

    execute_ai

    expect(@minimax).to(
      have_received(:best_move).with(
        [win([2, 2])]
      )
    )
  end

  it 'is aware of multiple best moves' do
    @get_empty_cells = double(execute: [[2, 2], [1, 1]])

    execute_ai

    expect(@minimax).to(
      have_received(:best_move).with(
        [
          win([2, 2]),
          win([1, 1])
        ]
      )
    )
  end

  it 'can determine a loss' do
    @simulator = spy(check_status: :lose, empty_cells: [])
    @get_empty_cells = double(execute: [[2, 2]])

    execute_ai

    expect(@minimax).to(
      have_received(:best_move).with(
        [
          lose([2, 2])
        ]
      )
    )
  end

  it 'can determine a tie' do
    @simulator = spy(check_status: :tie, empty_cells: [])
    @get_empty_cells = double(execute: [[2, 2]])

    execute_ai

    expect(@minimax).to(
      have_received(:best_move).with(
        [
          tie([2, 2])
        ]
      )
    )
  end

  class StubSimulator
    def initialize
      @check_status_returns = [
        nil,
        :win,
        :win
      ]
      @empty_cells_returns = [
        [[2, 2]],
        [],
        []
      ]
      @pieces_placed = []
      @pieces_undone = []
    end

    attr_reader :pieces_placed, :pieces_undone

    def place_piece(coordinates)
      @pieces_placed << coordinates
    end

    def undo_piece(coordinates)
      @pieces_undone << coordinates
    end

    def check_status
      @check_status_returns.shift
    end

    def empty_cells
      @empty_cells_returns.shift
    end
  end

  it 'uses the simulator to create children on the tree' do
    @simulator = StubSimulator.new
    @get_empty_cells = double(execute: [[1, 1], [2, 2]])

    execute_ai

    expect(@minimax).to(
      have_received(:best_move).with(
        [
          move([1, 1], win([2, 2])),
          win([2, 2])
        ]
      )
    )
  end

  it 'places the correct pieces using the simulator' do
    @simulator = StubSimulator.new
    @get_empty_cells = double(execute: [[1, 1], [2, 2]])
    execute_ai

    expect(@simulator.pieces_placed).to eq([[1, 1], [2, 2], [2, 2]])
  end

  it 'places the correct pieces using the simulator' do
    @simulator = StubSimulator.new
    @get_empty_cells = double(execute: [[1, 1], [2, 2]])
    execute_ai

    expect(@simulator.pieces_undone).to eq([[2, 2], [1, 1], [2, 2]])
  end
end
