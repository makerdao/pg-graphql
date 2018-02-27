const app = require('express')()
const port = 3000

app.get('/', (request, response) => {
  response.send(`${Date.now()} MakerDAO. Caching data...`)

})

app.listen(port);
console.log(`Running an express server at localhost:${port}`)
