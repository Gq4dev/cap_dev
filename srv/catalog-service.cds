using {com.gq4dev as gq4dev} from '../db/schema.cds';

service CatalogService {
    entity Products      as projection on gq4dev.Products;
    entity Suppliers     as projection on gq4dev.Suppliers;
    entity Currency      as projection on gq4dev.Currencies;
    entity DimensionUnit as projection on gq4dev.DimensionUnits;
    entity Category      as projection on gq4dev.Categories;
    entity SalesData     as projection on gq4dev.SalesData;
    entity Reviews       as projection on gq4dev.ProductReview;
    entity UnitOfMeasure as projection on gq4dev.UnitOfMeasures;

}
