// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {University} from './University.sol';

contract Factory {
    mapping(address => bool) public createdUniversities;
    mapping(address => bool) public whitelistedUniversities;
    address[] public universities; // Array to store deployed universities

    address public admin;

    modifier onlyWhitelisted(address university) {
        require(whitelistedUniversities[university], "University is not whitelisted");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Unauthorized");
        _;
    }
    
    modifier isWhitelisted() {
        require(whitelistedUniversities[msg.sender], "Not whitelisted");
        _;
    }

    event UniversityCreated(address university, uint256 id);

    function setAdmin(address _admin) external {
        if (admin == address(0)){
            admin = _admin;
        }
    }

    function whitelistUniversity(address _university) onlyAdmin external {
        whitelistedUniversities[_university] = true;
    }

    // Method to get count of universities
    function getUniversityCount() external view returns (uint) {
        return universities.length;
    }

    function createUniversity(
        address _admin,
        string memory _name,
        string memory _country,
        string memory _city
    ) isWhitelisted external  {
        require(!createdUniversities[msg.sender], "Already created");

        University university = new University(
            _admin,
            _name,
            _country,
            _city
        );

        universities.push(address(university)); // Store the university address
        createdUniversities[address(university)] = true; // Automatically whitelist the new university

        emit UniversityCreated(address(university), universities.length - 1);
    }

    // Method to get university data by ID
    function getUniversityById(uint id) external view returns (
        address admin_,
        string memory name_,
        string memory country_,
        string memory city_
    ) {
        require(id < universities.length, "Invalid university ID");

        admin_ = University(universities[id]).admin();
        name_ = University(universities[id]).name();
        country_ = University(universities[id]).country();
        city_ =University(universities[id]).city();
    }
}
