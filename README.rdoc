*was deployed to Heroku, decommissioned as of 2019*

# Backtest v1
"Magic formula", annual rebalance, long only, web app


#### Business case

Full replication of Joel Greenblatt's ["Magic Formula" strategy](https://www.magicformulainvesting.com/Home/AboutTheBook), built over several weekends as a hobby project.

And from another angle, this was my first crack at OOP.

#### Key features

- high-fidelity implementation of the strategy since 1994
- true portfolio simulation with buy/sell transactions, granular accounting for all positions and cash, and proper handling of takeouts/delistings  
- annual rebalancing
- user could select market cap interval, concentration and test period
- dataset encompassing 9,931 stocks, accounting for survivorship bias.

#### Design highlights
*(for readers unfamiliar with Rails, business code that I wrote is in `app/models`, tests are in `spec`, and views in `app/views`; most of the rest is generic Rails infrastructure)*

- highly developed object-oriented abstraction of stock selection and trading process
- in retrospect, this was of course very suboptimal from performance viewpoint, but it was tolerable for annual rebalance, and learning OOP was a much higher priority than speed
- full test coverage, including fabricators for stock prices.
