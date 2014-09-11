-- Create Table: descriptions
--------------------------------------------------------------------------------
CREATE TABLE descriptions
(   
	id  INTEGER NOT NULL 
	,name VARCHAR(250)  NULL 
	,title VARCHAR(250)  NULL 
	,type VARCHAR(250)  NULL 
	,summary VARCHAR(250)  NULL 
	,CONSTRAINT PK_descriptions_id PRIMARY KEY (id)
);



-- Create Table: pages
--------------------------------------------------------------------------------
CREATE TABLE pages
(
	website_id INTEGER NOT NULL 
	,id INTEGER NOT NULL 
	,page_url VARCHAR(250)  NULL 
	,page_title VARCHAR(250)  NULL 
	,wave_url VARCHAR(250)  NULL 
	,CONSTRAINT PK_pages_id PRIMARY KEY (id)
);



-- Create Table: reports
--------------------------------------------------------------------------------
CREATE TABLE reports
(
	id INTEGER NOT NULL 
	,report_date TIMESTAMP  NULL 
	,website_id INTEGER NOT NULL 
	,CONSTRAINT PK_reports_id PRIMARY KEY (id)
);



-- Create Table: websites
--------------------------------------------------------------------------------
CREATE TABLE websites
(
	 id INTEGER NOT NULL 
	,website_url VARCHAR(250)  NULL 
	,website_name VARCHAR(250)  NULL 
	,CONSTRAINT PK_websites_id PRIMARY KEY (id)
);



-- Create Table: categories
--------------------------------------------------------------------------------
CREATE TABLE categories
(
	id INTEGER NOT NULL 
	,page_id INTEGER NOT NULL 
	,category_name VARCHAR(250)  NULL 
	,description_name VARCHAR(250)  NULL 
	,description_title VARCHAR(250)  NULL 
	,count INTEGER  NULL 
	,CONSTRAINT PK_categories_id PRIMARY KEY (id)
);



-- Create Foreign Key: pages.website_id -> websites.websites.id
ALTER TABLE pages ADD CONSTRAINT FK_pages_website_id_websites_id FOREIGN KEY (website_id) REFERENCES websites(id);

-- Create Foreign Key: reports.website_id -> websites.id
ALTER TABLE reports ADD CONSTRAINT FK_reports_website_id_websites_id FOREIGN KEY (website_id) REFERENCES websites(id);


-- Create Foreign Key: categories.page_id -> pages.id
ALTER TABLE categories ADD CONSTRAINT FK_categories_page_id_pages_id FOREIGN KEY (page_id) REFERENCES pages(id);





