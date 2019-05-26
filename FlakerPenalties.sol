pragma solidity ^0.5.1;
  
contract FlakerPenalties {

    // TODO we should probably be validating meeting dates as > now
    // TODO we need an oracle that allows the contract to observe a no-show (or lateness)
    // and penalise
        // we could have one or both parties report this but that is definitely open to
        // abuse/manipulation
    // TODO ways for the invitee to reschedule
        // we should probably let the inviter set up penalties for that too. that way,
        // if its an invitation going up the social ladder, the invitee should not be
        // penalised, but if its going down it, the invitee may be penalised. The system
        // participants will be able to sort that out themselves :)

    // The wei per minute that must be staked to invite a particular addr out
    mapping(address=>uint) stakeRates;
    // A staked meeting requires a recipient, a date, a stake amount that each party must supply, and whether its been accepted
    struct Meeting {
        // The date of the meeting in unix time
        uint date;
        address payable invitee;
        uint atStake;
        bool happening;
    }
    event MeetingSaved(address inviter, uint meetingID);
    // A mapping from inviters to meeting structs
    mapping(address=>Meeting[]) stakedMeetings;

    function invite(address payable invitee, uint invitedDate, uint duration) public payable {
        require(msg.value >= stakeRates[invitee] * duration, "You must stake more to invite this person - look up their rate");
        stakedMeetings[msg.sender].push(Meeting(invitedDate, invitee, msg.value, false));
        emit MeetingSaved(msg.sender, stakedMeetings[msg.sender].length - 1);
    }

    function accept(address inviter, uint meetingID) public payable {
        require(msg.value >= stakedMeetings[inviter][meetingID].atStake, "You must match the inviter's stake");
        stakedMeetings[inviter][meetingID].happening = true;
    }

    // TODO should the inviter or invitee be able to mark a meeting as done? or should both?
    // Currently giving a 10% penalty for a reschedule by inviter
    function reschedule(uint meetingID, uint newDate) public payable {
        // TODO this should use safemath tbh
        require(msg.value >= stakedMeetings[msg.sender][meetingID].atStake / 10);
        stakedMeetings[msg.sender][meetingID].invitee.transfer(msg.value);
        stakedMeetings[msg.sender][meetingID].date = newDate;
    }

    // Currently giving a 50% penalty for a cancellation by inviter
    function cancel(uint meetingID) public payable {
        // TODO this should use safemath tbh
        require(msg.value >= stakedMeetings[msg.sender][meetingID].atStake / 2);
        stakedMeetings[msg.sender][meetingID].invitee.transfer(msg.value);
        stakedMeetings[msg.sender][meetingID].happening = false;
    }

    // currently going with inviter since its fewer params lol
    function meetingDone(uint meetingID) public {
        msg.sender.transfer(stakedMeetings[msg.sender][meetingID].atStake);
        stakedMeetings[msg.sender][meetingID].invitee.transfer(stakedMeetings[msg.sender][meetingID].atStake);
        stakedMeetings[msg.sender][meetingID].happening = false;
    }
}
