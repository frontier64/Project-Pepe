pragma solidity ^0.4.18;

/*
 * Define the basics of tripartate ownership
 */
contract tripartate_ownership {

    address public CEO;
    address public CFO;
    address public COO;

//Operations can only be performed by the Chief Executive Officer
    modifier onlyCEO {
        require(msg.sender == CEO);
        _;
    }

//Operations can only be performed by the Chief Financial Officer
    modifier onlyCFO {
        require(msg.sender == CFO);
        _;
    }

//Operations can only be performed by the Chief Operations Officer
    modifier onlyCOO {
        require(msg.sender == COO);
        _;
    }

//Operations can only be performed by a Chief Officer.
    modifier onlyC {
        require(
            msg.sender == CEO ||
            msg.sender == CFO ||
            msg.sender == COO
            );
        _;
    }

//All Chief Officer positions are originally held by contract owner.
    function tripartate_ownership() {
        CEO = msg.sender;
        CFO = msg.sender;
        COO = msg.sender;
    }

//Transfer CEO status to new account. Only available to current CEO
    function transferCEO(address _newCEO) public onlyCEO {
        CEO = _newCEO;
    }

//Transfer CFO status to new account. Only available to current CFO and CEO
    function transferCFO(address _newCFO) public {
        if (msg.sender == CEO || msg.sender == CFO){
            CFO = _newCFO;
        }
    }

//Transfer COO status to new account. Only available to current COO and CEO
    function transferCOO(address _newCOO) public {
        if (msg.sender == CEO || msg.sender == COO){
            COO = _newCOO;
        }
    }

//CFO can get all the ether currently in the contract
    function getEther(uint256 amount) public onlyCFO{
        CFO.transfer(amount);
    }

//Return the amount of wei in the contract
    function amountEther() constant public onlyC{
        return this.balance;
    }

}


contract pepeCoin is tripartate_ownership {


    event slot_released(address slot_owner, uint256 pepe_id);
//In case further changes need be made to a pepe
    struct Pepe {
        uint256 id;
    }

    uint256 next_id;
//Map from pepe id to the owning address
    mapping (uint256 => address) slot_owner;
    mapping (address => uint256) amount_bid;
//Array of all created pepes;

    address max_bidder;
    Pepe[] public pepes;

//Transfer pepe from owner to new owner
    function transfer(uint256 pepe_id, address to) returns (bool completed) public{
        if (slot_owner[pepe_id] != msg.sender || slot_owner[pepe_id] == 0x0){
            return false;
        } else {
            slot_owner[pepe_id] = to;
        }
    }

    function admin_transfer(uint256 pepe_id, address to) onlyC returns (bool completed) public {
        slot_owner[pepe_id] = to;
    }


//Release the next pepe to the current max bidder.
    function release_slot() public{
        if (amount_bid[max_bidder] == 0){
            return false;
        }
        slot_owner[next_id] = max_bidder;
        amount_bid[max_bidder] = 0;
        slot_released(max_bidder, next_id);
        next_id += 1;
        return true;
    }

    function take_bid() public payable{
        if (msg.value > 0){
           amount_bid[msg.sender] += msg.value;
           return true;
        }
        return false;
    }
}

