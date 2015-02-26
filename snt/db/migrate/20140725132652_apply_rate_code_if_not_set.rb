class ApplyRateCodeIfNotSet < ActiveRecord::Migration
  def change
    execute('update rates set rate_code = rate_name where rate_code is null')
  end
end
