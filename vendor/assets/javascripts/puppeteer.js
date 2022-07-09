const puppeteer = require('puppeteer')
const address = process.argv[2]
const output = process.argv[3]
const timeoutLength = 15000

const getScreenshot = async () => {
  // Note when debugging, pdf won't generate if not headless
  // const browser = await puppeteer.launch({headless: false})
  const browser = await puppeteer.launch()
  const page = await browser.newPage()
  
  page
    .on('console', message =>
      console.log(`${message.type().substr(0, 3).toUpperCase()} ${message.text()}`))
    .on('pageerror', ({ message }) => console.log(message))
    .on('response', response =>
      console.log(`${response.status()} ${response.url()}`))
    .on('requestfailed', request =>
      console.log(`${request.failure().errorText} ${request.url()}`))

  await page.goto(address, {waitUntil: 'networkidle2'})

  await page
    .waitForSelector('#pdf-alignment-options', { timeout: 5000 })
    .catch(e => console.log(e))
  await page
    .waitForSelector('#pdf-portfolio-details', { timeout: 2000 })
    .catch(e => console.log(e))

  const headerHTML = `<div style="padding-top:10px; padding-right:26px; width: 100%;">
    <p style="float:right; margin-bottom:0;">
      <span style="color:#000; font-family:'Roboto',Arial; font-size:5pt;">ENCORE | </span>
      <span style="color:#000; font-family:'Roboto',Arial; font-size:5pt; font-weight:bold;">Page</span>
      <span style="color:#000; font-family:'Roboto',Arial; font-size:5pt; font-weight:bold; padding-left:2px;" class="pageNumber"></span>
      <span style="color:#000; font-family:'Roboto',Arial; font-size:5pt; padding:0 2px; display:inline-block"> of </span> 
      <span style="color:#000; font-family:'Roboto',Arial; font-size:5pt; font-weight:bold;" class="totalPages"></span>
  </div>`

  const footerHTML = `<div style="padding-right:26px; width: 100%;">
    <span style="color:#000; float:right; font-family:'Roboto',Arial; font-size:5pt; font-weight:bold;" class="date"></span>
  </div>`

  page.emulateMediaType('screen')

  await page.pdf({
    displayHeaderFooter: true,
    headerTemplate: headerHTML,
    footerTemplate: footerHTML,
    format: 'A4',
    margin: {
      top: '60px',
      right: '20px',
      bottom: '60px',
      left: '20px',
    },
    path: output, 
    printBackground: true,
    scale: 0.58
  })

  await browser.close()
}

setTimeout(() => {
  console.log(`Node puppeteer process timed-out after ${timeoutLength/1000}s.`)
  process.exit()
}, timeoutLength)

getScreenshot()
  .then(() => {
    console.log('Screenshot completed.')
    process.exit()
  })
  .catch(e => {
    console.log(e)
    process.exit()
  })