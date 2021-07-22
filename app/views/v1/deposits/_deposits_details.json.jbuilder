json.deposits deposits do |deposit|
  json.partial! '/v1/deposits/deposit', locals: { deposit: deposit }
end

