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
    mapping(uint => Resource) public resources;
    mapping(uint => Quiz) public quizzes;
    mapping(uint => Score) public scores;

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

    struct Score {
        uint id;
        uint quizId;
        uint score;
        uint total;
        uint date;
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
        string[] questions;
        string[] answers;
        uint[] formats; // input or radio or checkbox
    }

    function startLearning() public onlyLearners {}

    function submitQuiz(uint id, string[] memory answers) public onlyLearners {
      // check if user has already took quiz
      // require(scores[])

      string[] memory quizAnswers = quizzes[id].answers;
      uint score = _markQuiz(answers, quizAnswers);
      scores[msg.sender].push(
        Score(
          0,
        );
      )
    }

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

    // == Internal Functions == //

    function _markQuiz(string[] memory answers, string[] memory quizAnswers) private returns (uint, uint) {
        require(answers.length == quizAnswers.length, "Answers must map");

        uint score;
        uint total;

        for (uint index = 0; index < answers.length; index++) {
          if (_compareStrings(answers[index]), (quizAnswers[index])) {
            score++;
          }
          total++;
        }

        return (score, total);
    }

    function _inWei(uint256 amount) private pure returns (uint256) {
        return amount * 10 ** 18;
    }

    function _compareStrings(string memory a, string memory b) private view returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
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
