pragma solidity ^0.5.7;

contract Will {
    address owner;
    uint fortune;
    bool deceased;

    //payable helps to send and recieve ether
    constructor() payable public {
        owner = msg.sender; // person who is calling contract(address that is being called).
        fortune = msg.value; // tells how much ether is being sent.
        deceased = false;
    }

    //create modifier so the only person who can call the contract is owner
    modifier onlyOwner{
        require(msg.sender == owner);
        _; // shift to actual function else prevent this.
    }

    // create modifier so that we  allocate funds if gramps deceased
     modifier mustBeDeceased{
        require(deceased == true);
        _; // shift to actual function else prevent this.
    }

    //list of family wallets
    address payable[] familyWallets;

    //map through inheritance
    mapping(address => uint) inheritance;

    //set inheritance for each address
    function setInheritance(address payable wallet, uint amout) public {
        familyWallets.push(wallet);
        inheritance[wallet] = amout;
    }

    //Pay each family member based on their wallet address
    function payout() private mustBeDeceased{
        for( uint i=0; i<familyWallets.length; i++){
            // transferring funds from contract address to receiver address.
            familyWallets[i].transfer(inheritance[familyWallets[i]]);
        }
    }

    function hasDeceased() public onlyOwner{
        deceased = true;
        payout();
    }
}
