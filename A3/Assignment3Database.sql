DROP TABLE PhoneDeliveryOrder;
DROP TABLE PhonePickupOrder
DROP TABLE WalkInOrder;
DROP TABLE OrderItems;
DROP TABLE Orders;
DROP TABLE InStoreShift;
DROP TABLE DriverShift;
DROP TABLE DriverPay;
DROP TABLE InStorePay;
DROP TABLE Driver;
DROP TABLE InStore;
DROP TABLE Customer;
DROP TABLE MenuItemComposition;
DROP TABLE MenuItem;
DROP TABLE IngredientOrders;
DROP TABLE Ingredient;
DROP TABLE StockOrder;

--StockOrder(StockOrderNumber, DateOrdered, DateReceived, Status)
--Primary Key StockOrderNumber


CREATE TABLE StockOrder (
	StockOrderNumber		CHAR(10)	NOT NULL	PRIMARY KEY,
	DateOrdered				DATE		NOT NULL,
	DateReceived			DATE,
	OrderStatus				CHAR(2)		NOT NULL	DEFAULT	'PR',	--PR means purchased but not received
	CONSTRAINT dteChk			CHECK (DateReceived > DateOrdered),
);

--Ingredient(IngredientCode, Name, Description, Type, SuggestedReorderLevel, SuggestedStockLevel)
--Primary Key IngredientCode 


CREATE TABLE Ingredient (
	IngredientCode			CHAR(10)	NOT NULL	PRIMARY KEY,
	IngredientName			VARCHAR(30)	NOT NULL,
	IngredientType			VARCHAR(30),
	SuggestedReorderLevel	INTEGER,
	SuggestedStockLevel		INTEGER,
	CONSTRAINT sggstReorderPos	CHECK(SuggestedReorderLevel>0),
	CONSTRAINT sggstStckPos		CHECK(SuggestedStockLevel>0)
);

--IngredientOrders(StockOrderNumber, IngredientCode, Quantity, Price) 
--Primary Key StockOrderNumber, IngredientCode  
--Foreign Key StockOrderNumber references StockOrder(StockOrderNumber) ON UPDATE CASCADE ON DELETE CASCADE
--Foreign Key IngredientCode 

CREATE TABLE IngredientOrders (
	StockOrderNumber		CHAR(10)	 NOT NULL,
	IngredientCode			CHAR(10)	 NOT NULL,
	Quantity				INTEGER		 NOT NULL,
	Price					DECIMAL(6,2) NOT NULL,
	PRIMARY KEY (StockOrderNumber, IngredientCode),
	CONSTRAINT fkStkOrd		FOREIGN KEY(StockOrderNumber)	REFERENCES	StockOrder(StockOrderNumber)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fkIng		FOREIGN KEY(IngredientCode)		REFERENCES	Ingredient(IngredientCode)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT qntyPos			CHECK(Quantity>0),
	CONSTRAINT prcePos			CHECK(Price>=0)
);

--MenuItem(MenuItemCode, Name, Size, SellingPrice)
--Primary Key MenuItemCode

CREATE TABLE MenuItem (
	MenuItemCode			CHAR(10)	NOT NULL	PRIMARY KEY,
	MenuItemName			VARCHAR(35)	NOT NULL,
	Size					CHAR(1)		NOT NULL,
	SellingPrice			DECIMAL(5,2),
	Description				VARCHAR(50),
	
	CONSTRAINT szechk			CHECK(Size IN ('S','M','L')),
	CONSTRAINT sellprcePos		CHECK(SellingPrice >= 0),
);

--MenuItemComposition(MenuItemCode, IngredientCode, Quantity)
--Primary Key MenuItemCode, IngredientCode 
--Foreign Key MenuItemCode References MenuItem(MenuItemCode) ON UPDATE CASCADE ON DELETE CASCADE
--Foreign Key IngredientCode references Ingredient(IngredientCode) ON UPDATE CASCADE ON DELETE CASCADE 


CREATE TABLE MenuItemComposition (
	MenuItemCode			CHAR(10)	NOT NULL,
	IngredientCode			CHAR(10)	NOT NULL,
	Quantity				INTEGER		NOT NULL,

	PRIMARY KEY(MenuItemCode, IngredientCode),
	CONSTRAINT fkmnuitem	FOREIGN KEY(MenuItemCode)		REFERENCES MenuItem(MenuItemCode)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fkingcode	FOREIGN KEY(IngredientCode)		REFERENCES Ingredient(IngredientCode)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT qntpos		CHECK(Quantity > 0)
);

--Customer(CustomerID, PhoneNumber, FirstName, LastName, isHoax, AddressStreet, AddressCity, AddressPostcode) 
--Primary Key CustomerID 
--Alternate Key Phone Number 


CREATE TABLE Customer (
	CustomerID				CHAR(10)	NOT NULL	PRIMARY KEY,
	PhoneNumber				VARCHAR(15)	NOT NULL,
	FirstName				VARCHAR(35)	NOT NULL,
	LastName				VARCHAR(35)	NOT NULL,
	AddressStreet			VARCHAR(35)	NOT NULL,
	AddressCity				VARCHAR(30)	NOT NULL,
	AddressPostcode			CHAR(4)		NOT NULL,
	isHoax					VARCHAR(10)	DEFAULT	'unverified',
	CONSTRAINT ishx			CHECK(isHoax IN('verified','unverified')),
	UNIQUE(PhoneNumber)
);

--Instore(EmployeeNumber, FirstName, LastName, ContactNumber, TaxFileNumber, Description, HourlyRate, AddressStreet, AddressCity, AddressPostcode, AccountNumber, BankCode, BankName)
--Primary Key EmployeeNumber
--Alternate Key TaxFileNumber

CREATE TABLE InStore (
	EmployeeNumber			CHAR(10)	NOT NULL	PRIMARY KEY,
	FirstName				VARCHAR(35)	NOT NULL,
	LastName				VARCHAR(35)	NOT NULL,
	HourlyRate				DECIMAL(5,2),
	ContactNumber			VARCHAR(15)	NOT NULL,
	TaxFileNumber			CHAR(9)		NOT NULL,
	AccountNumber			VARCHAR(16)	NOT NULL,
	AddressStreet			VARCHAR(35)	NOT NULL,
	AddressCity				VARCHAR(30)	NOT NULL,
	AddressPostcode			CHAR(4)		NOT NULL,
	BankCode				CHAR(6)		NOT NULL,
	BankName				VARCHAR(50)	NOT NULL,
	Description				VARCHAR(500),

	UNIQUE(TaxFileNumber),

);

