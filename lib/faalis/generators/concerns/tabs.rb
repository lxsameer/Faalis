module Faalis
  module Generators
    module Concerns
      # Using this **concern** module user can specify an array of tab objects
      # which each one has an `id` and `name` attribute. Tabs will be added to
      # **new** view of resource. Also this concern will a `tab` key to field
      # object. All the fields with same `id` as a tab will be grouped in that
      # tab
      module Tabs

        def self.included(base)
          # Add tabs to 'new' view of scaffold. format: --tabs tab1:'field1;field2',tab2 Note: __all__ field include all fileds.
          #base.class_option :tabs, :type => :string, :default => "", :desc => "Add tabs to 'new' view of scaffold. format: --tabs tab1:'field1;field2',tab2 Note: __all__ field include all fileds."
        end

        private

        # Process the user provided tabs
        # @return a Hash of tabs like
        def tabs
          if resource_data.include? "tabs"
            tabs = resource_data"tabs"
            result = {}
            tabs.each do |tab|
              name = tab["name"]
              fields_list = fields_with("tab", tab["id"])
              result[name] = fields_list
            end
            return result
          else
            {}
          end
        end

        def any_tabs?
          resource_data.include? "tabs"
        end

      end
    end
  end
end