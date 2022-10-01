def maxProfit(self, prices: List[int]) -> int:
	best = 0
	buy = prices[0]
	for i in range(1, len(prices)):
		profit = prices[i] - buy
		best = max(best, profit)
		buy = min(buy, prices[i])
	return best