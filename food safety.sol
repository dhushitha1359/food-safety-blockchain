// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FoodChainTraceability {
    address public owner;
    uint256 public foodItemCount;

    struct FoodItem {
        uint256 id;
        string name;
        string origin;
        string processingDate;
        string expiryDate;
        string currentStatus;
        uint256 timestamp;
    }

    mapping(uint256 => FoodItem) public foodItems;

    event FoodItemAdded(uint256 indexed id, string name, string origin);
    event FoodItemStatusUpdated(uint256 indexed id, string status);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addFoodItem(
        string memory _name,
        string memory _origin,
        string memory _processingDate,
        string memory _expiryDate
    ) public onlyOwner {
        foodItemCount++;
        foodItems[foodItemCount] = FoodItem(
            foodItemCount,
            _name,
            _origin,
            _processingDate,
            _expiryDate,
            "Created",
            block.timestamp
        );
        emit FoodItemAdded(foodItemCount, _name, _origin);
    }

    function updateStatus(uint256 _id, string memory _status) public onlyOwner {
        require(_id > 0 && _id <= foodItemCount, "Invalid ID");
        FoodItem storage item = foodItems[_id];
        item.currentStatus = _status;
        emit FoodItemStatusUpdated(_id, _status);
    }

    function getAllFoodItems()
        public
        view
        returns (
            uint256[] memory ids,
            string[] memory names,
            string[] memory origins,
            string[] memory processingDates,
            string[] memory expiryDates,
            string[] memory statuses,
            uint256[] memory timestamps
        )
    {
        uint256 len = foodItemCount;
        ids = new uint256[](len);
        names = new string[](len);
        origins = new string[](len);
        processingDates = new string[](len);
        expiryDates = new string[](len);
        statuses = new string[](len);
        timestamps = new uint256[](len);

        for (uint256 i = 0; i < len; i++) {
            FoodItem storage item = foodItems[i + 1];
            ids[i] = item.id;
            names[i] = item.name;
            origins[i] = item.origin;
            processingDates[i] = item.processingDate;
            expiryDates[i] = item.expiryDate;
            statuses[i] = item.currentStatus;
            timestamps[i] = item.timestamp;
        }
    }
}