--Driver(EmployeeNumber, FirstName, LastName, ContactNumber, TaxFileNumber, Description, PaymentRate, AddressStreet, AddressCity, AddressPostcode, AccountNumber, BankCode, BankName, DriversLicenseNumber)
--Primary Key EmployeeNumber
--Alternate Key TaxFileNumber
--Alternate Key DriversLicenseNumber

CREATE TABLE Driver (
	EmployeeNumber			CHAR(10)	NOT NULL	PRIMARY KEY,
	FirstName				VARCHAR(35)	NOT NULL,
	LastName				VARCHAR(35)	NOT NULL,
	PaymentRate				DECIMAL(5,2),
	ContactNumber			VARCHAR(15)	NOT NULL,
	TaxFileNumber			CHAR(9)		NOT NULL,
	DriversLicenseNumber	VARCHAR(15)	NOT NULL,
	AccountNumber			VARCHAR(16)	NOT NULL,
	AddressStreet			VARCHAR(35)	NOT NULL,
	AddressCity				VARCHAR(30)	NOT NULL,
	AddressPostcode			CHAR(4)		NOT NULL,
	BankCode				CHAR(6)		NOT NULL,
	BankName				VARCHAR(50)	NOT NULL,
	Description				VARCHAR(500),

	UNIQUE(TaxFileNumber),
	UNIQUE(DriversLicenseNumber),

);

--InStorePay(PaymentID, EmployeeNumber, TotalPayment, TaxWithheld, PaymentDateStart, PaymentDateEnd, PaymentPeriodStart, PaymentPeriodEnd, TotalPaid, HoursWorked) 

CREATE TABLE InStorePay (
	PaymentID				CHAR(10)	NOT NULL	PRIMARY KEY,
	TotalPayment			FLOAT		NOT NULL,
	TaxWitheld				FLOAT,
	PaymentDateStart		DATETIME,
	PaymentDateEnd			DATETIME,
	PaymentPeriodStart		DATETIME,
	PaymentPeriodEnd		DATETIME,
	HoursWorkedPaid			TINYINT		NOT NULL,

	CONSTRAINT pymtcorrin		CHECK(PaymentDateStart < PaymentDateEnd),
	CONSTRAINT pymtprdcorrin	CHECK(PaymentPeriodStart < PaymentPeriodEnd),
);

--DriverPay(PaymentID, TotalPayment, TaxWithheld, PaymentDateStart, PaymentDateEnd, PaymentPeriodStart, PaymentPeriodEnd, TotalPaid, NumberOfDeliveries) 
--Primary Key PaymentID


CREATE TABLE DriverPay (
	PaymentID				CHAR(10)	NOT NULL	PRIMARY KEY,
	TotalPayment			FLOAT		NOT NULL,
	TaxWitheld				FLOAT,
	PaymentDateStart		DATETIME,
	PaymentDateEnd			DATETIME,
	PaymentPeriodStart		DATETIME,
	PaymentPeriodEnd		DATETIME,
	DeliveriesPaid			TINYINT		NOT NULL,

	CONSTRAINT pymtcorrdr		CHECK(PaymentDateStart < PaymentDateEnd),
	CONSTRAINT pymtprdcorrdr	CHECK(PaymentPeriodStart < PaymentPeriodEnd),
);

--DriverShift(ShiftID, Date Start, Time Start, Time End, Date End, EmployeeNumber, PaymentID)
--Primary Key ShiftID
--Foreign Key EmployeeNumber References Driver(EmployeeNumber) ON UPDATE NO ACTION ON DELETE NO ACTION
--Foreign Key PaymentID References DriverPay(PaymentID) ON UPDATE NO ACTION ON DELETE NO ACTION


CREATE TABLE DriverShift (
	ShiftID					CHAR(10)	NOT NULL	PRIMARY KEY,
	Start					DATETIME,
	Finish					DATETIME,
	EmployeeNumber			CHAR(10)	NOT NULL,
	PaymentID				CHAR(10),

	CONSTRAINT startfinishcorrdr	CHECK(Start <= Finish),
	CONSTRAINT employeeFKdr		FOREIGN KEY(EmployeeNumber) REFERENCES Driver(EmployeeNumber)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT paymentFKdr		FOREIGN KEY(PaymentID)		REFERENCES DriverPay(PaymentID)
		ON UPDATE NO ACTION ON DELETE NO ACTION, 
);

--InstoreShift(ShiftID, Date Start, Time Start, Time End, Date End, EmployeeNumber, PaymentID)
--Primary Key ShiftID
--Foreign Key EmployeeNumber References Instore(EmployeeNumber) ON UPDATE NO ACTION ON DELETE NO ACTION
--Foreign Key PaymentID References InStorePay(PaymentID) ON UPDATE CASCADE ON DELETE CASCADE
--DriverPay(PaymentID, TotalPayment, TaxWithheld, PaymentDateStart, PaymentDateEnd, PaymentPeriodStart, PaymentPeriodEnd, TotalPaid, NumberOfDeliveries) 
--Primary Key PaymentID


CREATE TABLE InStoreShift (
	ShiftID					CHAR(10)	NOT NULL	PRIMARY KEY,
	Start					DATETIME,
	Finish					DATETIME,
	EmployeeNumber			CHAR(10)	NOT NULL,
	PaymentID				CHAR(10),
	HoursWorked				TINYINT,

	CONSTRAINT startfinishcorrin	CHECK(Start <= Finish),
	CONSTRAINT employeeFKin		FOREIGN KEY(EmployeeNumber) REFERENCES InStore(EmployeeNumber)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT paymentFKin		FOREIGN KEY(PaymentID)		REFERENCES DriverPay(PaymentID)
		ON UPDATE NO ACTION ON DELETE NO ACTION, 
);


--Order(OrderNumber, Description, OrderStatus, Date, CustomerID,EmployeeNumber, Amount Due, PaymentMethod, PaymentApprovalNumber)
--Primary Key OrderNumber
--Foreign Key CustomerID References Customer(CustomerID) ON UPDATE CASCADE ON DELETE SET NULL
--Foreign Key EmployeeNumber References Instore(EmployeeNumber) ON UPDATE CASCADE ON DELETE SET NULL 

