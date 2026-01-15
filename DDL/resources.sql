CREATE OR REPLACE FILE FORMAT IF NOT EXISTS csv_format
  TYPE = 'CSV' 
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;


CREATE OR REPLACE STAGE snowstage
FILE_FORMAT = csv_format
URL='.........';
    

COPY INTO <your_table_name>
FRoM @snowstage
FILES=('.....')
CREDENTIALS=(aws_key_id = ...., aws_secret_key = '....');

