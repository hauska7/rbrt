module Rbrt::Associations
  def self.build
    {}.tap do |associations|
      def associations.loaded
        select { |_name, association| association.state.loaded? }.tap do |loaded_associations|
          def loaded_associations.names
            keys
          end
        end
      end
      def associations.names
        keys
      end
      def associations.all
        values
      end
      def associations.method_missing(method_name, *args, &block)
        self[method_name]
      end
    end
  end
end
