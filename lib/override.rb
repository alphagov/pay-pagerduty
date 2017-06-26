class Override < Struct.new(:from, :to, :user_id, :user_name)

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

  def to_json
    payload.to_json
  end
end
