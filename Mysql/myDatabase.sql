#Gym Database 
DROP DATABASE IF EXISTS Gym;
CREATE DATABASE Gym;
USE Gym;

#Activities and its associated attributes, notably an activity can have no sponsor 
CREATE TABLE Activities(AID VARCHAR(2) PRIMARY KEY,
 Name VARCHAR(20),
 Max_Capacity INT,
 Start_Time VARCHAR(8),
 End_Time VARCHAR(8));

INSERT INTO Activities VALUES('1a','Weights',5,'06:00:00','20:00:00');
INSERT INTO Activities VALUES('2b','Running',6,'06:00:00','20:00:00');    
INSERT INTO Activities VALUES('3b','Rowing',4,'10:00:00','22:00:00');    
INSERT INTO Activities VALUES('4c','Fencing',2,'10:00:00','22:00:00');    
INSERT INTO Activities VALUES('5c','Swimming',7,'08:00:00','22:00:00');
INSERT INTO Activities VALUES('6c','Walking',7,'08:00:00','22:00:00');

#Sponsors linked to there Actvities a sponsor can only have 1 activity, not all activities have a sponsor e.g 3b
CREATE TABLE SponsoredActivities(AID VARCHAR(2),
 Sponsor_Name VARCHAR(20),
PRIMARY KEY (AID, Sponsor_Name),
FOREIGN KEY (AID) REFERENCES Activities(AID));

INSERT INTO SponsoredActivities VALUES('1a','Heavy_Limited');
INSERT INTO SponsoredActivities VALUES('2b','Gotta_Go_Fast');
INSERT INTO SponsoredActivities VALUES('4c','Pokey_Things');
INSERT INTO SponsoredActivities VALUES('5c','Pro_Water');
INSERT INTO SponsoredActivities VALUES('6c','Pro_Land');


#Types of Rooms and there associated attributes, not all room types are found in the Gym
CREATE TABLE RoomType(RoomTypeID VARCHAR(3) PRIMARY KEY, 
RoomTypeName VARCHAR(20));

INSERT INTO RoomType VALUES('D12','Dry');
INSERT INTO RoomType VALUES('W23','Wet');
INSERT INTO RoomType VALUES('D45','Meeting');
INSERT INTO RoomType VALUES('C11','Dynamic');
INSERT INTO RoomType VALUES('R22','Rented');
INSERT INTO RoomType VALUES('C45','Office');

# Life Guards and there associated attributes, not all guards are assigned to a room but can at max be assigned to  1 room
CREATE TABLE Lifeguards(LID VARCHAR(1) PRIMARY KEY,
Fname VARCHAR(20),
Sname VARCHAR(20));

INSERT INTO Lifeguards VALUES('A','Bill','Real');
INSERT INTO Lifeguards VALUES('B','Jane','Made');
INSERT INTO Lifeguards VALUES('C','Steve','Silly');
INSERT INTO Lifeguards VALUES('D','Haily','Bored');
INSERT INTO Lifeguards VALUES('E','Fred','Still');
INSERT INTO Lifeguards VALUES('F','Sarah','Something');
INSERT INTO Lifeguards VALUES('G','George','Save');
INSERT INTO Lifeguards VALUES('H','Page','Guard');

#Room in the Gym and there associated attributes, they must have 1 life guard have cant not have a type
CREATE TABLE Rooms(RoomID VARCHAR(4) PRIMARY KEY,
Name VARCHAR(10),
LID VARCHAR(1) NOT NULL,
RoomTypeID VARCHAR(3) NOT NULL,
FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID),
FOREIGN KEY (LID) REFERENCES Lifeguards(LID));

INSERT INTO Rooms VALUES('445R','Hawk','A','D12');
INSERT INTO Rooms VALUES('334R','Crow','B','D12');
INSERT INTO Rooms VALUES('556R','Pidgen','C','W23');
INSERT INTO Rooms VALUES('567R','Sparrow','D','W23');
INSERT INTO Rooms VALUES('678R','Eagle','G','C45');
INSERT INTO Rooms VALUES('999G','Owl','H','C11');


