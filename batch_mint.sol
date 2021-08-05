// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;

// batch nft minting
import "./ERC2309.sol";


contract NFTBatchMint is ERC2309 {
    
    
    
    ERC2309 public token;
    
    
    address payable public main_owner;
    
    
    constructor (string memory _name, string memory _symbol, string memory _baseurl, uint256 _qty) ERC2309(_name, _symbol, _baseurl) public {
        main_owner = msg.sender;
         _init(main_owner, _qty);
    }
    
    
    function batchMint() public {
         
         require(msg.sender == main_owner, "Sorry, only owner allowed to mint");
         
         _init(main_owner, 1000);
         
     }
     
    
    
    function getNFTBalance() public view returns (uint){
        
        require(msg.sender == main_owner, "Sorry, only owner allowed to get the balance");
        return token.balanceOf(address(main_owner));
        
    }
    
    
    
    
    
}