CREATE TABLE Orders (
	OrderNumber				CHAR(10)	NOT NULL	PRIMARY KEY,
	OrderTime				DATETIME,
	AmountDue				DECIMAL(7,2),
	PaymentMethod			VARCHAR(20)	NOT NULL,
	PaymentApprovalNumber	VARCHAR(20)	NOT NULL,
	OrderStatus				CHAR(2)		DEFAULT 'PR', -- Purchased and being prepared
	CustomerID				CHAR(10),
	EmployeeNumber			CHAR(10),

	CONSTRAINT fkcmID		FOREIGN KEY(CustomerID)	REFERENCES Customer(CustomerID)
		ON UPDATE CASCADE ON DELETE SET NULL,
	CONSTRAINT emnmorFK		FOREIGN KEY(EmployeeNumber)	REFERENCES InStore(EmployeeNumber)
		ON UPDATE CASCADE ON DELETE SET NULL,

	CHECK (AmountDue>0)
);

--OrderItems(OrderNumber, MenuItemCode, Quantity)
--Primary Key OrderNumber, MenuItemCode
--Foreign Key OrderNumber References Order(OrderNumber) ON UPDATE CASCADE ON DELETE CASCADE 
--Foreign Key MenuItemCode References MenuItem(MenuItemCode) ON UPDATE CASCADE ON DELETE SET NULL


CREATE TABLE OrderItems(
	OrderNumber				CHAR(10),
	MenuItemCode			CHAR(10),
	Quantity				INTEGER,

	PRIMARY KEY(OrderNumber,MenuItemCode),
	CONSTRAINT fkOrdIdOrderItems FOREIGN KEY(OrderNumber) REFERENCES Orders(OrderNumber)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fkMenuItemCodeOrderItems	FOREIGN KEY(MenuItemCode) REFERENCES MenuItem(MenuItemCode)
		ON UPDATE CASCADE ON DELETE CASCADE,
);

--WalkInOrder(OrderNumber, WalkInTime, PickupTime)
--Primary Key OrderNumber
--Foreign Key OrderNumber References Order(OrderNumber) ON UPDATE CASCADE ON DELETE CASCADE


CREATE TABLE WalkInOrder (
	OrderNumber				CHAR(10)	PRIMARY KEY,
	WalkInTime				DATETIME2,
	PickupTime				DATETIME2,
	
	CONSTRAINT fkOrderNumberWalkInOrder	FOREIGN KEY(OrderNumber) REFERENCES Orders(OrderNumber)
		ON UPDATE CASCADE ON DELETE CASCADE 
);

--PhonePickupOrder(OrderNumber, CallTime, TerminationTime, PickupTime)
--Primary Key OrderNumber 
--Foreign Key OrderNumber References Order(OrderNumber) ON UPDATE CASCADE ON DELETE CASCADE

CREATE TABLE PhonePickupOrder (
	OrderNumber				CHAR(10)	PRIMARY KEY,
	CallTime				DATETIME2,
	PickupTime				DATETIME2,
	TerminationTime			DATETIME2,

	CONSTRAINT timecorrph		CHECK(TerminationTime > CallTime),
	CONSTRAINT fkOrderNumberPhoneOrderph	FOREIGN KEY(OrderNumber) REFERENCES Orders(OrderNumber)
		ON UPDATE CASCADE ON DELETE CASCADE
);

--PhoneDeliveryOrder(OrderNumber, CallTime, TerminationTime, DeliveryTime, AddressStreet, AddressCity, AddressPostcode, Driver)
--Primary Key OrderNumber
--Foreign Key OrderNumber References Order(OrderNumber) ON UPDATE CASCADE ON DELETE CASCADE
--Foreign Key Driver references DriverShift(ShiftID) ON UPDATE CASCADE ON DELETE SET NULL  


CREATE TABLE PhoneDeliveryOrder (
	OrderNumber				CHAR(10)	PRIMARY KEY,
	CallTime				DATETIME2,
	TerminationTime			DATETIME2,
	DeliveryTime			DATETIME2,
	ShiftID					CHAR(10),
	AddressStreet			VARCHAR(35) NOT NULL,
	AddressCity				VARCHAR(35) NOT NULL,
	AddressPostcode			CHAR(4)		NOT NULL,

	CONSTRAINT timecorrdl		CHECK(TerminationTime > CallTime),
	CONSTRAINT fkOrderNumberPhoneOrderdl	FOREIGN KEY(OrderNumber) REFERENCES Orders(OrderNumber)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fkdrvershft					FOREIGN KEY(ShiftID)	 REFERENCES	DriverShift(ShiftID)
	ON UPDATE CASCADE ON DELETE SET NULL,
);


--CREATE TABLE Ingredient (
--	IngredientCode			CHAR(10)	NOT NULL	PRIMARY KEY,
--	IngredientName			VARCHAR(30)	NOT NULL,
--	IngredientType			VARCHAR(30),
--	SuggestedReorderLevel	INTEGER,
--	SuggeedStockLevel		INTEGER,
--	CONSTRAINT sggstReorderPos	CHECK(SuggestedReorderLevel>0),
--	CONSTRAINT sggstStckPos		CHECK(SuggestedStockLevel>0)
--);

--This will create NULL's as I did not specify Ingredient type

INSERT INTO Ingredient(IngredientCode,IngredientName,SuggestedReorderLevel,SuggestedStockLevel) VALUES('I000000001','Dough',150,340);
INSERT INTO Ingredient(IngredientCode,IngredientName,SuggestedReorderLevel,SuggestedStockLevel) VALUES('I000000002','Cheese',300,270);
INSERT INTO Ingredient(IngredientCode,IngredientName,IngredientType,SuggestedReorderLevel,SuggestedStockLevel) VALUES('I000000003','Toppings','Tomato',100,620);

--SELECT * FROM Ingredient;

--CREATE TABLE StockOrder (
--	StockOrderNumber		CHAR(10)	NOT NULL	PRIMARY KEY,
--	DateOrdered				DATE		NOT NULL,
--	DateReceived			DATE,
--	OrderStatus				CHAR(2)		NOT NULL	DEFAULT	'PR',	--PR means purchased but not received
--	CONSTRAINT dteChk			CHECK (DateReceived < DateOrdered),
--);

