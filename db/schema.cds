namespace com.gq4dev;

using {
    cuid,
    managed
} from '@sap/cds/common';


type Address : {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
}

context materials {


    entity Products : cuid, managed {
        //key ID               : UUID ;
        Name             : localized String not null;
        Description      : localized String;
        ImageUrl         : String;
        ReleaseDate      : DateTime default $now;
        DiscontinuedDate : DateTime;
        Price            : Decimal(16, 2);
        Height           : Decimal(16, 2);
        Width            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
        Supplier         : Association to one sales.Suppliers;
        UnitOfMeasure    : Association to UnitOfMeasures;
        DimensionUnits   : Association to DimensionUnits;
        Category         : Association to Categories;
        Currency         : Association to Currencies;
        SalesData        : Association to many sales.SalesData
                               on SalesData.Product = $self;
        Reviews          : Association to many materials.ProductReview
                               on Reviews.Product = $self;

    };

    entity Categories {
        key ID   : String(1);
            Name : localized String;
    };

    entity StockAvailability {
        key ID          : Integer;
            Description : localized String;
            Product     : Association to Products
    };

    entity Currencies {
        key ID          : String(3);
            Description : localized String
    };

    entity UnitOfMeasures {
        key ID          : String(2);
            Description : localized String;
    };

    entity DimensionUnits {
        key ID          : String(2);
            Description : localized String;
    };

    entity SelProducts   as select from gq4dev.materials.Products;

    entity SelProducts1  as
        select from gq4dev.materials.Products {
            Name,
            Price,
            Quantity
        }

    entity ProductReview : cuid, managed {
        // key ID      : UUID;
        Name    : String;
        Rating  : Integer;
        Comment : String;
        Product : Association to materials.Products;
    };

    entity SelProducts2  as
        select from gq4dev.materials.Products
        left join materials.ProductReview
            on Products.Name = ProductReview.Name
        {
            Rating,
            Products.Name,
            sum(Price) as totalprice
        }
        group by
            Rating,
            Products.Name
        order by
            Rating;

    // Projections

    entity ProjProducts  as projection on Products;

    entity ProjProducts2 as
        projection on Products {
            Name,
            ReleaseDate
        };

}


context sales {
    entity Orders : cuid, managed {
        // key ID       : UUID;
        Date     : Date;
        Customer : String;
        Item     : Composition of many OrderItems
                       on Item.Order = $self
    };

    entity OrderItems : cuid, managed {
        // key ID       : UUID;
        Order    : Association to Orders;
        Product  : Association to materials.Products;
        Quantity : Integer;
    }


    entity Suppliers : cuid, managed {
        // key ID      : UUID;
        Name    : String;
        Email   : String;
        Phone   : String;
        Fax     : String;
        Address : Address;
        Product : Association to many materials.Products
                      on Product.Supplier = $self
    };


    entity Months {
        key ID               : String(2);
            Description      : localized String;
            ShortDescription : localized String(3);
    };


    entity SalesData : cuid, managed {
        // key ID            : UUID;
        DeliveryDate  : DateTime;
        Revenue       : Decimal(16, 2);
        Product       : Association to materials.Products;
        Currency      : Association to materials.Currencies;
        DeliveryMonth : Association to Months;
    };

}

context reports {
    entity AverageRating as
        select from gq4dev.materials.ProductReview {
            Product.ID  as ProductId,
            avg(Rating) as AverageRating : Decimal(16, 2)
        }
        group by
            Product.ID;

    entity Products      as
        select from gq4dev.materials.Products
        mixin {
            ToStockAvailibility : Association to gq4dev.materials.StockAvailability
                                      on ToStockAvailibility.ID = $projection.StockAvailability;
            ToAverageRating     : Association to AverageRating
                                      on ToAverageRating.ProductId = ID;
        }

        into {
            *,
            ToAverageRating.AverageRating as Rating,
            case
                when Quantity >= 8
                     then 3
                when Quantity > 0
                     then 2
                else 1
            end                           as StockAvailability : Integer,
            ToStockAvailibility
        }


}
