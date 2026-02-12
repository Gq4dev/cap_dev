using {com.gq4dev as gq4dev} from '../db/schema.cds';

service CatalogService {
    entity ProductsSrv as projection on gq4dev.Products;
    entity Categories as projection on gq4dev.Categories;
    entity Suppliers as projection on gq4dev.Suppliers;

   
}
