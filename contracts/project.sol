// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DigitalArtRoyaltyManager {
    struct Art {
        uint256 id;
        address payable artist;
        uint256 price;
        uint256 royaltyPercentage;
    }
    
    mapping(uint256 => Art) public artworks;
    uint256 public nextArtId;
    
    event ArtRegistered(uint256 id, address artist, uint256 price, uint256 royaltyPercentage);
    event ArtSold(uint256 id, address buyer, uint256 price);
    
    function registerArt(uint256 price, uint256 royaltyPercentage) public {
        require(royaltyPercentage <= 100, "Invalid royalty percentage");
        artworks[nextArtId] = Art(nextArtId, payable(msg.sender), price, royaltyPercentage);
        emit ArtRegistered(nextArtId, msg.sender, price, royaltyPercentage);
        nextArtId++;
    }
    
    function purchaseArt(uint256 artId) public payable {
        Art storage art = artworks[artId];
        require(msg.value >= art.price, "Insufficient funds");
        
        uint256 royaltyAmount = (msg.value * art.royaltyPercentage) / 100;
        art.artist.transfer(royaltyAmount);
        payable(msg.sender).transfer(msg.value - royaltyAmount);
        
        emit ArtSold(artId, msg.sender, msg.value);
    }
}
