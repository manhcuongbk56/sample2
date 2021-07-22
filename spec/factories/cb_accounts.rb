UUID_GENERATOR = UUID.new

FactoryBot.define do
  factory :cb_account do
    uuid "#{UUID_GENERATOR.generate}-#{Time.now.to_f}"
  end
end

