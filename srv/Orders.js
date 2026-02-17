const cds = require("@sap/cds");
const { message } = require("@sap/cds/lib/log/cds-error");
const { INSERT, UPDATE, DELETE } = cds.ql


module.exports = (srv) => {
    const { Orders } = cds.entities("com.training");
    
    srv.before("*", async (req) => {
        console.log(`Method : ${req.method}`)
        console.log(`Target : ${req.target}`)
    })


    //**Read */
    srv.on("READ", "Orders", async (req) => {
        if (req.data.ClientEmail !== undefined) {
            return await SELECT.from`com.training.Orders`.where`ClientEmail = ${req.data.ClientEmail}`;
        }
        return await SELECT.from(Orders);
    });

    srv.after("READ", "Orders", (data) => {
        return data.map(element => {
            element.Reviewed = false
        })
    })

    //**Create */
    srv.on("CREATE", "Orders", async (req) => {
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
    srv.before("CREATE", "Orders", (req) => {
        req.data.CreatedOn = new Date().toISOString().slice(0, 10)
        return req
    })


    //**Update */
    srv.on("UPDATE", "Orders", async (req) => {
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
    srv.on("DELETE", "Orders", async (req) => {
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


    //**Funcion para traer Tax */
    srv.on("getClientTaxRate", async (req) => {
        const { clientEmail } = req.data;
        if (!clientEmail) req.reject(400, "clientEmail is required");

        const tx = cds.tx(req);

        const row = await tx.run(
            SELECT.one.from(Orders).columns("Country_code").where({ ClientEmail: clientEmail })
        );

        if (!row) return 0.00;

        switch (row.Country_code) {
            case "ES": return 21.50;
            case "UK": return 24.60;
            default: return 0.00;
        }
    });

    // ACTIONS
    srv.on("cancelOrder", async (req) => {
        const { clientEmail } = req.data

        const db = cds.tx(req);
        const resultsRead = await db.read(Orders, ["FirstName", "LastName", "Approved"]).where({ ClientEmail: clientEmail })

        let returnOrder = {
            status: "",
            message: ""
        }

        if (resultsRead[0].Approved == false) {
            const resultsUpdate = await db.update(Orders).set({ Status: "C" }).where({ ClientEmail: clientEmail })

            returnOrder.status = "Succeeded"
            returnOrder.message = `The Order placed by  ${resultsRead[0].FirstName} ${resultsRead[0].LastName} was cancel`
        } else {
            returnOrder.status = "Failed"
            returnOrder.message = `The Order placed by  ${resultsRead[0].FirstName} ${resultsRead[0].LastName} was NOT cancel,`
        }

        return returnOrder
    })

}