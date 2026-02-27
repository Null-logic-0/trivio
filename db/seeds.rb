[
  { symbol: "AAPL", name: "Apple Inc." },
  { symbol: "TSLA", name: "Tesla Inc." },
  { symbol: "AMZN", name: "Amazon.com Inc." },
  { symbol: "NVDA", name: "NVIDIA Corporation" },
  { symbol: "MSFT", name: "Microsoft Corporation" }
].each do |s|
  Stock.find_or_create_by(symbol: s[:symbol]) do |stock|
    stock.name = s[:name]
  end
end
