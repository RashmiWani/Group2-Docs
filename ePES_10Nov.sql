create schema Group2 
----------------------------
create table Group2.Admin
(
adminID int primary key,
loginID varchar(10),
userType varchar(15)
)
--------------------------
create table Group2.Customer
(
customerID int primary key,
loginID varchar(10),
customerName varchar(30),
customerAddress varchar(50),
customerTelephone varchar(12),
customerGender char,
customerDOB DateTime,
customerSmoking varchar(20),
customerHobbies varchar(20),
nomineeName varchar(30),
nomineeRelation varchar(20),
userType varchar(15)
)
-----------------------------
create table Group2.LoginCredentials
(
loginID varchar(10) primary key,
userpassword varchar(20),
userType varchar(15)
)

--drop table Group2.LoginCredentials

----------------------------------
create table Group2.InsuranceProduct
(
productID int primary key,
productName varchar(30),
productLine varchar(200)
)

--alter table Group2.InsuranceProduct drop column productName
--alter table Group2.InsuranceProduct alter column productLine varchar(30)


------------------------------------
create table Group2.Policy
(
policyNumber int primary key,
policyName varchar(30),
policyDetails varchar(200),
productID int FOREIGN KEY (productID) REFERENCES Group2.InsuranceProduct(productID)
)
----------------------------------
create table Group2.CustomerPolicyDetails
(
policyNumber int FOREIGN KEY (policyNumber) REFERENCES Group2.Policy(policyNumber),
customerID int FOREIGN KEY (customerID) REFERENCES Group2.Customer(customerID),
premiumFrequency varchar(20)
)
--------------------------------------
create table Group2.Endorsements
(
transactionID int identity(1000,1) primary key,
customerID int FOREIGN KEY (customerID) REFERENCES Group2.Customer(customerID),
policyNumber int FOREIGN KEY (policyNumber) REFERENCES Group2.Policy(policyNumber),
policyName varchar(30),
productName varchar(30),
productLine varchar(200),
customerName varchar(30),
customerAddress varchar(50),
customerTelephone varchar(12),
customerGender char,
customerDOB DateTime,
customerSmoking varchar(20),
nomineeName varchar(30),
nomineeRelation varchar(20),
premiumFrequency varchar(20)
)

--alter table Group2.Endorsements drop column productName
------------------------------------------

insert into Group2.Admin values(8003,'ADM8003','ADMIN')

insert into Group2.Customer values(5003,'CUST5003','Maria S','Kolkata','9856274123','F','02/05/1992','Non-Smoker','Painting','Sarah S','Sister','CUSTOMER')

insert into Group2.LoginCredentials values('CUST5002','5002','CUSTOMER')

insert into Group2.InsuranceProduct values(2, 'Non-Life Insurance')