INSERT INTO StockOrder(StockOrderNumber, DateOrdered) VALUES('S000000001','15-OCT-2021');
INSERT INTO StockOrder(StockOrderNumber, DateOrdered, DateReceived, OrderStatus) VALUES('s000000002','15-JUN-2021','21-JUN-2021','RC');
INSERT INTO StockOrder(StockOrderNumber, DateOrdered, DateReceived, OrderStatus) VALUES('s000000004','15-JUN-2020','21-JUN-2020','RC');
INSERT INTO StockOrder(StockOrderNumber, DateOrdered, OrderStatus) VALUES('s000000003','1-AUG-2020','CL');
INSERT INTO StockOrder(StockOrderNumber, DateOrdered) VALUES('S000000006','15-OCT-2020');
INSERT INTO StockOrder(StockOrderNumber, DateOrdered, DateReceived, OrderStatus) VALUES('s000000005','15-JUN-2020','21-JUN-2020','RC');

--SELECT * FROM StockOrder;

--CREATE TABLE IngredientOrders (
--	StockOrderNumber		CHAR(10)	 NOT NULL,
--	IngredientCode			CHAR(10)	 NOT NULL,
--	Quantity				INTEGER		 NOT NULL,
--	Price					DECIMAL(6,2) NOT NULL,
--	PRIMARY KEY (StockOrderNumber, IngredientCode),
--	CONSTRAINT fkStkOrd		FOREIGN KEY(StockOrderNumber)	REFERENCES	StockOrder(StockOrderNumber)
--		ON UPDATE CASCADE ON DELETE CASCADE,
--	CONSTRAINT fkIng		FOREIGN KEY(IngredientCode)		REFERENCES	Ingredient(IngredientCode)
--		ON UPDATE CASCADE ON DELETE CASCADE,
--	CONSTRAINT qntyPos			CHECK(Quantity>0),
--	CONSTRAINT prcePos			CHECK(Price>=0)
--);

INSERT INTO IngredientOrders VALUES('S000000001','I000000001',430,3);
INSERT INTO IngredientOrders VALUES('S000000001','I000000002',230,0.34);
INSERT INTO IngredientOrders VALUES('s000000003','I000000003',1000,0.03)
INSERT INTO IngredientOrders VALUES('S000000002','I000000001',430,3);
INSERT INTO IngredientOrders VALUES('S000000002','I000000002',230,0.34);
INSERT INTO IngredientOrders VALUES('s000000002','I000000003',1000,0.03);;

INSERT INTO IngredientOrders VALUES('S000000004','I000000001',430,3);
INSERT INTO IngredientOrders VALUES('S000000004','I000000002',230,0.34);
INSERT INTO IngredientOrders VALUES('s000000005','I000000003',1000,0.03)
INSERT INTO IngredientOrders VALUES('S000000006','I000000001',430,3);
INSERT INTO IngredientOrders VALUES('S000000004','I000000003',230,0.34);
INSERT INTO IngredientOrders VALUES('s000000006','I000000003',1000,0.03);;

--SELECT * FROM IngredientOrders;

--CREATE TABLE MenuItem (
--	MenuItemCode			CHAR(10)	NOT NULL	PRIMARY KEY,
--	MenuItemName			VARCHAR(35)	NOT NULL,
--	Size					CHAR(1)		NOT NULL,
--	SellingPrice			DECIMAL(5,2),
--	Description				VARCHAR(50),
	
--	CONSTRAINT szechk			CHECK(Size IN ('S','M','L')),
--	CONSTRAINT sellprcePos		CHECK(SellingPrice >= 0),
--);

INSERT INTO MenuItem VALUES('MI00000001','Supreme','M',19.99,'Supreme pizza is the best pizza');
INSERT INTO MenuItem VALUES('MI00000002','Hawaiin','L',12.99,'Pinapple does belong on pizza!!!!');
INSERT INTO MenuItem(MenuItemCode,MenuItemName,Size) VALUES ('MI00000003','Meat Lovers', 'S');

--SELECT * FROM MenuItem;

--CREATE TABLE MenuItemComposition (
--	MenuItemCode			CHAR(10)	NOT NULL,
--	IngredientCode			CHAR(10)	NOT NULL,
--	Quantity				INTEGER		NOT NULL,

--	PRIMARY KEY(MenuItemCode, IngredientCode),
--	CONSTRAINT fkmnuitem	FOREIGN KEY(MenuItemCode)		REFERENCES MenuItem(MenuItemCode)
--		ON UPDATE CASCADE ON DELETE CASCADE,
--	CONSTRAINT fkingcode	FOREIGN KEY(IngredientCode)		REFERENCES Ingredient(IngredientCode)
--		ON UPDATE CASCADE ON DELETE CASCADE,
--	CONSTRAINT qntpos		CHECK(Quantity > 0)
--);

INSERT INTO MenuItemComposition VALUES('MI00000001','I000000001',3);
INSERT INTO MenuItemComposition VALUES('MI00000001','I000000002',76);
INSERT INTO MenuItemComposition VALUES('MI00000001','I000000003',4);
INSERT INTO MenuItemComposition VALUES('MI00000002','I000000001',5);
INSERT INTO MenuItemComposition VALUES('MI00000002','I000000002',2);
INSERT INTO MenuItemComposition VALUES('MI00000003','I000000001',7);


--CREATE TABLE Customer (
--	CustomerID				CHAR(10)	NOT NULL	PRIMARY KEY,
--	PhoneNumber				VARCHAR(15)	NOT NULL,
--	FirstName				VARCHAR(35)	NOT NULL,
--	LastName				VARCHAR(35)	NOT NULL,
--	AddressStreet			VARCHAR(35)	NOT NULL,
--	AddressCity				VARCHAR(30)	NOT NULL,
--	AddressPostcode			CHAR(4)		NOT NULL,
--	isHoax					VARCHAR(10)	DEFAULT	'unverified',
--	CONSTRAINT ishx			CHECK(isHoax IN('verified','unverified')),
--	UNIQUE(PhoneNumber)
--);

INSERT INTO Customer VALUES('C000000001','04353982','John','Doe','11 Sesseme Street', 'Sesseme City','2234','verified');
INSERT INTO Customer(CustomerID,PhoneNumber,FirstName,LastName,AddressCity,AddressStreet,AddressPostcode)
	VALUES('C000000002','0490332245','Jane','Doe','Brisbane','11 Delitasteland','2345');
INSERT INTO Customer VALUES('C000000003','0435398542','Johhny','Doe','11 Gamer Avenue', 'Abcland','2234','verified');

--SELECT * FROM Customer;

