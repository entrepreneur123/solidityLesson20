
//deposite and withdraw funds
//manage order
//make order and cancel them
//handle trades-charge fees
//it gonna handle all of our bahavious of exchange

//ToDos:
//[] DEposite Ether
//[] widthdraw Ether
//[] Deposite Toekns
//[] withdraw Tokens
//[] check balances
//[] make order
//[] cancel order
//SPDX-license-Identifier:MIT
pragma solidity ^0.8.1;
import "./Token.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
 contract Exchange {
     using SafeMath for uint;
     //variables
     address public feeAccount;//the account that receives exchange fees
     uint256 public feePercent;//the fee percentage
     address constant ETHER = address(0);//store Ether in tokens mapping with blank address
     mapping(address => mapping(address=> uint256) ) public tokens;

     //Events
     event Deposite(address token, address user, uint256 amount, uint256 balance);

     constructor (address _feeAccount, uint256  _feePercent) {
         feeAccount = _feeAccount;
         feePercent = _feePercent;
     }


    //fallback: reverts if ether is sent to this smart contract by mistake
    function() external {
        revert();
    }



    
    function depositEther() payable public {
        require(Token(_token).transferFrom(msg.sender, address(this), _amount));
        tokens[Ether][msg.sender] = tokens[_token][msg.sender].add(msg.value);
        emit Deposit(ETHER, msg.sender, msg.value, tokens[ETHER][msg.sender]);


    }



     function depositeToken(address _token, uint _amount) public {
         require(_token != ETHER);
        require(Token(_token).transferFrom(msg.sender,address(this),_amount));
        tokens[_token][msg.sender] = tokens[_token][msg.sender].add(_amount);
        emit Deposit(_token, msg.sender,_amount,tokens[_token][msg.sender])

         //which token?
         //how much?
         //track balance
         //manage deposite-update balance
         //emit event
     }
 }
