
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS parts CASCADE;
DROP TABLE IF EXISTS supplier CASCADE;
DROP TABLE IF EXISTS parts_supplier CASCADE;
DROP TABLE IF EXISTS kicad_project CASCADE;
DROP TABLE IF EXISTS kicad_project_bom CASCADE;

CREATE TABLE parts (
    parts_uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    description TEXT NOT NULL,
    component_type TEXT CHECK(
        component_type = '' OR
        component_type = 'Resistor' OR
        component_type = 'Capacitor' OR
        component_type = 'Connector' OR
        component_type = 'Diode' OR
        component_type = 'Electro Mechanical' OR
        component_type = 'Mechanical' OR
        component_type = 'Inductor' OR
        component_type = 'Opto' OR
        component_type = 'OpAmp' OR
        component_type = 'Transister' OR
        component_type = 'Power Supply IC' OR
        component_type = 'Semiconductor'
    ) DEFAULT '',
    datasheet TEXT DEFAULT '',
    footprint_ref TEXT NOT NULL,
    symbol_ref TEXT NOT NULL,
    model_ref TEXT NOT NULL DEFAULT '',
    kicad_part_number TEXT NOT NULL PRIMARY KEY,
    manufacturer_part_number TEXT NOT NULL DEFAULT '',
    manufacturer TEXT NOT NULL DEFAULT '',
    manufacturer_part_url TEXT DEFAULT '',
    note TEXT DEFAULT '',
    published timestamp without time zone DEFAULT now(),
    value TEXT NOT NULL
);

CREATE TABLE supplier (
    supplier_uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    supplier_name TEXT NOT NULL UNIQUE,
    supplier_address TEXT,
    supplier_web_url TEXT,
    supplier_phone TEXT,
    supplier_email TEXT
);

CREATE TABLE parts_supplier (
    parts_supplier_uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    supplier_name TEXT NOT NULL REFERENCES supplier (supplier_name),
    kicad_part_number TEXT NOT NULL REFERENCES parts (kicad_part_number),
    supplier_part_number TEXT NOT NULL,
    supplier_part_url TEXT,
    price MONEY,
    price_currency TEXT,
    quantity INTEGER
);

CREATE TABLE kicad_project(
    kicad_project_design_uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    date timestamp without time zone DEFAULT now(),
    version TEXT UNIQUE,
    project_ref TEXT
);

CREATE TABLE kicad_project_bom(
    kicad_project_bom_uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    kicad_project_design_uuid UUID NOT NULL REFERENCES kicad_project (kicad_project_design_uuid),
    parts_supplier_uuid UUID REFERENCES parts_supplier (parts_supplier_uuid),
    reference TEXT NOT NULL,
    quantity INT NOT NULL,
    do_not_place BOOLEAN NOT NULL DEFAULT FALSE
);

INSERT INTO supplier(
    supplier_name,
    supplier_address,
    supplier_web_url,
    supplier_phone,
    supplier_email
)
VALUES
    (
        'Digikey',
        '',
        'http://www.digikey.com',
        '+1-218-681-6674',
        ''
    );


-- Test to make sure it works.
INSERT INTO parts (description , value, component_type, datasheet, footprint_ref, symbol_ref, kicad_part_number, manufacturer, manufacturer_part_number)
VALUES
('RES 10K OHM 1% 1/10W 0603', '10K','Resistor', 'https://www.yageo.com/upload/media/product/products/datasheet/rchip/PYu-RC_Group_51_RoHS_L_12.pdf', 'db_footprints:R_0603_1608Metric', 'db_library:R', '10K_0603', 'YAGEO', 'RC0603FR-0710KL'),
('CONN RCPT 100POS SMD GOLD', '100POS', 'Connector', 'https://www.hirose.com/en/product/document?clcode=&productname=&series=DF40&documenttype=Catalog&lang=en&documentid=en_DF40_CAT', 'db_footprints:CONN_DF40C-100DS-0.4V51_HIR', 'db_library:DF40C-100DS-0.4V51', 'CONN_100POS_HIROSE_SMD', 'Hirose Electric Co Ltd', 'DF40C-100DS-0.4V(51)'),
('Mounting Hole, 2.7mm for M2.5mm', 'M2.5', 'Mechanical', '', 'db_footprints:MountingHole_2.7mm_M2.5', 'db_library:MountingHole', 'MH_2.7MM_M2.5', '', '');
INSERT INTO parts_supplier(supplier_name, kicad_part_number, supplier_part_number, supplier_part_url, price, price_currency, quantity)
VALUES
('Digikey', '10K_0603', '311-10.0KHRCT-ND', 'https://www.digikey.co.nz/en/products/detail/yageo/RC0603FR-0710KL/726880', 0.18000, 'NZD', 1);


CREATE VIEW resistors AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.kicad_part_number,
        p.note,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    WHERE
        p.component_type = 'Resistor';


CREATE VIEW capacitors AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.kicad_part_number,
        p.note,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    WHERE
        p.component_type = 'Capacitor';


CREATE VIEW Connectors AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.kicad_part_number,
        p.note,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    WHERE
        p.component_type = 'Connector';


CREATE VIEW diodes AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.kicad_part_number,
        p.note,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    WHERE
        p.component_type = 'Diode';


CREATE VIEW electro_mechanicals AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.kicad_part_number,
        p.note,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    WHERE
        p.component_type = 'Electro Mechanical';

CREATE VIEW mechanicals AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.kicad_part_number,
        p.note,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    WHERE
        p.component_type = 'Mechanical';


CREATE VIEW inductors AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.kicad_part_number,
        p.note,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    WHERE
        p.component_type = 'Inductor';


CREATE VIEW optos AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.kicad_part_number,
        p.note,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    WHERE
        p.component_type = 'Opto';


CREATE VIEW op_amps AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.kicad_part_number,
        p.note,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    WHERE
        p.component_type = 'OpAmp';


CREATE VIEW transisters AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.kicad_part_number,
        p.note,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    WHERE
        p.component_type = 'Transister';


CREATE VIEW power_supply_ic AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.kicad_part_number,
        p.note,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    WHERE
        p.component_type = 'Power Supply IC';


CREATE VIEW semiconductors AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.kicad_part_number,
        p.note,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    WHERE
        p.component_type = 'Semiconductor';


CREATE VIEW misc AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.kicad_part_number,
        p.note,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    WHERE
        p.component_type = '';