--CREATE TABLE InStore (
--	EmployeeNumber			CHAR(10)	NOT NULL	PRIMARY KEY,
--	FirstName				VARCHAR(35)	NOT NULL,
--	LastName				VARCHAR(35)	NOT NULL,
--	HourlyRate				DECIMAL(5,2),
--	ContactNumber			VARCHAR(15)	NOT NULL,
--	TaxFileNumber			CHAR(9)		NOT NULL,
--	AccountNumber			VARCHAR(16)	NOT NULL,
--	AddressStreet			VARCHAR(35)	NOT NULL,
--	AddressCity				VARCHAR(30)	NOT NULL,
--	AddressPostcode			CHAR(4)		NOT NULL,
--	BankCode				CHAR(6)		NOT NULL,
--	BankName				VARCHAR(50)	NOT NULL,
--	Description				VARCHAR(500),

--	UNIQUE(TaxFileNumber),

--);

INSERT INTO InStore(EmployeeNumber,FirstName,LastName,ContactNumber,TaxFileNumber,AccountNumber,AddressStreet,AddressCity,AddressPostcode,BankCode,BankName)
	VALUES('E000000001','Jane','Doe','04309535656','123456789','1324546757','Good Street','Good City','2394','650000','Newcastle Permanent');
INSERT INTO InStore VALUES('E000000002','John','Doe',15.42,'043879473','987654321','32908235243','Bad Street','Bad City','8945','123456','Bannnnnkkk','Lorem Ipsum');
INSERT INTO InStore VALUES('E000000003','Johhny','Doe',15.70,'043895473','111111111','328235243','Bad Street','Bad City','8945','123456','Bannnnnkkk','Lorem Ipsum 2');

--SELECT * FROM InStore;

--CREATE TABLE Driver (
--	EmployeeNumber			CHAR(10)	NOT NULL	PRIMARY KEY,
--	FirstName				VARCHAR(35)	NOT NULL,
--	LastName				VARCHAR(35)	NOT NULL,
--	PaymentRate				DECIMAL(5,2),
--	ContactNumber			VARCHAR(15)	NOT NULL,
--	TaxFileNumber			CHAR(9)		NOT NULL,
--	DriversLicenseNumber	VARCHAR(15)	NOT NULL,
--	AccountNumber			VARCHAR(16)	NOT NULL,
--	AddressStreet			VARCHAR(35)	NOT NULL,
--	AddressCity				VARCHAR(30)	NOT NULL,
--	AddressPostcode			CHAR(4)		NOT NULL,
--	BankCode				CHAR(6)		NOT NULL,
--	BankName				VARCHAR(50)	NOT NULL,
--	Description				VARCHAR(500),

--	UNIQUE(TaxFileNumber),
--	UNIQUE(DriversLicenseNumber),

--);

INSERT INTO Driver(EmployeeNumber,FirstName,LastName,ContactNumber,TaxFileNumber,DriversLicenseNumber,AccountNumber,AddressStreet,AddressCity,AddressPostcode,BankCode,BankName)
	VALUES('DR00000001','Jane','Doe','04309535656','123456789','342908534','1324546757','Good Street','Good City','2394','650000','Newcastle Permanent');
INSERT INTO Driver VALUES('DR00000002','John','Doe',3.42,'043879473','987654321','84375934353','32908235243','Bad Street','Bad City','8945','123456','Bannnnnkkk','Lorem Ipsum');
INSERT INTO Driver VALUES('DR00000003','Johhny','Doe',6.70,'043895473','111111111','895486940','328235243','Bad Street','Bad City','8945','123456','Bannnnnkkk','Lorem Ipsum 2');

--SELECT * FROM Driver;

--CREATE TABLE InStorePay (
--	PaymentID				CHAR(10)	NOT NULL	PRIMARY KEY,
--	TotalPayment			FLOAT		NOT NULL,
--	TaxWitheld				FLOAT,
--	PaymentDateStart		DATETIME,
--	PaymentDateEnd			DATETIME,
--	PaymentPeriodStart		DATETIME,
--	PaymentPeriodEnd		DATETIME,
--	HoursWorkedPaid			TINYINT		NOT NULL,

--	CONSTRAINT pymtcorrin		CHECK(PaymentDateStart < PaymentDateEnd),
--	CONSTRAINT pymtprdcorrin	CHECK(PaymentPeriodStart < PaymentPeriodEnd),
--);

INSERT INTO InStorePay(PaymentID,TotalPayment,HoursWorkedPaid) VALUES('INSTRP0001',501.34,'13');
INSERT INTO InStorePay(PaymentID,TotalPayment,PaymentDateEnd,PaymentPeriodStart,HoursWorkedPaid) 
	VALUES('INSTRP0002',1000.34,'13-JUN-2021','14-JUN-2021',17);
INSERT INTO InStorePay VALUES('INSTRP0003',1302.23,80,'14-JAN-2021','15-JAN-2021','12-JAN-2021','21-JAN-2021',34);
INSERT INTO InStorePay(PaymentID,TotalPayment,HoursWorkedPaid) VALUES('INSTRP0004',501.34,'13');
INSERT INTO InStorePay(PaymentID,TotalPayment,PaymentDateEnd,PaymentPeriodStart,HoursWorkedPaid) 
	VALUES('INSTRP0005',1000.34,'13-JUN-2020','14-JUN-2020',17);
INSERT INTO InStorePay VALUES('INSTRP0006',1302.23,80,'14-JAN-2020','15-JAN-2020','12-JAN-2020','21-JAN-2020',34);

--SELECT * FROM InStorePay;

--CREATE TABLE DriverPay (
--	PaymentID				CHAR(10)	NOT NULL	PRIMARY KEY,
--	TotalPayment			FLOAT		NOT NULL,
--	TaxWitheld				FLOAT,
--	PaymentDateStart		DATETIME,
--	PaymentDateEnd			DATETIME,
--	PaymentPeriodStart		DATETIME,
--	PaymentPeriodEnd		DATETIME,
--	DeliveriesPaid			TINYINT		NOT NULL,

--	CONSTRAINT pymtcorrdr		CHECK(PaymentDateStart < PaymentDateEnd),
--	CONSTRAINT pymtprdcorrdr	CHECK(PaymentPeriodStart < PaymentPeriodEnd),
--);

INSERT INTO DriverPay(PaymentID,TotalPayment,DeliveriesPaid) VALUES('INSTRP0001',501.34,'13');
INSERT INTO DriverPay(PaymentID,TotalPayment,PaymentDateEnd,PaymentPeriodStart,DeliveriesPaid) 
	VALUES('INSTRP0002',1000.34,'13-JUN-2021','14-JUN-2021',17);
