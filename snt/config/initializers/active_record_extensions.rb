module ActiveRecordExtensions
  # When ascending order, place null values at the end
  def order_null_last(column, direction = 'asc')
    scoped.order("ISNULL(#{column}) #{direction}").order("#{column} #{direction}")
  end
end

ActiveRecord::Base.extend ActiveRecordExtensions