insert into Group2.Policy values(25,'Crop Insurance',
'Crop insurance is purchased by agricultural producers to protect against either 
the loss of their crops due to natural disasters, such as hail, drought, and floods.',2)

insert into Group2.CustomerPolicyDetails values (24,5001,'YEARLY')

insert into Group2.Endorsements values(5002,24,'Travel Insurance','Non-Life Insurance',
'Robert J','Bangalore','9811234561','M','10/10/1991','Smoker','John J','Father' ,'YEARLY')

select * from  Group2.Endorsements
------------------------------------------------------------------------

create table Group2.EndorsementsTemp
(
transactionID int identity(1000,10) primary key,
customerID int FOREIGN KEY (customerID) REFERENCES Group2.Customer(customerID),
policyNumber int FOREIGN KEY (policyNumber) REFERENCES Group2.Policy(policyNumber),
policyName varchar(30),
productLine varchar(30),
customerName varchar(30),
customerAddress varchar(50),
customerTelephone varchar(12),
customerGender char,
customerDOB DateTime,
customerSmoking varchar(20),
nomineeName varchar(30),
nomineeRelation varchar(20),
premiumFrequency varchar(20),
docPath varchar(50),
statusEndo varchar(20)
)


insert into Group2.EndorsementsTemp values(5002,22,	
'Home Insurance','Non-Life Insurance',
'Saumya R','Delhi','9988112347','F','1990-05-08','Smoker','Ram','Father','MONTHLY','C:','PENDING')
----------------------------------------------------------------
CREATE proc [Group2].[usp_InsertEndoTemp]
@ccustomerID int,
@cpolicyNumber int,
@cpolicyName varchar(30),
@cproductLine varchar(200),
@cName varchar(30),
@cAddress varchar(50),
@cPh varchar(12),
@cGender char,
@cDOB DateTime,
@cSmoking varchar(20),
@cnomineeName varchar(30),
@cnomineeRelation varchar(20),
@cpremiumFrequency varchar(20),
@cdocPath varchar(50),
@cstatusEndo varchar(20)
as
begin 
--SET IDENTITY_INSERT Group2.EndorsementsTemp  ON
insert into Group2.EndorsementsTemp
 (customerID, policyNumber, policyName,productLine, customerName,
 customerAddress,customerTelephone,customerGender,customerDOB,
 customerSmoking,nomineeName,nomineeRelation,premiumFrequency,docPath,statusEndo)

 values(@ccustomerID,@cpolicyNumber,@cpolicyName,@cproductLine,
 @cName,@cAddress,@cPh,@cGender,@cDOB,@cSmoking,@cnomineeName,
 @cnomineeRelation,@cpremiumFrequency,@cdocPath,@cstatusEndo)
end
------------------------
exec Group2.usp_InsertEndoTemp 5001,22,	
'Home Insurance','Non-Life Insurance',
'Rajan R','Pune','7700112347','M','1990-05-08','Smoker','Ram','Brother','MONTHLY','C:','PENDING'

----------------

drop table Group2.EndorsementsTemp
--create table Group2.Temp
--(
--transactionID int identity(1000,10) primary key,
--customerID int FOREIGN KEY (customerID) REFERENCES Group2.Customer(customerID),
--policyNumber int FOREIGN KEY (policyNumber) REFERENCES Group2.Policy(policyNumber),
--policyName varchar(30),
--productLine varchar(30),
--customerName varchar(30),
--customerAddress varchar(50),
--customerTelephone varchar(12),
--customerGender char,
--customerDOB DateTime,
--customerSmoking varchar(20),
--nomineeName varchar(30),
--nomineeRelation varchar(20),
--premiumFrequency varchar(20),

--)


--drop table Group2.Temp

create table Group2.Test
(
transactionID int identity(1000,10) primary key,

nomineeRelation varchar(20),
premiumFrequency varchar(20)

)

insert into Group2.Test values('Father','BCD')


---------------------------------------

--alter table Group2.Endorsements
--ALTER COLUMN  customerID int NOT NULL

--policyNumber int NOT NULL
--------------------------------------

create table Group2.CustDocuments
(
transactionID int FOREIGN KEY (transactionID) REFERENCES Group2.EndorsementsTemp(transactionID),
docsPath varchar(100)
)

---------------------------------25/10--------------------------------------------
SELECT CPD.policyNumber, CPD.customerID, Ct.customerID, Ct.customerDOB, Ct.customerName
from Group2.CustomerPolicyDetails CPD, Group2.Customer Ct
where CPD.customerID=Ct.customerID
----------------------------------------------------------------------------
SELECT CPD.policyNumber, CPD.customerID, Ct.customerDOB, Ct.customerName
from Group2.CustomerPolicyDetails CPD INNER JOIN Group2.Customer Ct
ON CPD.customerID=Ct.customerID where 
(CPD.policyNumber=11 and (CPD.customerID=5002 or Ct.customerName='Maria S') and Ct.customerDOB='02/05/1992')
---------------------------------------------------------------------------------
alter proc Group2.usp_SearchPolicy
@PN int ,
@CID int
as
begin
SELECT CPD.policyNumber,CPD.customerID,PC.policyName, PC.policyDetails
from Group2.CustomerPolicyDetails CPD INNER JOIN Group2.Policy PC
ON CPD.policyNumber=PC.policyNumber where   
(CPD.policyNumber=@PN and CPD.customerID=@CID)
end
---------------------------------
--SELECT CPD.policyNumber,CPD.customerID,PC.policyNumber, PC.customerDOB, PC.customerName
--from Group2.CustomerPolicyDetails CPD INNER JOIN Group2.Policy PC
--ON CPD.policyNumber=PC.policyNumber where   
--(CPD.policyNumber=@PN and CPD.customerID=@CID)
---------------------------

--SELECT CPD.policyNumber,CPD.customerID,PC.policyName, PC.policyDetails
--from Group2.CustomerPolicyDetails CPD INNER JOIN Group2.Policy PC
--ON CPD.policyNumber=PC.policyNumber where   
--(CPD.policyNumber=11 and CPD.customerID=5002)

exec Group2.usp_SearchPolicy 11,5002

--------------------------------------------------------------------------------------
alter table Group2.Endorsements
add
 customerDocs varchar(50),
 endoStatus varchar(15)
 -----------------------------------------------------------------
 select * from  Group2.Policy

 -------------------------------------------------------------------

select * from Group2.EndorsementsTemp


update Group2.Endorsements set endoStatus='PENDING'

select ET.transactionID,ET.customerID, ET.policyNumber, 
ET.policyName, ET.customerName, ET.customerAddress, 
ET.customerTelephone, ET.customerGender, ET.customerDOB,
 ET.customerSmoking, ET.nomineeName, ET.nomineeRelation, ET.premiumFrequency, 
 ET.customerDocs, ET.endoStatus
from Group2.EndorsementsTemp ET INNER JOIN Group2.Customer C
ON ET.customerID = C.customerID
where C.customerID=5001 and ET.endoStatus = 'PENDING'

------------------------------------26/10----------------------------------------------------

create table Group2.AuditEndoresementsTemp
(
auditID int identity(100,1),
transactionID int,
customerID int,
policyNumber int,
policyName varchar(30),
dateUpdated DateTime
)
-----------
create table Group2.AuditEndoresements
(
auditID int identity(100,1),
transactionID int,
customerID int,
policyNumber int,
policyName varchar(30),
dateUpdated DateTime
)
------------------------------------------------
create trigger Group2.trigger_updateOnEndo
ON Group2.EndorsementsTemp
for update
as
declare @transactionID int;
declare @customerID int;
declare @policyNumber int;
declare @policyName varchar(30);

select @transactionID = i.transactionID from inserted i;	
select @customerID = i.customerID from inserted i;	
select @policyNumber = i.policyNumber from inserted i;	
select @policyName = i.policyName from inserted i;	

begin

insert into Group2.AuditEndoresements
values(@transactionID,@customerID,@policyNumber,@policyName,getDate())

end
-----------------------------------------------------------------
 select * from  Group2.EndorsementsTemp

----------------------------------

SET IDENTITY_INSERT Group2.EndorsementsTemp  ON
exec Group2.usp_UpdateCustomerTemp 5002,22,'Home Insurance','Non-Life Insurance','Saumya R','Delhi','9988112347','Ram','Father','05/08/1990','F','Smoker','MONTHLY'
	--Procedure Credit Manish Rahangdale
transactionID int identity(1000,10) primary key,
customerID int FOREIGN KEY (customerID) REFERENCES Group2.Customer(customerID),
policyNumber int FOREIGN KEY (policyNumber) REFERENCES Group2.Policy(policyNumber),
policyName varchar(30),
productLine varchar(30),
customerName varchar(30),
customerAddress varchar(50),
customerTelephone varchar(12),
customerGender char,
customerDOB DateTime,
customerSmoking varchar(20),
nomineeName varchar(30),
nomineeRelation varchar(20),
premiumFrequency varchar(20)

SET IDENTITY_INSERT Group2.EndorsementsTemp  ON
insert into Group2.Temp values(5001, 11,'Abc','A','B','C','D','M','02/03/1999','fdgh','tjgf','tduy','yihg')

select IDENT_CURRENT('Rashmi.HospitalDB')+ident_incr('Rashmi.HospitalDB')

select IDENT_CURRENT('Group2.EndorsementsTemp')+ident_incr('Group2.EndorsementsTemp')

select IDENT_CURRENT('Group2.Test')+ident_incr('Group2.Test')


-------------------------------------------------------

alter PROC Group2.usp_Endorsements
@cid int,
@pno int
as 
begin
select transactionID,policyName,productLine,
customerName,customerAddress,customerTelephone,
nomineeName,nomineeRelation
from Group2.Endorsements
where (customerID=@cid AND policyNumber = @pno)
end

exec Group2.usp_Endorsements 5001,24


-----------------------02/11/2018----------------------------------

create PROC Group2.usp_ViewEndorsements
@cid int,
@pno int
as 
begin
select customerID,policyNumber,policyName,productLine,
customerName,customerAddress,customerTelephone,customerGender,
customerDOB,customerSmoking,nomineeName,nomineeRelation,premiumFrequency,customerDocs
from Group2.Endorsements
where (customerID=@cid AND policyNumber = @pno)
end

exec Group2.usp_ViewEndorsements 5001,24

-----------------------------------
ALTER TABLE Group2.Endorsements DROP column customerDocs

select * from Group2.Endorsements
---------------------------------------------

---- 03/11/2018-------------

delete from Group2.EndorsementsTemp where customerID=5003 AND policyNumber=13

ALTER TABLE Group2.CustomerDocs DROP column transactionID

drop table Group2.CustomerDocs

create table Group2.CustomerDocs
(
customerID varchar(20),
policyNumber int,
img image
)


----------------05/11/2018-----------------------------

create trigger Group2.trigger_customerUpdate
ON Group2.Endorsements
for insert
as
declare @customerID varchar(30);
declare @customerName varchar(30);
declare @customerAddress varchar(50);
declare @customerTelephone varchar(12);
declare @customerGender char;
declare @customerDOB DateTime;
declare @customerSmoking varchar(20);
declare @nomineeName varchar(30);
declare @nomineeRelation varchar(20);

select @customerName = i.customerName from inserted i;	
select @customerAddress = i.customerAddress from inserted i;	
select @customerTelephone = i.customerTelephone from inserted i;	
select @customerGender = i.customerGender from inserted i;	
select @customerDOB = i.customerDOB from inserted i;	
select @customerSmoking = i.customerSmoking from inserted i;	
select @nomineeName = i.nomineeName from inserted i;	
select @nomineeRelation = i.nomineeRelation from inserted i;	

begin
update Group2.Customer set
customerName=@customerName,
customerAddress=@customerAddress,
customerTelephone=@customerTelephone,
customerGender=@customerGender,
customerDOB=@customerDOB,
customerSmoking=@customerSmoking,
nomineeName=@nomineeName,
nomineeRelation=@nomineeRelation
where (customerID=@customerID AND @customerName = customerName);

end
------------------------------
select * from Group2.Customer

create proc Group2.usp_AllCustEndo
as
begin
select * from Group2.Endorsements
end

exec Group2.usp_AllCustEndo

---------------07/11/2018-------------
alter proc Group2.usp_RetrieveImage
@cid int,
@pn int
as
begin
select * from Group2.CustomerDocs
 where customerID=@cid AND policyNumber=@pn
end

exec Group2.usp_RetrieveImage 5003,13
