pragma solidity ^0.8.0;

contract SupplyChain {
    
    event Added(uint256 index);

    struct State {
        string description;
        address person;
    }

    struct Product {
        address creator;
        string productName;
        uint256 productId;
        string date;
        uint256 totalStates;
        mapping (uint256 => State) positions;
    }

    mapping(uint => Product) allProducts;
    uint256 items = 0;

    // Utility function to concatenate two strings
    function concat(string memory _a, string memory _b) public pure returns (string memory) {
        return string(abi.encodePacked(_a, _b));
    }

    // Function to create a new product
    function newItem(string memory _text, string memory _date) public returns (bool) {
        Product storage p = allProducts[items];
        p.creator = msg.sender;
        p.productName = _text;
        p.productId = items;
        p.date = _date;
        p.totalStates = 0;

        emit Added(items);
        items += 1;
        return true;
    }

    // Function to add state or update product status
    function addState(uint _productId, string memory info) public returns (string memory) {
        require(_productId < items, "Product does not exist");

        Product storage p = allProducts[_productId];
        uint256 currentState = p.totalStates;
        p.positions[currentState] = State({
            person: msg.sender,
            description: info
        });

        p.totalStates += 1;
        return info;
    }

    // Function to fetch product details and its history
    function searchProduct(uint _productId) public view returns (string memory) {
        require(_productId < items, "Product does not exist");

        Product storage p = allProducts[_productId];
        string memory output = concat("Product Name: ", p.productName);
        output = concat(output, "<br>Manufacture Date: ");
        output = concat(output, p.date);
        output = concat(output, "<br>Status History:<br>");

        for (uint256 j = 0; j < p.totalStates; j++) {
            output = concat(output, p.positions[j].description);
            output = concat(output, "<br>");
        }

        return output;
    }
}
