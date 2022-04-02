
import { tokens,ether, ETHER_ADDRESS, EVM_REVERT } from "./helpers";

const Token = artifacts.require("./Token");
const Exchange = artifacts.require("./Exchange");

require("chai").use(require("chai-as-promised")).should();
contract("Exchange", ([deployer, feeAccount, user1]) => {
  let token;
  let Exchange;
  const feePercent = 10;

  beforeEach(async () => {
    token = await Token.new();
    //transfer same tokens to user1
    token.transfer(user1, tokens(100), { from: deployer });
    //deploy exchange
    exchange = await Exchange.new(feeAccount, feePercent);
  });

  describe("deployment", () => {
    it("tracks the fee acccount", async () => {
      const result = await exchange.feeAccount();
      result.should.equal(feeAccount);
    });

    it("tracks the fee percent", async () => {
      const result = await exchange.feePercent();
      result.toString().should.equal(feePercent.toString());
    });
  });
  describe('fallback',()=> {
      it('reverts when Ether is sent',async()=> {
          await exchange.sendTransaction({value: 1, from: user1}).should.be.rejectedWith(EVM_REVERT)
      })

      
  })

  describe('depositing Ether', async()=> {
      let result
      let amount

      beforeEach(async ()=> {
          amount = ether(1)
          result = await exchange.depositeEther({from: user1, value: amount})
      })

      it('tracks the Ether deposit', async()=> {
          const balance = await exchange.tokens(ETHER_ADDRESS, user1)
          balance.toString().should.equal(amount.toString())
      })
      it('emits a Deposit event', async()=> {
          const log = result.logs[0]
          log.event.should.eq('Deposit')
          const event = log args
          event.token.should.equal(ETHER_ADDRESS, 'token address is correct')
          event.user.should.equal(user1,'user address is correct')
          event.amount.toString().should.equal(amount.toString(), 'amount is correct')
          event.balance.toString().should.equal(amount.toString(),'balance is correct')
      })
  })

  describe("depositing token", () => {
    let result;
    beforeEach(async () => {
      await token.approve(exchange.address, token(10), { from: user1 });
       result = await exchange.depositeToken(token.address, token(10), {
        from: user1,
      });
    });
    describe("success", () => {
        beforeEach(async ()=> {
            amount = tokens(10)
            await token.approve(exchange.address,amount, {from: user1})
            result = await exchange.depositeToken(token.address, amount, {from:user1})
        })
      it("tracks the token deposit", async () => {
        //check exchange token balance
        let balance;
        balance = await token.balanceOf(exchange.address);
        balance.toString().should.equal(amount.toString());
        //check token on exchange
        balance = await exchange.tokens(token.address, user1);
        balance.toString().should.equal(amount.toString());
      });
      it("emits a Deposite event", async () => {
        const log = result.logs[0];
        log.event.should.eq("deposit");
        const event = log.args
        event.token.should.equal(token.address, 'token address is correct')
        event.user.should.equal(user1,'user address is correct')
        event amount.toString().should.equal(token(10).toString(),'amount is correct')
        event.balance.toString().should.equal(tokens(10).toString(),'balance is correct')

      });
    });
    describe("failure", () => {
        it('rejects ether deposits', async()=> {
            await exchange.depositeToken(ETHER_ADDRESSS.be.rejectedWith(EVM_REVERT)

        })
        it('fails when no tokens are approved', async()=> {
            //don't approve any tokens before depositing 
            await exchange.depositToken(token.address, amount,{from: user1}).should.be.rejectedWith(EVM_REVERT)
        })
    });
  });
});
