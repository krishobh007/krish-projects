json.headers @data[:headers].map { |header|
  if header
    if header.is_a?(Hash)
      {
        value: header[:value].is_a?(Array) ? t(header[:value][0], header[:value][1]) : t(header[:value]),
        span: header[:span] || 1
      }
    else
      { value: header.is_a?(Array) ? t(header[0], header[1]) : t(header), span: 1 }
    end
  end
}

json.sub_headers @data[:sub_headers].andand.map { |header|
  header.is_a?(Array) ? t(header[0], header[1]) : t(header) if header
}

json.results @data[:results]
json.results_total_row @data[:results_total_row]
json.total_count @data[:total_count]
json.summary_counts @data[:summary_counts]
json.totals @data[:totals] do |total|
  json.label total[:label].is_a?(Array) ? t(total[:label][0], total[:label][1]) : t(total[:label])
  json.value total[:value]
end