INSERT INTO DriverPay VALUES('INSTRP0003',1302.23,80,'14-JAN-2021','15-JAN-2021','12-JAN-2021','21-JAN-2021',34);
INSERT INTO DriverPay(PaymentID,TotalPayment,DeliveriesPaid) VALUES('INSTRP0004',501.34,'13');
INSERT INTO DriverPay(PaymentID,TotalPayment,PaymentDateEnd,PaymentPeriodStart,DeliveriesPaid) 
	VALUES('INSTRP0005',1000.34,'13-JUN-2020','14-JUN-2020',17);
INSERT INTO DriverPay VALUES('INSTRP0006',1302.23,80,'14-JAN-2020','15-JAN-2020','12-JAN-2020','21-JAN-2020',34);

--SELECT * FROM DriverPay;

--CREATE TABLE InStoreShift (
--	ShiftID					CHAR(10)	NOT NULL	PRIMARY KEY,
--	Start					DATETIME,
--	Finish					DATETIME,
--	EmployeeNumber			CHAR(10)	NOT NULL,
--	PaymentID				CHAR(10),
--	HoursWorked				TINYINT,

--	CONSTRAINT startfinishcorrin	CHECK(Start < Finish),
--	CONSTRAINT employeeFKin		FOREIGN KEY(EmployeeNumber) REFERENCES InStore(EmployeeNumber)
--		ON UPDATE NO ACTION ON DELETE NO ACTION,
--	CONSTRAINT paymentFKin		FOREIGN KEY(PaymentID)		REFERENCES DriverPay(PaymentID)
--		ON UPDATE NO ACTION ON DELETE NO ACTION, 
--);

INSERT INTO InStoreShift(ShiftID,EmployeeNumber)
	VALUES('SH00000001','E000000001');

INSERT INTO InStoreShift(ShiftID,Start,EmployeeNumber,PaymentID,HoursWorked)
	VALUES('SH00000002','14-JAN-2021 00:00:00','E000000002','INSTRP0001',4);

INSERT INTO InStoreShift VALUES('SH00000003','14-AUG-2021 03:43:21','15-AUG-2021 00:23:31','E000000003','INSTRP0001',5);

INSERT INTO InStoreShift VALUES('SH00000004','14-JUN-2021 03:43:21','15-AUG-2021 00:23:31','E000000003','INSTRP0001',5);

INSERT INTO InStoreShift VALUES('SH00000005','14-FEB-2021 03:43:21','15-JUN-2021 00:23:31','E000000003','INSTRP0002',5);

INSERT INTO InStoreShift VALUES('SH00000006','14-FEB-2020 03:43:21','15-JUN-2020 00:23:31','E000000002','INSTRP0004',4);

INSERT INTO InStoreShift VALUES('SH00000007','14-OCT-2021 03:43:21','15-OCT-2021 00:23:31','E000000002','INSTRP0005',5);

INSERT INTO InStoreShift VALUES('SH00000008','14-NOV-2021 03:43:21','15-NOV-2021 00:23:31','E000000001','INSTRP0004',6);

INSERT INTO InStoreShift VALUES('SH00000009','14-DEC-2021 03:43:21','15-DEC-2021 00:23:31','E000000001','INSTRP0001',4);

INSERT INTO InStoreShift VALUES('SH00000010','14-DEC-2021 03:43:21','15-DEC-2021 00:23:31','E000000001','INSTRP0003',4);

--SELECT * FROM InStoreShift;

--CREATE TABLE DriverShift (
--	ShiftID					CHAR(10)	NOT NULL	PRIMARY KEY,
--	Start					DATETIME,
--	Finish					DATETIME,
--	EmployeeNumber			CHAR(10)	NOT NULL,
--	PaymentID				CHAR(10),

--	CONSTRAINT startfinishcorrdr	CHECK(Start < Finish),
--	CONSTRAINT employeeFKdr		FOREIGN KEY(EmployeeNumber) REFERENCES Driver(EmployeeNumber)
--		ON UPDATE NO ACTION ON DELETE NO ACTION,
--	CONSTRAINT paymentFKdr		FOREIGN KEY(PaymentID)		REFERENCES DriverPay(PaymentID)
--		ON UPDATE NO ACTION ON DELETE NO ACTION, 
--);

INSERT INTO DriverShift VALUES('SH00000001','14-AUG-2021 03:43:21','15-AUG-2021 00:23:31','DR00000003','INSTRP0004');

INSERT INTO DriverShift VALUES('SH00000002','14-JUN-2021 03:43:21','15-AUG-2021 00:23:31','DR00000001','INSTRP0005');

INSERT INTO DriverShift VALUES('SH00000003','14-AUG-2021 03:43:21','15-AUG-2021 00:23:31','DR00000003','INSTRP0001');

INSERT INTO DriverShift VALUES('SH00000004','14-JUN-2021 03:43:21','15-AUG-2021 00:23:31','DR00000003','INSTRP0001');

INSERT INTO DriverShift VALUES('SH00000005','14-FEB-2021 03:43:21','15-JUN-2021 00:23:31','DR00000003','INSTRP0002');

INSERT INTO DriverShift VALUES('SH00000006','18-OCT-2021 03:43:21','19-OCT-2021 00:23:31','DR00000002','INSTRP0004');

INSERT INTO DriverShift VALUES('SH00000007','14-OCT-2021 03:43:21','15-OCT-2021 00:23:31','DR00000002','INSTRP0005');

INSERT INTO DriverShift VALUES('SH00000008','14-NOV-2021 03:43:21','15-NOV-2021 00:23:31','DR00000001','INSTRP0004');

INSERT INTO DriverShift VALUES('SH00000009','14-DEC-2021 03:43:21','15-DEC-2021 00:23:31','DR00000001','INSTRP0001');

INSERT INTO DriverShift VALUES('SH00000010','14-DEC-2021 03:43:21','15-DEC-2021 00:23:31','DR00000001','INSTRP0003');

--SELECT * FROM DriverShift;

