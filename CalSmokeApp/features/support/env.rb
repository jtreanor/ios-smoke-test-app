# Do not use Calabash pre-defined steps.
require 'calabash-cucumber/wait_helpers'
require 'calabash-cucumber/operations'
World(Calabash::Cucumber::Operations)

require 'rspec'
require 'chronic'
require 'benchmark'

# Pry is not allowed on the Xamarin Test Cloud.  This will force a validation
# error if you mistakenly submit a binding.pry to the Test Cloud.
if !ENV['XAMARIN_TEST_CLOUD']
  require 'pry'
  Pry.config.history.file = '.pry-history'
  require 'pry-nav'
end

module Calabash
  module Cucumber
    module Core
      alias_method :old_query, :query
      def query(uiquery, *args)
        result = nil
        time = Benchmark.realtime do
          result = old_query(uiquery, *args)
        end
        calabash_info "query '#{uiquery}' took #{time*1000} milliseconds"
        result
      end
    end
  end
end
