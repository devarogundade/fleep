// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {FleepToken} from "./FleepToken.sol";

contract Learn {
    FleepToken private _fleepToken;
    address private _deployer;

    uint private CREATOR_FEE;
    uint private INPUT_FORMAT = 1;
    uint private RADIO_FORMAT = 2;
    uint private CHECKBOX_FORMAT = 3;

    mapping(address => Creator) public creators;
    mapping(address => Learner) public learners;
    mapping(uint => Quiz) public quizzes;

    constructor(address fleepToken) {
        _fleepToken = FleepToken(fleepToken);
        _deployer = msg.sender;

        CREATOR_FEE = _inWei(1000);
    }

    struct Creator {
        uint id;
        string name;
        string image;
    }

    struct Learner {
        uint id;
        uint level;
        uint256 earned;
        uint256 totalEarned;
    }

    struct Resource {
        string title;
        string image; // ipfs src
        string description;
        uint256 reward;
        uint256 rewardPool;
        address tokenAddress;
        uint quiz;
        uint[] levels;
        uint cutoff;
        uint createdAt;
        uint startAt;
        uint endAt;
        address creator;
    }

    struct Quiz {
        uint id;
        uint[] questions;
        uint[] formats; // input or radio or checkbox
        string[] answers;
    }

    function startLearning() public onlyLearners {}

    function submitQuiz() public onlyLearners {}

    function createResource(
        string memory name,
        string memory image,
        string memory description,
        uint256 reward,
        uint256 rewardPool,
        address tokenAddress,
        uint[] memory levels,
        uint cutoff,
        uint startAt,
        uint endAt
    ) public onlyCreators {}

    function deleteResource() public onlyCreators {}

    function _inWei(uint256 amount) private pure returns (uint256) {
        return amount * 10 ** 18;
    }

    modifier onlyGuest() {
        require(learners[msg.sender].id == 0, "Only Guest");
        require(creators[msg.sender].id == 0, "Only Guest");
        _;
    }

    modifier onlyLearners() {
        require(learners[msg.sender].id != 0, "Only Provider");
        _;
    }

    modifier onlyCreators() {
        require(creators[msg.sender].id != 0, "Only Provider");
        _;
    }

    modifier onlyDeployer() {
        require(msg.sender == _deployer, "Only Deployer");
        _;
    }
}
