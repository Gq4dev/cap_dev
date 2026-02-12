using {com.gq4dev as gq4dev} from '../db/schema.cds';

service CustomerService {
    entity CustomerSrv as projection on gq4dev.Customer;
}
