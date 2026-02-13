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

define service CatalogService {
    entity Products          as
        select from gq4dev.materials.Products {
            ID,
            Name           as ProductName,
            Description,
            ImageUrl,
            ReleaseDate,
            DiscontinuedDate,
            Price,
            Quantity,
            Height,
            Width,
            UnitOfMeasure  as ToUnitOfMeasure,
            Currency       as ToCurrency,
            Category       as ToCategory,
            Category.Name  as Category,
            DimensionUnits as ToDimensionUnit,
            SalesData,
            Supplier,
            Reviews

        };

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

    entity StockAvailability as
        select from gq4dev.materials.StockAvailability {
            ID,
            Description,
            Product as ToProduct
        };

    entity VH_Categories     as
        select from gq4dev.materials.Categories {
            ID   as Code,
            Name as Text
        }

    entity VH_Currencies     as
        select from gq4dev.materials.Currencies {
            ID          as Code,
            Description as Text
        }

    entity VH_UnitOfMeasures as
        select from gq4dev.materials.UnitOfMeasures {
            ID          as Code,
            Description as Text
        }

    entity VH_DimensionUnits as
        select from gq4dev.materials.DimensionUnits {
            ID          as Code,
            Description as Text
        }
}