# Members Attributes a memeber can only be in 1 room at a time but can be in no rooms
CREATE TABLE Members(MID INT PRIMARY KEY, 
Fname VARCHAR(20),
Sname VARCHAR(20), 
StreetName VARCHAR(20), 
Postcode VARCHAR(20),
Tel VARCHAR(11),
RoomID VARCHAR(4),
FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID));

INSERT INTO Members VALUES(1,'John','Snow','no_nothing','WIN004','31465627137','445R');
INSERT INTO Members VALUES(2,'Ned','Stark','headless_lane','WIN005','31465777767',null);
INSERT INTO Members VALUES(3,'Joffrey','Barathron','evil_street','KGL003','22023453256','334R');
INSERT INTO Members VALUES(4,'Cersei','Lannister','evil_street','KGL003','22023453256','556R');
INSERT INTO Members VALUES(5,'Margaery','Tyrell','garden_avenue','HIG245','66545435446','445R');
INSERT INTO Members VALUES(6,'Brienne','Trath','oathkeeper_street','WIN103','31465653242','445R');
INSERT INTO Members VALUES(7,'Petyr','Baelish','secret_lane','KGL224','22023666766','334R');
INSERT INTO Members VALUES(9,'Hodor','Hodor','hodor_street','HODOR1','40040040004','567R');
INSERT INTO Members VALUES(10,'Daenerys','Targaryen','dragon_road','DRG175','76793739590','567R');

#only be recommended at most once and only can recommed 1 person at most 
CREATE TABLE Endorsorments(Recommender INT, 
Reciever INT,
PRIMARY KEY (Recommender, Reciever),
FOREIGN KEY (Recommender) REFERENCES Members(MID),
FOREIGN KEY (Reciever) REFERENCES Members(MID)); 

INSERT INTO Endorsorments VALUES(1,2);
INSERT INTO Endorsorments VALUES(2,3);
INSERT INTO Endorsorments VALUES(3,6);
INSERT INTO Endorsorments VALUES(10,5);


#members can have mutiple activities and activities can have multiple people 
CREATE TABLE MembersActivities(MID INT,
AID VARCHAR(2),
PRIMARY KEY (MID, AID),
FOREIGN KEY (MID) REFERENCES Members(MID),
FOREIGN KEY (AID) REFERENCES Activities(AID));

INSERT INTO MembersActivities VALUES(1,'1a');
INSERT INTO MembersActivities VALUES(1,'2b');
INSERT INTO MembersActivities VALUES(1,'3b');
INSERT INTO MembersActivities VALUES(1,'5c');
INSERT INTO MembersActivities VALUES(3,'1a');
INSERT INTO MembersActivities VALUES(3,'3b');
INSERT INTO MembersActivities VALUES(4,'2b');
INSERT INTO MembersActivities VALUES(5,'2b');
INSERT INTO MembersActivities VALUES(5,'1a');
INSERT INTO MembersActivities VALUES(6,'5c');
INSERT INTO MembersActivities VALUES(6,'2b');
INSERT INTO MembersActivities VALUES(6,'1a');
INSERT INTO MembersActivities VALUES(7,'2b');
INSERT INTO MembersActivities VALUES(7,'5c');

#Show all rooms and their room types
CREATE VIEW Room_RoomTypes AS SELECT * FROM Rooms NATURAL JOIN RoomType;
# tuples in the rooms tables were compared to Roomtype tuples if the Room type ID corrlated data was grouped togther with a JOIN this was created
# as a view and this was displayed
SELECT * FROM Room_RoomTypes;
#show members with associated activities
CREATE VIEW Member_Activities AS (SELECT * FROM Members NATURAL JOIN (MembersActivities NATURAL JOIN Activities) ORDER BY MID);
#A join was formed between activities and members activities which correlated with AID in both tables the results were then joined to members where
#MID correlated in the two tables this was then created as a view and displayed
SELECT * FROM Member_Activities;
#show ALL activities and any sponsors
CREATE VIEW Activities_Sponsors AS SELECT Activities.AID, Name, Max_Capacity, Start_Time, End_Time, Sponsor_Name FROM Activities  LEFT JOIN SponsoredActivities ON Activities.AID = SponsoredActivities.AID;
#An OUTER join was formed between Activities and SponsoredActivities where AID in both tablkes correlated the result was then made into a view and 
#displayed 
SELECT * FROM Activities_Sponsors;
