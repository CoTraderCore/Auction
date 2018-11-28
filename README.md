# Not finished!!!

# create Uniswap exchange in console

1) // get exchange instance address
var auction  
Auction.deployed().then(a => auction = a)  
var ex = auction.exchangeAddress()  

2) //get contract
var exchange = UniswapExchange.at('ex)

3) // approve
var token   
Token.deployed().then(t => token = t)  
token.approve(ex, 1000000000000000)  
token.approve('0xb9462ef3441346dbc6e49236edbb0df207db09b7', 1000000000)  

4) // init exchange
exchange.initializeExchange(valueT, {from: accounts[0], value:10000})  
