
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
     mapping(uint256 => _Order) public orders;
     uint256 public orderCount;
     mapping(uint256 => bool) public orderCancelled;


     //Events
     event Deposit(address token, address user, uint256 amount, uint256 balance);
     event Withdraw(address token, address user, uint amount, uint balance);
     event Order(
         uint256 id,
         address user,
         address tokenGet,
         uint256 amountGet,
         address tokenGive,
         uint256 amountGive,
         uint256 timestamp

     );
     event Cancel (
        uint id,
        address user,
        address takenGet,
        uint amountGet,
        address tokenGive,
        uint amountGive,
        uint timestamp
    );


     //struct
    struct _Order {
        uint id;
        address user;
        address tokenGet;
        uint amountGet;
        address tokenGive;
        uint amountGive;
        uint timestamp;


    }
 

     //a way to model the order
     //a way to store the order
     //add the order to storage


     constructor (address _feeAccount, uint256  _feePercent) {
         feeAccount = _feeAccount;
         feePercent = _feePercent;
     }


    //fallback: reverts if ether is sent to this smart contract by mistake
    fallback() external payable {
        revert();
    }





    function depositEther() payable public {

        tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].add(msg.value);
        emit Deposit(ETHER, msg.sender, msg.value, tokens[ETHER][msg.sender]);


    }

    function withdrawEther(uint _amount) public {
        require(tokens[ETHER][msg.sender] >= _amount);
        tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].sub(_amount);
        msg.sender.transfer(_amount);
        emit Withdraw(ETHER, msg.sender, _amount,tokens[ETHER][msg.sender]);
    }


    function withdrawToken(address _token, uint256 _amount) public {
        require(_token != ETHER);
        require(tokens[_token][msg.sender] >= _amount);
        tokens[_token][msg.sender]= tokens[_token][msg.sender].sub(_amount);
        require(Token(_token).transfer(msg.sender, _amount));

    }

    function balanceOf(address _token, address _user) public view returns(uint256){
        return tokens[_token][_user];
    }



     function depositToken(address _tokens, uint _amount) public {
         require(_tokens != ETHER);
        require(Token(_tokens).transferFrom(msg.sender,address(this),_amount));
        tokens[_tokens][msg.sender] = tokens[_tokens][msg.sender].add(_amount);
        emit Deposit(_tokens, msg.sender,_amount,tokens[_tokens][msg.sender]);
     }


     function makeOrder(address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive) public {
            orderCount = orderCount.add(1);
         orders[orderCount] = _Order(orderCount, msg.sender, _tokenGet, _amountGet, _tokenGive, _amountGive,now);
         emit Order(orderCount, msg.sender, _tokenGet, _amountGet, _tokenGive, _amountGive, now);

      

     }


function cancelOrder(uint256 _id) public {
    //must be my orer
    //must be a valid order
    //fetch order 
    _Order storage _order = orders[_id];//fetch it from storage specifially
    require(address(_order.user) == msg.sender);
    require(_order.id == _id);//the order must exist
    orderCancelled[_id] = true;
    emit Cancel(_order.id,msg.sender, _order.takenGet, _order.amountGet);
}

         //which token?
         //how much?
         //track balance
         //manage deposite-update balance
         //emit event
     



     function fillOrder(uint256 _id) public {
         require(_id > 0 && _id <= orderCount);
         require(!orderFilled[_id]);
         require(!orderCancelled[_id]);
         _Order storage _order = orders[_id];
          _trade(_order.id, _order.user, _order.tokenGet, _order.amountGet, _order.tokenGive, _order.amountGive);
         orderFilled[_order.id ] = true;

     }

     function _trade(uint256 _orderId, address _user, address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive) internal {
         //Exchange trade
         uint256 _feeAmount = _amountGive.mul(feePercent).div(100);
         tokens[_tokenGet][msg.sender] = tokens[_tokenGet][msg.sender].sub(_amountGet);
         tokens[_tokenGet][_user] = tokens[_tokenGet][_user].add(_amountGet);
         tokens[_tokenGive][_user] = tokens[_tokenGive][_user].sub(_amountGive);
         tokens[_tokenGive][msg.sender]= tokens[_tokenGive][msg.sender].add(_amountGet);

         //charge fees
         //emit trade event
     }
 }
