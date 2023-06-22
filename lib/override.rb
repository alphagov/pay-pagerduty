# frozen_string_literal: true

require 'date'
require 'time'
Override = Struct.new(:from, :to, :user_id, :user_name) do
  def payload
    {
      override: {
        start: from.iso8601,
        end: to.iso8601,
        user: {
          id: user_id,
          type: 'user_reference'
        }
      }
    }
  end

  def to_json(*_args)
    payload.to_json
  end
end
