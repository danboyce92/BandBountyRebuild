const BandBounty = artifacts.require("BandBounty");


contract("BandBounty", (accounts) => {
    before(async () => {
        instance = await BandBounty.deployed()
        
    })

    it("ensures that starting state is Yellow / 1", async () => {
        let state = await instance.state()
        assert.equal(state, 1, "The initial state should be 1 or Yellow")
        debugger; 
    })

    it("Updates state when requested", async () => {
        await instance.setState(2)

        let state = await instance.state()
        assert.equal(state, 2, "Updated state correctly")

    })

    it("Updates Balances", async () => {
        
        await instance.contribute({from: accounts[0], value: 500})

        let balances =  await instance.balances(accounts[0])
        assert.equal(balances, 500, "Not equal to 500")
    })

    it("Updates Balances on different accounts", async () => {

        await instance.contribute({from: accounts[1], value: 400})

        let balances = await instance.balances(accounts[1])
        assert.equal(balances, 400, "Not equal to 400")

    })

    
    it("Updates Balances after multiple purchases", async () => {
        
        await instance.contribute({from: accounts[0], value: 300})

        await instance.contribute({from: accounts[0], value: 500})

        let balances =  await instance.balances(accounts[0])

    
    
        assert.equal(balances, 1300, "balance does not carry over from multiple it statements")
    })
    

    
    it("Compares two balances", async () => {
        
        await instance.contribute({from: accounts[0], value: 500})
        await instance.contribute({from: accounts[1], value: 500})


        let balance1 = await instance.balances(accounts[0])
        let balance2 = await instance.balances(accounts[1])
        
        assert.notEqual(balance1, balance2, "Balances are equal")

    }) 

});
