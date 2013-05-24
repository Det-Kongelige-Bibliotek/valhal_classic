# -*- encoding : utf-8 -*-
module Concerns
  module Person
    # handles portrait. Requires the 'concerning' module for person.
    # TODO figure out whether a better solution is possible, e.g. other relationship instead of this hack.
    module Portrait
      extend ActiveSupport::Concern

      # @return all portraits
      def get_all_portraits
        res = []
        concerning_works.each do |work|
          if work.work_type == 'PersonPortrait'
            res << work
          end
        end

        res
      end

      # @return whether any portrait for this person exists
      def has_portrait?
        return get_all_portraits.length > 0
      end
    end
  end
end