// // SPDX-License-Identifier: Apache-2.0
// pragma solidity ^0.8.20;

// // import '@openzeppelin/contracts/access/Ownable.sol';
// import "@orochi-network/contracts/orocle-v2/interfaces/IOrocleAggregatorV2.sol"';
// import {Ownable} from "./Ownable.sol";

// // contract Context {
// //     // Empty internal constructor, to prevent people from mistakenly deploying
// //     // an instance of this contract, which should be used via inheritance.
// //     constructor() {}

// //     function _msgSender() internal view returns (address payable) {
// //         return payable(msg.sender);
// //     }

// //     function _msgData() internal view returns (bytes memory) {
// //         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
// //         return msg.data;
// //     }
// // }

// // /**
// //  * @dev Contract module which provides a basic access control mechanism, where
// //  * there is an account (an owner) that can be granted exclusive access to
// //  * specific functions.
// //  *
// //  * By default, the owner account will be the one that deploys the contract. This
// //  * can later be changed with {transferOwnership}.
// //  *
// //  * This module is used through inheritance. It will make available the modifier
// //  * `onlyOwner`, which can be applied to your functions to restrict their use to
// //  * the owner.
// //  */
// // contract Ownable is Context {
// //     address private _owner;

// //     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

// //     /**
// //      * @dev Initializes the contract setting the deployer as the initial owner.
// //      */
// //     constructor() {
// //         address msgSender = _msgSender();
// //         _owner = msgSender;
// //         emit OwnershipTransferred(address(0), msgSender);
// //     }

// //     /**
// //      * @dev Returns the address of the current owner.
// //      */
// //     function owner() public view returns (address) {
// //         return _owner;
// //     }

// //     /**
// //      * @dev Throws if called by any account other than the owner.
// //      */
// //     modifier onlyOwner() {
// //         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
// //         _;
// //     }

// //     /**
// //      * @dev Leaves the contract without owner. It will not be possible to call
// //      * `onlyOwner` functions anymore. Can only be called by the current owner.
// //      *
// //      * NOTE: Renouncing ownership will leave the contract without an owner,
// //      * thereby removing any functionality that is only available to the owner.
// //      */
// //     function renounceOwnership() public onlyOwner {
// //         emit OwnershipTransferred(_owner, address(0));
// //         _owner = address(0);
// //     }

// //     /**
// //      * @dev Transfers ownership of the contract to a new account (`newOwner`).
// //      * Can only be called by the current owner.
// //      */
// //     function transferOwnership(address newOwner) public onlyOwner {
// //         _transferOwnership(newOwner);
// //     }

// //     /**
// //      * @dev Transfers ownership of the contract to a new account (`newOwner`).
// //      */
// //     function _transferOwnership(address newOwner) internal {
// //         require(newOwner != address(0), 'Ownable: new owner is the zero address');
// //         emit OwnershipTransferred(_owner, newOwner);
// //         _owner = newOwner;
// //     }
// // }
// contract BnbPriceConsumer is Ownable {
//     IOrocleAggregatorV2 public orocle;

//     event SetOrocle(address indexed oldOrocle, address indexed newOrocle);

//     constructor(address orocleAddress) {
//       _setOrocle(orocleAddress);
//     }

//     // Set the Oracle address (only owner)
//     function setOrocle(address newOrocle) external {
        
//         orocle = IOrocleAggregatorV2(newOrocle);
//         emit SetOrocle(address(orocle), newOrocle);
//     }

//     // Fetch BNB/USD price (18 decimals)
//     function getBnbPrice() public view returns (uint256) {
//         // App ID 1 = Asset Price, Identifier = "BNB"
//         return uint256(orocle.getLatestData(1, bytes20("BNB"))) / 1e9; // Adjust decimals if needed
//     }
// }