--CREATE TABLE Orders (
--	OrderNumber				CHAR(10)	NOT NULL	PRIMARY KEY,
--	OrderTime				DATETIME,
--	AmountDue				DECIMAL(7,2),
--	PaymentMethod			VARCHAR(20)	NOT NULL,
--	PaymentApprovalNumber	VARCHAR(20)	NOT NULL,
--	OrderStatus				CHAR(2)		DEFAULT 'PR', -- Purchased and being prepared
--	CustomerID				CHAR(10),
--	EmployeeNumber			CHAR(10),

--	CONSTRAINT fkcmID		FOREIGN KEY(CustomerID)	REFERENCES Customer(CustomerID)
--		ON UPDATE CASCADE ON DELETE SET NULL,
--	CONSTRAINT emnmorFK		FOREIGN KEY(EmployeeNumber)	REFERENCES InStore(EmployeeNumber)
--		ON UPDATE CASCADE ON DELETE SET NULL,

--	CHECK (AmountDue>0)
--);

INSERT INTO Orders
	VALUES('O000000001','12-OCT-2021',45,'Card','P4e90384','AW','C000000001','E000000001');

INSERT INTO Orders
	VALUES('O000000002','12-DEC-2021',45,'Card','P1223423','CC','C000000002','E000000002');

INSERT INTO Orders
	VALUES('O000000003','12-JAN-2021',45,'Card','P1224353','CC','C000000003','E000000003');

INSERT INTO Orders
	VALUES('O000000004','13-JAN-2021',45,'Card','P1224353','CC','C000000002','E000000003');

INSERT INTO Orders
	VALUES('O000000005','17-JAN-2021',45,'Card','P3924353','DE','C000000002','E000000003');

INSERT INTO Orders
	VALUES('O000000006','18-JAN-2021',45,'Card','P3924353','CP','C000000002','E000000003');

INSERT INTO Orders
	VALUES('O000000007','19-JAN-2021',45,'Card','P3924353','CP','C000000001','E000000003');

INSERT INTO Orders
	VALUES('O000000008','20-JAN-2021',45,'Card','P3924353','CP','C000000001','E000000001');

INSERT INTO Orders
	VALUES('O000000009','19-JAN-2021',45,'Cash','P392454353','CP','C000000002','E000000002');

--SELECT * FROM Orders;

--CREATE TABLE OrderItems(
--	OrderNumber				CHAR(10),
--	MenuItemCode			CHAR(10),
--	Quantity				INTEGER,

--	PRIMARY KEY(OrderNumber,MenuItemCode),
--	CONSTRAINT fkOrdIdOrderItems FOREIGN KEY(OrderNumber) REFERENCES Orders(OrderNumber)
--		ON UPDATE CASCADE ON DELETE CASCADE,
--	CONSTRAINT fkMenuItemCodeOrderItems	FOREIGN KEY(MenuItemCode) REFERENCES MenuItem(MenuItemCode)
--		ON UPDATE CASCADE ON DELETE CASCADE,
--);

INSERT INTO OrderItems
	VALUES('O000000001','MI00000001',3);

INSERT INTO OrderItems
	VALUES('O000000002','MI00000002',4);

INSERT INTO OrderItems
	VALUES('O000000002','MI00000003',5);

INSERT INTO OrderItems
	VALUES('O000000003','MI00000001',6);

INSERT INTO OrderItems
	VALUES('O000000004','MI00000002',2);

INSERT INTO OrderItems
	VALUES('O000000005','MI00000003',1);

INSERT INTO OrderItems
	VALUES('O000000006','MI00000001',8);

INSERT INTO OrderItems
	VALUES('O000000007','MI00000002',9);

INSERT INTO OrderItems
	VALUES('O000000008','MI00000003',1);

INSERT INTO OrderItems
	VALUES('O000000009','MI00000001',4);

INSERT INTO OrderItems
	VALUES('O000000001','MI00000002',10);

INSERT INTO OrderItems
	VALUES('O000000002','MI00000001',3);

INSERT INTO OrderItems
	VALUES('O000000003','MI00000003',1);

--SELECT * FROM OrderItems;

--CREATE TABLE WalkInOrder (
--	OrderNumber				CHAR(10)	PRIMARY KEY,
--	WalkInTime				DATETIME2,
--	PickupTime				DATETIME2,
	
--	CONSTRAINT fkOrderNumberWalkInOrder	FOREIGN KEY(OrderNumber) REFERENCES Orders(OrderNumber)
--		ON UPDATE CASCADE ON DELETE CASCADE 
--);

INSERT INTO WalkInOrder 
	VALUES('O000000001','12-OCT-2021 00:00:00','12-OCT-2021 1:00:00');

INSERT INTO WalkInOrder 
	VALUES('O000000002','13-OCT-2021 00:00:00','13-OCT-2021 1:00:00');

INSERT INTO WalkInOrder 
	VALUES('O000000003','14-OCT-2021 00:00:00','14-OCT-2021 1:00:00');

--SELECT * FROM WalkInOrder;

--CREATE TABLE PhonePickupOrder (
--	OrderNumber				CHAR(10)	PRIMARY KEY,
--	CallTime				DATETIME2,
--	PickupTime				DATETIME2,
--	TerminationTime			DATETIME2,

--	CONSTRAINT timecorrph		CHECK(TerminationTime > CallTime),
--	CONSTRAINT fkOrderNumberPhoneOrderph	FOREIGN KEY(OrderNumber) REFERENCES Orders(OrderNumber)
--		ON UPDATE CASCADE ON DELETE CASCADE
--);

INSERT INTO PhonePickupOrder 
	VALUES('O000000004','12-OCT-2021 00:00:00','12-OCT-2021 00:30:00','12-OCT-2021 1:00:00');

INSERT INTO PhonePickupOrder 
	VALUES('O000000005','13-OCT-2021 00:00:00','13-OCT-2021 00:30:00','13-OCT-2021 1:00:00');

INSERT INTO PhonePickupOrder 
	VALUES('O000000006','14-OCT-2021 00:00:00','14-OCT-2021 00:30:00','14-OCT-2021 1:00:00');

--SELECT * FROM PhonePickupOrder;

--CREATE TABLE PhoneDeliveryOrder (
--	OrderNumber				CHAR(10)	PRIMARY KEY,
--	CallTime				DATETIME2,
--	TerminationTime			DATETIME2,
--	DeliveryTime			DATETIME2,
--	ShiftID					CHAR(10),
--	AddressStreet			VARCHAR(35) NOT NULL,
--	AddressCity				VARCHAR(35) NOT NULL,
--	AddressPostcode			CHAR(4)		NOT NULL,

--	CONSTRAINT timecorrdl		CHECK(TerminationTime > CallTime),
--	CONSTRAINT fkOrderNumberPhoneOrderdl	FOREIGN KEY(OrderNumber) REFERENCES Orders(OrderNumber)
--		ON UPDATE CASCADE ON DELETE CASCADE,
--	CONSTRAINT fkdrvershft					FOREIGN KEY(ShiftID)	 REFERENCES	DriverShift(ShiftID)
--	ON UPDATE CASCADE ON DELETE SET NULL,
--);

