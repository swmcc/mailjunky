# frozen_string_literal: true

module MailJunky
  module Resources
    class Base
      def initialize(connection)
        @connection = connection
      end

      private

      attr_reader :connection
    end
  end
end
