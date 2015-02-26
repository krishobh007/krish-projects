class AsyncCallback < ActiveRecord::Base
  attr_accessible :origin, :request, :response
  
  belongs_to :origin, polymorphic: true
  
  serialize :request
  serialize :response
end
