-- # Table

-- ## Drop

drop table if exists dim_customer cascade;
drop table if exists dim_product cascade;
drop table if exists dim_category cascade;
drop table if exists dim_date cascade;
drop table if exists ft_sales cascade;
drop table if exists agg_product_sales cascade;

-- ## Create

-- - Dimensions

create table dim_customer (
	id serial,
	customer_id integer not null,
	customer_name varchar(100) not null
);

create table dim_product (
	id serial,
	product_id integer not null,
	product_description varchar(100) not null,
	product_manufacturer varchar(100) not null,
	inventory integer not null
);

create table dim_category (
	id serial,
	category_id integer not null,
	category_description varchar(100) not null
);

create table dim_date (
	date_key character(8) not null,
	full_date date not null,
	day_of_week smallint not null,
	day_number smallint not null,
	month_number smallint not null,
	year_number smallint not null
);

-- - Fact

create table ft_sales (
	id serial,
	dim_customer_id integer not null,
	dim_product_id integer not null,
	dim_category_id integer not null,
	dim_date_key character(8) not null,
	quantity integer not null,
	value numeric(10, 4) not null
);

create table ft_inventory (
	id serial,
	dim_product_id integer not null,
	dim_category_id integer not null,
	dim_date_key character(8) not null,
	product_manufacturer varchar(100) not null,
	quantity integer not null,
	value integer not null
);

-- - Aggregated Fact

create table agg_product_sales (
	dim_product_id integer not null,
	dim_date_key character(8) not null,
	quantity integer not null,
	value numeric(10, 4) not null
);

-- ## Alter

-- ### Constraints

-- - Primary Key

alter table dim_customer add constraint pk_dim_customer primary key (id);
alter table dim_product add constraint pk_dim_product primary key (id);
alter table dim_category add constraint pk_dim_category primary key (id);
alter table dim_date add constraint pk_dim_date_key primary key (date_key);
alter table ft_sales add constraint pk_ft_sales primary key (id);
alter table ft_inventory add constraint pk_ft_inventory primary key (id);
alter table agg_product_sales add constraint pk_agg_product_sales primary key (dim_product_id, dim_date_key);

-- - Foreign Key

alter table ft_sales add constraint fk_dim_customer foreign key (dim_customer_id) references dim_customer (id);
alter table ft_sales add constraint fk_dim_product foreign key (dim_product_id) references dim_product (id);
alter table ft_sales add constraint fk_dim_category foreign key (dim_category_id) references dim_category (id);
alter table ft_sales add constraint fk_dim_date foreign key (dim_date_key) references dim_date (date_key);

alter table ft_inventory add constraint fk_dim_product foreign key (dim_product_id) references dim_product (id);
alter table ft_inventory add constraint fk_dim_category foreign key (dim_category_id) references dim_category (id);
alter table ft_inventory add constraint fk_dim_date foreign key (dim_date_key) references dim_date (date_key);

alter table agg_product_sales add constraint fk_dim_product foreign key (dim_product_id) references dim_product (id);
alter table agg_product_sales add constraint fk_dim_date foreign key (dim_date_key) references dim_date (date_key);

-- - Check

alter table ft_sales add constraint ck_salues_quantity check (quantity >= 0);
alter table ft_sales add constraint ck_salues_value check (value >= 0);

alter table ft_inventory add constraint ck_inventory_quantity check (quantity >= 0);
alter table ft_inventory add constraint ck_inventory_value check (value >= 0);

alter table agg_product_sales add constraint ck_product_sales_quantity check (quantity >= 0);
alter table agg_product_sales add constraint ck_product_sales_value check (value >= 0);



select * from dim_product dp join ft_sales fs2 on dp.id = fs2.dim_product_id