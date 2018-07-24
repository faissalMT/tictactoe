# frozen_string_literal: true

describe SimulatorAdapter do
  def simulator
    described_class.new(
      place_piece: @place_piece,
      get_empty_cells: @get_empty_cells,
      undo_piece: @undo_piece,
      check_game_status: @check_game_status
    )
  end

  before do
    @undo_piece = spy
    @get_empty_cells = spy
    @place_piece = spy
    @check_game_status = spy
  end

  it 'can delegate to get empty cells (example 1)' do
    @get_empty_cells = double(execute: 1)

    expect(simulator.empty_cells).to eq(1)
  end

  it 'can delegate to get empty cells (example 2)' do
    @get_empty_cells = double(execute: 2)

    expect(simulator.empty_cells).to eq(2)
  end

  it 'can delegate to place piece' do
    simulator.place_piece([0, 0])
    expect(@place_piece).to have_received(:execute).with(coordinates: [0, 0])
  end

  it 'can delegate to undo piece' do
    simulator.undo_piece([0, 0])
    expect(@undo_piece).to have_received(:execute).with(coordinates: [0, 0])
  end

  it 'can check for a win' do
    @check_game_status = double(execute: :win)
    simulator.check_status(:O)
    expect(simulator.check_status).to eq(:win)
  end
end
