const { chromium } = require('playwright');
const TARGET = 'https://robot-validation-produit.web.app/dashboard.html?v=' + Date.now();
(async () => {
  const browser = await chromium.launch({ headless: true });
  const ctx = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  const page = await ctx.newPage();
  await page.goto(TARGET, { waitUntil: 'networkidle' });
  await page.waitForTimeout(2000);
  await page.evaluate(() => { document.getElementById('auth-screen')?.classList.add('hidden'); document.querySelector('.dash-shell')?.classList.remove('hidden'); });
  await page.waitForTimeout(500);

  // Inject a manual native click event the way a user mouse click would generate
  const r = await page.evaluate(() => {
    const av = document.getElementById('gh-avatar');
    const rect = av.getBoundingClientRect();
    const cx = rect.left + rect.width/2, cy = rect.top + rect.height/2;
    // Real browser fires mousedown, mouseup, click in sequence
    av.dispatchEvent(new MouseEvent('mousedown', { bubbles:true, cancelable:true, clientX:cx, clientY:cy, button:0 }));
    window.dispatchEvent(new MouseEvent('mouseup', { bubbles:true, cancelable:true, clientX:cx, clientY:cy, button:0 }));
    av.dispatchEvent(new MouseEvent('click', { bubbles:true, cancelable:true, clientX:cx, clientY:cy, button:0 }));
    return new Promise(resolve => {
      setTimeout(() => resolve({
        faq: document.getElementById('faq-modal')?.style.display,
        suppressFlag: window.__rbDragSuppressClick,
        excited: av.classList.contains('rb-excited')
      }), 600);
    });
  });
  console.log(JSON.stringify(r, null, 2));
  await browser.close();
})();
