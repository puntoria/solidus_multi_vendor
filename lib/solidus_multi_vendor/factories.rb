# frozen_string_literal: true

FactoryBot.define do
  GEM_ROOT = File.dirname(File.dirname(File.dirname(__FILE__)))

  Dir[File.join(GEM_ROOT, 'spec', 'factories', '**', '*.rb')].sort.each do |factory|
    require(factory)
  end
end
