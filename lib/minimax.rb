# frozen_string_literal: true

class Minimax
  def best_move(nodes)
    nodes = all_nodes(nodes)
    pp nodes.map { |node| node[:score] }
    max_node = nodes.max_by { |x| x[:score] }
    max_node[:coordinates]
  end

  private

  def all_nodes(nodes, depth = 0)
    nodes.each do |node|
      next if node[:children].empty?
      inner_nodes = all_nodes(node[:children], depth + 1)

      node[:score] = inner_nodes.map { |x| x[:score] }.sum - depth
    end
  end
end
