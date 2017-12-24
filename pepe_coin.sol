pragma solidity ^0.4.18;

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

//operations can only be performed by the Chief Operations Officer
    modifier onlyCOO {
        require(msg.sender == COO);
        _;
    }

//Operations can onlny be performed by any Chief Officer.
    modifier onlyC {
        require(
            msg.sender == CEO ||
            msg.sender == CFO ||
            msg.sender == COO
            );
        _;
    }

//All C positions are originally held by contract owner.
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

}


contract pepeCoin is tripartate_ownership {

//In case further changes need be made to a pepe
    struct Pepe {
        uint256 id;
    }

    uint256 next_id;
//Map from pepe id to the owning address
    mapping (uint256 => address) slot_owner;

//Array of all created pepes;
    Pepe[] public pepes ;

//Transfer pepe from owner to new owner
    function transfer(uint256 pepe_id, address to) returns (bool completed){
        if (slot_owner[pepe_id] != msg.sender || slot_owner[pepe_id] == 0x0){
            return false;
        } else {
            slot_owner[pepe_id] = to;
        }
    }

    function admin_transfer(uint256 pepe_id, address to) onlyC returns (bool completed){
        slot_owner[pepe_id] = to;
    }


    function release_slot(){
        
    }
}

