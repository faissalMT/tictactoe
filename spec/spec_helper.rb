# frozen_string_literal: true

require 'gateway/in_memory_board_gateway'
require 'use_case/view_board'
require 'use_case/place_piece'
require 'use_case/ai_play'
require 'use_case/check_game_status'
require 'domain/board'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  begin
    config.filter_run_when_matching :focus
    config.run_all_when_everything_filtered
    config.warnings = true
    config.default_formatter = 'doc' if config.files_to_run.one?

    config.order = :random

    Kernel.srand config.seed
  end
end
