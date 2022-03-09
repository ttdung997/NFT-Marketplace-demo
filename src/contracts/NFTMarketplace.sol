// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFTCollection.sol";
import "./Token.sol";

contract NFTMarketplace {
    uint256 public offerCount = 0;
    mapping(uint256 => _Offer) public offers;
    mapping(address => uint256) public userFunds;
    mapping(address => uint256[]) public offerListByAddress;
    mapping(uint256 => uint256) public TokenIndex;
    mapping(uint256 => uint256) public offerIndex;
<<<<<<< HEAD
    mapping(uint256 => uint256) public tokenIdToOffer;
    uint256 [] offerList;
    BAoE BATK;

    NFTCollection nftCollection;
    struct _Offer {
        uint256 offerId;
        uint256 id;
        address user;
        uint256 price;
        bool fulfilled;
        bool cancelled;
    }

    event Offer(
        uint256 offerId,
        uint256 id,
        address user,
        uint256 price,
        bool fulfilled,
        bool cancelled
    );

    event OfferFilled(uint256 offerId, uint256 id, address newOwner);
    event OfferCancelled(uint256 offerId, uint256 id, address owner);
    event ClaimFunds(address user, uint256 amount);
    event DonateEvent(address user, uint256 amount);

    constructor(address _nftCollection, address _token) {
        nftCollection = NFTCollection(_nftCollection);
        BATK = BAoE(_token);
    }

=======
    uint256 [] offerList;

    NFTCollection nftCollection;
    struct _Offer {
        uint256 offerId;
        uint256 id;
        address user;
        uint256 price;
        bool fulfilled;
        bool cancelled;
    }

    event Offer(
        uint256 offerId,
        uint256 id,
        address user,
        uint256 price,
        bool fulfilled,
        bool cancelled
    );

    event OfferFilled(uint256 offerId, uint256 id, address newOwner);
    event OfferCancelled(uint256 offerId, uint256 id, address owner);
    event ClaimFunds(address user, uint256 amount);
    event DonateEvent(address user, uint256 amount);

    constructor(address _nftCollection) {
        nftCollection = NFTCollection(_nftCollection);
    }

>>>>>>> bf1cb2ce5726d14b0943822e4f6f425c4c109f84
    function makeOffer(uint256 _id, uint256 _price) public {
        nftCollection.transferFrom(msg.sender, address(this), _id);
        offerCount++;
        offers[offerCount] = _Offer(
            offerCount,
            _id,
            msg.sender,
            _price,
            false,
            false
        );
<<<<<<< HEAD
        tokenIdToOffer[_id] = offerCount;
=======
>>>>>>> bf1cb2ce5726d14b0943822e4f6f425c4c109f84
        offerListByAddress[msg.sender].push(_id);
        uint256 arrayLength = offerListByAddress[msg.sender].length;
        TokenIndex[_id] = arrayLength;
        offerList.push(_id);
        uint256 offerLength = offerList.length;
        offerIndex[_id] = offerLength;
<<<<<<< HEAD
        // emit Offer(offerCount, _id, msg.sender, _price, false, false);
=======
        emit Offer(offerCount, _id, msg.sender, _price, false, false);
>>>>>>> bf1cb2ce5726d14b0943822e4f6f425c4c109f84
    }

    function fromHexChar(uint8 c) public pure returns (uint8) {
        if (bytes1(c) >= bytes1("0") && bytes1(c) <= bytes1("9")) {
            return c - uint8(bytes1("0"));
        }
        if (bytes1(c) >= bytes1("a") && bytes1(c) <= bytes1("f")) {
            return 10 + c - uint8(bytes1("a"));
        }
        if (bytes1(c) >= bytes1("A") && bytes1(c) <= bytes1("F")) {
            return 10 + c - uint8(bytes1("A"));
        }
        return 0;
    }

    function hexStringToAddress(string memory s)
        public
        pure
        returns (bytes memory)
    {
        bytes memory ss = bytes(s);
        require(ss.length % 2 == 0); // length must be even
        bytes memory r = new bytes(ss.length / 2);
        for (uint256 i = 0; i < ss.length / 2; ++i) {
            r[i] = bytes1(
                fromHexChar(uint8(ss[2 * i])) *
                    16 +
                    fromHexChar(uint8(ss[2 * i + 1]))
            );
        }

        return r;
    }

    function toAddress(string calldata s) public pure returns (address) {
        bytes memory _bytes = hexStringToAddress(s);
        require(_bytes.length >= 1 + 20, "toAddress_outOfBounds");
        address tempAddress;

        assembly {
            tempAddress := div(
                mload(add(add(_bytes, 0x20), 1)),
                0x1000000000000000000000000
            )
        }

        return tempAddress;
    }

    function Donate() public payable {
        string memory OwnAddress = "0xACDe144Fd8eFC3c9A9DAFfD6812a1B769e9Da06C";

        payable(this.toAddress(OwnAddress)).transfer(msg.value);
        emit DonateEvent(this.toAddress(OwnAddress), msg.value);
    }

    function checkTokenIndex(uint256 tokenId) public view returns (uint256) {
        return TokenIndex[tokenId];
    }

    function checkOfferIndex(uint256 tokenId) public view returns (uint256) {
        return offerIndex[tokenId];
    }

<<<<<<< HEAD
    function fillOffer(uint256 _offerId, uint256 amount) public {
=======
    function fillOffer(uint256 _offerId) public payable {
>>>>>>> bf1cb2ce5726d14b0943822e4f6f425c4c109f84
        _Offer storage _offer = offers[_offerId];
        require(_offer.offerId == _offerId, "The offer must exist");
        require(
            _offer.user != msg.sender,
            "The owner of the offer cannot fill it"
        );
        require(!_offer.fulfilled, "An offer cannot be fulfilled twice");
        require(!_offer.cancelled, "A cancelled offer cannot be fulfilled");
        require(
<<<<<<< HEAD
            amount == _offer.price,
            "The BAoE amount should match with the NFT Price"
        );
        nftCollection.transferFrom(address(this), msg.sender, _offer.id);
        BATK.transferFrom(msg.sender,_offer.user, amount);
=======
            msg.value == _offer.price,
            "The ETH amount should match with the NFT Price"
        );
        nftCollection.transferFrom(address(this), msg.sender, _offer.id);
        payable(_offer.user).transfer(msg.value);
>>>>>>> bf1cb2ce5726d14b0943822e4f6f425c4c109f84
        _offer.fulfilled = true;

        uint256 token_index = checkTokenIndex(_offer.id);
        uint256 len = offerListByAddress[_offer.user].length;
        if (len == 1) {
            offerListByAddress[_offer.user].pop();
        } else {
            uint256 token_pop = offerListByAddress[_offer.user][len - 1];
            offerListByAddress[_offer.user][token_index] = token_pop;
            offerListByAddress[_offer.user].pop();
            TokenIndex[token_pop] = token_index;
        }

        uint256 offer_index = checkOfferIndex(_offer.id);
        uint256 offerlen = offerList.length;
        if (offerlen == 1) {
            offerList.pop();
        } else {
            uint256 offer_pop = offerList[offerlen - 1];
            offerList[offer_index] = offer_pop;
            offerList.pop();
            offerIndex[offer_pop] = offer_index;
        }
<<<<<<< HEAD

        tokenIdToOffer[_offer.id] = 0;
=======
>>>>>>> bf1cb2ce5726d14b0943822e4f6f425c4c109f84
        // userFunds[_offer.user] += msg.value;
        emit OfferFilled(_offerId, _offer.id, msg.sender);
    }

    function cancelOffer(uint256 _offerId) public {
        _Offer storage _offer = offers[_offerId];
        require(_offer.offerId == _offerId, "The offer must exist");
        require(
            _offer.user == msg.sender,
            "The offer can only be canceled by the owner"
        );
        require(
            _offer.fulfilled == false,
            "A fulfilled offer cannot be cancelled"
        );
        require(
            _offer.cancelled == false,
            "An offer cannot be cancelled twice"
        );
        nftCollection.transferFrom(address(this), msg.sender, _offer.id);
        _offer.cancelled = true;
        uint256 token_index = checkTokenIndex(_offer.id);
        uint256 len = offerListByAddress[msg.sender].length;
        if (len == 1) {
            offerListByAddress[msg.sender].pop();
        } else {
            uint256 token_pop = offerListByAddress[msg.sender][len - 1];
            offerListByAddress[msg.sender][token_index] = token_pop;
            offerListByAddress[msg.sender].pop();
            TokenIndex[token_pop] = token_index;
        }

        uint256 offer_index = checkOfferIndex(_offer.id);
        uint256 offerlen = offerList.length;
        if (offerlen == 1) {
            offerList.pop();
        } else {
            uint256 offer_pop = offerList[offerlen - 1];
            offerList[offer_index] = offer_pop;
            offerList.pop();
            offerIndex[offer_pop] = offer_index;
        }
<<<<<<< HEAD
        tokenIdToOffer[_offer.id] = 0;
=======
>>>>>>> bf1cb2ce5726d14b0943822e4f6f425c4c109f84
        emit OfferCancelled(_offerId, _offer.id, msg.sender);
    }

    function claimFunds() public {
        require(
            userFunds[msg.sender] > 0,
            "This user has no funds to be claimed"
        );
        payable(msg.sender).transfer(userFunds[msg.sender]);
        emit ClaimFunds(msg.sender, userFunds[msg.sender]);
        userFunds[msg.sender] = 0;
    }

    function getNFTOfferList()
        public
        view
        returns (uint256[] memory)
    {
        return offerList;
    }

    function getNFTOfferListByUser(address user)
        public
        view
        returns (uint256[] memory)
    {
        return offerListByAddress[user];
    }

<<<<<<< HEAD
    function getOfferId(uint256 TokenId) view public returns(uint256){
        return tokenIdToOffer[TokenId];
    }

    function getOfferPrice(uint256 TokenId) view public returns(uint256){
        uint256 OfferId = getOfferId(TokenId);
        _Offer storage _offer = offers[OfferId];
        return _offer.price;
    }

=======
>>>>>>> bf1cb2ce5726d14b0943822e4f6f425c4c109f84
    // Fallback: reverts if Ether is sent to this smart-contract by mistake
    fallback() external {
        revert();
    }
}
