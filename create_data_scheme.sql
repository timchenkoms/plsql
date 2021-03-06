
CREATE TABLE  "ORDER_STATUSES" 
   (	"STATUS_ID" NUMBER, 
	"STATUS_NAME" VARCHAR2(100), 
	 CONSTRAINT "ORDER_STATUSES_PK" PRIMARY KEY ("STATUS_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "ORDER_STATUSES_UK1" UNIQUE ("STATUS_NAME")
  USING INDEX  ENABLE
   )
/


CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_ORDER_STATUSES" 
  before insert on "ORDER_STATUSES"               
  for each row  
begin   
  if :NEW."STATUS_ID" is null then 
    select "ORDER_STATUSES_SEQ".nextval into :NEW."STATUS_ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_ORDER_STATUSES" ENABLE
/

CREATE TABLE  "CUSTOMERS" 
   (	"CUSTOMER_ID" NUMBER, 
	"CUSTOMER_USERNAME" VARCHAR2(100) NOT NULL ENABLE, 
	"CUSTOMER_FIRST_NAME" VARCHAR2(100) NOT NULL ENABLE, 
	"CUSTOMER_EMAIL" VARCHAR2(100) NOT NULL ENABLE, 
	"CUSTOMER_PHONE" NUMBER, 
	"CUSTOMER_PASSWORD" VARCHAR2(100) NOT NULL ENABLE, 
	"CUSTOMER_LAST_NAME" VARCHAR2(100) NOT NULL ENABLE, 
	"CUSTOMER_CREATE_DATE" DATE NOT NULL ENABLE, 
	 CONSTRAINT "CUSTOMERS_PK" PRIMARY KEY ("CUSTOMER_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "CUSTOMERS_UK1" UNIQUE ("CUSTOMER_EMAIL")
  USING INDEX  ENABLE, 
	 CONSTRAINT "CUSTOMERS_UK2" UNIQUE ("CUSTOMER_USERNAME")
  USING INDEX  ENABLE
   )
/
CREATE TABLE  "SELLERS" 
   (	"SELLER_ID" NUMBER, 
	"SELLER_NAME" VARCHAR2(100) NOT NULL ENABLE, 
	"SELLER_EMAIL" VARCHAR2(100) NOT NULL ENABLE, 
	"SELLER_PHONE" NUMBER, 
	 CONSTRAINT "SELLERS_PK" PRIMARY KEY ("SELLER_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "SELLERS_UK1" UNIQUE ("SELLER_EMAIL")
  USING INDEX  ENABLE, 
	 CONSTRAINT "SELLERS_UK2" UNIQUE ("SELLER_NAME")
  USING INDEX  ENABLE
   )
/
CREATE TABLE  "SHIPPING_SPEEDS" 
   (	"SPEED_ID" NUMBER, 
	"SPEED_NAME" VARCHAR2(100) NOT NULL ENABLE, 
	 CONSTRAINT "SHIPPING_SPEEDS_PK" PRIMARY KEY ("SPEED_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "SHIPPING_SPEEDS_UK1" UNIQUE ("SPEED_NAME")
  USING INDEX  ENABLE
   )
/
CREATE TABLE  "ORDERS" 
   (	"ORDER_ID" NUMBER, 
	"ORDER_CUSTOMER" NUMBER NOT NULL ENABLE, 
	"ORDER_SELLER" NUMBER NOT NULL ENABLE, 
	"ORDER_SPEED" NUMBER NOT NULL ENABLE, 
	"ORDER_DATE" DATE NOT NULL ENABLE, 
	"ORDER_ADDRESS_LINE1" VARCHAR2(100) NOT NULL ENABLE, 
	"ORDER_ADDRESS_LINE2" VARCHAR2(100), 
	"ORDER_ZIPCODE" NUMBER NOT NULL ENABLE, 
	"ORDER_TRACKING_ID" VARCHAR2(100), 
	"ORDER_STATUS" NUMBER NOT NULL ENABLE, 
	 CONSTRAINT "ORDERS_PK" PRIMARY KEY ("ORDER_ID")
  USING INDEX  ENABLE
   )
/
ALTER TABLE  "ORDERS" ADD CONSTRAINT "ORDERS_FK4" FOREIGN KEY ("ORDER_STATUS")
	  REFERENCES  "ORDER_STATUSES" ("STATUS_ID") ENABLE
/
CREATE TABLE  "PRODUCT_CATEGORIES" 
   (	"CATEGORY_ID" NUMBER, 
	"CATEGORY_NAME" VARCHAR2(100) NOT NULL ENABLE, 
	 CONSTRAINT "PRODUCT_CATEGORIES_PK" PRIMARY KEY ("CATEGORY_ID")
  USING INDEX  ENABLE
   )
/
CREATE TABLE  "PRODUCTS" 
   (	"PRODUCT_ID" NUMBER, 
	"PRODUCT_NAME" VARCHAR2(100) NOT NULL ENABLE, 
	"PRODUCT_DESCRIPTION" VARCHAR2(1000), 
	"PRODUCT_CATEGORY" NUMBER NOT NULL ENABLE, 
	 CONSTRAINT "PRODUCTS_PK" PRIMARY KEY ("PRODUCT_ID")
  USING INDEX  ENABLE
   )
/

CREATE UNIQUE INDEX  "PRODUCTS_UK1" ON  "PRODUCTS" ("PRODUCT_NAME", "PRODUCT_CATEGORY")
/

CREATE TABLE  "PRODUCT_CONDITIONS" 
   (	"CONDITION_ID" NUMBER, 
	"CONDITION_NAME" VARCHAR2(100) NOT NULL ENABLE, 
	 CONSTRAINT "PRODUCT_CONDITIONS_PK" PRIMARY KEY ("CONDITION_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "PRODUCT_CONDITIONS_UK1" UNIQUE ("CONDITION_NAME")
  USING INDEX  ENABLE
   )
/
CREATE TABLE  "PRODUCTS_FOR_SELL" 
   (	"PFS_ID" NUMBER, 
	"PFS_PRODUCT" NUMBER NOT NULL ENABLE, 
	"PFS_SELLER" NUMBER NOT NULL ENABLE, 
	"PFS_CONDITION" NUMBER NOT NULL ENABLE, 
	"PFS_PRICE" NUMBER NOT NULL ENABLE, 
	"PFS_AMOUNT" NUMBER NOT NULL ENABLE, 
	 CONSTRAINT "PRODUCTS_FOR_SELL_PK" PRIMARY KEY ("PFS_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "PRODUCTS_FOR_SELL_UK1" UNIQUE ("PFS_PRODUCT", "PFS_SELLER", "PFS_CONDITION")
  USING INDEX  ENABLE
   )
/
CREATE TABLE  "ORDER_PURCHASES" 
   (	"PURCHASE_ID" NUMBER, 
	"PURCHASE_ORDER" NUMBER NOT NULL ENABLE, 
	"PURCHASE_PSP" NUMBER NOT NULL ENABLE, 
	"PURCHASE_PRICE" NUMBER NOT NULL ENABLE, 
	"PURCHASE_AMOUNT" NUMBER NOT NULL ENABLE, 
	 CONSTRAINT "ORDER_PURCHASES_PK" PRIMARY KEY ("PURCHASE_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "ORDER_PURCHASES_UK1" UNIQUE ("PURCHASE_ORDER", "PURCHASE_PSP")
  USING INDEX  ENABLE
   )
/
CREATE TABLE  "CUSTOMER_ADDRESSES" 
   (	"ADDRESS_ID" NUMBER, 
	"ADDRESS_CUSTOMER" NUMBER NOT NULL ENABLE, 
	"ADDRESS_LINE1" VARCHAR2(100) NOT NULL ENABLE, 
	"ADDRESS_LINE2" VARCHAR2(100), 
	"ADDRESS_ZIPCODE" VARCHAR2(10) NOT NULL ENABLE, 
	 CONSTRAINT "CUSTOMER_ADDRESSES_PK" PRIMARY KEY ("ADDRESS_ID")
  USING INDEX  ENABLE
   )
/
ALTER TABLE  "CUSTOMER_ADDRESSES" ADD CONSTRAINT "CUSTOMER_ADDRESSES_FK" FOREIGN KEY ("ADDRESS_CUSTOMER")
	  REFERENCES  "CUSTOMERS" ("CUSTOMER_ID") ENABLE
/
ALTER TABLE  "ORDERS" ADD CONSTRAINT "ORDERS_FK" FOREIGN KEY ("ORDER_CUSTOMER")
	  REFERENCES  "CUSTOMERS" ("CUSTOMER_ID") ENABLE
/
ALTER TABLE  "ORDERS" ADD CONSTRAINT "ORDERS_FK2" FOREIGN KEY ("ORDER_SELLER")
	  REFERENCES  "SELLERS" ("SELLER_ID") ENABLE
/
ALTER TABLE  "ORDERS" ADD CONSTRAINT "ORDERS_FK3" FOREIGN KEY ("ORDER_SPEED")
	  REFERENCES  "SHIPPING_SPEEDS" ("SPEED_ID") ENABLE
/
ALTER TABLE  "ORDER_PURCHASES" ADD CONSTRAINT "ORDER_PURCHASES_FK" FOREIGN KEY ("PURCHASE_ORDER")
	  REFERENCES  "ORDERS" ("ORDER_ID") ENABLE
/
ALTER TABLE  "PRODUCTS" ADD CONSTRAINT "PRODUCTS_FK" FOREIGN KEY ("PRODUCT_CATEGORY")
	  REFERENCES  "PRODUCT_CATEGORIES" ("CATEGORY_ID") ENABLE
/
ALTER TABLE  "PRODUCTS_FOR_SELL" ADD CONSTRAINT "PRODUCTS_FOR_SELL_FK" FOREIGN KEY ("PFS_PRODUCT")
	  REFERENCES  "PRODUCTS" ("PRODUCT_ID") ENABLE
/
ALTER TABLE  "PRODUCTS_FOR_SELL" ADD CONSTRAINT "PRODUCTS_FOR_SELL_FK2" FOREIGN KEY ("PFS_SELLER")
	  REFERENCES  "SELLERS" ("SELLER_ID") ENABLE
/
ALTER TABLE  "PRODUCTS_FOR_SELL" ADD CONSTRAINT "PRODUCTS_FOR_SELL_FK3" FOREIGN KEY ("PFS_CONDITION")
	  REFERENCES  "PRODUCT_CONDITIONS" ("CONDITION_ID") ENABLE
/
CREATE UNIQUE INDEX  "CUSTOMERS_PK" ON  "CUSTOMERS" ("CUSTOMER_ID")
/
CREATE UNIQUE INDEX  "CUSTOMERS_UK1" ON  "CUSTOMERS" ("CUSTOMER_EMAIL")
/
CREATE UNIQUE INDEX  "CUSTOMERS_UK2" ON  "CUSTOMERS" ("CUSTOMER_USERNAME")
/
CREATE UNIQUE INDEX  "CUSTOMER_ADDRESSES_PK" ON  "CUSTOMER_ADDRESSES" ("ADDRESS_ID")
/
CREATE UNIQUE INDEX  "ORDERS_PK" ON  "ORDERS" ("ORDER_ID")
/
CREATE UNIQUE INDEX  "ORDER_PURCHASES_PK" ON  "ORDER_PURCHASES" ("PURCHASE_ID")
/
CREATE UNIQUE INDEX  "ORDER_PURCHASES_UK1" ON  "ORDER_PURCHASES" ("PURCHASE_ORDER", "PURCHASE_PSP")
/
CREATE UNIQUE INDEX  "PRODUCTS_FOR_SELL_PK" ON  "PRODUCTS_FOR_SELL" ("PFS_ID")
/
CREATE UNIQUE INDEX  "PRODUCTS_FOR_SELL_UK1" ON  "PRODUCTS_FOR_SELL" ("PFS_PRODUCT", "PFS_SELLER", "PFS_CONDITION")
/
CREATE UNIQUE INDEX  "PRODUCTS_PK" ON  "PRODUCTS" ("PRODUCT_ID")
/
CREATE UNIQUE INDEX  "PRODUCT_CATEGORIES_PK" ON  "PRODUCT_CATEGORIES" ("CATEGORY_ID")
/
CREATE UNIQUE INDEX  "PRODUCT_CONDITIONS_PK" ON  "PRODUCT_CONDITIONS" ("CONDITION_ID")
/
CREATE UNIQUE INDEX  "PRODUCT_CONDITIONS_UK1" ON  "PRODUCT_CONDITIONS" ("CONDITION_NAME")
/
CREATE UNIQUE INDEX  "SELLERS_PK" ON  "SELLERS" ("SELLER_ID")
/
CREATE UNIQUE INDEX  "SELLERS_UK1" ON  "SELLERS" ("SELLER_EMAIL")
/
CREATE UNIQUE INDEX  "SELLERS_UK2" ON  "SELLERS" ("SELLER_NAME")
/
CREATE UNIQUE INDEX  "SHIPPING_SPEEDS_PK" ON  "SHIPPING_SPEEDS" ("SPEED_ID")
/
CREATE UNIQUE INDEX  "SHIPPING_SPEEDS_UK1" ON  "SHIPPING_SPEEDS" ("SPEED_NAME")
/
 CREATE SEQUENCE   "CUSTOMERS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "CUSTOMER_ADDRESSES_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "ORDERS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "ORDER_PURCHASES_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "PRODUCTS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "PRODUCT_CATEGORIES_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 41 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "PRODUCT_CONDITIONS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 41 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SELLERS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SHIPPING_SPEEDS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "UNITS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_CUSTOMERS" 
  before insert on "CUSTOMERS"               
  for each row  
begin   
  if :NEW."CUSTOMER_ID" is null then 
    select "CUSTOMERS_SEQ".nextval into :NEW."CUSTOMER_ID" from sys.dual; 
  end if; 
  
  if :NEW.CUSTOMER_create_date is null then 
    :NEW.CUSTOMER_create_date := sysdate; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_CUSTOMERS" ENABLE
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_CUSTOMER_ADDRESSES" 
  before insert on "CUSTOMER_ADDRESSES"               
  for each row  
begin   
  if :NEW."ADDRESS_ID" is null then 
    select "CUSTOMER_ADDRESSES_SEQ".nextval into :NEW."ADDRESS_ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_CUSTOMER_ADDRESSES" ENABLE
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_ORDERS" 
  before insert on "ORDERS"               
  for each row  
begin   
  if :NEW."ORDER_ID" is null then 
    select "ORDERS_SEQ".nextval into :NEW."ORDER_ID" from sys.dual; 
  end if; 
  
  if :NEW.ORDER_date is null then 
    :NEW.ORDER_date := sysdate; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_ORDERS" ENABLE
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_ORDER_PURCHASES" 
  before insert on "ORDER_PURCHASES"               
  for each row  
begin   
  if :NEW."PURCHASE_ID" is null then 
    select "ORDER_PURCHASES_SEQ".nextval into :NEW."PURCHASE_ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_ORDER_PURCHASES" ENABLE
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_PRODUCTS" 
  before insert on "PRODUCTS"               
  for each row  
begin   
  if :NEW."PRODUCT_ID" is null then 
    select "PRODUCTS_SEQ".nextval into :NEW."PRODUCT_ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_PRODUCTS" ENABLE
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_PRODUCTS_FOR_SELL" 
  before insert on "PRODUCTS_FOR_SELL"               
  for each row  
begin   
  if :NEW."PFS_ID" is null then 
    select "UNITS_SEQ".nextval into :NEW."PFS_ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_PRODUCTS_FOR_SELL" ENABLE
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_PRODUCT_CATEGORIES" 
  before insert on "PRODUCT_CATEGORIES"               
  for each row  
begin   
  if :NEW."CATEGORY_ID" is null then 
    select "PRODUCT_CATEGORIES_SEQ".nextval into :NEW."CATEGORY_ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_PRODUCT_CATEGORIES" ENABLE
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_PRODUCT_CONDITIONS" 
  before insert on "PRODUCT_CONDITIONS"               
  for each row  
begin   
  if :NEW."CONDITION_ID" is null then 
    select "PRODUCT_CONDITIONS_SEQ".nextval into :NEW."CONDITION_ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_PRODUCT_CONDITIONS" ENABLE
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_SELLERS" 
  before insert on "SELLERS"               
  for each row  
begin   
  if :NEW."SELLER_ID" is null then 
    select "SELLERS_SEQ".nextval into :NEW."SELLER_ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_SELLERS" ENABLE
/
CREATE OR REPLACE EDITIONABLE TRIGGER  "BI_SHIPPING_SPEEDS" 
  before insert on "SHIPPING_SPEEDS"               
  for each row  
begin   
  if :NEW."SPEED_ID" is null then 
    select "SHIPPING_SPEEDS_SEQ".nextval into :NEW."SPEED_ID" from sys.dual; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_SHIPPING_SPEEDS" ENABLE
/
