const cds = require("@sap/cds");
const { SELECT } = require("@sap/cds/lib/ql/cds-ql");

module.exports = cds.service.impl(async function (srv) {
        const { Products } = srv.entities;
            const sapbackend = await cds.connect.to("sapbackend");

                srv.on("READ", Products, async (req) => {
                        return await sapbackend.tx(req).send({
                                    query: req.query,
                                                headers: {}
                                                        })
                                                            })

                                                            })



// module.exports = async (srv) => {
//     const { Products } = srv.entities;
//     const sapbackend = await cds.connect.to("sapbackend");
  
//     srv.on("READ", Products, async (req) => {
//         let ProductsQuery = SELECT.from(req.query.SELECT.from).limit(req.query.SELECT.limit);
//         if (req.query.SELECT.where) ProductsQuery.where(req.query.SELECT.where);
//         if (req.query.SELECT.orderBy) ProductsQuery.where(req.query.SELECT.orderBy);

//         let product = await sapbackend.tx(req).send({
//             query: ProductsQuery,
//             headers: {}
//         })
//         let products = []
//         if (Array.isArray(product)) {
//             products = product
//         } else {
//             products[0] = product
//         }
//         return products
//     })
// }