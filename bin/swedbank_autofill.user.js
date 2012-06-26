// ==UserScript==
// @name        swedbank_autofill
// @namespace   https://internetbank.swedbank.se/idp/portal
// @description This will fill in my person number and submit the form when visinting https://internetbank.swedbank.se/bviPrivat/privat?ns=1
// @version     1
// @grant       none
// ==/UserScript==

document.getElementById('auth:kundnummer').value = 'GIT-CENSORED';
document.getElementById('auth:fortsett_knapp').click();
//document.getElementsByTagName('form:challengeResponse').focus();
