// SPDX-License-Identifier: MIT 

/// contract is supposed to accept ETH funding by anyone and then let the owner withdraw
pragma solidity 0.8.19; 

/// gas efficiency 
contract FundMe {

//// constant read-only calls are cheaper than non-constant variables
//// immutable variables are also lower gas cost 
    uint256 public constant min_ETH = 0.01 * 10 ** 18; 
    address _owner; 
    constructor() {

        _owner = msg.sender; 
    }

    mapping(address => uint256) public funderValue;
    address[] public funders;  
    event funded(address funder, uint _value); 
    event fundWithdrawn(uint _amount); 
    event ownerchanged(address _newOwner); 

    function fund() public payable {
        require(msg.value >= min_ETH);
        funderValue[msg.sender] = msg.value; 
        funders.push(msg.sender); 
        emit funded(msg.sender, msg.value);
    }

    modifier onlyOwner{
        require(msg.sender==_owner,"not the owner");
        _;
    }

    function withdraw() public onlyOwner {
        require (address(this).balance > min_ETH); 
         (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        emit fundWithdrawn(address(this).balance); 
         _setFunderstoZero(); 
    } 

    function changeOwnerToBub(address _newOwner) public onlyOwner{
        _owner = _newOwner;  
        emit ownerchanged(_newOwner);
    }
    
    function _setFunderstoZero() public {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex = funderIndex + 1) {
            address funder = funders[funderIndex]; 
            funderValue[funder] = 0; 
        } 
    } 

}