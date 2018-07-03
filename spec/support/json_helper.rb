# frozen_string_literal: true

module JsonHelper
  def json_response
    if (json = JSON.parse(response.body)).is_a?(Array)
      json.map!(&:with_indifferent_access)
    else
      json.with_indifferent_access
    end
  end
end
