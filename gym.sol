pragma solidity ^0.4.21;

contract GymMachineRental{

    uint timeSlot = 30 minutes;

    event reserve(uint slotNo, address cust, uint machineNum);

    struct Reservation {
        uint slotNo;
        address cust;
        uint machineNum;
    }

    address owner;
    uint pricePerSlot;
    uint time;
    uint totalMachines;
    Reservation[] reservation;

    constructor(uint pricePerSlot2, uint totalMachines2) public{
        pricePerSlot = pricePerSlot2;
        owner = msg.sender;
        time = now;
        totalMachines = totalMachines2;
        reservation.push(Reservation(0,0,0)); 
    }

    function slotBook(uint slotNo2, uint machineNum) public payable{
        for(uint i=0 ; i < reservation.length; i++){
            if(reservation[i].slotNo == slotNo2){
                revert();
            }
        }
        if(msg.value < pricePerSlot){
            revert();
        }
        reservation.push(Reservation(slotNo2,msg.sender,machineNum));

        emit reserve(slotNo2, msg.sender, machineNum);
    }

    function withdrawMoney() public{
        if(msg.sender != owner ){
            return;                
        }
        selfdestruct(owner);
    }

    function validate(address cust2) public view returns (bool) {
        uint currentSlot = uint((now-time) / timeSlot) + 1;

        for(uint i = 0; i < reservation.length; i++){
            if(reservation[i].cust == cust2 && reservation[i].slotNo == currentSlot){
                return true;
            }
            return false;
        }
    }

    function addMachine() public{
        if(msg.sender != owner ){
            return;                
        }else{
            totalMachines++;
        }
    }

}