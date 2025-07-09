// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IyamegeDAO {
    address public admin;
    uint256 public proposalCount;

    enum VoteType { None, Yes, No }

    struct Proposal {
        uint256 id;
        string title;
        string description;
        uint256 deadline;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
        mapping(address => VoteType) votes;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => bool) public voters;

    event ProposalCreated(uint256 id, string title, uint256 deadline);
    event VoteCast(address voter, uint256 proposalId, VoteType vote);
    event ProposalExecuted(uint256 proposalId, bool passed);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerVoter(address voter) external onlyAdmin {
        voters[voter] = true;
    }

    function createProposal(string memory title, string memory description) external onlyAdmin {
        proposalCount++;
        Proposal storage p = proposals[proposalCount];
        p.id = proposalCount;
        p.title = title;
        p.description = description;
        p.deadline = block.timestamp + 3 days;

        emit ProposalCreated(p.id, p.title, p.deadline);
    }

    function vote(uint256 proposalId, bool voteYes) external {
        require(voters[msg.sender], "Not registered");
        Proposal storage p = proposals[proposalId];
        require(block.timestamp <= p.deadline, "Voting closed");
        require(p.votes[msg.sender] == VoteType.None, "Already voted");

        if (voteYes) {
            p.yesVotes++;
            p.votes[msg.sender] = VoteType.Yes;
        } else {
            p.noVotes++;
            p.votes[msg.sender] = VoteType.No;
        }

        emit VoteCast(msg.sender, proposalId, p.votes[msg.sender]);
    }

    function executeProposal(uint256 proposalId) external onlyAdmin {
        Proposal storage p = proposals[proposalId];
        require(block.timestamp > p.deadline, "Too early");
        require(!p.executed, "Already executed");

        bool passed = p.yesVotes > p.noVotes;
        p.executed = true;

        emit ProposalExecuted(proposalId, passed);
    }
}
