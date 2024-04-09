DROP TABLE IF EXISTS parts CASCADE;
DROP TABLE IF EXISTS supplier CASCADE;
DROP TABLE IF EXISTS parts_supplier CASCADE;

CREATE TABLE parts (
    parts_id bigserial PRIMARY KEY,
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
    note TEXT,
    published timestamp without time zone DEFAULT now(),
    value TEXT NOT NULL
);

CREATE TABLE supplier (
    supplier_name TEXT NOT NULL UNIQUE,
    supplier_address TEXT,
    supplier_web_url TEXT,
    supplier_phone TEXT,
    supplier_email TEXT
);

CREATE TABLE parts_supplier (
    parts_supplier_id bigserial PRIMARY KEY,
    supplier_name TEXT NOT NULL REFERENCES supplier (supplier_name),
    kicad_part_number TEXT NOT NULL REFERENCES parts (kicad_part_number),
    supplier_part_number TEXT NOT NULL,
    manufacturer_part_number TEXT,
    manufacturer TEXT,
    manufacturer_part_url TEXT,
    supplier_part_url TEXT,
    price MONEY,
    price_currency TEXT,
    quantity INTEGER
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
        p.parts_id,
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
        ps.supplier_name,
        ps.supplier_part_number,
        ps.manufacturer_part_number,
        ps.manufacturer_part_url,
        ps.manufacturer,
        ps.supplier_part_url,
        ps.price,
        ps.price_currency,
        ps.quantity
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Resistor';


CREATE VIEW capacitors AS
    SELECT
        p.parts_id,
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
        ps.supplier_name,
        ps.supplier_part_number,
        ps.manufacturer_part_number,
        ps.manufacturer_part_url,
        ps.manufacturer,
        ps.supplier_part_url,
        ps.price,
        ps.price_currency,
        ps.quantity
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Capacitor';


CREATE VIEW Connectors AS
    SELECT
        p.parts_id,
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
        ps.supplier_name,
        ps.supplier_part_number,
        ps.manufacturer_part_number,
        ps.manufacturer_part_url,
        ps.manufacturer,
        ps.supplier_part_url,
        ps.price,
        ps.price_currency,
        ps.quantity
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Connector';


CREATE VIEW diodes AS
    SELECT
        p.parts_id,
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
        ps.supplier_name,
        ps.supplier_part_number,
        ps.manufacturer_part_number,
        ps.manufacturer_part_url,
        ps.manufacturer,
        ps.supplier_part_url,
        ps.price,
        ps.price_currency,
        ps.quantity
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Diode';


CREATE VIEW electro_mechanicals AS
    SELECT
        p.parts_id,
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
        ps.supplier_name,
        ps.supplier_part_number,
        ps.manufacturer_part_number,
        ps.manufacturer_part_url,
        ps.manufacturer,
        ps.supplier_part_url,
        ps.price,
        ps.price_currency,
        ps.quantity
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Electro Mechanical';


CREATE VIEW inductors AS
    SELECT
        p.parts_id,
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
        ps.supplier_name,
        ps.supplier_part_number,
        ps.manufacturer_part_number,
        ps.manufacturer_part_url,
        ps.manufacturer,
        ps.supplier_part_url,
        ps.price,
        ps.price_currency,
        ps.quantity
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Inductor';


CREATE VIEW optos AS
    SELECT
        p.parts_id,
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
        ps.supplier_name,
        ps.supplier_part_number,
        ps.manufacturer_part_number,
        ps.manufacturer_part_url,
        ps.manufacturer,
        ps.supplier_part_url,
        ps.price,
        ps.price_currency,
        ps.quantity
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Opto';


CREATE VIEW op_amps AS
    SELECT
        p.parts_id,
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
        ps.supplier_name,
        ps.supplier_part_number,
        ps.manufacturer_part_number,
        ps.manufacturer_part_url,
        ps.manufacturer,
        ps.supplier_part_url,
        ps.price,
        ps.price_currency,
        ps.quantity
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'OpAmp';


CREATE VIEW transisters AS
    SELECT
        p.parts_id,
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
        ps.supplier_name,
        ps.supplier_part_number,
        ps.manufacturer_part_number,
        ps.manufacturer_part_url,
        ps.manufacturer,
        ps.supplier_part_url,
        ps.price,
        ps.price_currency,
        ps.quantity
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Transister';


CREATE VIEW power_supply_ic AS
    SELECT
        p.parts_id,
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
        ps.supplier_name,
        ps.supplier_part_number,
        ps.manufacturer_part_number,
        ps.manufacturer_part_url,
        ps.manufacturer,
        ps.supplier_part_url,
        ps.price,
        ps.price_currency,
        ps.quantity
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Power Supply IC';


CREATE VIEW semiconductors AS
    SELECT
        p.parts_id,
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
        ps.supplier_name,
        ps.supplier_part_number,
        ps.manufacturer_part_number,
        ps.manufacturer_part_url,
        ps.manufacturer,
        ps.supplier_part_url,
        ps.price,
        ps.price_currency,
        ps.quantity
    FROM
        parts p
    JOIN
        parts_supplier ps ON ps.kicad_part_number = p.kicad_part_number
    WHERE
        p.component_type = 'Semiconductor';
