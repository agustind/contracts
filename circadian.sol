// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;

// batch nft minting
import "./ERC2309.sol";

// CIRCADIAN GALLERY AUCTION SMART CONTRACT
// https://circadian.gallery




// auction contract
contract Circadian is ERC2309 {
    
    
    ERC2309 public token;
    
    
    address payable public main_owner = 0x5BB1468b0519c9A1abbE0C22074CE4862D0862A3;
    
    
    struct Bid {
        uint timestamp;
        address owner;
        uint value;
    }
    
    
    Bid[] public bids;
    
    uint public day;
    uint timeOfTheDay;
    uint public bidCount;
    
    // highest bid
    address payable public  highestAddr;
    uint public highestVal;
    uint public highestDate;
    uint public highestTimeOfTheDay;
    
    
    // events
    event HighestBidIncreased(address bidder, uint amount);
    
    
    constructor () ERC2309("TestingNFT", "CNFT1") public {
        
    }
    
    
    function batchMint() public {
         
         require(msg.sender == main_owner, "Sorry, only owner allowed to mint");
         
         _init(main_owner, 10000);
         
     }
     
    
    function bid() public payable {
        
        
        require(msg.sender != highestAddr, "you_cannot_outbid_yourself");
        
        require(msg.value > 0, "bid_lower_than_minimum");
        
        
        // is useful to have the number of seconds since midnight,
        // to get the time of the day we get the block timestamp
        // and we mod it for the number of seconds within an day
        
        timeOfTheDay = (now % 86400);
        
        // if running for the first time or first bid of the current day
        if(bids.length == 0 || timeOfTheDay < highestTimeOfTheDay){
            
            bidCount = 1;
            day++;
            
            // send NFT to previous day winner, if any and not sent already
            
            
        }else{
            
            
            // if bidding the same day
            
            // check if no higher bid
            require(msg.value > highestVal, "error_higher_bid_exists");
            
            
            bidCount++;
            
            // transfer back to the immediate bid below
            highestAddr.transfer(highestVal);
            
            
        }
        
        
        highestAddr = msg.sender;
        highestVal = msg.value;
        highestDate = now;
        highestTimeOfTheDay = timeOfTheDay;
        
        
        bids.push(Bid(highestDate, highestAddr, highestVal));
        
        
        // trigger event
        emit HighestBidIncreased(msg.sender, msg.value);
        
        
    }
    
    
    //return Array of structure
    function getAllBids() public view returns (Bid[] memory){
        
        return bids;
        
    }
    
    
    function getNFTBalance() public view returns (uint){
        
        require(msg.sender == main_owner, "Sorry, only owner allowed to get the balance");
        
        
        return token.balanceOf(address(this));
        
    }
    
    
    function nftToWinner(address winner) public {
        
        
        // check if the user is a winner
        // approve the transfer of the nft
        approve(winner, 1);
        // transfer the nft to the winner
        safeTransferFrom(main_owner, winner, 1);
        
    }
    
    
    function clear() public {
        
        require(msg.sender == main_owner, "Sorry, only owner allowed to reset");
        
        highestVal = 0;
        highestDate = now;
        highestTimeOfTheDay = 0;
        highestAddr = address(0);
        delete bids;
        
    }
    
    
}