# Band-Bounty

## Plan of Action
*Do not hold back with comments.. The reason I have to rebuild is because I did not write enough comments and coming back to older stuff after a while I would easily get lost.*

### Smart Contract Direction
Work through completing functions in following order:
Functions in Yellow state,
Functions in Red state,
Functions in Green state,
Functions in Complete state.
A lot of functions have crossover or are even state irrelevant, follow this as best as possible

*Truffle tests will have to be done without chainlink pricefeed.*
*Make sure to test with chainlink pricefeed through remix after truffle tests are finished*

### Division
Consider breaking entire contract up into smaller easier to digest contracts that are connected via inheritance.
**Possible divisions**
1. BountyFactory
2. Yellow state and Red state functions
3. Green state and Complete state functions
4. Modifiers
5. PriceFeed

#### Yellow state functions
Contribute
Set State


#### Red state functions
Refund

*Important to make sure refund can only be called once*
*Contribute function should be locked in this state*


#### Green state functions
Get on Viplist
Set target

*Standard ticket holders and VIP ticket holders should be marked as such through using their balance (Not by single contribution)*


#### Complete state functions
This state should only be allowed to trigger if target is met.

Close contribution function (This will also prevent expiration from triggering)

Withdraw funds 


### Front-end Display Requirements
*Important information to display-*
Band/Artist
Location/City
Contributor no.
Contract Balance (Funds raised)
Contract state (Early stage, Confirmed, Complete, Expired)
Funds Target
Expiration time / deadline
List of Bounties

*Important functions needed-*
The ability to add funds to a Bounty (contribute)
The ability to claim a standard ticket
The ability to claim a vip ticket(max 1)
Need to create a countdown timer for expiring bounties?




**Tackle next**
Figure out AdminOnly situation. ✓
Create The BountyFactory. ✓
Before deploying decide on what variables need to be public / which ones need to be accessed by frontend
I need a way to convert all wei balances into eth (This can probably be done in front end)



Once those are resolved move on to Front-end.