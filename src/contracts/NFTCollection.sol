//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTCollection is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(address => uint256[]) public nftListByAddress;
    mapping(uint256 => uint256) public TokenIndex;

    constructor() public ERC721("MyNFT", "NFT") {}

    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }

    function mintNFT(address recipient, string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        uint256 arrayLength = nftListByAddress[recipient].length;
        TokenIndex[newItemId] = arrayLength;
        nftListByAddress[recipient].push(newItemId);
        return newItemId;
    }

    function getUserCollectionList(address user)
        public
        view
        returns (uint256[] memory)
    {
        return nftListByAddress[user];
    }

    function checkTokenIndex(uint256 tokenId) public view returns (uint256) {
        return TokenIndex[tokenId];
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        changeOwnerTokenID(from, to, tokenId);
        _transfer(from, to, tokenId);
    }

    function changeOwnerTokenID(
        address from,
        address to,
        uint256 tokenId
    ) public {
        uint256 token_index = checkTokenIndex(tokenId);
        uint256 len = nftListByAddress[from].length;
        if (len == 1) {
            nftListByAddress[from].pop();
        } else {
            uint256 token_pop = nftListByAddress[from][len - 1];
            nftListByAddress[from][token_index] = token_pop;
            nftListByAddress[from].pop();
            TokenIndex[token_pop] = token_index;
        }
        uint256 arrayLength = nftListByAddress[to].length;
        TokenIndex[tokenId] = arrayLength;
        nftListByAddress[to].push(tokenId);
    }
}
