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


if (process.env.NODE_ENV === "development") {
    const swaggerUi = require("cds-swagger-ui-express");
    app.use("/swagger", swaggerUi.serve, swaggerUi.setup(require("cds-swagger")(app)));
}
module.exports = cds.server;