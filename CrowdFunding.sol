// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {

    struct Proyecto {
        uint32 id;
        string projectName;
        string projectState;
        address payable author;
        uint funds;
        uint fundraisingGoal;    
    }

    Proyecto public deez;

    error CantBeZero(uint256 total);

    event ProjectFunded(
        uint32 projectId,
        uint valueFunded
    );

    event ProjectStateChanged(
        uint32 id,
        string projectState
    );

    constructor (uint32 _id, string memory _projectName, string memory _projectState, uint _fundraisingGoal) {
        deez = Proyecto( _id, _projectName, _projectState,  payable(msg.sender), 0, _fundraisingGoal);
    }

    modifier fundProjectModifier() {
        require(
            msg.sender != deez.author,
            "The owner of the project can't fund it");
            _;
    }

    modifier projectOwner() {
        require(
            msg.sender == deez.author,
            "The state of the project can be changed by the author"
        );
        _;
    }


    function fundProject() public payable fundProjectModifier {
        require(msg.value > 0, "You can't fund the project with 0 eth");
        if(msg.value > 0){
            deez.author.transfer(msg.value);
            deez.funds += msg.value;
            emit ProjectFunded(deez.id, msg.value);
        }
        else {
            revert CantBeZero(msg.value);
        }
        
    }

    function changeProjectState(string calldata _newState) public projectOwner {
        deez.projectState = _newState;
        emit ProjectStateChanged(deez.id, _newState);
    }
}