namespace com.training;

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

//TIPOS ARRAY
// type EmailsAddresses_01 : array of {
//     kind  : String;
//     email : String;
// }

// type EmailsAddresses_02 : {
//     kind  : String;
//     email : String;
// }


// entity Emails {
//     email_01 : EmailsAddresses_01;
//     email_02 : many EmailsAddresses_02;
//     email_03 : many {
//         kind  : String;
//         email : String;
//     }
// }


//ENUM
// type Gender  : String enum {
//     male;
//     female
// }

// entity Order {
//     clientgender : Gender;
//     status       : Integer enum {
//         submitted = 1;
//         fullfilled = 2;
//         shipped = 3;
//         cancel = -1;
//     }
//     priority: String @asset.range enum {
//         high;medium;low;
//     }
// }


// entity Car {

//     key     ID         : UUID;
//             Name       : String;
//     virtual Discount_1 : Decimal;
//     @Core.Computed: false;
//     virtual Discount_2 : Decimal;
// }

//Vistas con parametros

// entity ParamProducts(pName: String)     as
//     select from Products {
//         Name,
//         Price,
//         Quantity
//     }
//     where
//         Name = :pName;


// entity ProjParamProducts(pName: String) as projection on Products
//    where
//        Name = :pName


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
    Supplier         : Association to one Suppliers;
    UnitOfMeasure    : Association to UnitOfMeasures;
    DimensionUnits   : Association to DimensionUnits;
    Category         : Association to Categories;
    Currency         : Association to Currencies;
    SalesData        : Association to many SalesData
                           on SalesData.Product = $self;
    Reviews          : Association to many ProductReview
                           on Reviews.Product = $self;


};

entity Orders {
    key ClientEmail : String(65);
        FirstName   : String(30);
        LastName    : String(30);
        CreatedOn   : Date;
        Reviewed    : Boolean;
        Approved    : Boolean;
};


entity Suppliers : cuid, managed {
    // key ID      : UUID;
    Name    : String;
    Email   : String;
    Phone   : String;
    Fax     : String;
    Address : Address;
    Product : Association to many Products
                  on Product.Supplier = $self
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

entity Months {
    key ID               : String(2);
        Description      : localized String;
        ShortDescription : localized String(3);
};

entity ProductReview : cuid, managed {
    // key ID      : UUID;
    Name    : String;
    Rating  : Integer;
    Comment : String;
    Product : Association to Products;
};

entity SalesData : cuid, managed {
    // key ID            : UUID;
    DeliveryDate  : DateTime;
    Revenue       : Decimal(16, 2);
    Product       : Association to Products;
    Currency      : Association to Currencies;
    DeliveryMonth : Association to Months;
};


entity SelProducts   as select from training.Products;

entity SelProducts1  as
    select from training.Products {
        Name,
        Price,
        Quantity
    }

entity SelProducts2  as
    select from training.Products
    left join ProductReview
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


extend Products with {
    PriceCondition     : String(2);
    PriceDetermination : String(3);
}


entity Course : cuid {
    // key ID      : UUID;
    Student : Association to many StudentCourse
                  on Student.Course = $self
}

entity Student : cuid {
    // key ID     : UUID;
    Course : Association to many StudentCourse
                 on Course.Student = $self
}

entity StudentCourse : cuid {
    // key ID      : UUID;
    Student : Association to Student;
    Course  : Association to Course
}
