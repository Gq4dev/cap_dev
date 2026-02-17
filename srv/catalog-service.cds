using {com.gq4dev as gq4dev} from '../db/schema.cds';

// service CatalogService {
//     entity Products      as projection on gq4dev.materials.Products;
//     entity Suppliers     as projection on gq4dev.sales.Suppliers;
//     entity Currency      as projection on gq4dev.materials.Currencies;
//     entity DimensionUnit as projection on gq4dev.materials.DimensionUnits;
//     entity Category      as projection on gq4dev.materials.Categories;
//     entity SalesData     as projection on gq4dev.sales.SalesData;
//     entity Reviews       as projection on gq4dev.sales.ProductReview;
//     entity Months        as projection on gq4dev.sales.Months;
//     entity UnitOfMeasure as projection on gq4dev.materials.UnitOfMeasures;
//     entity Order         as projection on gq4dev.sales.Orders;
//     entity OrderItem     as projection on gq4dev.sales.OrderItems;

// }

@graphql define service CatalogService {

    entity Products          as
        select from gq4dev.reports.Products {
            ID,
            Name           as ProductName     @mandatory,
            Description                       @mandatory,
            ImageUrl,
            ReleaseDate,
            DiscontinuedDate,
            Price                             @mandatory,
            Quantity                          @(
                mandatory,
                assert.range: [
                    0.00,
                    20.00
                ]
            ),
            Height,
            Width,
            UnitOfMeasure  as ToUnitOfMeasure @mandatory,
            Currency       as ToCurrency      @mandatory,
            Category       as ToCategory      @mandatory,
            Category.Name  as Category        @readonly,
            DimensionUnits as ToDimensionUnit,
            SalesData,
            Supplier,
            Reviews,
            Rating,
            StockAvailability,
            ToStockAvailibility

        };

    @readonly
    entity Supplier          as
        select from gq4dev.sales.Suppliers {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct
        };

    entity Reviews           as
        select from gq4dev.materials.ProductReview {
            ID,
            Name,
            Rating,
            Comment,
            createdAt,
            Product as ToProduct
        };

    @readonly
    entity SalesData         as
        select from gq4dev.sales.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as CurrencyKey,
            DeliveryMonth.ID          as DeliveryMonthId,
            DeliveryMonth.Description as DeliveryMonth,
            Product                   as toproduct
        };

    @readonly
    entity StockAvailability as
        select from gq4dev.materials.StockAvailability {
            ID,
            Description,
            Product as ToProduct
        };

    @readonly
    entity VH_Categories     as
        select from gq4dev.materials.Categories {
            ID   as Code,
            Name as Text
        }

    @readonly
    entity VH_Currencies     as
        select from gq4dev.materials.Currencies {
            ID          as Code,
            Description as Text
        }

    @readonly
    entity VH_UnitOfMeasures as
        select from gq4dev.materials.UnitOfMeasures {
            ID          as Code,
            Description as Text
        }

    //Pojection con PostFix
    @readonly
    entity VH_DimensionUnits as
        select
            ID          as Code,
            Description as Text

        from gq4dev.materials.DimensionUnits

}

service MyService {
    entity SuppliersProducts as
        select from gq4dev.materials.Products[Name = 'Laptop Pro 15']{
            *,
            Name,
            Description,
            Supplier.Address
        }
        where
            Supplier.Address.PostalCode = 1000;


}

define service Reports {

    entity AverageRating as projection on gq4dev.reports.AverageRating;


}
