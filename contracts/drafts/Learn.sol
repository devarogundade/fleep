// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// TO DO

contract Learn {
    uint private INPUT_FORMAT = 1;
    uint private RADIO_FORMAT = 2;
    uint private CHECKBOX_FORMAT = 3;

    mapping(address => Creator) public creators;
    mapping(address => Learner) public learners;
    mapping(uint256 => Quiz) public quizzes;

    struct Creator {
        string name;
    }

    struct Learner {
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
        uint[] questions;
        uint[] formats; // input or radio or checkbox
        string[] answers;
    }

    function startLearning() public {}

    function submitQuiz() {}

    function createResource(
        string memory name,
        string memory image,
        string memory description,
        uint256 reward,
        uint256 rewardPool,
        address tokenAddress,
        uint[] levels,
        uint cutoff,
        uint startAt,
        uint endAt
    ) public {}

    function deleteResource() public {}
}
