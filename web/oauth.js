const urlParams = new URLSearchParams(window.location.search);
const code = urlParams.get('code');
if (code) {
    // TODO: replace the localhost URL with the actual URL of the web app
    window.opener.postMessage(window.location.href, 'https://gregertw.github.io/actingweb_firstapp_web/');
}