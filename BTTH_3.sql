# 1
create database QuanLyBanHang_BTTH;
use QuanLyBanHang_BTTH;
create table Customer(
    cID int primary key ,
    Name varchar(25),
    cAge tinyint
);
create table product(
    pID int primary key,
    pName varchar(25),
    pPrice int
);
create table orders(
    oID int primary key,
    cID int not null,
    oDate DATETIME,
    oTotalPrice int,
    constraint fk_1 foreign key (cID) references Customer(cID)
);
create table OrderDetail(
    oID int not null,
    pID int not null,
    adQTY int check ( adQTY > 0 ),
    constraint fk_2 foreign key (oID) references orders(oID),
    constraint fk_3 foreign key (pID) references product(pID)
);

insert into Customer(cID, Name, cAge)
values (1,'Minh Quan',10),
       (2,'Ngoc Oanh',20),
       (3,'Hong Ha',50);
insert into Product(pID, pName, pPrice)
values (1,'May Giat',3),
       (2,'Tu Lanh',5),
       (3,'Dieu Hoa',7),
       (4,'Quat',1),
       (5,'Bep Dien',2);
insert into orders(oID, cID, oDate, oTotalPrice)
values (1,1,'2006-03-21',null),
       (2,2,'2006-03-23',null),
       (3,1,'2006-03-16',null);
insert into OrderDetail(oID, pID, adQTY)
values (1,1,3),
       (1,3,7),
       (1,4,2),
       (2,1,1),
       (3,1,8),
       (2,5,4),
       (2,3,3);
# 2
select * from orders order by oDate desc ;
# 3
select pName, pPrice from product where pPrice >= all(select pPrice from product);
# 4
select distinct C.Name, p.pName
from orders join Customer C on C.cID = orders.cID
            join OrderDetail OD on orders.oID = OD.oID
            join product p on p.pID = OD.pID;
# 5
select Name from customer where cID not in (select cID from orders);
# 6
select o.oID, o.oDate, od.adQTY, p.pName, p.pPrice
from orders o join OrderDetail OD on o.oID = OD.oID
            join product p on p.pID = OD.pID;
# 7
select o.oID, o.oDate, sum(p.pPrice * od.adQTY) as Total
from orders o join OrderDetail OD on o.oID = OD.oID
            join product p on p.pID = OD.pID
group by o.oID;
# 8
create view Sales as select sum(t1.Total) `Sales` from
(select o.oID, o.oDate, sum(p.pPrice * od.adQTY) as Total
from orders o join OrderDetail OD on o.oID = OD.oID
              join product p on p.pID = OD.pID
group by o.oID) `t1`;
select * from Sales;
#9
alter table orders
    drop constraint fk_1;
alter table orderdetail
    drop constraint fk_2,
    drop constraint fk_3;
#10
create trigger after_update_customer
after update
on customer
for each row
begin
    update orders set cID = new.cID where oID = (select oID from orders where oID = old.cID);
end;

update customer set cID = 10 where cID = 4;
select * from customer;
select * from orders;
# 11
delimiter //
create procedure delProduct(in proName varchar(25))
begin
    delete from orderdetail where pID like (select pID from product where pName like proName);
    delete from product where pName like proName;
end //
select * from orderdetail;
select * from product;
call delProduct('may giat');
