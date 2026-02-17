const cds = require("@sap/cds")
const adapterProxy = require("@sap/cds-odata-v2-adapter-proxy")

const cors = require("cors")

cds.on("bootstrap", (app) => {
    app.use(adapterProxy())
    app.use(cors());

    app.get("/alive", (_, res) => {
        res.status(200).send("Server is Alive")
    })
})

module.exports = cds.server;