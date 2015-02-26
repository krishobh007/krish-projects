require ::File.expand_path('../../../config/environment',  __FILE__)

namespace :six_payment do 
  
  desc "Six payment server starts"
  task :start_payment_processor do
    SixPayment::ThreeCIntegra::PaymentProcessor.start
  end  
end