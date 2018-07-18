# frozen_string_literal: true

shared_examples 'a board gateway' do
  it do
    gateway = described_class.new
    board = Domain::Board.new
    gateway.save(board)
    expect(gateway.board).to eq(board)
  end
end

describe InMemoryBoardGateway do
  it_behaves_like 'a board gateway'
end
