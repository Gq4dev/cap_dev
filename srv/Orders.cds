using {com.training as training} from '../db/training';

@graphql service ManageOrders {
    type CancelOrderReturn {
        status  : String enum {
            Succeeded;
            Failed
        };
        message : String;
    }

    //  function getClientTaxRate(clientEmail: String(65)) returns Decimal(4, 2);
    //     action   cancelOrder(clientEmail: String(65))  returns CancelOrderReturn

    entity Orders as projection on training.Orders
        actions {
            function getClientTaxRate(clientEmail: String(65)) returns Decimal(4, 2);
            action   cancelOrder(clientEmail: String(65))      returns CancelOrderReturn
        }
}
