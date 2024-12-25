# frozen_string_literal: true

require_relative 'lib/obpm_updator'

OBPMUpdator.new(ARGV[0]).execute
