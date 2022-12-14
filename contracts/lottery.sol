// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

/// @title Basic Smart Contract Lottery
/// @author Frank | Eloi

// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0ocxNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOd;.,oXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOdo;..'lKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXkooo;....:0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKxoooo;.....;OWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0dooooo;......,xNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOdoooooo;'......'oXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOdooooooo;........'lKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXkooooooooo;..........:0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKxoooooooooo;...........;kWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0dooooooooooo;............,xNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOdoooooooooooo;.............'oXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNkdooooooooooooo;...............lKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXkooooooooooooooo;................:0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKxoooooooooooooooo;.................;kWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0dooooooooooooooooo;..................,dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMNOdoooooooooooooooooo;...................'oXMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMXkdooooooooooooooooooo;.....................cKMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMWXxooooooooooooooooollc;.......................:OWMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMWKxoooooooooooooolc:;,'...     ..................;kNMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMW0dooooooooooolc;,'........         ...............,dNMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMNOdooooooolc:;,'............             ............'oXMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMXkooooolc:;,'................                  .........c0WMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMWXxolc:;,'.....................                      ......:OWMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMW0o:;,'.........................                          ...,xWMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMW0o;'...........................                           ..:kNMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMWXOo:'........................                        .,lkKWMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMN0xc,.....................                     .;oONWMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMNXNWMMMMWKko;'.................                 .'cx0WMMMMWK0XWMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMWKOk0XWMMMMWXOd:,..............              .,lkXWMMMWN0xllONMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMNOddxOKNWMMMMN0xl;'..........          ..:d0NMMMMWXOo:,,lKWMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMW0xoooxO0XWMMMMWXOo:'.......       .'cxKWMMMMNKxl;'..;xNMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMXkdoooodk0XNMMMMWN0dc,....    .;oOXWMMMWXOdc,....'c0WMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMN0doooooodxOKNWMMMMWKkl;..':d0NMMMMWKko:'......,dXMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMWKkoooooooooxk0XWMMMMWX00XWMMMMN0xl,'.......':OWMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMNOdoooooooooodxOKNWMMMMMMWXOo:,..........,oXMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKxoooooooooooodxOKNNXKkl;'...........':kNMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXkdoooooooooooooodl:,'.............'lKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0xoooooooooooooo:'..............;xNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXkooooooooooooo:''...........'c0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0dooooooooooo:''..........,dXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKxoooooooooo:''........':OWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOdoooooooo:''.......,oKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKxooooooo:''......;kNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXkdooooo;'.....'l0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0doooo:'....;xXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXkooo:''.'cOWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOdo:'',oXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKx:,:kNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
// MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKdoOWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM

/// @dev Make sure after deployment to add deployed contract address to the subsription as a consumer.

contract Lottery is VRFConsumerBaseV2, Ownable {
    address payable[] public players;
    address[] public winners;
    address payable public lotteryVault;
    uint256 public entryFee = 0.01 ether;

    enum LOTTERY_STATE {
        CLOSED,
        OPEN,
        PICKING_WINNER
    }
    LOTTERY_STATE public lottery_state;
    event WinnerSelected(address winner);

    /// @dev Variables and Events for VRF (verified random number from chainlink).
    uint64 s_subscriptionId;
    uint256[] public requestIds;
    uint256 public lastRequestId;

    /// @dev The gas lane to use, which specifies the maximum gas price to bump to. 200k is max, current function is close to that limit.
    bytes32 keyHash =
        0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
    uint32 callbackGasLimit = 200000;

    /// @dev The default is 3, but can set this higher.
    uint16 requestConfirmations = 3;

    /// @dev Retrieve 1 random value in one request.
    uint32 numWords = 1;

    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);
    struct RequestStatus {
        bool fulfilled;
        bool exists;
        uint256[] randomWords;
    }
    mapping(uint256 => RequestStatus) public s_requests; /* requestId --> requestStatus */
    VRFCoordinatorV2Interface COORDINATOR;

    /// @dev currently hard-coded for Goerli Testnet.
    constructor(uint64 subscriptionId)
        VRFConsumerBaseV2(0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D)
    {
        COORDINATOR = VRFCoordinatorV2Interface(
            0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D
        );
        s_subscriptionId = subscriptionId;
    }

    /// @notice Setting lottery vault address, orignally set to owner
    function setLotteryVault(address payable vault) external onlyOwner {
        lotteryVault = vault;
    }

    /// @notice Function called by tx signer to enter the lottery.
    function enter() public payable {
        require(lottery_state == LOTTERY_STATE.OPEN);
        require(msg.value >= entryFee, "Not enough ETH!");
        players.push(payable(msg.sender));
    }

    /// @notice Function used to toggle the status of the lottery to OPEN.
    function startLottery() public onlyOwner {
        require(
            lottery_state == LOTTERY_STATE.CLOSED,
            "Can't start a new lottery yet!"
        );
        lottery_state = LOTTERY_STATE.OPEN;
    }

    /// @notice Function used to end the lottery, chain reaction to select random number.
    function endLottery() public onlyOwner {
        require(
            lottery_state != LOTTERY_STATE.PICKING_WINNER,
            "Can't select a winner during current draw!"
        );
        lottery_state = LOTTERY_STATE.PICKING_WINNER;
        requestRandomWords();
    }

    /// @notice Assumes the subscription is funded sufficiently.
    function requestRandomWords() internal returns (uint256 requestId) {
        /// Will revert if subscription is not set and funded.
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        s_requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    /// @dev Chainlink VRF fulfills the request and returns the random values to your contract in a callback to the fulfillRandomWords() function.
    /// At this point, a new key requestId is added to the mapping s_requests.
    /// @notice Function used to fullfill the random number request, pay out winner, and reset for next lottery.
    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        require(s_requests[_requestId].exists, "request not found");
        require(
            lottery_state == LOTTERY_STATE.PICKING_WINNER,
            "State is not calculating winner!"
        );
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
        emit RequestFulfilled(_requestId, _randomWords);

        /// Lottery drawing.
        uint256 indexOfWinner = _randomWords[0] % players.length;
        winners.push(players[indexOfWinner]);
        emit WinnerSelected(players[indexOfWinner]);

        /// Transfer balance.
        players[indexOfWinner].transfer((address(this).balance * 95) / 100);
        lotteryVault.transfer(address(this).balance);

        /// Reset.
        players = new address payable[](0);
        lottery_state = LOTTERY_STATE.CLOSED;
    }
}
