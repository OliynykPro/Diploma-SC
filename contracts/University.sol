// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract University {
    address public admin;
    string public name;
    string public country;
    string public city;
    
    mapping(address => string) public professors;
    address[] public listProfessors;

    mapping(string => Group) public groups;
    string[] public listGroups;

    Subject[] public subjects;

    mapping(bytes32 => Grade[]) private grades;

    struct Subject {
        string name;

        address professor;
        uint createdAt;
    }

    struct Group {
        string name;

        uint8 course;

        uint[] subjects;
        Student[] students;

        uint createAt;
        uint updatedAt;
    }

    struct Student {
        string name;
        address wallet;
        
        bool excluded;
    }

    struct Grade {
        uint8 grade;
        uint8 prevGrade;

        string description;

        uint createdAt;
        uint updatedAt;
    }

    modifier olyAdmin {
        require(msg.sender == admin, "Unathorized");
        _;
    }

    modifier hasGroup(string calldata _id) {
        require(groups[_id].createAt != 0, "Group not found");
        _;
    }

    modifier onlyProfessor(uint _subjectId) {
        require(subjects[_subjectId].professor == msg.sender, "Access denied");
        _;
    }

    modifier validateGrade(uint8 _grade) {
        require(_grade >= 0 && _grade <= 100, "Invalid grade");
        _;
    }

    constructor(
        address _admin,
        string memory _name,
        string memory _country,
        string memory _city
    ) {
        admin = _admin;

        name = _name;
        city = _city;
        country = _country;
    }

    function addProfessor(address _address, string calldata _name) olyAdmin external {
        require(bytes(professors[_address]).length == 0, "Already added");

        professors[_address] = _name;
        listProfessors.push(_address);
    }

    function addSubject(string calldata _name, address _professor) olyAdmin external {
        require(bytes(professors[_professor]).length != 0, "Professor not found");

        subjects.push(Subject(_name, _professor, block.timestamp));
    }

    function addGroup(string calldata _id, string calldata _name, uint8 _course) olyAdmin external {
        Group storage _group = groups[_id];

        require(_group.createAt == 0, "Already added");

        _group.name = _name;
        _group.course = _course;
        _group.createAt = block.timestamp;
    }

    function addStudent(string calldata _id, string calldata _name, address _address) olyAdmin hasGroup(_id) external {
        Group storage _group = groups[_id];

        _group.students.push(Student(_name, _address, false));
    }

    function addSubject(string calldata _id, uint _subjectId) olyAdmin hasGroup(_id) external {
        Group storage _group = groups[_id];

        _group.subjects.push(_subjectId);
    }

    function setGrade(
        address _strudent, 
        uint _subjectId, 
        uint8 _grade
    ) onlyProfessor(_subjectId) validateGrade(_grade)  external  {
        bytes32 _gradeId = getGradeId(_strudent, _subjectId);
        
        Grade[] storage _grades = grades[_gradeId];

        _grades.push(Grade(_grade, 0, "", block.timestamp, 0));
    }

    function updataGrade(
        address _strudent, 
        uint _subjectId, 
        uint _gradeId, 
        uint8 _grade, 
        string calldata _description
    ) onlyProfessor(_subjectId) validateGrade(_grade) external {
        bytes32 _gradeInternalId = getGradeId(_strudent, _subjectId);
        Grade[] storage _grades = grades[_gradeInternalId];
        Grade storage _studentGrade = _grades[_gradeId];

        _studentGrade.prevGrade = _studentGrade.grade;
        _studentGrade.grade = _grade;
        _studentGrade.description = _description;
        _studentGrade.updatedAt = block.timestamp;
    }

    function excludeStudent(string calldata _groupId, uint _studentId) olyAdmin external {
        Group storage _group = groups[_groupId];
        Student storage _student = _group.students[_studentId];

        _student.excluded = true;
    }

    function getStudentSubjectGrades(address _stundent, uint _subjectId) external view returns (Grade[] memory) {
        return grades[getGradeId(_stundent, _subjectId)];
    }

    function metadata() external view returns (
        address admin_,
        string memory name_,
        string memory country_,
        string memory city_
    ) {
        admin_ = admin;
        name_ = name;
        city_ = city;
        country_ = country;
    }

    function getGradeId(address _address, uint _id) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(_address, _id));
    }
}