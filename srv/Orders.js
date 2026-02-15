const cds = require("@sap/cds");
const { INSERT, UPDATE, DELETE } = require("@sap/cds/lib/ql/cds-ql");
const SELECT = require("@sap/cds/lib/ql/SELECT");
const { Orders } = cds.entities("com.training");

module.exports = (srv) => {

    //**Read */
    srv.on("READ", "GetOrders", async (req) => {
        if (req.data.ClientEmail !== undefined) {
            return await SELECT.from`com.training.Orders`.where`ClientEmail = ${req.data.ClientEmail}`;
        }
        return await SELECT.from(Orders);
    });

    srv.after("READ", "GetOrders", (data) => {
        return data.map(element => {
            element.Reviewed = false
        })
    })

    //**Create */

    srv.on("CREATE", "CreateOrder", async (req) => {
        let { ClientEmail, FirstName, LastName, CreatedOn, Reviewed, Approved } = req.data
        console.log(ClientEmail)
        let returnData = await cds.tx(req).run(
            INSERT.into(Orders).entries({
                ClientEmail: ClientEmail,
                FirstName: FirstName,
                LastName: LastName,
                CreatedOn: CreatedOn,
                Reviewed: Reviewed,
                Approved: Approved,
            })
        ).then((resolve, reject) => {
            console.log("Resolve", resolve)
            console.log("Rejected", reject)

            if (typeof resolve !== "undefined") {
                return req.data;
            } else {
                req.error(409, "Record Not Inserted")
            }
        }).catch((e) => {
            console.log("Error", e)
            req.error(e.code, e.message)
        });
        console.log("Before End", returnData)
        return returnData
    })
    srv.before("CREATE", "CreateOrder", (req) => {
        req.data.CreatedOn = new Date().toISOString().slice(0, 10)
        return req
    })


    //**Update */

    srv.on("UPDATE", "UpdateOrder", async (req) => {
        let { ClientEmail, FirstName, LastName } = req.data
        let resultData = await cds.tx(req).run(
            [
                UPDATE(Orders, ClientEmail).set({
                    FirstName: FirstName,
                    LastName: LastName,

                })
            ]
        ).then((resolve, reject) => {
            console.log("Resolve", resolve)
            console.log("Reject", reject)

            if (resolve[0] == 0) {
                req.error(409, "Record Not Found")
            }
        }).catch((err) => {
            console.log(err)
            req.error(err.code, err.message)
        })
        console.log("Before End", resultData)
        return resultData
    })

    //**Delete */
    srv.on("DELETE", "DeleteOrder", async (req) => {
        let { ClientEmail } = req.data
        let resultData = await cds.tx(req).run(
            DELETE.from(Orders).where({ ClientEmail: ClientEmail })
        ).then((resolve, reject) => {
            console.log("Resolve", resolve)
            console.log("Reject", reject)

            if (resolve !== 1) {
                req.error(409, "Record Not Found")
            }
        }).catch((err) => {
            console.log(err)
            req.error(err.code, err.message)
        })
        console.log("Before End", resultData)
        return resultData
    })
}