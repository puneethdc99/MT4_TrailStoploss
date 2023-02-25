// Trailing Stop Loss Expert Advisor for MT4

extern double TrailStart = 30; // Trail start in pips
extern double TrailStop = 10; // Trail stop in pips
extern double LotSize = 0.01; // Fixed lot size for each trade
extern int MagicNumber = 123; // Unique identifier for trades

void OnTick()
{
    // Check open positions for the current symbol and timeframe
    for (int i = 0; i < OrdersTotal(); i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
            {
                // Calculate current profit in pips
                double profit = (OrderType() == OP_BUY) ? (Bid - OrderOpenPrice()) / Point : (OrderOpenPrice() - Ask) / Point;

                // Set trailing stop loss
                if (profit >= TrailStart && OrderStopLoss() < Bid - TrailStop * Point && OrderType() == OP_BUY)
                {
                    double newStopLoss = Bid - TrailStop * Point;
                    OrderModify(OrderTicket(), OrderOpenPrice(), newStopLoss, OrderTakeProfit(), 0, Green);
                }
                else if (profit >= TrailStart && OrderStopLoss() > Ask + TrailStop * Point && OrderType() == OP_SELL)
                {
                    double newStopLoss = Ask + TrailStop * Point;
                    OrderModify(OrderTicket(), OrderOpenPrice(), newStopLoss, OrderTakeProfit(), 0, Red);
                }
            }
        }
    }
}

void OnTrade()
{
    // Check for new trades and add trailing stop loss
    for (int i = 0; i < OrdersTotal(); i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
            {
                double stopLoss = (OrderType() == OP_BUY) ? Bid - TrailStop * Point : Ask + TrailStop * Point;
                OrderModify(OrderTicket(), OrderOpenPrice(), stopLoss, OrderTakeProfit(), 0, Blue);
            }
        }
    }
}