INSERT INTO PhoneDeliveryOrder 
	VALUES('O000000007','12-OCT-2021 00:00:00','12-OCT-2021 00:30:00','12-OCT-2021 1:00:00','SH00000001','123 Gamer Avenue','Gamerland','2222');

INSERT INTO PhoneDeliveryOrder
	VALUES('O000000008','13-OCT-2021 00:00:00','13-OCT-2021 00:30:00','13-OCT-2021 1:00:00','SH00000002','123 Im Bored Street','Whyland','2223');

INSERT INTO PhoneDeliveryOrder 
	VALUES('O000000009','14-OCT-2021 00:00:00','14-OCT-2021 00:30:00','14-OCT-2021 1:00:00','SH00000003','123 This took me many ','hours :(','2224');

--SELECT * FROM PhoneDeliveryOrder;

--For  an  in-office  staff  with  id  number  xxx,  print  his/her  
--1stname, lname, and hourly payment rate.

SELECT InStore.FirstName, InStore.LastName, InStore.HourlyRate 
FROM InStore
WHERE InStore.EmployeeNumber = 'E000000002';

--List all the ingredient details of a menu item named xxx.

SELECT Ingredient.IngredientCode,Ingredient.IngredientName,Ingredient.IngredientType,Ingredient.SuggestedReorderLevel,Ingredient.SuggestedStockLevel
FROM Ingredient
INNER JOIN MenuItemComposition 
ON Ingredient.IngredientCode=MenuItemComposition.IngredientCode
INNER JOIN MenuItem ON 
MenuItem.MenuItemCode=MenuItemComposition.MenuItemCode
WHERE MenuItemName='Supreme';

--List  all  the  shift  details  of  a  delivery  staff  with  first  name  
--xxx and last name ttt between date yyy and zzz

SELECT DriverShift.ShiftID, DriverShift.Start, DriverShift.Finish, DriverShift.PaymentID
FROM DriverShift
INNER JOIN Driver
ON Driver.EmployeeNumber = DriverShift.EmployeeNumber
WHERE Driver.FirstName='Jane' AND Driver.LastName='Doe'
AND DriverShift.Start>'1-JAN-2020' AND DriverShift.Finish<'31-DEC-2021';

--List  all  the  order  details  of  the  orders  that  are  made  by  a 
--walk-in customer with first name xxx and last name ttt between 
--date yyy and zzz. 

SELECT Customer.FirstName, Customer.LastName ,Orders.OrderNumber, Orders.OrderStatus, Orders.OrderTime, Orders.OrderStatus, Orders.AmountDue, Orders.PaymentApprovalNumber, Orders.PaymentMethod FROM WalkInOrder
INNER JOIN Orders
ON Orders.OrderNumber=WalkInOrder.OrderNumber
INNER JOIN Customer
ON Customer.CustomerID=Orders.CustomerID
WHERE Customer.FirstName='Jane' AND Customer.LastName='Doe'
AND Orders.OrderTime > '1-JAN-2020' AND Orders.OrderTime<'31-DEC-2021';

--List all the order details of the orders that are taken by an 
--in-office  staff  with  first  name  xxx  and  last  name  ttt  between  
--date yyy and zzz.

SELECT InStore.FirstName AS EmployeeFirstName, InStore.LastName AS EmployeeLastName ,Orders.OrderNumber, Orders.OrderStatus, Orders.OrderTime, Orders.OrderStatus, Orders.AmountDue, Orders.PaymentApprovalNumber, Orders.PaymentMethod
FROM Orders
INNER JOIN InStore
ON InStore.EmployeeNumber=Orders.EmployeeNumber
WHERE InStore.FirstName='Jane' AND InStore.LastName='Doe'
AND Orders.OrderTime > '1-JAN-2020' AND Orders.OrderTime < '31-DEC-2021';

--Print  the  salary  paid  to  a  delivery  staff  named  xxx  in  the 
--current month. Note the current month is the current month that 
--is decided by the system

SELECT SUM(DriverPay.TotalPayment) AS 'Driver Pay Total' 
FROM DriverShift
INNER JOIN DriverPay
ON DriverPay.PaymentID=DriverShift.PaymentID
INNER JOIN Driver
ON Driver.EmployeeNumber=DriverShift.EmployeeNumber
WHERE MONTH(DriverShift.Finish)=MONTH(GETDATE())
AND YEAR(DriverShift.Finish)=YEAR(GETDATE())
AND Driver.FirstName = 'John' AND Driver.LastName='Doe'

--List  the  name  of  the  menu  item  that  is  mostly  ordered  in  
--the current year. Note the current year is the current year that is 
--decided by the system. 

SELECT p.MenuItemCode,MenuItemName,p.orderamount FROM (
	SELECT y.MenuItemCode,SUM(y.Quantity) AS 'orderamount' FROM (
		SELECT OrderItems.OrderNumber,OrderItems.MenuItemCode,OrderItems.Quantity
		FROM OrderItems -- get all the menu items ordered this year
		INNER JOIN Orders
		ON Orders.OrderNumber=OrderItems.OrderNumber
		WHERE YEAR(Orders.OrderTime) = YEAR(getDate())
	) as y
	GROUP BY y.MenuItemCode 
) AS p
INNER JOIN (
	SELECT MAX(h.orderamount) AS 'maxordamount' FROM (
		SELECT z.MenuItemCode,SUM(z.Quantity) AS 'orderamount' FROM (
			SELECT OrderItems.OrderNumber,OrderItems.MenuItemCode,OrderItems.Quantity
			FROM OrderItems -- get all the menu items ordered this year
			INNER JOIN Orders
			ON Orders.OrderNumber=OrderItems.OrderNumber
			WHERE YEAR(Orders.OrderTime) = YEAR(getDate())
		) as z
		GROUP BY z.MenuItemCode 
	) AS h
) AS g
ON g.maxordamount=p.orderamount
INNER JOIN MenuItem
ON MenuItem.MenuItemCode=p.MenuItemCode;

