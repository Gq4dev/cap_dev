using {sapbackend as external} from './external/sapbackend';


define service SAPBackendExit {

    @cds.persistence: {
        table,
        skip: false
    }
    @cds.autoexpose

    // entity Products as  select from external.Products
    entity Products as projection on external.Products;
}

@protocol: 'rest'
service RestService {

    entity Products as projection on SAPBackendExit.Products;
}
