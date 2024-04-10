
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS parts CASCADE;
DROP TABLE IF EXISTS supplier CASCADE;
DROP TABLE IF EXISTS parts_supplier CASCADE;
DROP TABLE IF EXISTS kicad_project CASCADE;
DROP TABLE IF EXISTS kicad_project_bom CASCADE;

CREATE TABLE parts (
    parts_uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    description TEXT,
    component_type TEXT CHECK(
        component_type = '' OR
        component_type = 'Resistor' OR
        component_type = 'Capacitor' OR
        component_type = 'Connector' OR
        component_type = 'Diode' OR
        component_type = 'Electro Mechanical' OR
        component_type = 'Inductor' OR
        component_type = 'Opto' OR
        component_type = 'OpAmp' OR
        component_type = 'Transister' OR
        component_type = 'Power Supply IC' OR
        component_type = 'Semiconductor'
    ) DEFAULT '',
    datasheet TEXT,
    footprint_ref TEXT,
    symbol_ref TEXT,
    model_ref TEXT,
    kicad_part_number TEXT NOT NULL UNIQUE,
    manufacturer_part_number TEXT,
    manufacturer TEXT,
    manufacturer_part_url TEXT,
    note TEXT,
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
    parts_supplier_uuid UUID REFERENCES parts_supplier (parts_supplier_uuid)
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

CREATE VIEW resistors AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.model_ref,
        p.kicad_part_number,
        p.note,
        p.published,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Resistor';


CREATE VIEW capacitors AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.model_ref,
        p.kicad_part_number,
        p.note,
        p.published,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Capacitor';


CREATE VIEW Connectors AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.model_ref,
        p.kicad_part_number,
        p.note,
        p.published,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Connector';


CREATE VIEW diodes AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.model_ref,
        p.kicad_part_number,
        p.note,
        p.published,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Diode';


CREATE VIEW electro_mechanicals AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.model_ref,
        p.kicad_part_number,
        p.note,
        p.published,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Electro Mechanical';


CREATE VIEW inductors AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.model_ref,
        p.kicad_part_number,
        p.note,
        p.published,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Inductor';


CREATE VIEW optos AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.model_ref,
        p.kicad_part_number,
        p.note,
        p.published,
        p.value,

        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Opto';


CREATE VIEW op_amps AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.model_ref,
        p.kicad_part_number,
        p.note,
        p.published,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'OpAmp';


CREATE VIEW transisters AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.model_ref,
        p.kicad_part_number,
        p.note,
        p.published,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Transister';


CREATE VIEW power_supply_ic AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.model_ref,
        p.kicad_part_number,
        p.note,
        p.published,
        p.value,

        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Power Supply IC';


CREATE VIEW semiconductors AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.model_ref,
        p.kicad_part_number,
        p.note,
        p.published,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Semiconductor';


CREATE VIEW misc AS
    SELECT
        p.datasheet,
        p.description,
        p.component_type,
        p.footprint_ref,
        p.symbol_ref,
        p.model_ref,
        p.kicad_part_number,
        p.note,
        p.published,
        p.value,
        p.manufacturer_part_number,
        p.manufacturer_part_url,
        p.manufacturer
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = '';
